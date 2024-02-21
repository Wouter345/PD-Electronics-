clear all
close all
fs = 50000;
t = linspace(-1,1,fs);
function1 = cos(2*pi*t*10);
function2 = cos(2*pi*t*100);
function3 = cos(2*pi*t*5000);

filt = ones(50);
filter = filt/sum(filt);

response1 = conv(function1, filter);
response2 = conv(function2, filter);
response3 = conv(function3, filter);

figure(1)
plot(function3(5000:5250))
hold on 
plot(response3(5000:5250))

% Calculate frequency response
figure(2)
freqz(filter);
[H, w] = freqz(filter);

% Plot magnitude response
figure(9)
plot(w/pi, abs(H));
title('Magnitude Response of Averaging Filter');
xlabel('Normalized Frequency');
ylabel('Magnitude');