%P115-Exer8
%手动计算MSE函数，即KSI函数，LMS就是该函数中的变量W(自适应滤波器的权)由于算法的假设而有特别的递归函数
%W的递归函数可以由输入Xk，自适应增益u决定

clear;

%计算最优权值
R=[0.5,0.5*cos(pi/7);0.5*cos(pi/7),0.5]; 
P=[0;0.5*sin(pi/7)];
Ws=inv(R)*P;
 
%计算最小均方误差
KSIm=0.5-P'*Ws;  %理论上是无限趋近于零
 
 
%自适应增益常数
u1=0.05;
u2=0.005;
%设开始权值(由上面计算出最优权值看情况来取的)
W1=[4;-10];
W2=[4;-10];

for k1=1:1000
    Xk1=[cos(pi*k1/7);cos(pi*(k1-1)/7)]; 
    dk1=sin(pi*k1/7);
    ek1(k1)=dk1-Xk1'*W1(:,k1);
    W1(:,k1+1)=W1(:,k1)+2*u1*ek1(k1)*Xk1; %LMS的权值递归函数
    
    KSI1(k1)=0.5*(W1(1,k1)^2+W1(2,k1)^2)+W1(1,k1)*W1(2,k1)*cos(pi/7)-W1(2,k1)*sin(pi/7)+0.5;
end

for k2=1:1000
    Xk2=[cos(pi*k2/7);cos(pi*(k2-1)/7)]; 
    dk2=sin(pi*k2/7);
    ek2(k2)=dk2-Xk2'*W2(:,k2);
    W2(:,k2+1)=W2(:,k2)+2*u2*ek2(k2)*Xk2; %LMS的权值递归函数
    
    KSI2(k2)=0.5*(W2(1,k2)^2+W2(2,k2)^2)+W2(1,k2)*W2(2,k2)*cos(pi/7)-W2(2,k2)*sin(pi/7)+0.5;
end

% %画出performance surface
% ss=-10:0.1:10;
% [m,n]=size(ss);
% [w0,w1]=meshgrid(ss,ss);
% for i=1:m*n
%     for j=1:m*n
%         KSIp(i,j)=0.5*(w0(i,j)^2+w1(i,j)^2)+w0(i,j)*w1(i,j)*cos(pi/7)-w1(i,j)*sin(pi/7)+0.5;
%     end
% end
% figure(1);
% surf(w0,w1,KSIp);

%画出learning curve
k1=1:1:1000;
k2=1:1:1000;
LC1=KSI1-KSIm*ones(1,k1);
LC2=KSI2-KSIm*ones(1,k2);
figure(1);
semilogy(k1,LC1);
figure(2);
semilogy(k2,LC2);
