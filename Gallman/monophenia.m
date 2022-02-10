function monophenia

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
    toptop = 1024-720;
    topbottom = 1024-400;
    bottomtop = 1024-320;
    bottombottom = 1024;

% X-axis coordinates
    lefty = [1 640];
    righty = [640 1280];

% Concatonated for loop below
coordinates(1,:) = [toptop, topbottom, lefty(1), lefty(2)];
coordinates(2,:) = [toptop, topbottom, righty(1), righty(2)];
coordinates(3,:) = [toptop, topbottom, lefty(1), lefty(2)];
coordinates(4,:) = [bottomtop, bottombottom, righty(1), righty(2)];

%% Extract frames and write 4 videos

tic

   v = VideoReader(fullfile(pather,filer));

   writerObj1 = VideoWriter(newfilenames{1}, 'Uncompressed AVI');
   writerObj1.FrameRate = v.FrameRate;
   writerObj2 = VideoWriter(newfilenames{2}, 'Uncompressed AVI');
   writerObj2.FrameRate = v.FrameRate;
   writerObj3 = VideoWriter(newfilenames{3}, 'Uncompressed AVI');
   writerObj3.FrameRate = v.FrameRate;
   writerObj4 = VideoWriter(newfilenames{4}, 'Uncompressed AVI');
   writerObj4.FrameRate = v.FrameRate;
   
   open(writerObj1);
   open(writerObj2);
   open(writerObj3);
   open(writerObj4);

   while hasFrame(v) 
       
    im = readFrame(v);
    
    writeVideo(writerObj1, im(coordinates(1,1):coordinates(1,2), coordinates(1,3):coordinates(1,4)));
    writeVideo(writerObj2, im(coordinates(2,1):coordinates(2,2), coordinates(2,3):coordinates(2,4)));
    writeVideo(writerObj3, im(coordinates(3,1):coordinates(3,2), coordinates(3,3):coordinates(3,4)));
    writeVideo(writerObj4, im(coordinates(4,1):coordinates(4,2), coordinates(4,3):coordinates(4,4)));
    
   end
   
close(writerObj1); 
close(writerObj2); 
close(writerObj3); 
close(writerObj4); 
fprintf('Files written.\n');
   
toc
