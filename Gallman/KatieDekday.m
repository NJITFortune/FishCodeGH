function out = KatieDekday(in, orgidx, channel)

%in = kg(k)
%out = kay(k).e.


p = 0.7;
ReFs = 10;  %resample once every minute (Usually 60)
% Usage: k_initialplotter(kg(#));

%% Prep
ld = [in.info.ld];


%outliers
    % Prepare the data with outliers

            tto{1} = 1:length([in.e(1).s.timcont]); % tto is indices for obwAmp
            tto{2} = tto{1};

            ttz{1} = tto{1}; % ttz is indices for zAmp
            ttz{2} = tto{1};

            ttsf{1} = tto{1}; % ttsf is indices for sumfftAmp
            ttsf{2} = tto{1};
    % Prepare the data without outliers

            % If we have removed outliers via KatieRemover, get the indices...    
            if ~isempty(in.idx) 
                tto{1} = in.idx(1).obwidx; tto{2} = in.idx(2).obwidx; % tto is indices for obwAmp
                ttz{1} = in.idx(1).zidx; ttz{2} = in.idx(2).zidx; % ttz is indices for zAmp
                ttsf{1} = in.idx(1).sumfftidx; ttsf{2} = in.idx(2).sumfftidx; % ttsf is indices for sumfftAmp
            end
         
        
%% trim luz to data - Generate lighttimes
lighttimeslong = abs(in.info.luz);

    %fit light vector to power idx
    if isempty(in.info.poweridx) %if there are no values in poweridx []
        lighttimeslesslong = lighttimeslong;
    else
        lighttimesidx = lighttimeslong > in.info.poweridx(1) & lighttimeslong < in.info.poweridx(2);
        lighttimeslesslong = lighttimeslong(lighttimesidx);
    end

    
%only take times for light vector that have data
for j = 1:length(lighttimeslesslong)-1
        
        %is there data between j and j+1?    
        if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < (lighttimeslesslong(j+1)),1))  
            ott = [in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslesslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimeslesslong(j+1); 
            lighttim = [in.e(1).s(tto{1}(ott)).timcont]/(60*60);
            length(lighttim);
            
            if all(lighttim(1) >= lighttimeslesslong(j) & lighttim(1) < lighttimeslesslong(j) + ld/2)        
               lighttrim(j) = lighttimeslesslong(j);
              
            end
         
        end 
end


% take all cells with values and make a new vector
lighttimes = lighttrim(lighttrim > 0);


%% cspline entire data set

 
if channel == 1
    
    xx = lighttimes(1):1/ReFs:lighttimes(end);
      
      %estimate new yvalues for every x value
      
            %obw
            spliney = csaps([in.e(1).s(tto{1}).timcont]/(60*60), [in.e(1).s(tto{1}).obwAmp], p);
            %resample new x values based on light/dark
            obwyy = fnval(xx, spliney);
            %detrend ydata
            dtobwyy = detrend(obwyy,6,'SamplePoints', xx);
            %raw data variables
                obwtimOG = [in.e(1).s(tto{1}).timcont]/(60*60);
                obwAmpOG = [in.e(1).s(tto{1}).obwAmp];
      
            %zAmp
            spliney = csaps([in.e(1).s(ttz{1}).timcont]/(60*60), [in.e(1).s(ttz{1}).zAmp], p);
            %resample new x values based on light/dark
            zyy = fnval(xx, spliney);
            %detrend ydata
            dtzyy = detrend(zyy,6,'SamplePoints', xx);
                ztimOG = [in.e(1).s(ttz{1}).timcont]/(60*60);
                zAmpOG = [in.e(1).s(ttz{1}).zAmp]; 
            
            %sumfft
            spliney = csaps([in.e(1).s(ttsf{1}).timcont]/(60*60), [in.e(1).s(ttsf{1}).sumfftAmp], p);
            %resample new x values based on light/dark
            sumfftyy = fnval(xx, spliney);
            %detrend ydata
            dtsumfftyy = detrend(sumfftyy,6,'SamplePoints', xx);
                sumffttimOG = [in.e(1).s(ttsf{1}).timcont]/(60*60);
                sumfftAmpOG = [in.e(1).s(ttsf{1}).sumfftAmp]; 
     
      
else %channel = 2
    
        
    xx = lighttimes(1):1/ReFs:lighttimes(end);

      %estimate new yvalues for every x value
             
            %obw
            spliney = csaps([in.e(2).s(tto{2}).timcont]/(60*60), [in.e(2).s(tto{2}).obwAmp], p);
            %resample new x values based on light/dark
            obwyy = fnval(xx, spliney);
            %detrend ydata
            dtobwyy = detrend(obwyy,6,'SamplePoints', xx);
                obwtimOG = [in.e(2).s(tto{2}).timcont]/(60*60);
                obwAmpOG = [in.e(2).s(tto{2}).obwAmp];
                    
            %zAmp
            spliney = csaps([in.e(2).s(ttz{2}).timcont]/(60*60), [in.e(2).s(ttz{2}).zAmp], p);
            %resample new x values based on light/dark
            zyy = fnval(xx, spliney);
            %detrend ydata
            dtzyy = detrend(zyy,6,'SamplePoints', xx);
                ztimOG = [in.e(2).s(ttz{2}).timcont]/(60*60);
                zAmpOG = [in.e(2).s(ttz{2}).zAmp]; 
            
            %sumfft
            spliney = csaps([in.e(2).s(ttsf{2}).timcont]/(60*60), [in.e(2).s(ttsf{2}).sumfftAmp], p);
            %resample new x values based on light/dark
            sumfftyy = fnval(xx, spliney);
            %detrend ydata
            dtsumfftyy = detrend(sumfftyy,6,'SamplePoints', xx);
                sumffttimOG = [in.e(2).s(ttsf{2}).timcont]/(60*60);
                sumfftAmpOG = [in.e(2).s(ttsf{2}).sumfftAmp]; 
            
          

             
end


    
%% Divide into trials 

%define sample range
    perd = 48; % default length is 48 hours
    perd = perd - rem(perd, ld);       
    
    %perdsex = perd * 60 * 60; % perd in seconds, for convenience since timcont is in seconds

    % How many samples available?
    lengthofsampleHOURS = (xx(end) - xx(1));    
    % How many integer periods
    numoperiods = floor(lengthofsampleHOURS / perd); % of periods
    
        for jj = 1:numoperiods
    
            % indices for our sample window of perd hours
            timidx = find(xx > xx(1) + ((jj-1)*perd) & xx < xx(1) + (jj*perd));
            
            
            % Data   
             %detrended   
             out(jj).dtobwAmp = dtobwyy(timidx);
             out(jj).dtzAmp = dtzyy(timidx);
             out(jj).dtsumfftAmp =  dtsumfftyy(timidx);
             
             %not detrended
             out(jj).obwAmp = obwyy(timidx);
             out(jj).zAmp = zyy(timidx);
             out(jj).sumfftAmp = sumfftyy(timidx);
             
            % Time and treatment 
             out(jj).timcont = xx(timidx) - xx(timidx(1)) ;
             out(jj).xx = xx(timidx);
             
             if channel == 1
                 out(jj).light = [in.e(1).s(timidx).light];
                 out(jj).temp = [in.e(1).s(timidx).temp];
                 out(jj).fftFreq = [in.e(1).s(timidx).fftFreq];
             else 
                 out(jj).light = [in.e(2).s(timidx).light];
                 out(jj).temp = [in.e(2).s(timidx).temp];
                 out(jj).fftFreq = [in.e(2).s(timidx).fftFreq];
             end
             
             out(jj).ld = in.info.ld; 
             out(jj).kg = orgidx; % idx for kg
             
            

        end    


%% plots

%spline fit vs raw data

    %entire data set
    %trial overlay
    figure(48); clf; hold on;
    
        axs(1) = subplot(311); hold on; title('sumfft');
            %raw data
            plot(sumffttimOG, sumfftAmpOG, '.', 'MarkerSize', 3);
            %spline fit
            plot(xx, sumfftyy, 'k-.', 'LineWidth', 3);
            for jj = 1:length(out)
                plot(out(jj).xx, out(jj).sumfftAmp, '-', 'LineWidth', 3);
            end
        
        axs(2) = subplot(312); hold on; title('zAmp');
            %raw data
            plot(ztimOG, zAmpOG, '.', 'MarkerSize', 3);
            %spline fit
            plot(xx, zyy, '-', 'LineWidth', 3);
            for jj = 1:length(out)
                plot(out(jj).xx, out(jj).zAmp, '.', 'MarkerSize', 3);
            end
         
        axs(3) = subplot(313); hold on; title('obwAmp');
            %raw data
            plot(obwtimOG, obwAmpOG, '.', 'MarkerSize', 3);
            %spline fit
            plot(xx, obwyy, '-', 'LineWidth', 3);
            for jj = 1:length(out)
                plot(out(jj).xx, out(jj).obwAmp, '.', 'MarkerSize', 3);
            end
            
    linkaxes(axs, 'x');
    
    
%detrending

    %entire data set
    %trial overlay
    figure(49); clf; hold on;
    
        xa(1) = subplot(311); hold on; title('sumfft');
            plot(xx, sumfftyy, 'Color', [109 185 226]/255, 'DisplayName', 'Input data')
            hold on
            for jj = 1:length(out)
                plot(out(jj).xx, out(jj).dtsumfftAmp,'LineWidth', 1.5, 'DisplayName','Detrended data')
            end
            plot(xx, sumfftyy-dtsumfftyy, 'Color', [217 83 25]/255, 'LineWidth', 1, 'DisplayName','Trend')
            hold off
            legend
        
        xa(2) = subplot(312); hold on; title('zAmp');
            plot(xx, zyy, 'Color', [109 185 226]/255, 'DisplayName', 'Input data')
            hold on
            for jj = 1:length(out)
                plot(out(jj).xx, out(jj).dtzAmp, 'LineWidth', 1.5, 'DisplayName','Detrended data')
            end
            plot(xx, zyy-dtzyy, 'Color', [217 83 25]/255, 'LineWidth', 1, 'DisplayName','Trend')
            hold off
            legend
         
        xa(3) = subplot(313); hold on; title('obw');
            plot(xx,obwyy,'Color',[109 185 226]/255,'DisplayName','Input data')
            hold on
            for jj = 1:length(out)
                plot(out(jj).xx, out(jj).dtobwAmp, 'LineWidth', 1.5, 'DisplayName', 'Detrended data')
            end
            plot(xx, obwyy-dtobwyy, 'Color', [217 83 25]/255, 'LineWidth', 1, 'DisplayName','Trend')
            hold off
            legend
            
     linkaxes(xa, 'x');
     
 
%Dessembled trials

    %no detrending
    figure(50); clf; hold on; title('detrend trials?');

    maxlen = 0;

    for jj = 1:length(out) 
        
        ax(1) = subplot(611); hold on; title('sumfft - no detrending');
            plot(out(jj).timcont, out(jj).sumfftAmp); 
                 
        ax(2) = subplot(612); hold on; title('sumfft - detrending');
            plot(out(jj).timcont, out(jj).dtsumfftAmp); 
            
        ax(3) = subplot(613); hold on; title('zAmp - no detrending');
            plot(out(jj).timcont, out(jj).zAmp); 
            
        ax(4) = subplot(614); hold on; title('zAmp - detrending');
            plot(out(jj).timcont, out(jj).dtzAmp); 
            
        ax(5) = subplot(615); hold on; title('obw - no detrending');
            plot(out(jj).timcont, out(jj).obwAmp); 
            
        ax(6) = subplot(616); hold on; title('obw - detrending');
            plot(out(jj).timcont, out(jj).dtobwAmp); 
        
        maxlen = max([maxlen out(jj).timcont(end)]);
        
    end

    linkaxes(ax, 'x'); xlim([0 maxlen]);
 
    
%trial Dark/Light averages
 
    %add one to lighttimes to prevent data loss from logical indexing
    lighttimes = lighttimes ;

    %divide each trial into days
    for jj = 1:length(out) 

          for kk = 2:2:length(lighttimes)-1

              dayidx = find(out(jj).xx >= lighttimes(kk-1) & out(jj).xx < lighttimes(kk+1));

              %separate into days
                %always starts with dark
                
                %detrended
                mout(jj).dtsumfftavg(kk/2, :) = dtsumfftyy(dayidx);
                mout(jj).dtzavg(kk/2, :) = dtzyy(dayidx);
                mout(jj).dtobwavg(kk/2, :) = dtobwyy(dayidx);

                %not detrended
                mout(jj).sumfftavg(kk/2, :) = sumfftyy(dayidx);
                mout(jj).zavg(kk/2, :) = zyy(dayidx);
                mout(jj).obwavg(kk/2, :) = obwyy(dayidx);
                                
          end
        
          %create time idex for stardard deviation plot fill
          length(dayidx)
          length(out(jj).xx(dayidx))
                mout(jj).tt = out(jj).xx(dayidx);
            length(mout(jj).tt)
                
    end
     tt = out(1).timcont(dayidx) - out(1).timcont(dayidx(1));
     %length(tt)
              
    
                
                
    clrs = cool(length(mout));
    for jj = 1:length(mout)
        
        %for kk = 
        
        %normalize amplitude for each trial
            %detrended
            normavgdtsumfftresp(jj, :) = mout(jj).dtsumfftavg / max(abs(mout(jj).dtsumfftavg-mean(mout(jj).sumfftavg)));
            normavgdtzresp(jj, :) = mout(jj).dtzavg / max(abs(mout(jj).dtzavg- mean(mout(jj).dtzavg)));
            normavgdtobwresp(jj, :) = mout(jj).dtobwavg / max(abs(mout(jj).dtobwavg - mean(mout(jj).dtobwavg)));

            
        %plot by trial
       
            %sumfft
            figure(51); clf; hold on; title('sumfft');
                sax(1) = subplot(211); hold on; title('detrended sumfft');
                
                length(mout(jj).tt)
                    plot(mout(jj).tt, normavgdtsumfftresp(jj,:), 'Color', clrs(jj, :), 'LineWidth', 3); %normalized
                    plot([ld ld], ylim, 'k-','Linewidth', 2);
                    
           
            figure(52); clf; hold on; title('zAmp');
                zax(1) = subplot(211); hold on; title('detrended zAmp');
                    plot(mout(jj).tt, normavgdtzresp(jj), 'Color', clrs(jj, :), 'LineWidth', 3); %normalized
                    plot([ld ld], ylim, 'k-','Linewidth', 2);
                    
                    
           figure(53); clf; hold on; title('obwAmp');
                wax(1) = subplot(211); hold on; title('detrended obw');
                    plot(mout(jj).tt, normavgdtobwresp(jj), 'Color', clrs(jj, :), 'LineWidth', 3); %normalized
                    plot([ld ld], ylim, 'k-','Linewidth', 2);
                    
    end
            ttstd = [mout.tt mout.tt(end:-1:1)];
    
            %sumfft
            meanormavgdtsumfftresp = mean(normavgdtsumfftresp);
            stdavgdtsumfftresp = std(normavgdtsumfftresp);
            
    
           figure (51); hold on   
                sax(1) = subplot(211); hold on;
                    plot(tt, meanormavgdtsumfftresp, 'k-', 'LineWidth', 3);
                sax(2) = subplot(212);
                    fill(ttstd, [meanormavgdtsumfftresp+stdavgdtsumfftresp, meanormavgdtsumfftresp(end:-1:1)-stdavgdtsumfftresp(end:-1:1)], 'c');
                    plot(tt, meanormavgdtsumfftresp, 'k', 'LineWidth', 3);
                    plot([ld ld], ylim, 'k-', 'Linewidth', 2); 
                   
                    
           linkaxes(sax, 'x');
           
                    
           %zAmp
           meannormavgdtzresp = mean(normavgdtzresp);
           stdavgdtzresp = std(normavgdtzresp);
           
           figure(52); hold on;
                zax(1) = subplot(211); hold on;
                    plot(tt, meannormavgdtzresp, 'k-', 'LineWidth', 3);
                zax(2) = subplot(212);
                    fill(ttstd, [meannormavgdtzresp+stdavgdtzresp, meannormavgdtzresp(end:-1:1)-stdavgdtzresp(end:-1:1)], 'c');
                    plot(tt, meannormavgdtzresp, 'k-', 'LineWidth', 3);
                    plot([ld ld], ylim, 'k-', 'Linewidth', 2); 
      
            linkaxes(zax, 'x');
            
            
            %obw
            meannormavgdtobwresp = mean(normavgdtobwresp);
            stdavgdtobwresp = std(normavgdtobwresp);
    
            figure(53); hold on;
                wax(1) = subplot(211); hold on;
                    plot(tt, meannormavgdtobwresp, 'k-', 'LineWidth', 3);
                wax(2) = subplot(212);
                    fill(ttstd, [meannormavgdtobwresp+stdavgdtobwresp, meannormavgdtobwresp(end:-1:1)-stdavgdtobwresp(end:-1:1)], 'c');
                    plot(tt, meannormavgdtobwresp, 'k-', 'LineWidth', 3);
                    plot([ld ld], ylim, 'k-', 'Linewidth', 2); 
      
            linkaxes(wax, 'x');

  



    

        
    
    
  


