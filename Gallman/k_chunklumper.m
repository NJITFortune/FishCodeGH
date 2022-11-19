function [darkhalfamp, darkhalftim, lighthalfamp, lighthalftim, ld] = k_chunklumper(in, light)
%% usage
%Takes concatenated data from each experiment collected in KatieRawObwDay
%   and concatenates all expereriments together
%Perform across hour treatments to collate raw data


%   clearvars -except hkg hkg2 dark light darkmulti lightmulti kg kg2 darkraw lightraw
% light = 3;
% 
%   in = darkraw(1);
%% ld
if light == 3  
ld =  ceil(in.darkhalf(1).tim(end));
end

if light == 4
ld =  ceil(in.lighthalf(1).tim(end));
end
%% combine into single data vector

%darkhalf
    darkhalfamp = in.darkhalf(1).amp;
    darkhalftim = in.darkhalf(1).tim;
    
     for j = 2:length(in.darkhalf) % experiments of x hour length
      
            darkhalfamp = [darkhalfamp in.darkhalf(j).amp];
            darkhalftim = [darkhalftim in.darkhalf(j).tim];
    
     end
          
    [darkhalftim, sortidx] = sort(darkhalftim);
    darkhalfamp = darkhalfamp(sortidx);

%lighthalf
    lighthalfamp = in.lighthalf(1).amp;
    lighthalftim = in.lighthalf(1).tim;
    for j = 2:length(in.lighthalf) % experiments of x hour length
      
            lighthalfamp = [lighthalfamp in.lighthalf(j).amp];
            lighthalftim = [lighthalftim in.lighthalf(j).tim];
    
     end
          
    [lighthalftim, lsortidx] = sort(lighthalftim);
    lighthalfamp = lighthalfamp(lsortidx);





