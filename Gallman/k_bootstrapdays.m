function [exp, fish, ld] = k_bootstrapdays(in1, in2)
%   clearvars -except hkg hkg2 dark light darkmulti lightmulti kg kg2
  in1 = dark(1).h;
  in2 = darkmulti(1).h;

ld = in1(1).day(1).ld;

 
%vertically concatenate all days
    %single fish
        singlealldays(1) = in1(1).day;
        
        
         for j = 2:length(in1) % experiments of x hour length
          
            singlealldays(j,:) = [singlealldays; in1(j).day];
        
         end
        
    %multifish
        multialldays(1) = in2(1).day;
        
        
         for jj = 2:length(in2) % experiments of x hour length
          
            multialldays(jj,:) = [multialldays; in2(jj).day];
        
         end

      
