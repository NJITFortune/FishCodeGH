%function out = k_dataprepper(in, channel, ReFs)
%notfunction
clearvars -except l24kg
% 
in = kg(k);
channel = 1;
ReFs = 20;
light = 3;
p = 0.7;

%% prep

lighttimes = k_lighttimes(in, light);

%% regularize data across time in ReFs second intervals

    tto = [in.idx(channel).obwidx]; 
          
    timcont = [in.e(channel).s(tto{channel}).timcont];
    obw = [in.e(channel).s(tto{channel}).obwAmp]/max([in.e(channel).s(tto{channel}).obwAmp]);
    
    timidx = timcont >= lighttimes(1) & timcont <= lighttimes(end);
    timcont = timcont(timidx);
    obw = obw(timidx);  

    %regularize data to ReFs interval
    [xx, out.regobw, ~] = k_regularmetamucil(timcont, obw, ReFs);


    out.xx = xx/3600;
    out.lighttimes = lighttimes/3600;