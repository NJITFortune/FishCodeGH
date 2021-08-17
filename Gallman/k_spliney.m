function out = k_spliney(x, y, p)

            spliney = csaps(x, y, p);
            out.xx = x(1):1/ReFs:x(end);
            out.yy = fnval(xx, spliney);