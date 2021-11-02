%% Load data
load ~/Downloads/brown2019_04_12_merged.mat

%% Figure 1 - show data for 4 clusters

tim = raw_data.interval:raw_data.interval:raw_data.length*raw_data.interval;



figure(1); clf; 

numOwaveforms = 50; % tried 50, 100, and 200. Went with 100.
prePost = [0.0001, 0.0015]; % Time, in seconds, before and after spike time

clrs = hsv(numOwaveforms);

for k = 1:5

listofcodeIDX = find(spikes_p1.codes == k);


for j=1:numOwaveforms
    
   tt = find(tim > spikes_p1.times(listofcodeIDX(j)) - prePost(1) & ...
       tim <  spikes_p1.times(listofcodeIDX(j)) + prePost(2));

    figure(1); ax(k) = subplot(3,2,k); hold on;
        plot(tim(tt)-tim(tt(1)), raw_data.values(tt), 'Color', clrs(j,:));

    % figure(2); hold on;
    %    plot(tim(tt)-tim(tt(1)), raw_data.values(tt), 'Color', clrs(k,:));
    
end

end

linkaxes(ax, 'xy'); 
figure(1); subplot(3,2,1); ylim([-0.08 0.06]);



%% Next section

