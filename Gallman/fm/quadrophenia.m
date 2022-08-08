jfunction quadrophenia

[filer, pather] = uigetfile('*.avi');

[~, baseName, ~] = fileparts(fullfile(pather,filer));

tmpname = [baseName, '-UL.avi'];
    newfilenames{1} = fullfile(pather,tmpname);
tmpname = [baseName, '-UR.avi'];
    newfilenames{2} = fullfile(pather,tmpname);
tmpname = [baseName, '-LL.avi'];
    newfilenames{3} = fullfile(pather,tmpname);
tmpname = [baseName, '-LR.avi'];
    newfilenames{4} = fullfile(pather,tmpname);

%% Defaults
% Y-axis coordinates (adjust as needed)
%     toptop = 1024-720;
%     topbottom = 1024-400;
%     bottomtop = 1024-320;
%     bottombottom = 1024;
% 
% % X-axis coordinates
%     lefty = [1 640];
%     righty = [640 1280];
% 
% % Concatonated for loop below
% coordinates(1,:) = [toptop, topbottom, lefty(1), lefty(2)];
% coordinates(2,:) = [toptop, topbottom, righty(1), righty(2)];
% coordinates(3,:) = [toptop, topbottom, lefty(1), lefty(2)];
% coordinates(4,:) = [bottomtop, bottombottom, righty(1), righty(2)];

 toptop = 86;
    topbottom = 456;
    bottomtop = 498;
    bottombottom = 862;
    
    % X-axis coordinates
    lefty = [1 640];
    righty = [640 1280];

% Concatonated for loop below
    coordinates(1,:) = [toptop, topbottom, lefty(1), lefty(2)];
    coordinates(2,:) = [toptop, topbottom, righty(1), righty(2)];
    coordinates(3,:) = [bottomtop, bottombottom, lefty(1), lefty(2)];
    coordinates(4,:) = [bottomtop, bottombottom, righty(1), righty(2)];

%% Extract frames and write 4 videos



for j = 1:4

   v = VideoReader(fullfile(pather,filer));

   writerObj = VideoWriter(newfilenames{j}, 'Uncompressed AVI');
   writerObj.FrameRate = v.FrameRate;
   
   open(writerObj);

   while hasFrame(v) 
       
    im = readFrame(v);
    
    writeVideo(writerObj, im(coordinates(j,1):coordinates(j,2), coordinates(j,3):coordinates(j,4)));
    
   end
   
close(writerObj); 
fprintf('File %i written.\n', j);
pause(2);
   
end


