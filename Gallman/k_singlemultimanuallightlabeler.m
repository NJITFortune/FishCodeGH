function out = k_singlemultimanuallightlabeler(in)
%in = kg(#).e
%out = kg(k).info.luz

 startim = input('Enter the start time for the experiment: ');
 % LIGHT CYCLE ON/OFF STARTS 
    %caclulate hours when the light changed
        numbercycles = floor(in.s(end).timcont/(in.info.ld*60*60)); %number of cycles in data
        timz = 1:1:numbercycles;
        out(timz) = startim + (in.info.ld*(timz-1)); %without for-loop
        
         %find the time indicies for the first light cycle
        lidx = find([in.s.timcont] > out(1)*(60*60)& [in.s.timcont] < out(2)*(60*60));  
    %take the mean of the light values in the first cycle
        meaninitialbright = mean([in.s(lidx).light]);
    
    %Assign negative values to luz when lights were off
        if meaninitialbright < 2.5 % Lights in initial period were off
            out(1:2:end) = -out(1:2:end); % Set initial period and every other subseqent  as off
        else
            out(2:2:end) = -out(2:2:end); % Set the second period and every other subsequent as off.
        end