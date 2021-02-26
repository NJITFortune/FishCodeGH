function [xx, yy] = k_cspliner(x, y, p)

%%GENERATE CUBIC SPLINE FUNCTION FOR DATA
%f(x) = csaps(x,y,p); p = 0.9
if nargin < 3
    p = 0.9; %smoothing factor
end
ReFs = 60;  %resample once every minute

spliney = csaps(x, y, p);

% fx = fnval(x, spliney);

%%RESAMPLE DATA ALONG SPLINE FUNCTION
%%Generate uniform (regular) time values

xx = x(1):1/ReFs:x(end);
%xx = linspace(x(1), x(end), ((x(end)-x(1))*ReFs));

%%Resample at new time values along cubic spline
yy = fnval(xx, spliney);


end