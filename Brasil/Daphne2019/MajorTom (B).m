function out = MajorTom(in, tim, feesh)
% This generates stats on frequency and movement for each individual fish

if nargin < 3
    feesh = 1:length(in.fish);
end
if nargin < 2
    tim(2) = in.fish(1).freq(end,1);
    tim(1) = 0;
end

%% Mean frequency and variability

for j = length(feesh):-1:1 % For each fish
    
   idx = find(in.fish(j).freq(:,1) > tim(1) & in.fish(j).freq(:,1) < tim(2)); % Indices for the time range we want
               % idx(~isnan(in.fish(j).freq(idx,2)) is selecting only valid data
   out(j).meanfreq = mean(in.fish(j).freq(idx(~isnan(in.fish(j).freq(idx,2))),2)); 
   out(j).varfreq = var(in.fish(j).freq(idx(~isnan(in.fish(j).freq(idx,2))),2)); 
   out(j).numsamps = length(in.fish(j).freq(~isnan(in.fish(j).freq(idx,2)),2));
   out(j).numfish = length(feesh);
    
end
% figure(7); clf; 


%% Movement distance and velocity

% We want to use only sequential data (no missing samples)
% We want to avoid data in which the position of the fish is poorly estimated.

for j = length(feesh):-1:1 % For each fish

   idx = find(in.fish(j).freq(:,1) > tim(1) & in.fish(j).freq(:,1) < tim(2)); % Indices for the time range we want
   
   for k = 2:length(idx)
   % Find only consecutive data 
    if ~isnan(in.fish(j).freq(idx(k)-1,2)) && ~isnan(in.fish(j).freq(idx(k),2))
        % Calculate distance
            tmpXY(1,:) = [in.fish(j).x(idx(k)-1), in.fish(j).y(idx(k)-1)];
            tmpXY(2,:) = [in.fish(j).x(idx(k)), in.fish(j).y(idx(k))];
            
            out(j).pdist(k) = pdist(tmpXY); % How far did the real fish travel?
            out(j).pdistim(k) = in.fish(j).freq(idx(k),1);
            
            out(j).x(k-1,:) = [in.fish(j).x(idx(k-1)), in.fish(j).x(idx(k))];
            out(j).y(k-1,:) = [in.fish(j).y(idx(k-1)), in.fish(j).y(idx(k))];
    end 
   end
   
%    ax(1) = subplot(211); hold on; plot(out(j).pdist, '.-')
%    ax(2) = subplot(212); hold on; plot(diff(out(j).pdist), '.-')
%    linkaxes(ax, 'x')
end


% Useful code
% figure(10); clf; hold on;
% fsh = 1;
% clrs = hsv(100);
% for p = 1:length(out(fsh).pdist)
%     curcol = max([1, round(100*(out(fsh).pdist(p) / max(out(fsh).pdist)))]);
%     plot(out(fsh).x(p,:), out(fsh).y(p,:), 'k-.', 'Color', clrs(curcol,:));
% end

end


