function out = KatieLightLabeler(in)
%in = kg2(k).s
%out = kg2(k).info

%plot light
figure(58); clf; hold on;

plot([in.timcont]/3600, [in.light]);
            ylim([-1, 6]);
            
%find idicies where the light changes (threshold of 2.5)            
ipt = findchangepts([in.light], 'MinThreshold', 2.5);

%create luz vector for light change times
    %lights on is +
    %lights off is -
for j = 1:length(ipt)
    
    changepts(j) = [in(ipt(j)).timcont]/3600;
    if [out(ipt(j)).light] < 2.5
        changepts(j) = -changepts(j);
    end
    
end
    
if changepts > 0
plot([abs(changepts)' abs(changepts)'], [-1, 6], 'y-');
else
plot([abs(changepts)' abs(changepts)'], [-1, 6], 'k-');
end

out.luz = changepts;










    