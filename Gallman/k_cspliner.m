function [xx, yy] = k_cspliner(x, y)

%%GENERATE CUBIC SPLINE FUNCTION FOR DATA
%f(x) = csaps(x,y,p); p = 0.9
p = 0.3; %smoothing factor
ReFs = 60;  %resample once every minute

spliney = csaps(x, y, p);

% fx = fnval(x, spliney);

%%RESAMPLE DATA ALONG SPLINE FUNCTION
%%Generate uniform (regular) time values

xx = 1/ReFs:1/ReFs:max(x);



%%Resample at new time values along cubic spline
yy = fnval(xx, spliney);


end