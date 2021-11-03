%function out = KatieTempLabeler(in)
%in = kg2(k).s
%out = kg2(k).info

%in = kg2(1).s;
in = kg(52);




%plot light
figure(58); clf; hold on;

%plot([in.timcont]/3600, [in.temp]);
            
            
%find idicies where the light changes (threshold of 2.5)            
risetime([in.temp], [in.timcont]/3600);

%r = risetime
%lt = lowercross
%ut = uppercross
[r, lt, ut] = risetime([in.temp], [in.timcont]/3600);










    