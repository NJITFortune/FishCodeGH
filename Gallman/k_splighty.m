function [xx, yy] = k_splighty(x, y, xx)

%fit
p = 0.7;
%resample rate
ReFs = 10;

%ReFs = 60;  %resample once every minute

            spliney = csaps(x, y, p);
            %resample new x values based on light/dark
            yy = fnval(xx, spliney);