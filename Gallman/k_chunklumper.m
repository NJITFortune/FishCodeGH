%function [exp, fish, ld] = k_fftdaymovabovemeans(in)
  clearvars -except hkg hkg2 dark light darkmulti lightmulti kg kg2
  in = darkraw(1);

ld =  ceil(in.darkhalf(1).tim(end));



%figure(99);clf; hold on;

darkhalfamp = in.darkhalf(1).amp;
darkhalftim
lighthalfamp
lighthalftim
 for j = 2:length(in.darkhalf) % experiments of x hour length
  
        darkhalfamp = [darkhalfamp in.darkhalf(j).amp];
      
