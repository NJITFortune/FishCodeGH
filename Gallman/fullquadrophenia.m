function fullquadrophenia

% Pick folder with videos to crop 
    myfolder = uigetdir('/Volumes/SSD/');
    myfolder = [myfolder, '/*.avi'];
% Get all files in folder
    iFiles = dir(myfolder);

[pather, ~, ~] = fileparts(fullfile(iFiles(1).folder, iFiles(1).name));

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
    coordinates(3,:) = [bottomtop, bottombottom, lefty(1), lefty(2)];
    coordinates(4,:) = [bottomtop, bottombottom, righty(1), righty(2)];

%% Extract first frame and show 4 images 


%for j = 1:4

   v = VideoReader(fullfile(pather, iFiles(1).name));
         
   im = readFrame(v);
   imshow(im);

 %  figure(j); imshow(im(coordinates(j,1):coordinates(j,2), coordinates(j,3):coordinates(j,4)));
        
%end

%pause(2);

% xx = input('You like?: ');
% fprintf('You typed: %s \n', xx);
% 
% newdir = [pather, '/newFiles'];

%mkdir(newdir);

%% cycle through all files
ff = waitbar(0, 'Cycling through files.');

%kstart = 0397;

for k = 1:length(iFiles)
 
    waitbar(k/length(iFiles), ff, 'Cycling through files.', 'modal');

fprintf('Percent: %2.4f \n', 100 * (k/length(iFiles)) );

[pather, baseName, ~] = fileparts(fullfile(iFiles(k).folder, iFiles(k).name));
    tmpname = [pather, '/newFiles/', baseName, num2str(k), '-UL.avi'];
        newfilenames{1} = fullfile(tmpname);
    tmpname = [pather, '/newFiles/', baseName, num2str(k), '-UR.avi'];
        newfilenames{2} = fullfile(tmpname);
    tmpname = [pather, '/newFiles/', baseName, num2str(k),'-LL.avi'];
        newfilenames{3} = fullfile(tmpname);
    tmpname = [pather, '/newFiles/', baseName, num2str(k),'-LR.avi'];
        newfilenames{4} = fullfile(tmpname);


%     [pather, baseName, ~] = fileparts(fullfile(iFiles(k).folder,iFiles(k).name));
% 
%     tmpname = ['/newFiles/',baseName, '-UL.avi'];
%         newfilenames{1} = fullfile(pather,tmpname);
%     tmpname = ['/newFiles/',baseName, '-UR.avi'];
%         newfilenames{2} = fullfile(pather,tmpname);
%     tmpname = ['/newFiles/',baseName, '-LL.avi'];
%         newfilenames{3} = fullfile(pather,tmpname);
%     tmpname = ['/newFiles/',baseName, '-LR.avi'];
%         newfilenames{4} = fullfile(pather,tmpname);



    %extract files
    

   v = VideoReader(fullfile(pather,iFiles(k).name));

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

pause(1);

close(writerObj1); 
close(writerObj2); 
close(writerObj3); 
close(writerObj4); 
   



end
     pause(1); close(ff);   