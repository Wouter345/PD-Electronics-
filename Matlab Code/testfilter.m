clear all
close all
% For decimation, having the CIC filtering before taking every other sample
D = 2; % decimation factor
N = 64; % delay buffer depth
delayBuffer = zeros(1,N); % init
intOut = 0;
xn = sin(2*pi*[0:.1:100]);
y6n = [];
for ii = 1:length(xn)
% comb section
combOut = xn(ii) - delayBuffer(end);
delayBuffer(2:end) = delayBuffer(1:end-1);
delayBuffer(1) = xn(ii);

% integrator
intOut = intOut + combOut;
y6n = [y6n intOut];

end
y6n = y6n(1:D:end); % taking every other sample – decimation

% For efficient hardware implementation of the CIC filter, having the
% integrator section first, decimate, then the comb stage
% Gain : Reduced the delay buffer depth of comb section from N to N/D
D = 2; % decimation factor
N = 64; % delay buffer depth
delayBuffer = zeros(1,N/D);
intOut = 0;
xn = sin(2*pi*[0:.1:100]); % input
y7n = []; % output
for ii = 1:length(xn)
% integrator
intOut = intOut + xn(ii);

if mod(ii,2)==1
% comb section
combOut = intOut - delayBuffer(end);
delayBuffer(2:end) = delayBuffer(1:end-1);
delayBuffer(1) = intOut;
y7n = [ y7n combOut];
end

end
err67 = y6n - y7n;
err67dB = 10*log10(err67*err67'/length(err67));


