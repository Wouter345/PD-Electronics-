function complex_envelope = iq_downmixer(signal, osr, br, fc, fs, deviation)

% TODO: 
% DONE: CIC Downsampling filter, 1 stage
%       Mixer implemented with CORDIC algorithm


%% IQ downmixer
upsampled_envelope = []; %output
sinwave = []; 
coswave = [];
% phase = 0; % initialize phase value

phase = NCOControl(deviation, length(signal));
for i=1:length(signal)
    [sinwave(i), coswave(i)] = cordicSinCos(phase(i)); %generate sin and cos waves
    % normalizing not strictly necessary.
    sinwave(i) = floor(sinwave(i)./(2^13)); 
    coswave(i) = floor(coswave(i)./(2^13));
    
    I = signal(i)*coswave(i); % perform multiplication
    Q = signal(i)*sinwave(i);
    
    upsampled_envelope(i) = I+1j*Q;
end
% for i=1:length(signal)
%     [sinwave(i), coswave(i)] = cordicSinCos(phase); %generate sin and cos waves
% 
%     % normalizing not strictly necessary.
% %     sinwave(i) = sinwave(i)./13491; 
% %     coswave(i) = coswave(i)./13491;
%     I = signal(i)*coswave(i); % perform multiplication
%     Q = signal(i)*sinwave(i);
%     upsampled_envelope(i) = I+1j*Q;
% 
%     % increment phase value
%     phase = phase + 2^16 * fc/fs; % increment phase by 2^16 * fc/fs = 20480 angle units
%     if phase > 2^16 % implement rollover, only necessary in matlab
%         phase = phase - 2^16;
%     end
% 
% end
upsampled_envelope = upsampled_envelope'; 

%% CIC DOWNSAMPLING FILTER 
I_signal = real(upsampled_envelope);
Q_signal = imag(upsampled_envelope);

D = fs / (br*osr); %Decimation factor, NEEDS TO BE AN INTEGER
N = D*1;
delayBufferI = zeros(1,N/D);
delayBufferQ = zeros(1,N/D);
intOutI = 0;
intOutIlist = [0];
intOutQ = 0;
I_downsampled = [];
Q_downsampled = [];

for i = 1:length(I_signal)
    % integrator
    intOutI = intOutI + I_signal(i);
    intOutQ = intOutQ + Q_signal(i);
    intOutIlist(i) = intOutI;

    % Decimator
    if mod(i,D)==1
        % Comb
        combOutI = intOutI - delayBufferI(end);
        combOutQ = intOutQ - delayBufferQ(end);
        
%         % for normalizing the filter, not strictly necesarry
%         combOutI = combOutI / (N);
%         combOutQ = combOutQ / (N);
        
        % Shift delay buffer
        delayBufferI(2:end) = delayBufferI(1:end-1);
        delayBufferQ(2:end) = delayBufferQ(1:end-1);
        
        % Set first value of delay buffer
        delayBufferI(1) = intOutI;
        delayBufferQ(1) = intOutQ;
        I_downsampled = [ I_downsampled combOutI];  
        Q_downsampled = [ Q_downsampled combOutQ]; 
    end
    
end

%% Compensation filter

% % order 16, cutoff 120hz, 16 bits
% h = [ -0.0124 -0.0053 0.0240 0.1101 0.2736 0.5013 0.7434 0.9299 1.0000 0.9299 0.7434 0.5013 0.2736 0.1101 0.0240 -0.0053 -0.0124 ];

% % order 64, cutoff 120hz, 16 bits
% h = [ 0.0034 0.0052 0.0063 0.0064 0.0048 0.0012 -0.0046 -0.0117 -0.0185 -0.0227 -0.0218 -0.0139 0.0014 0.0222 0.0443 0.0619 0.0682 0.0576 0.0277 -0.0197 -0.0771 -0.1325 -0.1704 -0.1753 -0.1343 -0.0409 0.1030 0.2861 0.4889 0.6862 0.8515 0.9615 1.0000 0.9615 0.8515 0.6862 0.4889 0.2861 0.1030 -0.0409 -0.1343 -0.1753 -0.1704 -0.1325 -0.0771 -0.0197 0.0277 0.0576 0.0682 0.0619 0.0443 0.0222 0.0014 -0.0139 -0.0218 -0.0227 -0.0185 -0.0117 -0.0046 0.0012 0.0048 0.0064 0.0063 0.0052 0.0034 ];

% % order 64, cutoff 100hz, 16 bits
% h = [ -22.0000 -106.0000 -193.0000 -279.0000 -347.0000 -375.0000 -334.0000 -196.0000 54.0000 405.0000 821.0000 1229.0000 1534.0000 1627.0000 1411.0000 825.0000 -135.0000 -1394.0000 -2794.0000 -4103.0000 -5036.0000 -5297.0000 -4618.0000 -2813.0000 185.0000 4294.0000 9278.0000 14761.0000 20268.0000 25276.0000 29283.0000 31872.0000 32767.0000 31872.0000 29283.0000 25276.0000 20268.0000 14761.0000 9278.0000 4294.0000 185.0000 -2813.0000 -4618.0000 -5297.0000 -5036.0000 -4103.0000 -2794.0000 -1394.0000 -135.0000 825.0000 1411.0000 1627.0000 1534.0000 1229.0000 821.0000 405.0000 54.0000 -196.0000 -334.0000 -375.0000 -347.0000 -279.0000 -193.0000 -106.0000 -22.0000 ];

% % order 16, cutoff 100hz, 16 bits
% h = [ 16.0000 551.0000 2159.0000 5681.0000 11342.0000 18464.0000 25564.0000 30824.0000 32767.0000 30824.0000 25564.0000 18464.0000 11342.0000 5681.0000 2159.0000 551.0000 16.0000 ];

% order 16, cutoff 100hz, 6 bits
h = [ -1.0000 -0.0000 1.0000 5.0000 10.0000 17.0000 24.0000 29.0000 31.0000 29.0000 24.0000 17.0000 10.0000 5.0000 1.0000 -0.0000 -1.0000 ];
I_downsampled = conv(I_downsampled,h,'same');
Q_downsampled = conv(Q_downsampled,h,'same');

% % Compute the FFT of the signal
% N = length(I_downsampled);
% Y = fft(I_downsampled);
% Y_single_sided = Y(1:N/2+1);
% f = (0:N/2) * 1600 / N;
% % Plot the magnitude of the single-sided FFT
% figure
% plot(f, abs(Y_single_sided));
% xlabel('Frequency (Hz)');
% ylabel('Magnitude');
% title('Frequency Response of the Signal');


%%  Combine to get complex envelope
complex_envelope = I_downsampled + 1i*Q_downsampled;
end