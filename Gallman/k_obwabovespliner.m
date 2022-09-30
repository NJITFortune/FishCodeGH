function [xx, subfftyy] =  k_obwabovespliner(timcont, obw, ReFs, lighttimes)
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
            spliney1 = csaps(timcont, obw, p);
            
            %estimate without resample
            obwAmp = fnval(timcont, spliney1);

            

% figure(57); clf; title('testing original spline'); hold on;
%     plot(sumffttimOG, sumfftAmpOG, '.');
%     plot(xx, sumfftyy, '-');
%% subset raw data            
        
%take raw data above the spline

   fftidx = find(obw > obwAmp);
   subfft = obw(fftidx);
   subffttim = timcont(fftidx);
     
%estimate new spline 

  %estimate new yvalues for every x value

        %obw
        spliney = csaps(subffttim, subfft, p);
        %resample new x values based on light/dark
        subfftyy = fnval(xx, spliney);

%         %fix holes
%             %below
%             lowidx = find(subfftyy > 0);
%             for j = 1:length(lowidx)
%                 subfftyy(lowidx(j)) = subfftyy()
       
%detrend ydata
%    dtsubfftyy = detrend(subfftyy,0,'SamplePoints', xx); %changed from polynomial detrend to mean subtraction 
%    normsubfftyytrend = 1./(subfftyy - dtsubfftyy);
%    tnormsubfftyy = subfftyy .* normsubfftyytrend;



