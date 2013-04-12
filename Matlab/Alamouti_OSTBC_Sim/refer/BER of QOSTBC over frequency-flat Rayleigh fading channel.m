

% This program simulates the bit-error-rate (BER) performance of quasi-orthogonal
% space time block code (QOSTBC)
% with L=4 and M=1 antennas over the frequency flat Rayleigh block fading channel
% The costellation used: QPSK for s1 and s2. Rotated Pi/4 QPSK for s3 and s4.  
% Such design yields to full rate code and 2 bis/sec/Hz

% by Samat Shabdanov, February 2007, e-mail:shabdanov@yahoo.com


%QPSK constellation 

x_q=[1  1 -1 -1];
y_q=[1 -1  1 -1];
QPSK_s=x_q+y_q*i;

%rotated Pi/2 QPSK constellation 
x_r=[0         sqrt(2)  -sqrt(2)  0];
y_r=[sqrt(2)   0        0       -sqrt(2)];
QPSK_r=x_r+y_r*i;


Es=2; %average constellation energy for d=2;

index=1;
BER=zeros(1,5);


for SNR=4:4:20
    
%number of bit errors set to zero
count=0;


%number of iterations
N=10000;
if SNR==20 N=2*10^4; end; % increase for higher SNR
     
for it=1:N
    
%generate 8 bits uniformly distributed 
A=round(rand(1,8));

% TX symbols
% QPSK
s1=QPSK_s(bi2de(A(1:2),'left-msb')+1);
s2=QPSK_s(bi2de(A(3:4),'left-msb')+1);

%rotated QPSK
s3=QPSK_r(bi2de(A(5:6),'left-msb')+1);
s4=QPSK_r(bi2de(A(7:8),'left-msb')+1);


C=[s1 s2 s3 s4; -conj(s2) conj(s1) -conj(s4) conj(s3); -conj(s3) -conj(s4) conj(s1) conj(s2); s4 -s3 -s2 s1]; 

%Channel fading coefficients
Z=0;
K=1/sqrt(2)*(randn(4,1)+i*randn(4,1)); % normalize to the variance 1 CN(0,1)

%AWGN channel 
N0=(4*Es/10^(SNR/10));
Z=sqrt(N0/2)*(randn(4,1)+i*randn(4,1)); % variance N0

%RX symbols

R=C*K+Z; 


%pair-wise ML decoding QOSTBC
%find min s1 and s4 for different combinations

vector_c=combvec(QPSK_r,QPSK_s).';
qpsk_space=vector_c(:,2);
rotated_space=vector_c(:,1);

%cost function f1_4
f_1_4=(abs(qpsk_space).^2+abs(rotated_space).^2)* (sum(abs(K).^2)) + 2*real ( (-K(1)*conj(R(1))- conj(K(2))*R(2)-conj(K(3))*R(3)-K(4)*conj(R(4)))*qpsk_space+rotated_space*(-K(4)*conj(R(1))+conj(K(3))*R(2)+conj(K(2))*R(3)-K(1)*conj(R(4)) )  )+4*real( K(1)*conj(K(4))-conj(K(2))*K(3) )*real( qpsk_space.*conj(rotated_space));       

%find for S1 corresponding bits
[H1,I]=min(f_1_4);
[H1,I]=min(QPSK_s-vector_c(I,2));
dec_bits(1,1:2)=de2bi(I(1)-1,2,'left-msb');


%find for S4 corresponding bits
[H1,I]=min(f_1_4);
[H1,I]=min(QPSK_r-vector_c(I,1));
dec_bits(1,7:8)=de2bi(I(1)-1,2,'left-msb');


%cost function f2_3
f_2_3=(abs(qpsk_space).^2+abs(rotated_space).^2)* (sum(abs(K).^2)) + 2*real ( (-K(2)*conj(R(1))+ conj(K(1))*R(2)-conj(K(4))*R(3)+K(3)*conj(R(4)))*qpsk_space+rotated_space*(-K(3)*conj(R(1))-conj(K(4))*R(2)+conj(K(1))*R(3)+K(2)*conj(R(4)) )  )+4*real( K(2)*conj(K(3))-conj(K(1))*K(4) )*real( qpsk_space.*conj(rotated_space));  

%find for S2 corresponding bits
[H1,I]=min(f_2_3);
[H1,I]=min(QPSK_s-vector_c(I,2));
dec_bits(1,3:4)=de2bi(I(1)-1,2,'left-msb');


%find for S3 corresponding bits
[H1,I]=min(f_2_3);
[H1,I]=min(QPSK_r-vector_c(I,1));
dec_bits(1,5:6)=de2bi(I(1)-1,2,'left-msb');


%count errors
count=count+sum(abs(A-dec_bits));

end;

BER(index)=count/(N*8)
index=index+1;

end;


% your BER is in BER vector
% adjust your plot function to plot semilogy(4:4:20, BER);

