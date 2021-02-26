function [xx, yy] = k_cspliner(x, y, p)
% GENERATE CUBIC SPLINE FUNCTION FOR DATA
% 
% f(x) = csaps(x,y,p); p = 0.9
if nargin < 3
    p = 0.9; %smoothing factor
end

% Prepare the data

    tim = [in.e(1).s.timcont]/(60*60);
    %tim = [in.e(1).s.timcont];

    obwdata = [in.e(1).s.obwAmp]; 
    obwdata = obwdata(in.idx(1).obwidx);
        
    obwtim = tim(in.idx(1).obwidx);
    
%     zdata = [in.e(1).sampl.zAmp]; zdata = zdata(in.idx(1).zidx);
%         ztim = tim(in.idx(1).zidx);
%     sfftdata = [in.e(1).sampl.sumfftAmp]; sfftdata = sfftdata(in.idx(1).sumfftidx);
%         sffttim = tim(in.idx(1).sumfftidx);



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