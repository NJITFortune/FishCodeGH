

clearvars -except kg

figure(101); clf; hold on;

in = kg(10);
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
%% trim luz to data
lighttimeslong = abs(in.info.luz);

for j = 1:length(lighttimeslong)-1
        
        %is there data between j and j+1?    
        if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < (lighttimeslong(j+1)),1))  
            ott = find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimeslong(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimeslong(j+1)); 
           lighttim = [in.e(1).s(tto{1}(ott)).timcont]/(60*60);
      
            
            if all(lighttim(1) >= lighttimeslong(j) & lighttim(1) < lighttimeslong(j) + ld/2)        
               lighttrim(j) = lighttimeslong(j);
               trimluz(j) = in.info.luz(j);  
            end
            
             
        end 
end

nonzeroluz = find(trimluz);
newluz = in.info.luz(nonzeroluz);

lighttimes = lighttrim(lighttrim > 0);




%% cspline entire data set

%channel 1
%create data variables
    obwdata1 = [in.e(1).s(tto{1}).obwAmp]; 
    obwtim1 = [in.e(1).s(tto{1}).timcont]/(60*60);
    light = [in.e(1).s(tto{1}).light];
    
        %summarize data
            %ppform of cubic smoothing spline
            spliney1 = csaps(obwtim1, obwdata1, p);
            lightey = csaps(obwtim1, light, p);
            %fortune doesn't like linspace... I think he does it to confuse me
            obwxx = lighttimes(1):1/ReFs:lighttimes(end);
            %evaluate the csplined values of y for the new equally spaced values of x
            obwyy1 = fnval(obwxx, spliney1);
            lighty = fnval(obwxx, lightey); 
                lighty = lighty-mean(lighty); lighty = lighty / max(abs(lighty));
            
            

%channel 2
%create data variables
    obwdata2 = [in.e(2).s(tto{2}).obwAmp]; 
    obwtim2 = [in.e(2).s(tto{2}).timcont]/(60*60);
    
    
        %summarize data
            %ppform of cubic smoothing spline
            spliney2 = csaps(obwtim2, obwdata2, p);
            %fortune doesn't like linspace... I think he does it to confuse me
           
            %evaluate the csplined values of y for the new equally spaced values of x
            obwyy2 = fnval(obwxx, spliney2);
           
            
            


%plot against cspline of inidividual epochs
figure(101); 

subplot(211); hold on; title('Channel 1');
    plot(obwtim1, obwdata1, '.', 'MarkerSize', 3);
    plot(obwxx, obwyy1, '-', 'LineWidth', 3);
    
subplot(212); hold on; title('Channel 2');
    plot(obwtim2, obwdata2, '.', 'MarkerSize', 3);
    plot(obwxx, obwyy2, '-', 'LineWidth', 3);

%conclusion is its better to spline all at once

%% Detrend data

%Channel 1
    % Remove trend from data
        %custom parameters - 6th order polynomial
    dtobwyy1 = detrend(obwyy1,6,'SamplePoints',obwxx);

%Channel 2
     % Remove trend from data
        %custom parameters - 6th order polynomial
    dtobwyy2 = detrend(obwyy2, 6, 'SamplePoints', obwxx);
    

% Display results
figure(102); clf; hold on;
    
    subplot(211); hold on; title('Channel 1');
    plot(obwxx,obwyy1,'Color',[109 185 226]/255,'DisplayName','Input data')
    hold on
    plot(obwxx,dtobwyy1,'Color',[0 114 189]/255,'LineWidth',1.5,...
        'DisplayName','Detrended data')
    plot(obwxx,obwyy1-dtobwyy1,'Color',[217 83 25]/255,'LineWidth',1,...
        'DisplayName','Trend')
    hold off
    legend
    
    subplot(212); hold on; title('Channel 2');
    plot(obwxx,obwyy2,'Color',[109 185 226]/255,'DisplayName','Input data')
    hold on
    plot(obwxx,dtobwyy2,'Color',[0 114 189]/255,'LineWidth',1.5,...
        'DisplayName','Detrended data')
    plot(obwxx,obwyy2-dtobwyy2,'Color',[217 83 25]/255,'LineWidth',1,...
        'DisplayName','Trend')
    hold off
    legend

%% find frequ with greatest power

%pwelch
L = length(dtobwyy1); 
NFFT = 2^nextpow2(L)/2;
%NFFT = 8192;
FreqRange = 0.002:0.0001:0.2;


