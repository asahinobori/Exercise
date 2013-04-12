%教材上的LMS例子，但这里去掉引入的统计起伏
%手动计算MSE函数，即KSI函数，LMS就是该函数中的变量W(自适应滤波器的权)由于算法的假设而有特别的递归函数
%W的递归函数可以由输入Xk，自适应增益u决定

clear;

%计算最优权值
R=[0.5,0.5*cos(pi/8);0.5*cos(pi/8),0.5]; 
P=[0;(-1)*sin(pi/8)];
Ws=inv(R)*P;
 
%计算最小均方误差
KSIm=2-P'*Ws;  %理论上是无限趋近于零
 
 
%自适应增益常数
u=0.05;
%设开始权值(由上面计算出最优权值看情况来取的)
W=[4;-10];

for k=1:150
    Xk=[sin(pi*k/8);sin(pi*(k-1)/8)]; 
    dk=2*cos(pi*k/8);
    ek(k)=dk-Xk'*W(:,k);
    W(:,k+1)=W(:,k)+2*u*ek(k)*Xk; %LMS的权值递归函数
    
    %KSI(k1)=0.5*(W(1,k1)^2+W(2,k1)^2)+W(1,k1)*W(2,k1)*cos(pi/7)+W(2,k1)*sin(pi/7)+0.5;
    KSI(k)=0.5*(W(1,k)^2+W(2,k)^2)+W(1,k)*W(2,k)*cos(pi/8)+2*W(2,k)*sin(pi/8)+2; %教材例
end

%画出performance surface
ss=-10:0.1:10;
[m,n]=size(ss);
[w0,w1]=meshgrid(ss,ss);
for i=1:m*n
    for j=1:m*n
        KSIp(i,j)=0.5*(w0(i,j)^2+w1(i,j)^2)+w0(i,j)*w1(i,j)*cos(pi/8)+2*w1(i,j)*sin(pi/8)+2;
    end
end
figure(1);
surf(w0,w1,KSIp);
figure(2);
contour(w0,w1,KSIp); %等高线图
hold on;
plot(W(1,:),W(2,:)); %权值变动图
hold off;

%画出ek
figure(3);
k=1:1:150;
plot(k,ek);

%画出learning curve
LC=KSI-KSIm*ones(1,k);
figure(4);
semilogy(k,LC);



