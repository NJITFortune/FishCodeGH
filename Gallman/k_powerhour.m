%function k_powerhour(in)

 figure(7);clf; hold on;
   semilogx([8, 8], [0 0.05], 'r');
   semilogx([12, 12], [0 0.05], 'm');
   semilogx([24, 24], [0 0.05], 'b'); 

for k = 12%64:75
% not functioning today
clearvars -except l24kg k hkg
    in = hkg(k);



%% prep - define variables
ReFs = 20;
channel = 1;
Fs = 1/ReFs;


[regtim, regfreq, regtemp, regobwpeaks] = k_datatrimmean(in, channel, ReFs);
lighttimes = k_lighttimes(in, 3);


% trim data to lighttimes
    timidx = regtim >= lighttimes(1) & regtim <= lighttimes(end);
    regtim = regtim(timidx);
     obw = regobwpeaks(timidx);
   
    freq = regfreq(timidx);
    temp = regtemp(timidx);


   a = fftmachine(obw - mean(obw),Fs);
   %convert fft to hours - 0 is infinite so we skip 1
   newFreqs = (1./a.fftfreq(2:end))/3600; newAmps = a.fftdata(2:end);

 

   semilogx(newFreqs, newAmps, 'k', 'LineWidth', 2); 
  

end

 xlim([2 48]); xlabel('Hours in Day'); ylabel('Power'); title('Wahoo • Day Power');