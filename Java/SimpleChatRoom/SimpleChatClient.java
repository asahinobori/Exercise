package com.xusheng;

/*
 * 构建的GUI包
 */
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.DefaultListModel;
import javax.swing.SwingUtilities;
import javax.swing.border.LineBorder;

import java.awt.Color;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;

import java.net.InetAddress;
import java.net.Socket;
import java.util.StringTokenizer;

/*
 * 简易聊天室客户端
 * @author xusheng 
 */

public class SimpleChatClient extends JFrame implements ActionListener {

    /*
     * 构建GUI中的一些部件
     */
    private JButton login = new JButton("登录"); // 登录按钮
    private JButton logout = new JButton("下线"); // 下线按钮
    private JButton sendMsg = new JButton("发送"); // 发送按钮
    private JTextArea chatLog = new JTextArea(8, 40); // 当前聊天信息文本框
    private JTextArea chatSend = new JTextArea(3, 35); // 聊天输入文本框
    private JTextField name = new JTextField("xusheng"); // 登录用户名输入框，默认是xusheng
    private JTextField host = new JTextField("localhost", 9); // 主机地址输入框，默认是localhost
    private JTextField port = new JTextField("9000"); // 服务器端口口，默认是9000
    private JList currentUsers = new JList(new DefaultListModel()); // 当前在线用户列表

    Socket socket = null; // 客户端Socket线程
    PrintStream ps = null; // 输出流
    Listen listen = null;

    /*
     * 内部类：监听Socket线程
     */
    class Listen extends Thread {
        BufferedReader reader;
        PrintStream ps;
        String cname;
        Socket socket;
        SimpleChatClient chatClient;

