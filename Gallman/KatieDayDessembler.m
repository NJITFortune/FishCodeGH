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
    
 %% plot to check

 %all days
 %average day by trial
 figure(27); clf; hold on; title('Day average by trial');
    for j=1:length(trial) 

        %create temporary vector to calculate mean by trial
        mday(j,:) = zeros(1,length(trial(j).tim));


        for k=1:length(trial(j).day)

                %fill temporary vector with data from each day 
                mday(j,:) = mday(j,:) + trial(j).day(k).SobwAmp;
                subplot(211);
                plot(trial(j).tim, trial(j).day(k).SobwAmp);

        end

         % To get average across days, divide by number of days
            mday(j,:) = mday(j,:) / length(trial(j).day);
            subplot(212);
            plot(trial(j).tim, mday(j,:), 'k-', 'Linewidth', 1);


    end

    
    
 figure(28); clf; hold on; 
    for j=1:length(trial) 

        %create temporary vector to calculate mean by trial
        mday(j,:) = zeros(1,length(trial(j).tim));


        for k=1:length(trial(j).day)

                %fill temporary vector with data from each day 
                mday(j,:) = mday(j,:) + trial(j).day(k).SobwAmp;
                subplot(211);
                plot(trial(j).tim, trial(j).day(k).SobwAmp);

        end

         % To get average across days, divide by number of days
            mday(j,:) = mday(j,:) / length(trial(j).day);
            subplot(212);
            plot(trial(j).tim, mday(j,:), 'k-', 'Linewidth', 1);


    end


