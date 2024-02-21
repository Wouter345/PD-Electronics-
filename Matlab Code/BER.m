function ber = BER(x, y)

    % Check input lengths
    if length(x) ~= length(y)
    error('Input vectors must have the same length.');
    end


    % Calculate number of bit errors
    errors = sum(xor(x, y));

    % Calculate BER
    ber = errors / length(x);

end