%Channel 1

    %generate fft using pwelch
    [py1, pf1] = pwelch(dtobwyy1 - mean(dtobwyy1), NFFT, floor(NFFT*0.99), FreqRange, ReFs);  
        %take the peakfreq
        [pkAmp1, pkIDX1] = max(py1);
        [btAmp1, btIDX1] = min(py1);
        pkfrq1 = pf1(pkIDX1);

        
%Channel 2

    %generate fft using pwelch
    [py2, pf2] = pwelch(dtobwyy2 - mean(dtobwyy2), NFFT, floor(NFFT*0.99), FreqRange, ReFs);  
        %take the peakfreq
        [pkAmp2, pkIDX2] = max(py2);
        [btAmp2, btIDX2] = min(py2);
        pkfrq2 = pf2(pkIDX2);
        
        
%plot
figure(103); clf; hold on;
    
    subplot(211); hold on; title('Channel 1');
    plot(pf1, py1, '-', 'MarkerSize', 3);
    plot(pkfrq1, pkAmp1, '*', 'MarkerSize', 5);
    plot([1/(ld*2) 1/(ld*2)], [btAmp1, pkAmp1], 'k-', 'LineWidth', 0.25);
    plot([1/(12*2) 1/(12*2)], [btAmp1, pkAmp1], 'r-', 'LineWidth', 0.25);
    
    subplot(212); hold on; title('Channel 2');
    plot(pf2, py1, '-', 'MarkerSize', 3);
    plot(pkfrq1, pkAmp1, '*', 'MarkerSize', 5);
    plot([1/(ld*2) 1/(ld*2)], [btAmp1, pkAmp1], 'k-', 'LineWidth', 0.25);
    plot([1/(12*2) 1/(12*2)], [btAmp1, pkAmp1], 'r-', 'LineWidth', 0.25);
    
    %yaxis on log scale
     set(gca,'yscale', 'log');
    
    

%% resample light times without spline

%define ylim for light square wave
lightamp1 = max(dtobwyy1);
lightamp2 = max(dtobwyy2);

for j = 1:length(lighttimes)-1
    
    if in.info.luz(j) > 0  % Light side
        
        if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimes(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimes(j+1),1))    
            
            ott = find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimes(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimes(j+1)); 
        
            %is there enough data to do analysis?
            if length(ott) > 10
%                obwtim = [in.e(1).s(tto{1}(ott)).timcont]/(60*60);
%                light = [in.e(1).s(tto{1}(ott)).light];

               %resample x
               day(j).obwdayx = lighttimes(j):1/ReFs:lighttimes(j+1)-1/ReFs;
               
               %channel 1 amp
               day(j).daysquare1 = lightamp1 * (ones(1, length(day(j).obwdayx)));     
               day(j).lightsquare1 = lightamp1 * (ones(1, length(day(j).obwdayx))); 
               
               %channel 2 amp
               day(j).daysquare2 = lightamp2 * (ones(1, length(day(j).obwdayx)));     
               day(j).lightsquare2 = lightamp2 * (ones(1, length(day(j).obwdayx))); 
               
               day(j).lightsqx = lighttimes(j):1/ReFs:lighttimes(j+1)-1/ReFs;
            end 
            
        end 
        
    else %dark side
        
        if ~isempty(find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimes(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimes(j+1),1))    
            
            ott = find([in.e(1).s(tto{1}).timcont]/(60*60) >= lighttimes(j) & [in.e(1).s(tto{1}).timcont]/(60*60) < lighttimes(j+1)); 
        
            %is there enough data to do analysis?
            if length(ott) > 10
%                obwtim = [in.e(1).s(tto{1}(ott)).timcont]/(60*60);
%                light = [in.e(1).s(tto{1}(ott)).light];

               %resample x
               day(j).obwdayx = lighttimes(j):1/ReFs:lighttimes(j+1)-1/ReFs;
               
               %channel1 amp
               day(j).daysquare1 = -lightamp1 * (ones(1, length(day(j).obwdayx)));  
               day(j).darksquare1 = -lightamp1 * (ones(1, length(day(j).obwdayx))); 
               
               %channel 2 amp
               day(j).daysquare2 = -lightamp2 * (ones(1, length(day(j).obwdayx)));  
               day(j).darksquare2 = -lightamp2 * (ones(1, length(day(j).obwdayx))); 
               
               day(j).darksqx = lighttimes(j):1/ReFs:lighttimes(j+1)-1/ReFs;
            end 
        end
        
    end
    
end
 
% figure(222); 
% plot([day.obwdayx], [day.daysquare], '-');


%figure(27); hold on; for j=1:length(out); plot(out(j).obwdayy); end;

