package com.xusheng;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.StringTokenizer;
import java.util.Vector;

/*
 * 简易聊天室服务器端
 * 没有GUI，请使用命令行启动，终端会输出相应情况
 * @author xusheng 
 */

public class SimpleChatServer {

    static int port = 9000; // 服务器端口,这里固定为9000
    static Vector<Client> clients = new Vector<Client>(10); // 服务器可接受客户数
    static ServerSocket server = null;
    static Socket socket = null;

    /*
     * 内部类：客户端线程
     */
    class Client extends Thread {
        Socket socket;
        String name; // 客户端姓名
        String ip; // 客户端地址
        BufferedReader reader; // 输入流
        PrintStream ps; // 输出流

        public Client(Socket s) {
            socket = s;
            try {
                reader = new BufferedReader(new InputStreamReader(
                        s.getInputStream()));
                ps = new PrintStream(s.getOutputStream());
                String info = reader.readLine();
                StringTokenizer stinfo = new StringTokenizer(info, ":");
                stinfo.nextToken();
                if (stinfo.hasMoreTokens()) {
                    name = stinfo.nextToken();
                }
                if (stinfo.hasMoreTokens()) {
                    ip = stinfo.nextToken();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
            System.out.println("与客户端 " + ip + " 建立连接\n");
            System.out.println("客户信息\n" + "用户名: " + name);
            System.out.println("用户标识和地址: " + ip + "\n");
        }

        public void send(StringBuffer msg) {
            ps.println(msg); // 向该Socket输出具体信息
            ps.flush();
        }

        public void run() {
            while (true) {
                String line = null;
                try {
                    line = reader.readLine();
                } catch (IOException ex) {
                    ex.printStackTrace();
                    SimpleChatServer.disconnect(this);
                    SimpleChatServer.notifyChatRoom("Logout", name);
                    return;
                }
                if (line == null) {
                    SimpleChatServer.disconnect(this);
                    SimpleChatServer.notifyChatRoom("Logout", name);
                    return;
                }
                StringTokenizer st = new StringTokenizer(line, ":");
                String keyword = st.nextToken();
                if (keyword.equals("Msg")) {
                    StringBuffer msg = new StringBuffer("Msg:");
                    msg.append(name);
                    msg.append(st.nextToken("\0\n"));
                    SimpleChatServer.sendClients(msg);
                    System.out.println(name + " 说: "
                            + msg.substring(5 + name.length()));
                } else if (keyword.equals("Quit")) {
                    SimpleChatServer.disconnect(this);
                    SimpleChatServer.notifyChatRoom("Logout", name);
                }
            }
        }
    }

    public SimpleChatServer() {
        try {
            System.out.println("服务器已启动！");
            server = new ServerSocket(port); // 初始化服务器Socket
            while (true) {
                socket = server.accept(); // 等待客户端连接（新连接到达之前阻塞于此）
                Client client = new Client(socket); // 实例化客户线程
                clients.add(client); // 将新的客户线程添加到客户向量（表）中
                client.start(); // 启动线程
                notifyChatRoom("Login", client.name); // 通知聊天室当前在线用户的变化（有新客户连接进来）
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /*
     * 方法：通知各客户端更新在线用户列表 command表示变动用户的行为，即是上线（Login）还是离线（Logout），user是变动用户
     */
    public static void notifyChatRoom(String command, String user) {
        StringBuffer usersChanged = new StringBuffer(command + ":");
        usersChanged.append(user);
        for (int i = 0; i < clients.size(); i++) {
            Client c = (Client) clients.elementAt(i);
            usersChanged.append(":" + c.name);
        } // 构建新的用户列表，格式为 变动用户行为:变动用户名：当前用户1:当前用户2:...:当前用户n
        sendClients(usersChanged); // 向各客户端发送新的用户列表
    }

    /*
     * 方法：将信息（用户列表信息或聊天内容信息）发送到各个客户端
     */
    public static void sendClients(StringBuffer message) {
        for (int i = 0; i < clients.size(); i++) {
            Client client = (Client) clients.elementAt(i);
            client.send(message);
        }
    }

    /*
     * 方法：清除连接断开的Socket
     */
    public static void disconnect(Client c) {
        try {
            System.err.println("与客户端 " + c.ip + "断开连接\n");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        clients.removeElement(c); // 从客户向量（表）中清除
        c.socket = null; // 清除对应的Socket
    }

    /*
     * 入口函数，启动这个类，运行其构造函数启动服务器和相应客户端处理线程
     */
    public static void main(String[] args) {
        new SimpleChatServer(); // 新建简易聊天服务器对象
    }

}
