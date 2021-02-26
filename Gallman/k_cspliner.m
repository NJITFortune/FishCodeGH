function [xx, yy] = k_cspliner(x, y)

%%GENERATE CUBIC SPLINE FUNCTION FOR DATA
%f(x) = csaps(x,y,p); p = 0.9
p = 0.9; %smoothing factor
ReFs = 80;  %resample once every minute

spliney = csaps(x, y, p);

% fx = fnval(x, spliney);

%%RESAMPLE DATA ALONG SPLINE FUNCTION
%%Generate uniform (regular) time values

%xx = 1/ReFs:1/ReFs:max(x);
xx = linspace(x(1), x(end), ((x(end)-x(1))*ReFs));
xx

%%Resample at new time values along cubic spline
yy = fnval(xx, spliney);


end