function complex_envelope = iq_downmixer(signal, osr, br, fc, fs)

% TODO: Mixer needs to be implemented with CORDIC algorithm
% DONE: CIC Downsampling filter, 1 stage

% IQ downmixer
t = ((1 : numel(signal))' - 1) / fs;
upsampled_envelope = 2 * exp(-1j * 2 * pi * fc * t) .* signal;
I_signal = real(upsampled_envelope);
Q_signal = imag(upsampled_envelope);

%CIC DOWNSAMPLING FILTER 
D = fs / (br*osr); %Decimation factor, NEEDS TO BE AN INTEGER
N = 64; % delay buffer depth
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
complex_envelope = I_downsampled + 1i*Q_downsampled;






end