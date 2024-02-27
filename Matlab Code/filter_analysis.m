close all
clear all
fs = 51200; 
D = 32;
N = 512; % delay buffer depth
fs_new = fs/D;


impuls = zeros(1,fs);
impuls(1) = 1;
impulse_response = CIC_filter(impuls,N,D);

p = fft(impulse_response);
L = length(impulse_response);
k = 0:L/2;
freq = k*fs/D/L;

%plot(freq, mag2db(abs(p(1:(L/2+1)))))


filter = dsp.FIRFilter('Numerator',ones(1,N)/N);
fvtool(filter,"fs",fs)

t = 0:1/fs:1;
t_new = 0:1/fs_new:1;
fc = 400;
input = sin(2*pi*fc*t);
output = CIC_filter(input,N,D);
figure(3)
plot(t(1:fs/fc*8),input(1:fs/fc*8))
hold on
plot(t_new(1:fs_new/fc*8),output(1:fs_new/fc*8))
figure(4)
plot(t(fs/fc*50:fs/fc*58),input(fs/fc*50:fs/fc*58))
hold on
plot(t_new(fs_new/fc*50:fs_new/fc*58),output(fs_new/fc*50:fs_new/fc*58))

% cic = dsp.CICDecimator(D,N/D,1);
% 
% %fvtool(cic)
% 
% output = filter(cic,input);
% figure(4)
% plot(t(1:fs/fc*5),input(1:fs/fc*5))
% hold on
% plot(t_new(1:fs_new/fc*5),output(1:fs_new/fc*5))







function filtered_signal = CIC_filter(signal, N, D)
    delayBuffer = zeros(1,N/D);
    intOut = 0;
    filtered_signal = [];

    for i = 1:length(signal)
        % integrator
        intOut = intOut + signal(i);
        % Decimator
        if mod(i,D)==1
            % Comb
            combOut = intOut - delayBuffer(end);
            combOut = combOut / (N);

            % Shift delay buffer
            delayBuffer(2:end) = delayBuffer(1:end-1);

            % Set first value of delay buffer
            delayBuffer(1) = intOut;
            filtered_signal = [ filtered_signal combOut];  
        end

    end
end