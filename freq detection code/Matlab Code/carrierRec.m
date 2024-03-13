function deviation = carrierRec(frediff,bit0or1)
%% Notes
% frediff is the result from the frequency extraction
% bit0or1 shows the bit for recovery is 0 or 1

if(bit0or1)
    deviation = floor((frediff - 750)/32);
else
    deviation = floor((frediff - (-750))/32); % it should be +-1000 and /40 ideally but it is not ideal, so...
end



end