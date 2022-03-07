function out = fullfishmonger

Fs = 15;
%confidencelevel = 0.95;

%% Load csvfile
% Pick folder with videos to crop 
    myfolder = uigetdir;
    myfolder = [myfolder, '/*.csv'];
% Get all files in folder
    iFiles = dir(myfolder);

    
%[pather, ~, ~] = fileparts(fullfile(iFiles(1).folder, iFiles(1).name));


%% Put data into structure

ff = waitbar(0, 'Cycling through files.');

for k = 1:length(iFiles)
    
k    
c = readmatrix(fullfile(iFiles(k).folder,iFiles(k).name));

out.filename = iFiles(k).name; 

out.tim = 1/Fs:1/Fs:length(c(:,1))/Fs;
out.Fs = Fs;

out.nose(:,1) = c(:,2);
out.nose(:,2) = c(:,3);
out.nose(:,3) = c(:,4);

out.fin(:,1) = c(:,5);
out.fin(:,2) = c(:,6);
out.fin(:,3) = c(:,7);

out.tail(:,1) = c(:,8);
out.tail(:,2) = c(:,9);
out.tail(:,3) = c(:,10);

end

out.folder = iFiles(1).name;
out.tim = [];
%% Calculate shitty velocity
% 
% for j=1:length(out.nose)-1 
%     dNose(j) = pdist2(out.nose(j,1:2), out.nose(j+1,1:2)); 
%     dFin(j) = pdist2(out.fin(j,1:2), out.fin(j+1,1:2)); 
%     dTail(j) = pdist2(out.tail(j,1:2), out.tail(j+1,1:2)); 
% end
% 
% 
% %% Plot data
% figure(1); clf; hold on;
%     nn = find(out.nose(:,3) > confidencelevel);
%         plot(out.nose(nn,1), -out.nose(nn,2), '-r.', 'MarkerSize', 8);
%     ff = find(out.fin(:,3) > confidencelevel);
%         plot(out.fin(ff,1), -out.fin(ff,2), '-g.', 'MarkerSize', 8);
%     tt = find(out.tail(:,3) > confidencelevel);
%         plot(out.tail(tt,1), -out.tail(tt,2), '-b.', 'MarkerSize', 8);
% legend('Nose', 'Dorsal Fin', 'Tail', 'AutoUpdate','off');
% 
% % Add dots for starting location
%     plot(out.nose(1,1), -out.nose(1,2), 'k.', 'MarkerSize', 16);
%     plot(out.fin(1,1), -out.fin(1,2), 'k.', 'MarkerSize', 16);
%     plot(out.tail(1,1), -out.tail(1,2), 'k.', 'MarkerSize', 16);
% 
% xlim([0 640]); ylim([-340 0]);
%         
% figure(2); clf; hold on
% 
%         plot(out.tim(2:end), dNose, 'r');
%         plot(out.tim(2:end), dFin, 'g');
%         plot(out.tim(2:end), dTail,'b');     
% %         plot(out.tim(2:end), medfilt1(dNose, 5), 'r');
% %         plot(out.tim(2:end), medfilt1(dFin, 5), 'g');
% %         plot(out.tim(2:end), medfilt1(dTail, 5),'b');     
%         
% legend('Nose', 'Dorsal Fin', 'Tail');

        