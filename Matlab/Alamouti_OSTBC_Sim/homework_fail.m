%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author        : Xusheng Chen
% Email         : xusheng41@gmail.com
% Date          : 4th April 2013
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script for computing the BER for BPSK modulation in a
% Rayleigh fading channel with Alamouti Space Time Block Coding
% Two transmit antenna, Two Receive antenna

clear
N = 10^4; % number of bits or symbols
Eb_N0_dB = (0:25); % multiple Eb/N0 values

for ii = 1:length(Eb_N0_dB)

    % Transmitter
    ip = rand(1,N)>0.5; % generating 0,1 with equal probability
    s = 2*ip-1; % BPSK modulation 0 -> -1; 1 -> 1

    % Alamouti STBC 
    sCode4 = 1/sqrt(2)*kron(reshape(s,4,N/4),ones(1,4));
    
    % channel
    h4 = 1/sqrt(2)*(randn(1,N) + 1i*randn(1,N)); % Rayleigh channel
    n4 = 1/sqrt(2)*(randn(1,N) + 1i*randn(1,N)); % white gaussian noise, 0dB variance

    y4 = zeros(1,N);
    ipHat4 = zeros(1,N);
    
    hMod4 = kron(reshape(h4(1,:),4,N/4),ones(1,4));
    temp4 = hMod4;
    tempc1 = [0,1,0,0;-1,0,0,0;0,0,0,1;0,0,-1,0];
    tempc2 = [0,0,1,0;0,0,0,1;-1,0,0,0;0,-1,0,0];
    tempc3 = [0,0,0,1;0,0,-1,0;0,-1,0,0;1,0,0,0];
    hMod4(:,2:4:end) = conj(tempc1*temp4(:,1:4:end));
    hMod4(:,3:4:end) = conj(tempc2*temp4(:,1:4:end));
    hMod4(:,4:4:end) = tempc3*temp4(:,1:4:end);

    y4(1,:) = sum(hMod4.*sCode4,1) + 10^(-Eb_N0_dB(ii)/20)*n4(1,:);
        
    for ll = 1:N/4
            htemp = hMod4(:,4*ll-3:4*ll);
            rtemp = y4(1,4*ll-3:4*ll);
        for mm = 1:4
            switch mm
                case 1
                    cmp(mm)=2*(htemp(:,1))'*htemp(:,1)+2*real((-htemp(1,:)*rtemp')*(-1)+(-htemp(4,:)*rtemp')*(-1))+4*real(htemp(1,1)*conj(rtemp(4))-htemp(1,2)*rtemp(3));
                    cmp2(mm)=2*(htemp(:,1))'*htemp(:,1)+2*real((-htemp(2,:)*rtemp')*(-1)+(-htemp(3,:)*rtemp')*(-1))+4*real(htemp(2,1)*rtemp(3)+htemp(2,2)*rtemp(4));
                case 2
                    cmp(mm)=2*(htemp(:,1))'*htemp(:,1)+2*real((-htemp(1,:)*rtemp')*(-1)+(-htemp(4,:)*rtemp')*(1))-4*real(htemp(1,1)*conj(rtemp(4))-htemp(1,2)*rtemp(3));
                    cmp2(mm)=2*(htemp(:,1))'*htemp(:,1)+2*real((-htemp(2,:)*rtemp')*(-1)+(-htemp(3,:)*rtemp')*(1))-4*real(htemp(2,1)*rtemp(3)+htemp(2,2)*rtemp(4));
                case 3
                    cmp(mm)=2*(htemp(:,1))'*htemp(:,1)+2*real((-htemp(1,:)*rtemp')*(1)+(-htemp(4,:)*rtemp')*(-1))-4*real(htemp(1,1)*conj(rtemp(4))-htemp(1,2)*rtemp(3));
                    cmp2(mm)=2*(htemp(:,1))'*htemp(:,1)+2*real((-htemp(2,:)*rtemp')*(1)+(-htemp(3,:)*rtemp')*(-1))-4*real(htemp(2,1)*rtemp(3)+htemp(2,2)*rtemp(4));
                case 4
                    cmp(mm)=2*(htemp(:,1))'*htemp(:,1)+2*real((-htemp(1,:)*rtemp')*(1)+(-htemp(4,:)*rtemp')*(1))+4*real(htemp(1,1)*conj(rtemp(4))-htemp(1,2)*rtemp(3));
                    cmp2(mm)=2*(htemp(:,1))'*htemp(:,1)+2*real((-htemp(2,:)*rtemp')*(1)+(-htemp(3,:)*rtemp')*(1))+4*real(htemp(2,1)*rtemp(3)+htemp(2,2)*rtemp(4));
            end
        end
        [numb,n]=min(cmp);
        switch n
            case 1
                ipHat4(4*ll-3) = 0;
                ipHat4(4*ll) = 0;
            case 2
                ipHat4(4*ll-3) = 0;
                ipHat4(4*ll) = 1;
            case 3
                ipHat4(4*ll-3) = 1;
                ipHat4(4*ll) = 0;
            case 4
                ipHat4(4*ll-3) = 1;
                ipHat4(4*ll) = 1;
        end
        [numb,n]=min(cmp2);
        switch n
            case 1
                ipHat4(4*ll-2) = 0;
                ipHat4(4*ll-1) = 0;
            case 2
                ipHat4(4*ll-2) = 0;
                ipHat4(4*ll-1) = 1;
            case 3
                ipHat4(4*ll-2) = 1;
                ipHat4(4*ll-1) = 0;
            case 4
                ipHat4(4*ll-2) = 1;
                ipHat4(4*ll-1) = 1;
        end

    end

    % counting the errors
    nErr4(ii) =size(find(ip - ipHat4),2);

end

simBer4 = nErr4/N;

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