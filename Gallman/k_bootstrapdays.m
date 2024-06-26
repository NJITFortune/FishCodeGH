function [singexp, singlefish, multiexp, multifish, ld] = k_bootstrapdays(in1, in2)
% clearvars -except hkg hkg2 dark light darkmulti lightmulti kg kg2 xxkg
%   in1 = dark(2).h;
%   in2 = darkmulti(2).h;
% 
 ld = in1(1).day(1).ld;

 
%vertically concatenate all days
    %single fish
        
    kk = 0;
        
         for j = 1:length(in1) % experiments of x hour length
          
             
             for k = 1:length(in1(j).day)
              
                singlealldays(kk+k,:) = in1(j).day(k).Sobwyy;
                singlefishy(kk+k,:) = j;
                singleallamprange(kk+k,:) = in1(j).day(k).amprange;
                singleallfday(kk+k,:) = in1(j).day(k).freq;
                singlealltday(kk+k,:) = in1(j).day(k).temp;

             end
        
             kk = k;
         end

       
    %muilti fish
    ii = 0;
            
             for j = 1:length(in2) % experiments of x hour length
              
                 
                 for i = 1:length(in2(j).day)
                  
                 multialldays(ii+i,:) = in2(j).day(i).Sobwyy;
                 multifishy(ii+i,:) = j;
                 multiamprange(ii+i,:) = in2(j).day(i).amprange;
                 multifday(ii+i,:) = in2(j).day(i).freq;
                 multitday(ii+i,:) = in2(j).day(i).temp;
    
    
                 end
            
                 ii = i;
             end

%check number of days per hour experiment             
    singlesize = size(singlealldays);
    multisize = size(multialldays);

  if multisize(1) < singlesize(1)
      randsampidx = randi(multisize(1), multisize(1),1);
     
      singlesomedays = singlealldays(randsampidx,:);
      singlesomefish = singlefishy(randsampidx,:);

      singlesomeamprange = singleallamprange(randsampidx,:);
      singlesomefday = singleallfday(randsampidx,:);
      singlesometday = singlealltday(randsampidx,:);

  else
      singlesomedays = singlealldays;

      singlesomeamprange = singleallamprange;
      singlesomefday = singleallfday;
      singlesometday = singlealltday;
      singlesomefish = singlefishy;

  end
    
%average and save output
    %single fish
        expmean = mean(singlesomedays);
        singexp.meanofexperimentmeans = movmean(expmean, 5);
        singexp.meanoffreqmeans = mean(singlesomefday);
        singexp.meanoftempmeans = mean(singlesometday);

        [newfish, newfishidx] = sort(singlesomefish);
        newamprange = singlesomeamprange(newfishidx);

        singlefish.fish = newfish;
        singlefish.singlesomeamprange = newamprange;
    
        %testmean = movmean(expmean, 5);
        %average max and min
        singexp.expavgrange = mean(singlesomeamprange);
            
        singexp.hourtim = in1(1).day(1).tim/3600;

    %multi fish
         expmean = mean(multialldays);
        multiexp.meanofexperimentmeans = movmean(expmean, 5);
        multiexp.meanoffreqmeans = mean(singlesomefday);
        multiexp.meanoftempmeans = mean(singlesometday);
        multifish.fish =multifishy;
        multifish.multiamprange = multiamprange;
    
        %testmean = movmean(expmean, 5);
        %average max and min
        multiexp.expavgrange = mean(multiamprange);
            
        multiexp.hourtim = in2(1).day(1).tim/3600;


