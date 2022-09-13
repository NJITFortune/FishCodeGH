function out = k_singlemanuallightlabeler(in)
%in = kg(#).e
%out = kg(k).info.luz

 startim = input('Enter the start time for the experiment: ');
 % LIGHT CYCLE ON/OFF STARTS 
 tto{1} = [in.idx(1).obwidx];
 timcont = [in.e(1).s(tto{1}).timcont];
    %caclulate hours when the light changed
        numbercycles = floor(timcont(end)/(in.info.ld*60*60)); %number of cycles in data
        timz = 1:1:numbercycles;
        out(timz) = startim + (in.info.ld*(timz-1)); %without for-loop
        
         %find the time indicies for the first light cycle
        lidx = [in.e(1).s.timcont] < out(2)*(60*60);  
    %take the mean of the light values in the first cycle
        meaninitialbright = mean([in.e(1).s(lidx).light]);
    
    %Assign negative values to luz when lights were off
        if meaninitialbright < 2.5 % Lights in initial period were off
            out(1:2:end) = -out(1:2:end); % Set initial period and every other subseqent  as off
        else
            out(2:2:end) = -out(2:2:end); % Set the second period and every other subsequent as off.
        end