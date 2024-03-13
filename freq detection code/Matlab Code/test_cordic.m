theta = 0:1:2^16;

sin = [];
cos = [];
for i = 1:length(theta)
   [sin(i),cos(i)] = cordicSinCos(theta(i));
end
sin = sin./13491;
cos = cos./(13491);

plot(theta,sin)