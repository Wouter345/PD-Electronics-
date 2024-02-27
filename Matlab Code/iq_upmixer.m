function signal = iq_upmixer(complex_envelope, osr, br, fc, fs)

% calculate number of output samples
n1 = numel(complex_envelope);
n2 = round((n1 - 1) * fs / (br * osr)) + 1;

% resample the complex envelope to the new sample rate
t1 = ((1 : n1)' - 1) / (br * osr);
t2 = ((1 : n2)' - 1) / fs;
upsampled_envelope = interp1(t1, complex_envelope, t2);

% IQ upmixer
signal = real(exp(1j * 2 * pi * fc * t2) .* upsampled_envelope);

% % Compute the FFT of the signal
% N = length(real(complex_envelope));
% Y = fft(real(complex_envelope));
% Y_single_sided = Y(1:N/2+1);
% f = (0:N/2) * 1600 / N;
% % Plot the magnitude of the single-sided FFT
% figure
% plot(f, abs(Y_single_sided));
% xlabel('Frequency (Hz)');
% ylabel('Magnitude');
% title('Frequency Response of the Signal');

end