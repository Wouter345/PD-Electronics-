function bits = extract_bits(signal, clock, osr)

% % sample the signal at the times indicated by the clock
% t = ((1 : numel(signal))' - 1) / osr;
% symbols = interp1(t, signal, clock);

symbols = [];
index = 1;
new_symbol = 0;
counter = 1;
for i = 2:length(signal)
%     if clock(i) > clock(i-1)
%         symbols(index) = signal(i);
%         index = index + 1;
%     end


      new_symbol = (new_symbol + signal(i));
      counter = counter + 1;
      if clock(i) < clock(i-1)
          symbols(index) = new_symbol ./ counter;
          index = index + 1;
          counter = 1;
          new_symbol = 0;
      end
end
symbols(index) = new_symbol ./ counter;

symbols = symbols';



% convert to bits
bits = (symbols > 0);

end