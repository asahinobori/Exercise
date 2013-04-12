%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author        : Xusheng Chen
% Email         : xusheng41@gmail.com
% Date          : 4th April 2013
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script for computing the BER for BPSK modulation in a
% Rayleigh fading channel with Alamouti Space Time Block Coding
% Two transmit antenna, Two Receive antenna

clear
N = 10^6; % number of bits or symbols
Eb_N0_dB = (0:25); % multiple Eb/N0 values

for ii = 1:length(Eb_N0_dB)

    % Transmitter
    ip = rand(1,N)>0.5; % generating 0,1 with equal probability
    s = 2*ip-1; % BPSK modulation 0 -> -1; 1 -> 1
    
    % Alamouti STBC 
    for ll = 1:N/4
        s1 = s(ll*4-3);
        s2 = s(ll*4-2);
        s3 = s(ll*4-1);
        s4 = s(ll*4);
        C=[s1 s2 s3 s4; -conj(s2) conj(s1) -conj(s4) conj(s3); -conj(s3) -conj(s4) conj(s1) conj(s2); s4 -s3 -s2 s1]; 
    
        % channel
        K = 1/sqrt(2)*(randn(4,1) + 1i*randn(4,1)); % Rayleigh channel
    
    
        Z = 1/sqrt(2)*(randn(4,1) + 1i*randn(4,1))*10^(-Eb_N0_dB(ii)/20); % white gaussian noise, 0dB variance
        
        R=C*K+Z; 
        
        %pair-wise ML decoding QOSTBC
        %find min s1 and s4 for different combinations
        vector_c=combvec([-1,1],[-1,1]).';
        sa=vector_c(:,2);
        sb=vector_c(:,1);
        
        f_1_4=(abs(sa).^2+abs(sb).^2)* (sum(abs(K).^2)) + 2*real ( (-K(1)*conj(R(1))- conj(K(2))*R(2)-conj(K(3))*R(3)-K(4)*conj(R(4)))*sa+sb*(-K(4)*conj(R(1))+conj(K(3))*R(2)+conj(K(2))*R(3)-K(1)*conj(R(4)) )  )+4*real( K(1)*conj(K(4))-conj(K(2))*K(3) )*real( sa.*conj(sb));       

        %find for S1 corresponding bits
        [H1,I]=min(f_1_4);
        y(ll*4-3)=vector_c(I,2);
        
        %find for S4 corresponding bits
        [H1,I]=min(f_1_4);
         y(ll*4)=vector_c(I,1);
         
         %cost function f2_3
        f_2_3=(abs(sa).^2+abs(sb).^2)* (sum(abs(K).^2)) + 2*real ( (-K(2)*conj(R(1))+ conj(K(1))*R(2)-conj(K(4))*R(3)+K(3)*conj(R(4)))*sa+sb*(-K(3)*conj(R(1))-conj(K(4))*R(2)+conj(K(1))*R(3)+K(2)*conj(R(4)) )  )+4*real( K(2)*conj(K(3))-conj(K(1))*K(4) )*real( sa.*conj(sb));  

        %find for S2 corresponding bits
        [H1,I]=min(f_2_3);
         y(ll*4-2)=vector_c(I,2);


        %find for S3 corresponding bits
        [H1,I]=min(f_2_3);
        y(ll*4-1)=vector_c(I,1);
        
    end
    
    op=(y+1)/2;
    %count errors
    count=sum(abs(op-ip));
    simBer4(ii)=count/N;

end

close all
figure
semilogy(Eb_N0_dB,simBer4,'mo-','LineWidth',2);
hold on
axis([0 25 10^-5 0.5]);
grid on
legend('sim (nTx=4, nRx=1, Jafarkhani)');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK modulation with 4Tx, 1Rx Jafarkhani Q-OSTBC (Rayleigh channel)');