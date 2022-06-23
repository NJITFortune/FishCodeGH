function db = k_dB(in)
%% usage
%processes output from KatieDayTrialDessembler.m of kg by hourexp and
%k_fftdaymovabovemean.m 


%   clearvars -except dark kg kg2 colorsforplots
% 
% 
%   in = dark(1);


    %in.trial and %in.day
    
    db.ld = in.h(1).day(1).ld;
   % hourampmax = in.hourampmax;
    
     %all days
     %average day by trial
     

     for j = 1:length(in.h) % experiments of x hour length
      
            
           exprangemax = max([in.h(j).day.amprange]);
            %exprangemax
            for k = 1:length(in.h(j).day) %days within each trial
    
                  %fill temporary vector with data from each day 
                    %mday(k,:) = in(j).day(k).Ssumfftyy;
                    %mamprange(k,:) = max(in.h(j).day(k).nonormregsumfft);
                   % mamprange(k,:) = max(in.h(j).day(k).Ssumfftyy)-min(in.h(j).day(k).Ssumfftyy);
                    expdaydb(k,:) = 20*log10(max([in.h(j).day(k).nonormregsumfft])/exprangemax);
                   % hourdaydb(k,:) = 20*log10((max(in.h(j).day(k).Ssumfftyy)-min(in.h(j).day(k).Ssumfftyy))/in.hourampmax);
                    %plot(in(j).trial(jj).day(k).SsumfftAmp)
    
                   
            end
    
             % To get average across days, divide by number of days
                
              %  daymean(j,:) = mean(mday);
                
             % dbmethod test - max by exp
                dbdaymean(j,:) = mean(expdaydb);
              %  dbhourmean(j,:) = mean(hourdaydb);


                
    %             dayrange(jj,:) = max(mday(jj,:))-min(mday(jj,:));
    %             trialrange(jj,:) = 
              %  dBtrial(jj,:) = 20*log10((max(mday(jj,:))-min(mday(jj,:)))/(max(trialampmax(jj))-min(trialampmin(jj))));
                
                
     end
               
     
        
        %averages for each x hour set of experiments

          db.dbhourdaymean = mean(dbdaymean);
            db.daymeanmax = max(dbdaymean);
            db.daymeanmin = min(dbdaymean);
%           db.dbhourmaxmean = mean(dbhourmean);
%             db.dbhourmaxmeanmax = max(dbhourmean);
%             db.dbhourmaxmeanmin = min(dbhourmean);

%         expmean = mean(daymean);
%         meanofexperimentmeans = movmean(expmean, 5);

        %
       % dBdaymean = mean(dBday);
         %expmean = smoothdata(meanofexperimentmeans, 'SamplePoints',in(1).trial(1).tim);
        
       
        % Mean of means
        %meanofmeans = mean(mday); % Takes the mean of the means for a day from each trial 
        
        
        
      %  hourtim = in(j).day(1).tim/3600;
        

   

    
    

