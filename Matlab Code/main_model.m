clear
close all


%% Settings

% baseband modeling parameters
use_fec = false; % enable/disable forward error correction
bt = 0.5; % gaussian filter bandwidth
snr = 20; % in-band signal to noise ratio (dB)
osr = 16; % oversampling ratio

% RF modeling parameters
use_rf = true; % enable/disable RF model
adc_levels = 32; % number of ADC output codes (NB: #bits = log2[#levels])
br = 100; % bit rate (bit/s)
fc = 20.0e3; % carrier frequency (Hz)
fs = 64000; % sample frequency (Hz)

% plotting parameters
plot_raw_data = false;
plot_rf_signal = false;

% input message
message_in = 'yeet, skeet, repeat and skeet once again';


%% Modulation

% varicode encoding
plain_in = varicode_encode(message_in);
plain_in_enc = differentialEncoding(plain_in)';

% FEC encoding (optional)
if use_fec
    encoded_in = fec_encode(plain_in_enc);
else
    encoded_in = plain_in_enc;
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
else
    complex_envelope_out = complex_envelope_add_noise(complex_envelope_in, snr, osr);
end


%% Demodulation
fc = 20e3;
if use_rf
    
    % quantization
    signal_quantized = quantize(signal_out);
    
    % automatic gain control
    signal_agc = agc_gain(signal_quantized(1:640), signal_quantized);
    
    % downmixing
    complex_envelope_out = iq_downmixer(signal_agc, osr, br, fc, fs);
    
end

% GMSK demodulation
raw_out = gmsk_demodulate(complex_envelope_out, osr);

% clock recovery
clock_out = clock_recovery(raw_out, osr);

% extract bits
encoded_out = extract_bits(raw_out, clock_out, osr);

% FEC decoding (optional)
if use_fec
    plain_out_enc = fec_decode(encoded_out);
else
    plain_out_enc = encoded_out;
end

plain_out = differentialDecoding(plain_out_enc)';

% varicode decoding
message_out = varicode_decode(plain_out)

ber = BER(plain_in, plain_out(end-length(plain_in)+1:end))*100 %in percent


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
