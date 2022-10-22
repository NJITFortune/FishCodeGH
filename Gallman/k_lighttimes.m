function lighttimes = k_lighttimes(in, light)
%light is user input to determine if what day condiation to start with
%light = 3 start with dark
%light = 4 start with light
%% crop data to lighttimes
%prep variables
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld
%create positive vector of lighttimes
lighttimeslong = abs(in.info.luz);
poweridx = [in.info.poweridx];

%if we start with dark...
if in.info.luz(1) < 0

    
    %fit light vector to power idx
        %poweridx = good data
    if isempty(poweridx) %if there are no values in poweridx []
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
            lighttimesidx = lighttimeslong > poweridx(1) & lighttimeslong < poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1 & lighttimeslong < poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end

else %we start with light
    lighttimeslong = lighttimeslong(2:end);
    if isempty(poweridx) %if there are no values in poweridx []
        if light < 4
        lighttimes = lighttimeslong;
        else
        lighttimes = lighttimeslong(2:end);
        end
    else %take data from within power idx range

        if light < 4 %we start with dark
            lighttimesidx = lighttimeslong > poweridx(1) & lighttimeslong < poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        else %we start with light
            %poweridx normally starts with dark, so we need to add ld to start with light
            poweridx1 = poweridx(1) + ld;
            lighttimesidx = lighttimeslong > poweridx1 & lighttimeslong < poweridx(2);
            lighttimes = lighttimeslong(lighttimesidx);
        end
    end
end

%make lighttimes an integer
    %convert to seconds because xx is in seconds
    lighttimes = lighttimes*3600;
