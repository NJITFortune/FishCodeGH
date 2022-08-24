function out = AnxiouslySeparatedobwAmp(in)
% clearvars -except kg kg2 rkg k
% k = 57;
% in = kg2(k);
%% prep

Fs = 40000;
freqs = [200 650]; %freq range of typical eigen EOD
iFiles = dir('Eigen*');
rango = 50;
%plotnum = 300;
 % Band pass filter in frequency range of fish
 [h,g] = butter(5, [freqs(1)/(Fs/2) freqs(2)/(Fs/2)]);

%% obwAmp of anxiously separated data
ff = waitbar(0, 'Cycling through files.');
for j = 1:length(in.s)

     waitbar(j/length(iFiles), ff, 'Working on it...', 'modal');
    
  %load in raw data  
    load(iFiles(j).name, 'data');
    

  %filter data
    e1 = filtfilt(h,g,data(:,1));
    e2 = filtfilt(h,g,data(:,2));
  %fft to get frequency ranges
    f1 = fftmachine(data(:,1), Fs);
    f2 = fftmachine(data(:,2), Fs);


    sigf1 = find(f1.fftfreq > 200 & f1.fftfreq < 800);
    noisef1 = find(f1.fftfreq < 100);

    sigf2 = find(f2.fftfreq > 200 & f2.fftfreq < 800);
    noisef2 = find(f2.fftfreq < 100);

  %use frequencies of each fish to define new frequency ranges for obw
    midpoint = in.s(j).lofreq + ((in.s(j).hifreq - in.s(j).lofreq)/2);

  %perform obw on both fish
    %low frequency fish
    if in.s(j).lotube == 1

            if max(f1.fftdata(sigf1))/max(f1.fftdata(noisef1)) < 1
               %fprintf('bad %i', j);
                out(j).bad1idx = j;
                out(j).loAmpobw1 = -0.1;
            else
        %filter more
%         [n,m] = butter(5, [(in.s(j).lofreq-rango)/(Fs/2) (in.s(j).lofreq+rango)/(fs/2)]);
%         [p,o] = bandstop()

                [out(j).lobw1, out(j).loflo1, out(j).lofhi1, out(j).loAmpobw1] = obw(e1, Fs, [in.s(j).lofreq-rango midpoint]);
%                 if mod(j,plotnum) == 0
%                     figure(j); clf; hold on; 
%                     obw(e1, Fs, [in.s(j).lofreq-rango in.s(j).lofreq+rango]);ylabel('low1');xlim([0,1]);
%                     plot(in.s(j).lofreq, 0, 'r.', 'MarkerSize', 10);
%                     plot(in.s(j).hifreq, 0, 'b.', 'MarkerSize', 10);
%                 end


            end
    end

    if in.s(j).lotube == 2


        if max(f2.fftdata(sigf2))/max(f2.fftdata(noisef2)) < 1
                out(j).bad2idx = j;
                out(j).loAmpobw2 = -0.1;
        else
                [out(j).lobw2, out(j).loflo2, out(j).lofhi2, out(j).loAmpobw2] = obw(e2, Fs, [in.s(j).lofreq-rango midpoint]);
%                  if mod(j,plotnum) == 0
%                     figure(j); clf;  hold on;
%                     obw(e2, Fs, [in.s(j).lofreq-rango in.s(j).lofreq+rango]);ylabel('low2');xlim([0,1]); 
%                     plot(in.s(j).lofreq, 0, 'r.', 'MarkerSize', 10);
%                      plot(in.s(j).hifreq, 0, 'b.', 'MarkerSize', 10);
%                  end
        end
    end

    %high frequency fish
    if in.s(j).hitube == 1

        if max(f1.fftdata(sigf1))/max(f1.fftdata(noisef1)) < 1
                out(j).bad1idx = j;
                out(j).hiAmpobw1 = -0.1;
        else

            [out(j).hibw1, out(j).hiflo1, out(j).hifhi1, out(j).hiAmpobw1] = obw(e1, Fs, [midpoint in.s(j).hifreq+rango]);
            
