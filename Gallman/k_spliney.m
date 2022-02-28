function [xx, yy] = k_spliney(x, y, lightx, p)

%fit
%p = 0.9;
%resample rate
ReFs = 10;

%ReFs = 60;  %resample once every minute

            spliney = csaps(x, y, p);
            %resample new x values based on light/dark 
            xx = lightx(1):1/ReFs:lightx(end);
            yy = fnval(xx, spliney);