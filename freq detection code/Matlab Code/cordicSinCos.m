function [outsin,outcos] = cordicSinCos(theta)
%% Notes
% theta: 15-bit denoting from 0 to 360 deg
% output is scaled 


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
reg_cos         = 2^(15);
reg_sin         = 0;
reg_z           = 0;         % 16-bits iterated theta, one sign bit
reg_res_neg     = 0;         % note if the sign of the result need to be changed


%% rotate theta to -90 deg - 90 deg
if((theta >= 8192*2) && (theta <= 8192*4))   %  90 deg < theta < 180 deg
    reg_z       = theta - 8192*4;
    reg_res_neg = 1;
elseif((theta > 8192*4) && (theta < 8192*6)) % 180 deg < theta < 270 deg
    reg_z       = theta - 8192*4;
    reg_res_neg = 1;
elseif((theta >= 8192*6))                    % 270 deg < theta < 360 deg
    reg_z       = theta - 8192*8;
    reg_res_neg = 0;
else                                         %   0 deg < theta <  90 deg
    reg_z       = theta;
    reg_res_neg = 0;
end


%% Perform Iterations
for i = 1 : 16
    if(reg_z >= 0)
        reg_z        = reg_z - atan_table(i);
        reg_cos_temp = reg_cos - reg_sin/(2^(i-1));
        reg_sin_temp = reg_sin + reg_cos/(2^(i-1));
        reg_cos      = reg_cos_temp;
        reg_sin      = reg_sin_temp;
    else
        reg_z        = reg_z + atan_table(i);
        reg_cos_temp = reg_cos + reg_sin/(2^(i-1));
        reg_sin_temp = reg_sin - reg_cos/(2^(i-1));
        reg_cos      = reg_cos_temp;
        reg_sin      = reg_sin_temp;
    end
end


%% Give output
outsin = (-1)^(reg_res_neg) * floor(reg_sin/2^2);
outcos = (-1)^(reg_res_neg) * floor(reg_cos/2^2);
end