%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author        : Xusheng Chen
% Email         : xusheng41@gmail.com
% Date          : 4th April 2013
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script for computing the BER for BPSK modulation in a
% Rayleigh fading channel with Alamouti Space Time Block Coding
% Two transmit antenna, Two Receive antenna

clear
N = 10^5; % number of bits or symbols
Eb_N0_dB = (0:25); % multiple Eb/N0 values
nRx = 1;
nRx_4 = 1;
for ii = 1:length(Eb_N0_dB)

    % Transmitter
    ip = rand(1,N)>0.5; % generating 0,1 with equal probability
    s = 2*ip-1; % BPSK modulation 0 -> -1; 1 -> 1

    % Alamouti STBC 
    sCode = 1/sqrt(2)*kron(reshape(s,2,N/2),ones(1,2)) ;
    sCode4 = 1/sqrt(2)*kron(reshape(s,4,N/4),ones(1,8));
    
    % channel
    h = 1/sqrt(2)*(randn(nRx,N) + 1i*randn(nRx,N)); % Rayleigh channel
    h4 = 1/sqrt(2)*(randn(nRx_4,N) + 1i*randn(nRx_4,N)); % Rayleigh channel
    n = 1/sqrt(2)*(randn(nRx,N) + 1i*randn(nRx,N)); % white gaussian noise, 0dB variance
    n4 = 1/sqrt(2)*(randn(nRx_4,N*2) + 1i*randn(nRx_4,N*2)); % white gaussian noise, 0dB variance

    y = zeros(nRx,N);
    y4 = zeros(nRx_4,N*2);
    yMod = zeros(nRx*2,N);
    yMod4 = zeros(nRx_4*8,N);
    for kk = 1:nRx

        hMod = kron(reshape(h(kk,:),2,N/2),ones(1,2)); % repeating the same channel for two symbols    
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
        
        hMod4 = kron(reshape(h4(ll,:),4,N/4),ones(1,8));
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
        y4(ll,:) = sum(hMod4.*sCode4,1) + 10^(-Eb_N0_dB(ii)/20)*n4(ll,:);
        
        yMod4(8*ll-7:8*ll,:) = kron(reshape(y4(ll,:),8,N/4),ones(1,4));
        hEq4(8*ll-7:8*ll,:)=zeros(8,N);
        hEq4(8*ll-7:8*ll,1:4:end) = conj(reshape(hMod4(1,:),8,N/4));
        hEq4(8*ll-7:8*ll,2:4:end) = conj(reshape(hMod4(2,:),8,N/4));
        hEq4(8*ll-7:8*ll,3:4:end) = conj(reshape(hMod4(3,:),8,N/4));
        hEq4(8*ll-7:8*ll,4:4:end) = conj(reshape(hMod4(4,:),8,N/4));
        
    end
    % equalization 
    hEqPower = sum(hEq.*conj(hEq),1);
    hEqPower4 = sum(hEq4.*conj(hEq4),1);
    yHat = sum(hEq.*yMod,1)./hEqPower; % [h1*y1 + h2y2*, h2*y1 -h1y2*, ... ]
    yHat4 = sum(hEq4.*yMod4,1)./hEqPower4;

    % receiver - hard decision decoding
    ipHat = real(yHat)>0;
    ipHat4 = real(yHat4)>0;
    % counting the errors
    nErr(ii) = size(find(ip - ipHat),2);
    nErr4(ii) =size(find(ip - ipHat4),2);
end

simBer = nErr/N; % simulated ber
simBer4 = nErr4/N;

close all
figure
semilogy(Eb_N0_dB,simBer,'mo-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,simBer4,'bp-','LineWidth',2);
axis([0 25 10^-5 0.5]);
grid on
legend('sim (nTx=2, nRx=1, Alamouti)','sim (nTx=4, nRx=1, Alamouti)');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK modulation with 2Tx/4Tx, 1Rx Alamouti STBC (Rayleigh channel)');