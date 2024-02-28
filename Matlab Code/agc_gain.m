function out = agc_gain(in, signal)

% TODO: Implement this yourself!
% TIP: What can the output bits tell you about the signal amplitude
% beforing decoding?

% out = in./max(abs(in));

sig_max = max(abs(in));  % Use the first bit (0) to adjust the gain

Gain    = 4;
sig_max = sig_max * Gain;

while (sig_max < 64)
    Gain    = Gain * 2;
    sig_max = sig_max * 2;
end

out = signal * Gain;

end

