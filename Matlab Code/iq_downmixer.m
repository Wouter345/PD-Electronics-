function complex_envelope = iq_downmixer(signal, osr, br, fc, fs)

% TODO: Mixer needs to be implemented with CORDIC algorithm
% DONE: CIC Downsampling filter, 1 stage

% IQ downmixer
t = ((1 : numel(signal))' - 1) / fs;
upsampled_envelope2 = 2 * exp(-1j * 2 * pi * fc * t) .* signal;

% IQ downmixer
upsampled_envelope = []; %output
sinwave = []; 
coswave = [];
phase = 0;
for i=1:length(signal)
    [sinwave(i), coswave(i)] = cordicSinCos(phase); %generate sin and cos waves
    sinwave(i) = sinwave(i)./13491; % normalize
    coswave(i) = coswave(i)./13491;
    I = signal(i)*2*coswave(i); % perform multiplication
    Q = signal(i)*2*sinwave(i);
    upsampled_envelope(i) = I+1j*Q;
    phase = phase + 20480; % increment phase by 2^16 * fc/fs = 20480 angle units
    if phase > 2^16 % implement rollover, only necessary in matlab
        phase = phase - 2^16;
    end
    
end
upsampled_envelope = upsampled_envelope';

%CIC DOWNSAMPLING FILTER 
I_signal = real(upsampled_envelope);
Q_signal = imag(upsampled_envelope);

D = fs / (br*osr); %Decimation factor, NEEDS TO BE AN INTEGER
N = 40; % delay buffer depth
delayBufferI = zeros(1,N/D);
delayBufferQ = zeros(1,N/D);
intOutI = 0;
intOutQ = 0;
I_downsampled = [];
Q_downsampled = [];

for i = 1:length(I_signal)
    % integrator
    intOutI = intOutI + I_signal(i);
    intOutQ = intOutQ + Q_signal(i);

    % Decimator
    if mod(i,D)==1
        % Comb
        combOutI = intOutI - delayBufferI(end);
        combOutQ = intOutQ - delayBufferQ(end);
        
        % for normalizing the filter, not strictly necesarry
        combOutI = combOutI / (N);
        combOutQ = combOutQ / (N);
        
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

%%%%% Compensation filter

% order 16
h = [ -0.0176 -0.0242 -0.0249 0.0219 0.1598 0.3956 0.6775 0.9099 1.0000 0.9099 0.6775 0.3956 0.1598 0.0219 -0.0249 -0.0242 -0.0176 ];

% order 64
h = [ -0.0004 -0.0030 -0.0050 -0.0059 -0.0047 -0.0011 0.0048 0.0114 0.0158 0.0152 0.0075 -0.0068 -0.0240 -0.0375 -0.0402 -0.0269 0.0022 0.0403 0.0745 0.0895 0.0731 0.0219 -0.0553 -0.1363 -0.1909 -0.1882 -0.1069 0.0569 0.2855 0.5415 0.7761 0.9408 1.0000 0.9408 0.7761 0.5415 0.2855 0.0569 -0.1069 -0.1882 -0.1909 -0.1363 -0.0553 0.0219 0.0731 0.0895 0.0745 0.0403 0.0022 -0.0269 -0.0402 -0.0375 -0.0240 -0.0068 0.0075 0.0152 0.0158 0.0114 0.0048 -0.0011 -0.0047 -0.0059 -0.0050 -0.0030 -0.0004 ];

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


% Combine to get complex envelope
complex_envelope = I_downsampled + 1i*Q_downsampled;
end