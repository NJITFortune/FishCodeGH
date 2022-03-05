function [xx, yy] = k_spliney(x, y, p)

%fit
%p = 0.9;
%resample rate
ReFs = 10;

%ReFs = 60;  %resample once every minute

            spliney = csaps(x, y, p);
            %resample new x values based on light/dark 
            xx = x(1):1/ReFs:x(end);
            yy = fnval(xx, spliney);