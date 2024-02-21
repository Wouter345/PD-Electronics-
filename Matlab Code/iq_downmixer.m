function complex_envelope = iq_downmixer(signal, osr, br, fc, fs)

% TODO: You may want to implement a better downsampling filter.
% TIP: Look up 'CIC' filters as inspiration for an efficient hardware 
% implementation. Also think about how you will generate the LO signal in
% hardware, looking up 'CORDIC' will set you in a correct direction.

% IQ downmixer
t = ((1 : numel(signal))' - 1) / fs;
upsampled_envelope = 2 * exp(-1j * 2 * pi * fc * t) .* signal;
I_signal = real(upsampled_envelope);
Q_signal = imag(upsampled_envelope);


% CIC WITHOUT DOWNSAMPLING
D = 32; % decimation factor
N = 64; % delay buffer depth
delayBufferI = zeros(1,N); % init
delayBufferQ = zeros(1,N); % init
intOutI = 0;
intOutQ = 0;
I_downsampled = [];
Q_downsampled = [];
for i = 1:length(I_signal)
% comb section
combOutI = I_signal(i) - delayBufferI(end);
combOutQ = Q_signal(i) - delayBufferQ(end);
delayBufferI(2:end) = delayBufferI(1:end-1);
delayBufferQ(2:end) = delayBufferQ(1:end-1);
delayBufferI(1) = I_signal(i);
delayBufferQ(1) = Q_signal(i);

% integrator
intOutI = intOutI + combOutI;
intOutQ = intOutQ + combOutQ;
I_downsampled = [ I_downsampled intOutI];  
Q_downsampled = [ Q_downsampled intOutQ]; 
end

I_downsampled = I_downsampled(1:D:end);
Q_downsampled = Q_downsampled(1:D:end);

complex_envelope1 = I_downsampled + 1i*Q_downsampled;

%CIC DOWNSAMPLING FILTER 
D = 32; %Decimation factor
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




% % COMPARE CIC IMPLEMENTATION TO SIMPLE EXAMPLE
% 
% % apply a simple downsampling filter
% filt = ones(2 * round(fs / (br * osr)) + 1);
% upsampled_envelope = conv(upsampled_envelope, filt / sum(filt), 'same');
% 
% % calculate number of output samples
% n1 = numel(upsampled_envelope);
% n2 = round((n1 - 1) * (br * osr) / fs) + 1;
% 
% % resample the complex envelope to the new sample rate
% t1 = ((1 : n1)' - 1) / fs;
% t2 = ((1 : n2)' - 1) / (br * osr);
% complex_envelope = interp1(t1, upsampled_envelope, t2);



end