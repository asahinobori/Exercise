%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author        : Xusheng Chen
% Email         : xusheng41@gmail.com
% Date          : 11th April 2013
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1.Script for computing the BER for BPSK modulation in a Rayleigh fading
% channel with Alamouti Space Time Block Coding ,Two/four transmit antenna,
% multiple receive antenna for comparision

% 2.Script for computing the BER for BPSK modulation in a Raleigh fading
% channel with Jafarkhani Coding(Q-OSTBC),Four transmit antenna, multiple receive
% antenna for comparision



clear
N = 4*10^5; % number of bits or symbols
Eb_N0_dB = (0:25); % multiple Eb/N0 values
nRx = 2;
nRx_4 = 2;
for ii = 1:length(Eb_N0_dB)
    % Transmitter
    ip = rand(1,N)>0.5; % generating 0,1 with equal probability
    s = 2*ip-1; % BPSK modulation 0 -> -1; 1 -> 1

    % Alamouti STBC 
    sCode = 1/sqrt(2)*kron(reshape(s,2,N/2),ones(1,2)) ; % 2x2
    sCode_4 = 1/sqrt(2)*kron(reshape(s,4,N/4),ones(1,8)); % 4x8
    
    % channel 
    h = 1/sqrt(2)*(randn(nRx,N) + 1i*randn(nRx,N)); % Rayleigh channel for 2 transmit antenna (OSTBC)
    h_4 = 1/sqrt(2)*(randn(nRx_4,N) + 1i*randn(nRx_4,N)); % Rayleigh channel for 4 transmit antenna (OSTBC)
    n = 1/sqrt(2)*(randn(nRx,N) + 1i*randn(nRx,N)); % white gaussian noise, 0dB variance for 2 transmit antenna (OSTBC)
    n_4 = 1/sqrt(2)*(randn(nRx_4,N*2) + 1i*randn(nRx_4,N*2)); % white gaussian noise, 0dB variance for 4 transmit antenna (OSTBC)

    y = zeros(nRx,N);
    y_4 = zeros(nRx_4,N*2);
    yMod = zeros(nRx*2,N);
    yMod_4 = zeros(nRx_4*8,N);
    J = zeros(1,N);
    
    for kk = 1:nRx

        hMod = kron(reshape(h(kk,:),2,N/2),ones(1,2));     
        temp = hMod;
        hMod(1,2:2:end) = conj(temp(2,2:2:end)); 
        hMod(2,2:2:end) = -conj(temp(1,2:2:end));

        % Channel and noise Noise addition
        y(kk,:) = sum(hMod.*sCode,1) + 10^(-Eb_N0_dB(ii)/20)*n(kk,:);

        % Receiver
        yMod(2*kk-1:2*kk,:) = kron(reshape(y(kk,:),2,N/2),ones(1,2));
    
        % forming the equalization matrix
        hEq(2*kk-1:2*kk,:) = hMod;
        hEq(2*kk-1,1:2:end) = conj(hEq(2*kk-1,1:2:end));
        hEq(2*kk,  2:2:end) = conj(hEq(2*kk,  2:2:end));

    end
    
    for ll = 1:nRx_4
        
        hMod4 = kron(reshape(h_4(ll,:),4,N/4),ones(1,8));
        temp4 = hMod4;
        tempc1 = [0,1,0,0;-1,0,0,0;0,0,0,1;0,0,-1,0];
        tempc2 = [0,0,1,0;0,0,0,-1;-1,0,0,0;0,1,0,0];
        tempc3 = [0,0,0,1;0,0,1,0;0,-1,0,0;-1,0,0,0];
        hMod4(:,2:8:end) = tempc1*temp4(:,1:8:end);
        hMod4(:,3:8:end) = tempc2*temp4(:,1:8:end);
        hMod4(:,4:8:end) = tempc3*temp4(:,1:8:end);
        hMod4(:,5:8:end) = conj(hMod4(:,1:8:end));
        for mm = 6:8
            hMod4(:,mm:8:end) = -conj(hMod4(:,mm-4:8:end));
        end
        y_4(ll,:) = sum(hMod4.*sCode_4,1) + 10^(-Eb_N0_dB(ii)/20)*n_4(ll,:);
        
        yMod_4(8*ll-7:8*ll,:) = kron(reshape(y_4(ll,:),8,N/4),ones(1,4));
        hEq4(8*ll-7:8*ll,:)=zeros(8,N);
        hEq4(8*ll-7:8*ll,1:4:end) = conj(reshape(hMod4(1,:),8,N/4));
        hEq4(8*ll-7:8*ll,2:4:end) = conj(reshape(hMod4(2,:),8,N/4));
        hEq4(8*ll-7:8*ll,3:4:end) = conj(reshape(hMod4(3,:),8,N/4));
        hEq4(8*ll-7:8*ll,4:4:end) = conj(reshape(hMod4(4,:),8,N/4));
        
    end
    
    % Jafarkhani Q-OSTBC 
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
        
        % pair-wise ML decoding Q-OSTBC
        % find min s1 and s4 for different combinations
        vector_c=combvec([-1,1],[-1,1]).';
        sa=vector_c(:,2);
        sb=vector_c(:,1);
        
        f_1_4=(abs(sa).^2+abs(sb).^2)* (sum(abs(K).^2)) + 2*real ( (-K(1)*conj(R(1))- conj(K(2))*R(2)-conj(K(3))*R(3)-K(4)*conj(R(4)))*sa+sb*(-K(4)*conj(R(1))+conj(K(3))*R(2)+conj(K(2))*R(3)-K(1)*conj(R(4)) )  )+4*real( K(1)*conj(K(4))-conj(K(2))*K(3) )*real( sa.*conj(sb));       

        % find for S1 corresponding bits
        [H1,I]=min(f_1_4);
        J(ll*4-3)=vector_c(I,2);
        
        % find for S4 corresponding bits
        [H1,I]=min(f_1_4);
        J(ll*4)=vector_c(I,1);
         
        % cost function f2_3
        f_2_3=(abs(sa).^2+abs(sb).^2)* (sum(abs(K).^2)) + 2*real ( (-K(2)*conj(R(1))+ conj(K(1))*R(2)-conj(K(4))*R(3)+K(3)*conj(R(4)))*sa+sb*(-K(3)*conj(R(1))-conj(K(4))*R(2)+conj(K(1))*R(3)+K(2)*conj(R(4)) )  )+4*real( K(2)*conj(K(3))-conj(K(1))*K(4) )*real( sa.*conj(sb));  

        % find for S2 corresponding bits
        [H1,I]=min(f_2_3);
        J(ll*4-2)=vector_c(I,2);

        % find for S3 corresponding bits
        [H1,I]=min(f_2_3);
        J(ll*4-1)=vector_c(I,1);
        
    end
    
    op=(J+1)/2;
    % count Jafarkhani Q-OSTBC errors
    count=sum(abs(op-ip));
    simBer_Jafarkhani(ii)=count/N;
    
    % equalization
    hEqPower_2_1 = sum(hEq(1:2,:).*conj(hEq(1:2,:)),1);
    hEqPower_2_2 = sum(hEq.*conj(hEq),1);
    hEqPower_4_1 = sum(hEq4(1:8,:).*conj(hEq4(1:8,:)),1);
    hEqPower_4_2 = sum(hEq4.*conj(hEq4),1);
    yHat_2_1 = sum(hEq(1:2,:).*yMod(1:2,:),1)./hEqPower_2_1;
    yHat_2_2 = sum(hEq.*yMod,1)./hEqPower_2_2; % [h1*y1 + h2y2*, h2*y1 -h1y2*, ... ]
    yHat_4_1 = sum(hEq4(1:8,:).*yMod_4(1:8,:),1)./hEqPower_4_1;
    yHat_4_2 = sum(hEq4.*yMod_4,1)./hEqPower_4_2;

    % receiver - hard decision decoding
    ipHat_2_1 = real(yHat_2_1)>0;
    ipHat_2_2 = real(yHat_2_2)>0;
    ipHat_4_1 = real(yHat_4_1)>0;
    ipHat_4_2 = real(yHat_4_2)>0;
    % counting the errors
    nErr_2_1(ii) = size(find(ip - ipHat_2_1),2);
    nErr_2_2(ii) = size(find(ip - ipHat_2_2),2);
    nErr_4_1(ii) =size(find(ip - ipHat_4_1),2);
    nErr_4_2(ii) =size(find(ip - ipHat_4_2),2);

end

simBer_2_1 = nErr_2_1/N; % simulated ber
simBer_2_2 = nErr_2_2/N;
simBer_4_1 = nErr_4_1/N;
simBer_4_2 = nErr_4_2/N;

close all
figure
semilogy(Eb_N0_dB,simBer_2_1,'mo-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,simBer_2_2,'kd-','LineWidth',2);
semilogy(Eb_N0_dB,simBer_4_1,'bp-','LineWidth',2);
semilogy(Eb_N0_dB,simBer_4_2,'c+-','LineWidth',2);
semilogy(Eb_N0_dB,simBer_Jafarkhani,'r>-','LineWidth',2);
axis([0 25 10^-5 0.5]);
grid on
legend('sim (nTx=2, nRx=1, Alamouti(OSTBC))','sim (nTx=2, nRx=2, Alamouti(OSTBC))','sim (nTx=4, nRx=1, Alamouti(OSTBC))','sim (nTx=4, nRx=2, Alamouti(OSTBC))','sim (nTx=4, nRx=1, Jafarkhani(Q-OSTBC))');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK modulation with 2Tx/4Tx, 1Rx/2Rx Alamouti OSTBC (Rayleigh channel)');