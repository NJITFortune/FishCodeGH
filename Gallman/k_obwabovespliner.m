function [xx, subfftyy, lighttimes] =  k_obwabovespliner(in, channel, ReFs, light)
%% Usage
%in = kg(k);
%ReFs = 20;
%light is a label for whether the subjective day starts with light or with dark
    %starts with dark = 3
    %starts with light = 4
%% Prep
%tightness of spline fit
p = 0.99;


%% cspline entire data set
    
    xx = lighttimes(1):ReFs:lighttimes(end);
      
      %estimate new yvalues for every x value
      
            %obw
            spliney1 = csaps([in.e(channel).s(tto{channel}).timcont]/(60*60), [in.e(channel).s(tto{channel}).obwAmp]/max([in.e(channel).s(tto{channel}).obwAmp]), p);
            
            %estimate without resample
            obwAmp = fnval([in.e(1).s(tto{1}).timcont]/(60*60), spliney1);
%             %detrend ydata
%             dtobwyy = detrend(obwyy,6,'SamplePoints', xx);
            %raw data variables
                obwtimOG = [in.e(1).s(tto{1}).timcont]/(60*60);
                obwAmpOG = [in.e(1).s(tto{1}).obwAmp]/max([in.e(1).s(tto{1}).obwAmp]);


% figure(57); clf; title('testing original spline'); hold on;
%     plot(sumffttimOG, sumfftAmpOG, '.');
%     plot(xx, sumfftyy, '-');
%% subset raw data            
        
%take raw data above the spline

   fftidx = find(obwAmpOG > obwAmp);
   subfft = obwAmpOG(fftidx);
   subffttim = obwtimOG(fftidx);
     
%estimate new spline 

  %estimate new yvalues for every x value

        %obw
        spliney = csaps(subffttim, subfft, p);
        %resample new x values based on light/dark
        subfftyy = fnval(xx, spliney);
       
%detrend ydata
%    dtsubfftyy = detrend(subfftyy,0,'SamplePoints', xx); %changed from polynomial detrend to mean subtraction 
%    normsubfftyytrend = 1./(subfftyy - dtsubfftyy);
%    tnormsubfftyy = subfftyy .* normsubfftyytrend;



