% clear
% close all

freq_list = [];
ber_list = [];
dev = [];

for i=1:1001
%% Settings

% baseband modeling parameters
use_fec = false; % enable/disable forward error correction
bt = 0.5; % gaussian filter bandwidth
snr = 25; % in-band signal to noise ratio (dB)
osr = 16; % oversampling ratio

% RF modeling parameters
use_rf = true; % enable/disable RF model
adc_levels = 32; % number of ADC output codes (NB: #bits = log2[#levels])
br = 100; % bit rate (bit/s)
%fc = 20e3; % carrier frequency (Hz)
fc = 20.0e3 + 500*(-1+2*rand(1,1)); % carrier frequency (Hz)
fs = 64000; % sample frequency (Hz)


% plotting parameters
plot_raw_data = false;
plot_rf_signal = false;

% input message
message_in = 'yeet, skeet, repeat and skeet once again';

deviation = 0;

%% Modulation

% varicode encoding
plain_in = varicode_encode(message_in);

% FEC encoding (optional)
if use_fec
    encoded_in = fec_encode(plain_in);
else
    encoded_in = plain_in;
end

% GMSK modulation
complex_envelope_in = gmsk_modulate(encoded_in, bt, osr);



% upmixing
if use_rf
    signal_in = iq_upmixer(complex_envelope_in, osr, br, fc, fs);
end


%% Channel model

% add noise
if use_rf
    signal_out = signal_add_noise(signal_in, snr, br, fs);
    signal_out = (0.001+(0.1-0.001)*rand(1,1))*signal_out;
    %signal_out = (0.001)*signal_out;
else
    complex_envelope_out = complex_envelope_add_noise(complex_envelope_in, snr, osr);
end


%% Demodulation
if use_rf
    
    % quantization
    signal_quantized = quantize((signal_out.*4+0.5));   % basic Gain is 4

    % coarse recovery -- fft with first bit, which is also used for gain
    % control
    spect = abs(fft(signal_quantized(1:640)));
    [~, fre_fftmax] = max(spect(196:206)); % calculate only points of interests 
    deviation = deviation + (fre_fftmax-1-5)*100;
    
    % automatic gain control
    signal_agc = agc_gain(signal_quantized(1:640), signal_out);
    signal_quantized = quantize((signal_agc+0.5));

    % downmixing
    complex_envelope_out = iq_downmixer(signal_quantized(1:2000), osr, br, fc, fs, deviation);
    
end

% GMSK demodulation
raw_out = gmsk_demodulate(complex_envelope_out, osr);

% fine recovery -- with 2 bits, second bit 0 and third bit 1
% NCO frequency is further modified at the beginning of the fourth bit
deviation = deviation + floor(mean(raw_out(17:48))/40); % should be /40 but /32 is eaiser in hw, but if /32, accuracy degrades

complex_envelope_out = iq_downmixer(signal_quantized, osr, br, fc, fs, deviation);
raw_out = gmsk_demodulate(complex_envelope_out, osr);

% clock recovery
clock_out = clock_recovery(raw_out, osr);

% extract bits
encoded_out = extract_bits(raw_out, clock_out, osr);

% FEC decoding (optional)
if use_fec
    plain_out = fec_decode(encoded_out);
else
    plain_out = encoded_out;
end


% varicode decoding
message_out = varicode_decode(plain_out);
ber = BER(plain_in, plain_out(end-length(plain_in)+1:end))*100; %in percent
ber_list(i) = ber;
freq_list(i) = fc;
dev(i) = deviation;

end
freq_list = freq_list - 20000;


%% Plotting

raw_in = repelem(encoded_in * 2 - 1, osr, 1);

if plot_raw_data
    figure('Name', 'Raw data');
    time_in = ((1 : numel(raw_in))' - 1) / osr;
    time_out = ((1 : numel(raw_out))' - 1) / osr;
    h = plot(time_in, raw_in, '-', ...
             time_out, raw_out./max(raw_out), '-', ...
             clock_out, encoded_out * 2 - 1, 'sk');
    set(h, {'MarkerFaceColor'}, get(h, 'Color')); 
    grid();
end

if plot_rf_signal && use_rf
    figure('Name', 'RF signal');
    time_in = ((1 : numel(signal_in))' - 1) / osr;
    time_out = ((1 : numel(signal_out))' - 1) / osr;
    plot(time_in, signal_in, '-', ...
         time_out, signal_out, '-');
    grid();
end