%              if mod(j,plotnum) == 0
%                 figure(j+10); clf; hold on;
%                 obw(e1, Fs, [in.s(j).hifreq-rango in.s(j).hifreq+rango]);ylabel('hi1');xlim([0,1]);
%                  plot(in.s(j).lofreq, 0, 'r.', 'MarkerSize', 10);
%                  plot(in.s(j).hifreq, 0, 'b.', 'MarkerSize', 10);
%              end

        end
    end

    if in.s(j).hitube == 2

        if max(f2.fftdata(sigf2))/max(f2.fftdata(noisef2)) < 1
                out(j).bad2idx = j;
                out(j).hiAmpobw2 = -0.1;
        else


        [out(j).hibw2, out(j).hiflo2, out(j).hifhi2, out(j).hiAmpobw2] = obw(e2, Fs, [midpoint in.s(j).hifreq+rango]);
%          if mod(j,plotnum) == 0
%             figure(j+10); clf; hold on;
%             obw(e2, Fs, [in.s(j).hifreq-rango in.s(j).hifreq+rango]);ylabel('hi2');xlim([0,1]);
%              plot(in.s(j).lofreq, 0, 'r.', 'MarkerSize', 10);
%              plot(in.s(j).hifreq, 0, 'b.', 'MarkerSize', 10);
%         end
         end
    end

 end
pause(1); close(ff);


%%
    figure(65); clf; hold on;
    
       ax(1) = subplot(211); title('low frequency fish amp'); hold on;
        plot([in.s([in.s.lotube]==1).timcont]/3600, [out.loAmpobw1], 'b.');
        plot([in.s([in.s.lotube]==2).timcont]/3600, [out.loAmpobw2], 'c.');
      ax(2) = subplot(212); title('high frequency fish amp'); hold on;   
        plot([in.s([in.s.hitube]==1).timcont]/3600, [out.hiAmpobw1], 'r.');
        plot([in.s([in.s.hitube]==2).timcont]/3600, [out.hiAmpobw2], 'm.');
    linkaxes(ax, 'x');

%%
    figure(66); clf; hold on;
       ax(1) = subplot(211); title('low frequency fish'); hold on;
       if isfield(out,'lofhi1')
           find(~isempty(out.lofhi1))
         plot([in.s(find(~isempty(out.lofhi1))).timcont]/3600, [out.lofhi1], 'b.');
         plot([in.s(find(~isempty(out.lofhi2))).timcont]/3600, [out.loflo1], 'b.');
       end 
       if isfield(out,'lofhi2')
         plot([in.s([in.s.lotube]==2).timcont]/3600, [out.lofhi2], 'c.'); 
         plot([in.s([in.s.lotube]==2).timcont]/3600, [out.loflo2], 'c.');
       end  
         plot([in.s([in.s.lotube]==1).timcont]/3600, [in.s([in.s.lotube]==1).lofreq], 'k.');
         plot([in.s([in.s.lotube]==2).timcont]/3600, [in.s([in.s.lotube]==2).lofreq], 'k.');

       ax(2) = subplot(212); title('high frequency fish'); hold on;  
       if isfield(out,'hifhi1')
         plot([in.s([in.s.hitube]==1).timcont]/3600, [out.hifhi1], 'r.');
         plot([in.s([in.s.hitube]==1).timcont]/3600, [out.hiflo1], 'r.');
       end
       if isfield(out,'hifhi2')
         plot([in.s([in.s.hitube]==2).timcont]/3600, [out.hifhi2], 'm.'); 
         plot([in.s([in.s.hitube]==2).timcont]/3600, [out.hiflo2], 'm.'); 
       end
         plot([in.s([in.s.hitube]==1).timcont]/3600, [in.s([in.s.hitube]==1).hifreq], 'k.'); 
         plot([in.s([in.s.hitube]==2).timcont]/3600, [in.s([in.s.hitube]==2).hifreq], 'k.'); 
     linkaxes(ax, 'x');

%% save into output structure

