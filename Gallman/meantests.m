
clearvars -except xxkg hkg hkg2 xxkg2

in = xxkg(k);

%outlier removal
 tto = [in.idx(channel).obwidx]; 
      
%raw data
    timconts = [in.e(channel).s(tto).timcont]; %time in seconds
    timconth = timcont/3600;
    obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.e(channel).s(tto).fftFreq];
    oldtemp = [in.e(channel).s(tto).temp];
    

    lighttimes = k_lighttimes(in, 3);
%trim data to lighttimes
    lidx = find(timconth >= lighttimes(1) & timconth <= lighttimes(end));
    timconth = timconth(lidx);
    obw = obw(lidx);


%mean alternative tests



% %plot to check
% figure(76); clf; hold on;
%     plot(timconth, obw, '.', 'MarkerSize', 8);
%     plot    
% 



