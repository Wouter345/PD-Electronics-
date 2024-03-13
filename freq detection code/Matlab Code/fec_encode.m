function encoded = fec_encode(plain)

% % The NASA standard convolutional code with K=7 and rate 1/2.
% generator = [
%     1 1 1 1 0 0 1;
%     1 0 1 1 0 1 1;
% ];
% 
% encoded = reshape(mod(conv2(plain', generator), 2), [], 1);

encoded = [];
encoded(1) = plain(1);
encoded(2) = plain(2);
encoded(3) = plain(3);
for i = 4:length(plain)
    encoded(3*i-2) = plain(i); 
    encoded(3*i-1) = plain(i); 
    encoded(3*i) = plain(i); 
end
encoded = encoded';

end