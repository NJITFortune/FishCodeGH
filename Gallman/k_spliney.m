function [xx, yy] = k_spliney(x, y, p)

ReFs = 60;  %resample once every minute

            spliney = csaps(x, y, p);
            xx = x(1):1/ReFs:x(end);
            yy = fnval(xx, spliney);