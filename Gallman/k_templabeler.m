function out = KatieTempLabeler(in)
%in = kg2(k).s
%out = kg2(k).info

%in = kg2(1).s;

%in = kg(52);




%plot light
figure(58); clf; hold on;

plot([in.e(1).s.timcont]/3600, [in.e(1).s.temp]);
            
            
%find idicies where the light changes (threshold of 2.5)            
%risetime([in.e(1).s.temp], [in.e(1).s.timcont]/3600);
%falltime([in.e(1).s.temp], [in.e(1).s.timcont]/3600);

%r = risetime
%lt = lowercross
%ut = uppercross
[r, lrx, urx, lrl, url] = risetime([in.e(1).s.temp], [in.e(1).s.timcont]/3600);
[f, lfx, ufx, lfl, ufl] = falltime([in.e(1).s.temp], [in.e(1).s.timcont]/3600);



for j = 1:length(lrx)
    %plot([lrx(j)+(r(j)/2), lrx(j)+(r(j)/2)], ylim, 'k-');
    rise(j,:) = lrx(j)+(r(j)/2);
%     plot([rise(j) rise(j)], ylim, 'b-');
end



for k = 1:length(ufx)
    %plot([ufx(k)+(f(k)/2), ufx(k)+(f(k)/2)],  ylim, 'r-');
   fall(k,:) = ufx(k)+(f(k)/2);
end
%plot([lfx ufx], [lfl ufl], 'r*');

alltemp = vertcat(rise, fall);

[tempsort, ~] = sort(alltemp);
       
        
        for j = 1:length(tempsort)
            temptims(j,:) = tempsort(j);
            plot([temptims(j), temptims(j)], ylim, 'b-');
        end

% figure(59); clf; hold on;
% 
%      plot([in.e(1).s.timcont]/3600, [in.e(1).s.temp]);   
    



    