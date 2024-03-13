function plain = fec_decode(encoded)

% TODO: Implement this yourself!

plain = [];
plain(1) = encoded(1);
plain(2) = encoded(2);
plain(3) = encoded(3);
index = 4;
while index <= length(encoded)/3
    s = encoded(3*index-2) + encoded(3*index-1) + encoded(3*index);
    if s >= 2
        plain(index) = 1;
    else
        plain(index) = 0;
    end
    
    index = index + 1;
end

plain = plain';
    

end