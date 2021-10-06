%function out = KatieTempLabeler(in)
%in = kg2(k).s
%out = kg2(k).info

in = kg2(1).s;


%plot light
figure(58); clf; hold on;

plot([in.timcont]/3600, [in.temp]);
            
            
%find idicies where the light changes (threshold of 2.5)            
findchangepts([in.temp], 'MinThreshold', 2.5);

%create luz vector for light change times
    %lights on is +
    %lights off is -
% for j = 1:length(ipt)
%     
%     changepts(j) = [in(ipt(j)).timcont]/3600;
%     if [out(ipt(j)).light] < 2.55
%         changepts(j) = -changepts(j);
%     end
%     
% end
%     
% if changepts > 0
% plot([abs(changepts)' abs(changepts)'], ylim, 'y-');
% else
% plot([abs(changepts)' abs(changepts)'], ylim, 'k-');
% end
% 
% %out.luz = changepts;
% 
% 








    