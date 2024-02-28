function out = quantize(in)

% clip the input signal
% clipped = max(-1, min(1, in));

% quantize the clipped signal (levels = number of ADC output codes)
% out = round((clipped + 1) / 2 * (levels - 1)) ./ (levels - 1) * 2 - 1;

out = zeros(size(in));

for i = 1 : length(in)
    % 1st bit
    if (in(i) <= 0.5)
       out(i) = out(i)*2;
    else
       out(i) = out(i)*2 + 1;
       in(i) = in(i) - 0.5;
    end
    % 2nd bit
    if (in(i) <= 0.25)
       out(i) = out(i)*2;
    else
       out(i) = out(i)*2 + 1;
       in(i) = in(i) - 0.25;
    end
    % 3rd bit
    if (in(i) <= 0.125)
       out(i) = out(i)*2;
    else
       out(i) = out(i)*2 + 1;
       in(i) = in(i) - 0.125;
    end
    % 4th bit
    if (in(i) <= 0.0625)
       out(i) = out(i)*2;
    else
       out(i) = out(i)*2 + 1;
       in(i) = in(i) - 0.0625;
    end
    % 5th bit
    if (in(i) <= 0.03125)
       out(i) = out(i)*2;
    else
       out(i) = out(i)*2 + 1;
       in(i) = in(i) - 0.03125;
    end
    % 6th bit
    if (in(i) <= 0.015625)
       out(i) = out(i)*2;
    else
       out(i) = out(i)*2 + 1;
       in(i) = in(i) - 0.015625;
    end
    % 7th bit
    if (in(i) <= 0.0078125)
       out(i) = out(i)*2;
    else
       out(i) = out(i)*2 + 1;
       in(i) = in(i) - 0.0078125;
    end
    % 8th bit
    if (in(i) <= 0.00390625)
       out(i) = out(i)*2;
    else
       out(i) = out(i)*2 + 1;
       in(i) = in(i) - 0.00390625;
    end
end

out = out - 127;