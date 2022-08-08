function out = fishswapper(in)
% clearvars -except dualfm fm fmv
% in = dualfm(1);
for yy = length(in.s):-1:1
   
    
% Check to see if the first value is NaN and replace with first good value
    if isnan(in.s(yy).onefin(1,1)) %if the first value is NaN
        onenonnanidx = find(~isnan((in.s(yy).onefin(:,1))'), 1);
        in.s(yy).onefin(1,1)= in.s(yy).onefin(onenonnanidx,1);
        in.s(yy).onefin(1,2)= in.s(yy).onefin(onenonnanidx,2);
        in.s(yy).onefin(1,3) = 0.1; %confidence is low
    end
   
    if isnan(in.s(yy).twofin(1,1)) %if the first value is NaN
        
        %find the index of the first non NaN
        twononnanidx = find(~isnan((in.s(yy).twofin(:,1))'), 1);
        %replace the first value with the first non-nan value
        in.s(yy).twofin(1,1)= in.s(yy).twofin(twononnanidx,1);
        in.s(yy).twofin(1,2)= in.s(yy).twofin(twononnanidx,2);
        in.s(yy).twofin(1,3) = 0.1; %confidence is low
    end
    
% Check to see if the 1000th frame is NaN and replace with last good value
    %if length(in.s(yy).onefin) < 1000 || length(in.s(yy).twofin) < 1000
        onelastnonnanidx = find(~isnan((in.s(yy).onefin(:,1))'), 1, 'last');
        in.s(yy).onefin(1000,1)= in.s(yy).onefin(onelastnonnanidx,1);
        onelastnonnanidx = find(~isnan((in.s(yy).onefin(:,2))'), 1, 'last');
        in.s(yy).onefin(1000,2)= in.s(yy).onefin(onelastnonnanidx,2);
   
        twolastnonnanidx = find(~isnan((in.s(yy).twofin(:,1))'), 1, 'last');
        in.s(yy).twofin(1000,1)= in.s(yy).twofin(twolastnonnanidx,1);
        twolastnonnanidx = find(~isnan((in.s(yy).twofin(:,2))'), 1, 'last');
        in.s(yy).twofin(1000,2)= in.s(yy).twofin(twolastnonnanidx,2);
    %end
    
    
    
for x=2:1000
 
    % If the current value is an NaN, fix that
    if isnan(in.s(yy).onefin(x,1)) %if the value is NaN for fish one 
        %fill NaN value with previous integer value
        in.s(yy).onefin(x,1) = in.s(yy).onefin(x-1,1); % Same pos (zero vel) %x
        in.s(yy).onefin(x,3) = 0.1; %confidence is low
    end
    if isnan(in.s(yy).onefin(x,2)) %if the value is NaN for fish one         
        in.s(yy).onefin(x,2) = in.s(yy).onefin(x-1,2); % Same pos (zero vel) %y       
        in.s(yy).onefin(x,3) = 0.1; %confidence is low
    end
    
    if isnan(in.s(yy).twofin(x,1)) %if the value is NaN for fish two   
        %fill NaN value with previous integer value
        in.s(yy).twofin(x,1) = in.s(yy).twofin(x-1,1); %x
        in.s(yy).twofin(x,3) = 0.1; %confidence
    end
    if isnan(in.s(yy).twofin(x,2)) %if the value is NaN for fish two   
        in.s(yy).twofin(x,2) = in.s(yy).twofin(x-1,2); %y
        in.s(yy).twofin(x,3) = 0.1; %confidence
    end
  
    %tracking that switches between fish will have a greater distance in
    %same fish
    distancebetweenfishtwotoone = pdist2(in.s(yy).twofin(x,1:2), in.s(yy).onefin(x-1,1:2)); 
    distancesamefishone = pdist2(in.s(yy).onefin(x,1:2), in.s(yy).onefin(x-1,1:2));
    
    if distancebetweenfishtwotoone < distancesamefishone % need to swap
      %k=k+1; fprintf('Swap number first %i \n', k);  
        tmp = in.s(yy).onefin(x,:);
        in.s(yy).onefin(x,:) = in.s(yy).twofin(x,:);
        in.s(yy).twofin(x,:) = tmp;
    end

    distancebetweenfishonetotwo = pdist2(in.s(yy).onefin(x,1:2), in.s(yy).twofin(x-1,1:2)); 
    distancesamefishtwo = pdist2(in.s(yy).twofin(x,1:2), in.s(yy).twofin(x-1,1:2));
    
    if distancebetweenfishonetotwo < distancesamefishtwo % need to swap
    %  m=m+1; fprintf('Swap number second %i \n', m);  
        tmp = in.s(yy).onefin(x,:);
        in.s(yy).onefin(x,:) = in.s(yy).twofin(x,:);
        in.s(yy).twofin(x,:) = tmp;
    end
    
    

end

end
out = in; 
%plot to check
% figure(1); clf; plot(in.s(yy).onefin(:,1), in.s(yy).onefin(:,2), '.-'); hold on; plot(in.s(yy).twofin(:,1), in.s(yy).twofin(:,2), '.-');
% xlim([0 650]); ylim([0 320]);

