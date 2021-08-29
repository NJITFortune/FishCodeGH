function [amp, freq] = sinAnal(xx, datums)


yu = max(datums);
yl = min(datums);
yr = (yu-yl);                               % Range of y
yz = datums-yu+(yr/2);
zx = xx(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
per = 2*mean(diff(zx));                     % Estimate period
ym = mean(datums);                               % Estimate offset

    fit = @(b,xx)  b(1).*(sin(2*pi*xx./b(2) + 2*pi/b(3))) + b(4);     % Function to fit
    fcn = @(b) sum((fit(b,xx) - datums).^2);                            % Least-Squares cost function
    s = fminsearch(fcn, [yr;  per;  -1;  ym]);                      % Minimise Least-Squares

amp = s(1) * 1000;
freq = 1/s(2);
