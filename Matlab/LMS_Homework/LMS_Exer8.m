%P115-Exer8
%�ֶ�����MSE��������KSI������LMS���Ǹú����еı���W(����Ӧ�˲�����Ȩ)�����㷨�ļ�������ر�ĵݹ麯��
%W�ĵݹ麯������������Xk������Ӧ����u����

clear;

%��������Ȩֵ
R=[0.5,0.5*cos(pi/7);0.5*cos(pi/7),0.5]; 
P=[0;0.5*sin(pi/7)];
Ws=inv(R)*P;
 
%������С�������
KSIm=0.5-P'*Ws;  %��������������������
 
 
%����Ӧ���泣��
u1=0.05;
u2=0.005;
%�迪ʼȨֵ(��������������Ȩֵ�������ȡ��)
W1=[4;-10];
W2=[4;-10];

for k1=1:1000
    Xk1=[cos(pi*k1/7);cos(pi*(k1-1)/7)]; 
    dk1=sin(pi*k1/7);
    ek1(k1)=dk1-Xk1'*W1(:,k1);
    W1(:,k1+1)=W1(:,k1)+2*u1*ek1(k1)*Xk1; %LMS��Ȩֵ�ݹ麯��
    
    KSI1(k1)=0.5*(W1(1,k1)^2+W1(2,k1)^2)+W1(1,k1)*W1(2,k1)*cos(pi/7)-W1(2,k1)*sin(pi/7)+0.5;
end

for k2=1:1000
    Xk2=[cos(pi*k2/7);cos(pi*(k2-1)/7)]; 
    dk2=sin(pi*k2/7);
    ek2(k2)=dk2-Xk2'*W2(:,k2);
    W2(:,k2+1)=W2(:,k2)+2*u2*ek2(k2)*Xk2; %LMS��Ȩֵ�ݹ麯��
    
    KSI2(k2)=0.5*(W2(1,k2)^2+W2(2,k2)^2)+W2(1,k2)*W2(2,k2)*cos(pi/7)-W2(2,k2)*sin(pi/7)+0.5;
end

% %����performance surface
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

%����learning curve
k1=1:1:1000;
k2=1:1:1000;
LC1=KSI1-KSIm*ones(1,k1);
LC2=KSI2-KSIm*ones(1,k2);
figure(1);
semilogy(k1,LC1);
figure(2);
semilogy(k2,LC2);
