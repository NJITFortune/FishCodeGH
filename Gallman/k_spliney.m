function [xx, yy] = k_spliney(x, y, p)

            spliney = csaps(x, y, p);
            xx = x(1):1/ReFs:x(end);
            yy = fnval(xx, spliney);