function ss = dualfilteredvelocity(in)
%% prep
fr = 15; %frame rate of video 
cf = 16; %pixel to cm conversion factor
medfiltnum = 11; 

xmid = 320; %each video is 640 across
cutoffreq = 1;
[b,a] = butter(5, cutoffreq / (fr/2), 'low'); %low pass filter

%% Calculate velocity from  posistion data
for j = length(in.s):-1:1
    
       
     %calculates velocity
        for jj = (length(in.s(1).onefin)-1):-1:1
                
           ss(j).doneFin(jj) = ((pdist2(in.s(j).onefin(jj,1:2), in.s(j).onefin(jj+1,1:2)))/cf)*fr; 
           ss(j).dtwoFin(jj) = ((pdist2(in.s(j).twofin(jj,1:2), in.s(j).twofin(jj+1,1:2)))/cf)*fr; 
    
        end 
 
    %calculate tank crossings 
        %fish one
        onez = zeros(1,length(in.s(j).onefin)); %create vector length of data
        onez(in.s(j).onefin(:,1) > xmid) = 1; %fill with 1s for all filtered data greater than xmid
        onez = diff(onez); %subtract the X(2) - X(1) to find the xings greater than the midline

        posoneZs = find(onez == 1); 
        negoneZs = find(onez==-1);
        ss(j).onemidxings = length(posoneZs)+ length(negoneZs);
        
        %fish two
        twoz = zeros(1,length(in.s(j).twofin)); %create vector length of data
        twoz(in.s(j).twofin(:,1) > xmid) = 1; %fill with 1s for all filtered data greater than xmid
        twoz = diff(twoz); %subtract the X(2) - X(1) to find the xings greater than the midline

        postwoZs = find(twoz == 1); 
        negtwoZs = find(twoz==-1);
        ss(j).twomidxings = length(postwoZs)+ length(negtwoZs);

end  
 

for j = length(ss):-1:1 

        onesmean = filtfilt(b,a, medfilt1(ss(j).doneFin, medfiltnum));
        twosmean = filtfilt(b,a, medfilt1(ss(j).dtwoFin, medfiltnum));
       
        ss(j).onevel = mean(onesmean);
        ss(j).onestd = std(onesmean);
        
        ss(j).twovel = mean(twosmean);
        ss(j).twostd = std(twosmean);
        
end