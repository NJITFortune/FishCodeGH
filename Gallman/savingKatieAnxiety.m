%% assign amplitude data to fish by frequency
%% assign amplitude data to fish by frequency

   

%make better variables to play with

%amp
hitube1amp = [out([out.hitube]==1).hiamp];
hitube2amp = [out([out.hitube]==2).hiamp];
lotube1amp = [out([out.lotube]==1).loamp];
lotube2amp = [out([out.lotube]==2).loamp];


%% Analyze raw data files again
% Get the list of files to be analyzed 
    iFiles = dir('Eigen*');

%Set up the filters
    % Band pass filter in frequency range of fish
    [h,g] = butter(5, [freqs(1)/(Fs/2) freqs(2)/(Fs/2)]);

    % For the log filter thing
    [bb,aa] = butter(3, [0.02 0.4], 'bandpass');

% process each data point
for j = 1:length(iFiles)

    %load in data
    load(iFiles(j).name, 'data');

    % filter raw data
    e1 = filtfilt(h,g,data(:,1));
    e2 = filtfilt(h,g,data(:,2));


    % perform FFT  for both channels    
    f1 = fftmachine(e1, Fs);
    f2 = fftmachine(e2, Fs);

    %normalize amplitude by fish and by tube
    if out(j).hitube == 1
        data4analysis = (e1(out(j).hidataidx) - mean(e1(out(j).hidataidx))/ max(hitube1amp(j))
    end
