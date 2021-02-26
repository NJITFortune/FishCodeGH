function [xx, yy] = k_cspliner(x, y, p)
% GENERATE CUBIC SPLINE FUNCTION FOR DATA
% Usage: [xx, yy] = k_cspliner(x, y, p)
% f(x) = csaps(x,y,p); p = 0.9

%% Preparations

if nargin < 3
    p = 0.9; %smoothing factor
end

% Prepare the data

    tto{1} = 1:length([out.e(1).s.timcont]); % tto is indices for obwAmp
    tto{2} = tto{1};

    ttz{1} = tto{1}; % ttz is indices for zAmp
    ttz{2} = tto{1};

    ttsf{1} = tto{1}; % ttsf is indices for sumfftAmp
    ttsf{2} = tto{1};
    
% If we have removed outliers via KatieRemover, get the indices...    
    if isfield(out, 'idx')
        tto{1} = out.idx(1).obwidx; tto{2} = out.idx(2).obwidx; % tto is indices for obwAmp
        ttz{1} = out.idx(1).zidx; ttz{2} = out.idx(2).zidx; % ttz is indices for zAmp
        ttsf{1} = out.idx(1).sumfftidx; ttsf{2} = out.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
    end

    tim = [in.e(1).s.timcont]/(60*60);

    obwdata = [in.e(1).s.obwAmp]; 
    obwdata = obwdata(in.idx(1).obwidx);
        
    obwtim = tim(in.idx(1).obwidx);
    
%     zdata = [in.e(1).sampl.zAmp]; zdata = zdata(in.idx(1).zidx);
%         ztim = tim(in.idx(1).zidx);
%     sfftdata = [in.e(1).sampl.sumfftAmp]; sfftdata = sfftdata(in.idx(1).sumfftidx);
%         sffttim = tim(in.idx(1).sumfftidx);



ReFs = 60;  %resample once every minute

%% Resample

spliney = csaps(x, y, p);

% fx = fnval(x, spliney);

%%RESAMPLE DATA ALONG SPLINE FUNCTION
%%Generate uniform (regular) time values

xx = x(1):1/ReFs:x(end);
%xx = linspace(x(1), x(end), ((x(end)-x(1))*ReFs));

%%Resample at new time values along cubic spline
yy = fnval(xx, spliney);


end