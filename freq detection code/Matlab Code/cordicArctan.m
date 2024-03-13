function [theta] = cordicArctan(sinv,cosv)
%% Notes
% theta: 15-bit denoting from 0 to 360 deg
% sinv:  15-bit denoting the scaled sin value of the point
% cosv:  15-bit denoting the scaled cos value of the point

%% arctan table -- 16 iterations
atan_table = [8192;      % 45.000000  deg
              4836;      % 26.565051
              2555;      % 14.036243
              1297;      %  7.125016
              651;       %  3.576334
              326;       %  1.789911
              163;       %  0.895174
              81;        %  0.447614
              41;        %  0.223810
              20;        %  0.111906
              10;        %  0.055953
              5;         %  0.279765
              3;         %  0.013988
              1;         %  0.006994
              1;         %  0.003497
              0          %  0.001749
              ];


%% registers
reg_cos          = cosv;
reg_sin          = sinv;
reg_z            = 0;         % 16-bits iterated theta, one sign bit
reg_plus180      = 0;         % note if the result angle need to be change
reg_plus360      = 0;


%% rotate (sinv, cosv) to -90 deg to 90 deg
if((sinv > 0) && (cosv < 0))
    reg_cos     = - reg_cos;
    reg_sin     = - reg_sin;
    reg_plus180 = 1;
elseif((sinv <= 0) && (cosv < 0))
    reg_cos     = - reg_cos;
    reg_sin     = - reg_sin;
    reg_plus180 = 1;
elseif((sinv <= 0) && (cosv >= 0))
    reg_plus360 = 1;
else
    reg_plus360 = 0;
    reg_plus180 = 0;
end


%% Perform Iterations
for i = 1 : 16
    if(reg_sin >= 0)
        reg_z        = reg_z + atan_table(i);
        reg_cos_temp = reg_cos + reg_sin/(2^(i-1));
        reg_sin_temp = reg_sin - reg_cos/(2^(i-1));
        reg_cos      = reg_cos_temp;
        reg_sin      = reg_sin_temp;
    else
        reg_z        = reg_z - atan_table(i);
        reg_cos_temp = reg_cos - reg_sin/(2^(i-1));
        reg_sin_temp = reg_sin + reg_cos/(2^(i-1));
        reg_cos      = reg_cos_temp;
        reg_sin      = reg_sin_temp;
    end
end

%% Give output
theta = reg_z + reg_plus180*8192*4 + reg_plus360*8192*8;
end