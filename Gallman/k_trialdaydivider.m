function trial = k_trialdaydivider(rawtim, rawamp, resampledxx, splineyy, ld, lighttimes, ReFs)

%prep
        %define trial length

            if ld > 15 
                triallength = ld * 2;
            else
                triallength = ld * 4;
            end

            triallength %useful to keep track of 

        %adjust raw data to fit full day cycles
        timcont = rawtim;
        timcont = timcont(timcont >= lighttimes(1) & timcont <= lighttimes(end));

        %how many trials in sample?
        lengthofsampleHOURS = lighttimes(end) - lighttimes(1); 
        numotrials = floor(lengthofsampleHOURS / triallength); % of trials

    %divide  data into trials
    
    for jj = 1:numotrials
        
        
       %RAW DATA 
        %define trial indicis based on timcont
        timidx = find(timcont >= lighttimes(1) + ((jj-1)*triallength) & timcont < lighttimes(1) + (jj*triallength));

        %data
        trial(jj).Amp = rawamp(timidx);
        %time
        trial(jj).entiretimcont = timcont(timidx);
        trial(jj).timcont = timcont(timidx) - timcont(timidx(1));
        
       %SPLINE DATA
        %define trial indicies based on xx
        
        % Get the index for the start of the current period (xx is time)
        Stimidx = find(resampledxx > resampledxx(1) + ((jj-1) * triallength), 1);
        % Get the rest of the indices for the trial  
        Stimidx = Stimidx:Stimidx + (triallength*ReFs)-1;

        if length(rawamp) >= Stimidx(end)
            % Data   
            trial(jj).SAmp = splineyy(Stimidx);

            % Time  
            trial(jj).Stimcont = resampledxx(Stimidx) - resampledxx(Stimidx(1)); % Time starting at zero  
            trial(jj).Sentiretimcont = resampledxx(Stimidx);
        end
            
    end
        
%%        
    %divide trials into days
    for jj = length(trial):-1:1 % For each trial
        

        % Divide by daylength to get the number of days in the trial
        howmanydaysintrial = floor(triallength / (ld*2));
        % This is the number of sample in a day
        howmanysamplesinaday = ld * 2 * ReFs;

        for k = 1:howmanydaysintrial % Each day in a trial


            % Get the index of the start time of the trial
            dayidx = find(trial(jj).Stimcont > (k-1) * (ld*2), 1) -1; % k-1 so that we start at zero
            
            
            
            % Get the datums
            trial(jj).day(k).SAmpday(:) = trial(jj).SAmp(dayidx:dayidx+howmanysamplesinaday-1);
            

        end
            % Make a time sequence for the datums (easier than extracting from
            % xx...)
            trial(jj).daytim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;

    end

