function out = k_zAmp(in)
% Mean amplitude method

    z = zeros(1,length(in)); %creat vector length of data
    z(in > 0) = 1; %fill with 1s for all filtered data greater than 0
    z = diff(z); %subtract the X(2) - X(1) to find the positive zero crossings
    
    posZs = find(z == 1); 
    
    amp = zeros(1,length(posZs)-1); % PreAllocate for speed
    
    for kk = 2:length(posZs)
       amp(kk-1) = max(in(posZs(kk-1):posZs(kk))) - (min(in(posZs(kk-1):posZs(kk)))); % Max + min of signal for each cycle
    end
    
    out = mean(amp);