        /*
         * 内部类构造函数：监听Socket输入和输出流
         */
        public Listen(SimpleChatClient client, String name, Socket socket) {
            try {
                this.chatClient = client;
                this.socket = socket;
                this.cname = name;
                reader = new BufferedReader(new InputStreamReader(
                        socket.getInputStream()));
                ps = new PrintStream(socket.getOutputStream());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        /*
         * 内部类方法：启动监听线程，并根据接收到信息的标记将相应信息表现于客户端GUI上
         */
        public void run() {
            while (true) {
                String line = null;
                try {
                    line = reader.readLine(); // 读取输入流，没有输入时会阻塞于此
                } catch (IOException e) {
                    e.printStackTrace();
                    ps.println("Quit");
                    return;
                }
                StringTokenizer stinfo = new StringTokenizer(line, ":");
                String keyword = stinfo.nextToken();
                if (keyword.equals("Msg")) {
                    chatClient.chatLog.append(line.split("\\:")[1] + "说: "
                            + line.split("\\:")[2] + "\n");
                } // 输入标记为Msg，即为聊天信息，在聊天框中将其显示，对应相应用户

                else if (keyword.equals("Login")) {

                    String iname = stinfo.nextToken();
                    processCurrentUsersList("add", line);
                    chatClient.chatLog.append(iname + ": 进入聊天室\n");
                } // 输入标记为Login，即有新用户加入聊天室，重置在线用户列表
                else if (keyword.equals("Logout")) {
                    String oname = stinfo.nextToken();
                    processCurrentUsersList("remove", line);
                    chatClient.chatLog.append(oname + ": 离开聊天室\n");
                } // 输入标记为Login，即有用户离开聊天室，重置在线用户列表
            }
        }
    }

    /*
     * 构造函数：先调用initGUI方法构建出程序的GUI，然后为几个按钮加上动作监听器
     */
    public SimpleChatClient() {
        initGUI(); // 程序启动先进行GUI的初始绘制
        this.setSize(650, 600);
        this.setVisible(true);

        /*
         * 对三个按钮设定动作监听器，有动作会调用actionPerformed方法
         */
        login.addActionListener(this);
        logout.addActionListener(this);
        sendMsg.addActionListener(this);
    }

    /*
     * 方法：绘制GUI
     */
    public void initGUI() {
        GridBagLayout globalLayout = new GridBagLayout();
        this.setLayout(globalLayout); // 全局使用GridBagLayout布局

        /*
         * 分成三个部分，上方为控制区，左下为聊天区，右下为在线用户列表
         */
        JPanel controlPanel = new JPanel(); // 控制Panel
        controlPanel.setBackground(Color.ORANGE);
        JLabel loginName = new JLabel("登录用户名:");
        JLabel loginHost = new JLabel("服务器主机:");
        JLabel loginPort = new JLabel("服务器端口:");
        controlPanel.add(loginName);
        controlPanel.add(name);
        controlPanel.add(loginHost);
        controlPanel.add(host);
        controlPanel.add(loginPort);
        controlPanel.add(port);
        controlPanel.add(login);
        controlPanel.add(logout);

        JPanel chatPanel = new JPanel(); // 聊天Panel
        GridBagLayout chatLayout = new GridBagLayout();
        chatPanel.setLayout(chatLayout);
        chatPanel.add(chatLog);
        chatLog.setBorder(new LineBorder(Color.GRAY));
        chatPanel.add(chatSend);
        chatSend.setBorder(new LineBorder(Color.GRAY));
        chatPanel.add(sendMsg);

        // 将三个部分加入窗口中
        this.add(controlPanel);
        this.add(chatPanel);
        this.add(currentUsers);

        processCurrentUsersList("add", "default:在线用户");
        currentUsers.setBorder(new LineBorder(Color.GRAY));

        // 全局和聊天Panel均使用GridBadConstraints进行约束
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.BOTH;

        // 以下是全局三个部分的约束
        gbc.weightx = 1;
        gbc.weighty = 0;
        gbc.gridwidth = 0;
        globalLayout.setConstraints(controlPanel, gbc);

        gbc.weightx = 1;
        gbc.weighty = 1;
        gbc.gridwidth = 1;
        globalLayout.setConstraints(chatPanel, gbc);

        gbc.weightx = 0;
        gbc.weighty = 1;
        gbc.gridwidth = 0;
        globalLayout.setConstraints(currentUsers, gbc);

        // 以下是chatPanel里的布局约束
        gbc.weightx = 1;
        gbc.weighty = 1;
        gbc.gridwidth = 0;
        chatLayout.setConstraints(chatLog, gbc);

        gbc.weightx = 1;
        gbc.weighty = 0;
        gbc.gridwidth = 1;
        chatLayout.setConstraints(chatSend, gbc);

        gbc.weightx = 0;
        gbc.weighty = 0;
        gbc.gridwidth = 0;
        chatLayout.setConstraints(sendMsg, gbc);
    }

    public void actionPerformed(ActionEvent e) {
        try {
            if (e.getSource() == login) {
                if (socket == null) {
                    String h = host.getText();
                    if (h.equals("localhost"))
                        h = InetAddress.getLocalHost().toString().split("\\/")[1];
                    int p = Integer.parseInt(port.getText());
                    byte[] addr = new byte[4];
                    String[] hh = h.split("\\.");
                    for (int i = 0; i < 4; i++)
                        addr[i] = (byte) Integer.parseInt(hh[i]);
                    socket = new Socket(InetAddress.getByAddress(addr), p);
                    ps = new PrintStream(socket.getOutputStream());
                    StringBuffer info = new StringBuffer("Info:");
                    String userinfo = name.getText() + ":"
                            + InetAddress.getLocalHost().toString();
                    ps.println(info.append(userinfo));
                    ps.flush();
                    listen = new Listen(this, name.getText(), socket);
                    listen.start(); // 启动监听线程

                }
            } // 登录按钮被点击，获取控制区域相关输入，如服务器主机地址，端口号，将进Socket连接，然后启动监听线程
            else if (e.getSource() == logout) {
                logoutChatRoom();
            } // 下线按钮被点击，调用退出方法
            else if (e.getSource() == sendMsg) {
                if (socket != null) {
                    StringBuffer msg = new StringBuffer("Msg:");
                    String msgtxt = new String(chatSend.getText());
                    ps.println(msg.append(msgtxt));
                    ps.flush();
                    chatSend.setText("");
                } else {
                    JOptionPane.showMessageDialog(this, "请先登录进入聊天室！", "提示", 1);
                } // 发送按钮补点击，获取聊天输入框中的文本并通过Socket输出法发送到连接的服务器上
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /*
     * 方法：处理在线用户列表
     */
    public void processCurrentUsersList(String command, String user) {
        // 当JList的项集合为空时
        if (currentUsers.getModel().getSize() == 1) {
            // 新建一个默认项集合
            DefaultListModel listModel = (DefaultListModel) currentUsers
                    .getModel();
            // 操作这个集合
            user = user.substring(6, user.length()); // 去掉信息前面的标记字符串，提取后面的用户列表
            for (String u : user.split(":")) {
                listModel.add(listModel.getSize(), u.trim());
            }
            listModel.removeElement(user.split(":")[0]);
            // 将这个集合添加到JList中
            currentUsers.setModel(listModel);
        }
        // JList的项不为空时
        else {
            // 从JList中获得这个集合,转换为默认项集合类型
            DefaultListModel listModel = (DefaultListModel) currentUsers
                    .getModel();
            // 更改元素
            if (command.equalsIgnoreCase("remove")) {
                listModel.removeElement(user.split(":")[1]); // 直接将变动的用户名提取出来操作
            } else {
                listModel.add(listModel.getSize(), user.split(":")[1]);
            }
            // 将这个集合添加到JList中
            currentUsers.setModel(listModel);
        }
    }

    /*
     * 方法：下线，向服务器发送Quit标志表明下线，然后断开Socket连接
     */
    public void logoutChatRoom() {
        if (socket != null) {
            ps.println("Quit");
            ps.flush();

            socket = null;
        }
    }

    /*
     * 入口函数：为本类新建一个对象，并设置窗口关闭方式
     */
    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                try {
                    javax.swing.UIManager.setLookAndFeel(javax.swing.UIManager
                            .getSystemLookAndFeelClassName());

                } catch (Exception e) {
                    e.printStackTrace();
                }
                SimpleChatClient client = new SimpleChatClient();
                client.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            }
        });
    }

}
