function output_signal = edge_detector(input_signal)

% Define threshold for comparison (around zero)
threshold = 0;

% Initialize output signal with zeros
output_signal = zeros(size(input_signal));

% Loop through each sample of the input signal
for i = 1:length(input_signal)
  % Check if current sample is above the threshold (rising edge)
  if (input_signal(i) > threshold) && (i > 1 && input_signal(i-1) <= threshold)
    output_signal(i) = 1;
  % Check if current sample is below the threshold (falling edge)
  elseif (input_signal(i) < threshold) && (i > 1 && input_signal(i-1) >= threshold)
    output_signal(i) = 1;
  end
end

end