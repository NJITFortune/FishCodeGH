function  [regtim, regfreq, regtemp, regobwpeaks] = k_datatrimmean(in, channel, ReFs)
%takes raw data from structure and regularizes using trim mean with 33% outlier exclusion
%regtim output in seconds

% %notfunction
% clearvars -except rkg kg2 hkg hkg2 xxkg xxkg2     
% % 
% in = hkg(k);
% channel = 1;
% ReFs = 20;
% light = 3;
% p = 0.7;

%% prep

lighttimes = k_lighttimes(in, light);


   %% Prepare raw data variables

  if channel < 3 %single fish data has two channel

    %outlier removal
     tto = [in.idx(channel).obwidx]; 
          
    %raw data
        timcont = [in.e(channel).s(tto).timcont]; %time in seconds
        obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
        oldfreq = [in.e(channel).s(tto).fftFreq];
        oldtemp = [in.e(channel).s(tto).temp];

  else %multifish data only has one channel
    %outlier removal
     tto = [in.idx.obwidx]; 
          
    %raw data
        timcont = [in.s(tto).timcont]; %time in seconds
        obw = [in.s(tto).obwAmp]/max([in.s(tto).obwAmp]); %divide by max to normalize
        oldfreq = [in.s(tto).freq];
        oldtemp = [in.s(tto).temp];

  end
            
   %trimmed mean
 window = 5;
  fcn = @(x) trimmean(x,33);
  obwtrim = matlab.tall.movingWindow(fcn, window, obw');
  freqtrim = matlab.tall.movingWindow(fcn, window, oldfreq');
  temptrim = matlab.tall.movingWindow(fcn, window, oldtemp');

    
    
%Regularize
    %regularize data to ReFs interval
    [regtim, regfreq, regtemp, regobwpeaks] = k_regularmetamucil(timcont, obwtrim', timcont, obw, freqtrim', temptrim', ReFs, lighttimes);
 
