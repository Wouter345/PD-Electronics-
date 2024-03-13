function clock = clock_recovery(signal, osr)

% TODO: Implement this yourself!
% TIP: Add some non-ideal effects to your signal and come up with an algorithm
% which can provide a stable clock despite these effects.

% n = floor(numel(signal) / osr);
% clock = (1 : n)' - 0.5;

symbols = signal>0;
symbols = 2*symbols -1;

counter = 1;
clock = [];
for i = 2:length(symbols)
    edge = xor(symbols(i),symbols(i-1));
    if edge
        counter = 1;
    end
    
    if counter <=8
        clock(i) = 0;
    else
        clock(i) = 1;
    end
    
    counter = counter + 1;
    if counter == 17
        counter = 1;
    end
    
        
end



    
end
