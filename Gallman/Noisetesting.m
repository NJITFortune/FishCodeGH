%EVERYTHING on same power strip - USBs for trigger plugged in
load('GallmanElectro_08-20-2020_13-37-51.mat')
figure(1); plot(tim, EODonly)

%EVERYTHING on same power strip - USBs for trigger unplugged
load('GallmanElectro_08-20-2020_13-36-24.mat')
figure(2); plot(tim, EODonly)

%Computer and DAC on separate power - no USB
load('GallmanElectro_08-19-2020_17-12-25.mat')
figure(3); plot(tim, EODonly)

%Computer on separate power - noUSB
load('GallmanElectro_08-20-2020_14-01-48.mat')
figure(4); plot(tim, EODonly)

%computer on separate power - DAC plugged into wall cirucuit instead of
%power strip
load('GallmanElectro_08-20-2020_14-37-13.mat')
figure(5); plot(tim, EODonly)
%...with USB plugged in
load('GallmanElectro_08-20-2020_14-38-53.mat')
figure(6); plot(tim, EODonly)