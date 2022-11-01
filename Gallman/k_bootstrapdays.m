%function [exp, fish, ld] = k_bootstrapdays(in1, in2)
clearvars -except hkg hkg2 dark light darkmulti lightmulti kg kg2 xxkg
  in1 = dark(2).h;
  in2 = darkmulti(2).h;

ld = in1(1).day(1).ld;

 
%vertically concatenate all days
    %single fish
        
    kk = 0;
        
         for j = 1:length(in1) % experiments of x hour length
          
             
             for k = 1:length(in1(j).day)
              
             singlealldays(kk+k,:) = in1(j).day(k).Sobwyy;
             
                fish(j).amprange(k,:) = in(j).day(k).amprange;
                amprange(k,:) = in(j).day(k).amprange;
    
                fday(k,:) = in(j).day(k).freq;
               % tday(k,:) = k_temptocelcius(in(j).day(k).temp);
                tday(k,:) = in(j).day(k).temp;
               


             end
        
             kk = k;
         end

       
    %muilti fish
    ii = 0;
            
             for j = 1:length(in2) % experiments of x hour length
              
                 
                 for i = 1:length(in2(j).day)
                  
                 multialldays(ii+i,:) = in2(j).day(i).Sobwyy;
    
    
                 end
            
                 ii = i;
             end

%check number of days per hour experiment             
    singlesize = size(singlealldays);
    multisize = size(multialldays);

  if multisize(1) < singlesize(1)
      randsampidx = randi(multisize(1), multisize(1),1);
      singlesomedays = singlealldays(randsampidx,:);

  else
      singlesomedays = singlealldays;

  end
    

  %average and save output
    expmean = mean(singlesomedays);
    singexp.meanofexperimentmeans = movmean(expmean, 5);
    singexp.meanoffreqmeans = mean(freqday);
    singexp.meanoftempmeans = mean(tempday);

    %testmean = movmean(expmean, 5);
    %average max and min
    singexp.expavgrange = mean(avgrange);
    
        %expmean = smoothdata(meanofexperimentmeans, 'SamplePoints',in(1).trial(1).tim);
    
    
    
    singexp.hourtim = in(j).day(1).tim/3600;
