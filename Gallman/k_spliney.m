function [xx, yy] = k_spliney(x, y)

%fit
p = 0.7;
%resample rate
ReFs = 10;

%ReFs = 60;  %resample once every minute

            spliney = csaps(x, y, p);
            xx = x(1):1/ReFs:x(end);
            yy = fnval(xx, spliney);