%% plot spline vs light
figure(104); clf; hold on;

    %make sine wave
        %define amplitude
    samp1 = max(abs(dtobwyy1));
    samp2 = max(abs(dtobwyy2));
    %siney = samp1*sin(2 * pi * pkfrq1 * (obwxx-obwxx(1)));
     
   
% for j = 1:length(day)-1
%     
%     if day(1).daysquare1(1) < 0 %if we start with dark
%         rect(j).pos = [day(j).darksqx(end) day(j).darksquare1(end) ld 2*day(j+1).lightsquare1(1)];
%     else %we start with light
%         rect(j).pos = [day(j+1).darksqx(end) day(j+1).darksquare1(end) ld 2*day(j).lightsquare1(1)];
%     end
%     
% end    
    
    
    
axs(1) = subplot(211); hold on; title('Channel 1');
    %plot on top of detrended spline
  % rectangle('Position', rect.pos, 'FaceColor', 'y');
  % plot([day(2).darksqx], [day(2).darksquare1], 'yo', 'LineWidth', 3);
%   rectangle('Position', [day(2).darksqx(end) day(2).darksquare1(end) ld 2*day(1).lightsquare1(1)], 'FaceColor', 'y');
   plot([day.obwdayx], [day.daysquare1], 'k-', 'LineWidth', 2);
   %plot(obwxx1, siney*0.9, '-', 'LineWidth', 3);
   plot(obwxx, lighty * max(abs(dtobwyy1)), 'k-', 'MarkerSize', 4);
   plot(obwxx, dtobwyy1, '.-', 'MarkerSize', 10, 'LineWidth', 2); 
   
axs(2) =subplot(212); hold on; title('Channel 2');
    %plot on top of detrended spline
   plot([day.obwdayx], [day.daysquare2], 'k-', 'LineWidth', 2);
   %plot(obwxx1, siney*0.9, '-', 'LineWidth', 3);
   plot(obwxx, lighty * max(abs(dtobwyy2)), 'k-', 'MarkerSize', 4);
   plot(obwxx, dtobwyy2, '.-', 'MarkerSize', 10, 'LineWidth', 2); 
   
linkaxes(axs, 'x'); 
   
%% separate to individual epochs

figure(68); clf; 
  
%Channel 1
   subplot(211); hold on; 
   
    for j = 2:2:length(lighttimes)-1


                   otx = find(obwxx >= lighttimes(j-1) & obwxx < lighttimes(j+1)); 

                   plot(obwxx(otx) - obwxx(otx(1)), dtobwyy1(otx));
                   plot([[in.info.ld] [in.info.ld]], [-samp1 samp1], 'k-', 'Linewidth', 2); 
                  
                   avgresp1(j/2, :) = dtobwyy1(otx);

    end



    subplot(212); hold on;
        tt = obwxx(otx) - obwxx(otx(1));
        tt = [tt tt(end:-1:1)];
        mavgresp1 = mean(avgresp1);
        savgresp1 = std(avgresp1);

        fill(tt, [mavgresp1+savgresp1 mavgresp1(end:-1:1)-savgresp1(end:-1:1)], 'c');
        plot(obwxx(otx) - obwxx(otx(1)), mavgresp1, 'k', 'LineWidth', 3);
        plot([[in.info.ld] [in.info.ld]], [-samp1 samp1], 'k-', 'Linewidth', 2); 


        
 figure(69); clf;       
    %channel 2 
    subplot(211); hold on;
 
     for j = 2:2:length(lighttimes)-1


                   otx = find(obwxx >= lighttimes(j-1) & obwxx < lighttimes(j+1)); 

                   plot(obwxx(otx) - obwxx(otx(1)), dtobwyy2(otx));
                   plot([[in.info.ld] [in.info.ld]], [-samp2 samp2], 'k-', 'Linewidth', 2); 

                   avgresp2(j/2, :) = dtobwyy2(otx);

     end
 
    
     subplot(212); hold on;
        tt = obwxx(otx) - obwxx(otx(1));
        tt = [tt tt(end:-1:1)];
        mavgresp2 = mean(avgresp2);
        savgresp2 = std(avgresp2);

        fill(tt, [mavgresp2+savgresp2 mavgresp2(end:-1:1)-savgresp2(end:-1:1)], 'c');
        plot(obwxx(otx) - obwxx(otx(1)), mavgresp2, 'k', 'LineWidth', 3);
        plot([[in.info.ld] [in.info.ld]], [-samp2 samp2], 'k-', 'Linewidth', 2); 

