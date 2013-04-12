%�̲��ϵ�LMS���ӣ�������ȥ�������ͳ�����
%�ֶ�����MSE��������KSI������LMS���Ǹú����еı���W(����Ӧ�˲�����Ȩ)�����㷨�ļ�������ر�ĵݹ麯��
%W�ĵݹ麯������������Xk������Ӧ����u����

clear;

%��������Ȩֵ
R=[0.5,0.5*cos(pi/8);0.5*cos(pi/8),0.5]; 
P=[0;(-1)*sin(pi/8)];
Ws=inv(R)*P;
 
%������С�������
KSIm=2-P'*Ws;  %��������������������
 
 
%����Ӧ���泣��
u=0.05;
%�迪ʼȨֵ(��������������Ȩֵ�������ȡ��)
W=[4;-10];

for k=1:150
    Xk=[sin(pi*k/8);sin(pi*(k-1)/8)]; 
    dk=2*cos(pi*k/8);
    ek(k)=dk-Xk'*W(:,k);
    W(:,k+1)=W(:,k)+2*u*ek(k)*Xk; %LMS��Ȩֵ�ݹ麯��
    
    %KSI(k1)=0.5*(W(1,k1)^2+W(2,k1)^2)+W(1,k1)*W(2,k1)*cos(pi/7)+W(2,k1)*sin(pi/7)+0.5;
    KSI(k)=0.5*(W(1,k)^2+W(2,k)^2)+W(1,k)*W(2,k)*cos(pi/8)+2*W(2,k)*sin(pi/8)+2; %�̲���
end

%����performance surface
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
contour(w0,w1,KSIp); %�ȸ���ͼ
hold on;
plot(W(1,:),W(2,:)); %Ȩֵ�䶯ͼ
hold off;

%����ek
figure(3);
k=1:1:150;
plot(k,ek);

%����learning curve
LC=KSI-KSIm*ones(1,k);
figure(4);
semilogy(k,LC);



