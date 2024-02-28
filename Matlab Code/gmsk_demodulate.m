function raw = gmsk_demodulate(complex_envelope, osr)

% TODO: This is a very simple demodulator to get you started. There are
% lots of things that can be improved!
% TIP: Search for demodulation methods online. Are you going for the
% coherent or incoherent approach?
I_signal = real(complex_envelope);
Q_signal = imag(complex_envelope);


%% apply a simple filter
filt = ones(osr / 2 + 1);
filt =  filt / sum(filt);
complex_envelope = conv(complex_envelope, filt, 'same');


% % apply low pass filter 
% h = [ -0.0025 -0.0020 -0.0022 -0.0021 -0.0014 -0.0002 0.0013 0.0029 0.0044 0.0054 0.0057 0.0053 0.0043 0.0028 0.0013 0.0000 -0.0007 -0.0008 -0.0003 0.0005 0.0015 0.0022 0.0024 0.0020 0.0012 0.0001 -0.0009 -0.0015 -0.0016 -0.0011 -0.0002 0.0009 0.0017 0.0021 0.0018 0.0010 -0.0001 -0.0012 -0.0020 -0.0021 -0.0015 -0.0005 0.0008 0.0019 0.0024 0.0022 0.0013 -0.0001 -0.0014 -0.0024 -0.0026 -0.0020 -0.0008 0.0008 0.0021 0.0029 0.0027 0.0017 0.0001 -0.0016 -0.0028 -0.0033 -0.0027 -0.0012 0.0007 0.0025 0.0035 0.0035 0.0024 0.0005 -0.0017 -0.0034 -0.0041 -0.0036 -0.0018 0.0005 0.0028 0.0044 0.0046 0.0033 0.0010 -0.0018 -0.0041 -0.0053 -0.0048 -0.0027 0.0003 0.0033 0.0055 0.0060 0.0047 0.0017 -0.0019 -0.0051 -0.0069 -0.0066 -0.0041 -0.0002 0.0040 0.0072 0.0083 0.0068 0.0030 -0.0020 -0.0067 -0.0096 -0.0096 -0.0065 -0.0011 0.0051 0.0102 0.0124 0.0108 0.0055 -0.0020 -0.0097 -0.0149 -0.0159 -0.0117 -0.0032 0.0075 0.0171 0.0225 0.0212 0.0125 -0.0021 -0.0188 -0.0329 -0.0389 -0.0329 -0.0129 0.0199 0.0614 0.1053 0.1439 0.1703 0.1797 0.1703 0.1439 0.1053 0.0614 0.0199 -0.0129 -0.0329 -0.0389 -0.0329 -0.0188 -0.0021 0.0125 0.0212 0.0225 0.0171 0.0075 -0.0032 -0.0117 -0.0159 -0.0149 -0.0097 -0.0020 0.0055 0.0108 0.0124 0.0102 0.0051 -0.0011 -0.0065 -0.0096 -0.0096 -0.0067 -0.0020 0.0030 0.0068 0.0083 0.0072 0.0040 -0.0002 -0.0041 -0.0066 -0.0069 -0.0051 -0.0019 0.0017 0.0047 0.0060 0.0055 0.0033 0.0003 -0.0027 -0.0048 -0.0053 -0.0041 -0.0018 0.0010 0.0033 0.0046 0.0044 0.0028 0.0005 -0.0018 -0.0036 -0.0041 -0.0034 -0.0017 0.0005 0.0024 0.0035 0.0035 0.0025 0.0007 -0.0012 -0.0027 -0.0033 -0.0028 -0.0016 0.0001 0.0017 0.0027 0.0029 0.0021 0.0008 -0.0008 -0.0020 -0.0026 -0.0024 -0.0014 -0.0001 0.0013 0.0022 0.0024 0.0019 0.0008 -0.0005 -0.0015 -0.0021 -0.0020 -0.0012 -0.0001 0.0010 0.0018 0.0021 0.0017 0.0009 -0.0002 -0.0011 -0.0016 -0.0015 -0.0009 0.0001 0.0012 0.0020 0.0024 0.0022 0.0015 0.0005 -0.0003 -0.0008 -0.0007 0.0000 0.0013 0.0028 0.0043 0.0053 0.0057 0.0054 0.0044 0.0029 0.0013 -0.0002 -0.0014 -0.0021 -0.0022 -0.0020 -0.0025 ];
% complex_envelope = conv(complex_envelope, h, 'same');


%% CORDIC ARCTAN
I = real(complex_envelope);
Q = imag(complex_envelope);
phase = [];
for i = 1:length(I)
    phase(i) = cordicArctan(Q(i), I(i));
end

%% UNWRAPPING, works but is slow, can be better, potentially by doing a check in the derivator
% angle_range = 2^16;
% for i = 2:length(phase)    
%     d = phase(i) - phase(i-1);
%     while d > angle_range/2
%         phase(i) = phase(i) - (angle_range);
%         d = phase(i) - phase(i-1);
%     end
%     while d < -angle_range/2
%         phase(i) = phase(i) + (angle_range);
%         d = phase(i) - phase(i-1);
%     end
% end

%% DERIVATOR
angle_range = 2^16;
raw = [];
for i = 2:length(phase)
    
    % calculate difference between consecutive points
    d = phase(i) - phase(i-1);

    % check for wrapping jumps and adjust difference
    if d > angle_range/2
       d = d - angle_range;
    elseif d < -angle_range/2
       d = d + angle_range;
    end


    raw(i) = d; 
end


end