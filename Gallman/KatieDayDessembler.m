function trial = KatieDayDessembler(out, ReFs)

    perd = (length(out(1).Stimcont))/ReFs;

    for jj = length(out):-1:1 % For each trial
        
        ld = out(jj).ld;

        % Divide by daylength to get the number of days in the trial
        howmanydaysintrial = floor(perd / (ld*2));
        % This is the number of sample in a day
        howmanysamplesinaday = ld * 2 * ReFs;

        for k = 1:howmanydaysintrial % Each day in a trial


            % Get the index of the start time of the trial
            dayidx = find(out(jj).Stimcont > (k-1) * (ld*2), 1) -1; % k-1 so that we start at zero

            % Get the datums
            trial(jj).day(k).SobwAmp = out(jj).SobwAmp(dayidx:dayidx+howmanysamplesinaday-1);
            trial(jj).day(k).SzAmp = out(jj).SzAmp(dayidx:dayidx+howmanysamplesinaday-1);
            trial(jj).day(k).SsumfftAmp = out(jj).SsumfftAmp(dayidx:dayidx+howmanysamplesinaday-1);

           

        end
            % Make a time sequence for the datums (easier than extracting from
            % xx...)
            trial(jj).tim = 1/ReFs:1/ReFs:howmanysamplesinaday/ReFs;

    end