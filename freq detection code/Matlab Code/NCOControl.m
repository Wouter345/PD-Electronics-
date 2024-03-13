function theta = NCOControl(deviation, numofsample)
%% Notes
% deviation is the correction on the 20kHz NCO signal
% the default frequency of NCO is 20kHz, coresponding to 20480 phase step

phase_step = 20480 + deviation;

theta = [];
theta(1) = 0;


for i = 2 : numofsample
    theta(i) = theta(i-1) + phase_step;
    if(theta(i) >= 8192*8)
        theta(i) = theta(i) - 8192*8;
    end
end

end