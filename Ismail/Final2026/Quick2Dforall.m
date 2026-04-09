%% Prep

load ~/NotCloudy/ismailCompleatFinal2024.mat 
dataList_NeuronsDurationComments;


%% Loop through every neuron included in numIDX. This takes too long. Be patient.

for j=length(numIDX):-1:1

    % This gets the fish (f) and neuron (n) indices for each valid neuron.
    f = neuronsAll(numIDX(j),1);
    n = neuronsAll(numIDX(j),2);


    smitaPlot(curfish, f, n); drawnow;
    set(gcf, 'renderer', 'painters');
    fname = sprintf('%sF%dN%d.pdf', fishNames{f}, f, n);
    print(gcf, fname, '-dpdf', '-bestfit');
%     plotEVFAheatmaps(curfish, f, n); drawnow;
% 
% foo = DSItimeplotEVFA(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time);
%         figure; 
%         plot(foo.dels, [foo.evDSI', foo.faDSI'], 'LineWidth', 4); 
%         hold on; 
%         plot([0, 0], [-0.5, 0.5], 'k-'); plot([-1, 1], [0, 0], 'k-');
%         text(-0.9,-0.2, [num2str(f), ', ', num2str(n)]);
%         drawnow;

end