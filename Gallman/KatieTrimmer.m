function out  = KatieTrimmer(in)
%Usage:kg(#).e = KatieTrimmer(kg(#).e);
 % Optional data trimming
        
 
%plot the data over time to check for problems 
figure (1); hold on; title('sumfftAmp');

  ax(1) = subplot(311); hold on; title('obwAmp');   
    yyaxis right; plot([in(2).s.timcont]/(60*60), [in(2).s.obwAmp], '.');
    yyaxis left; plot([in(1).s.timcont]/(60*60), [in(1).s.obwAmp], '.');
   % plot([out.timcont]/(60*60), [out.Ch3sumAmp], '.');
 
  ax(2) = subplot(312); hold on; title('frequency (black) and temperature (red)');   
        yyaxis right; plot([in(2).s.timcont]/(60*60), [in(2).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis right; plot([in(1).s.timcont]/(60*60), [in(1).s.fftFreq], '.k', 'Markersize', 8);
        yyaxis left; plot([in(2).s.timcont]/(60*60), [in(2).s.temp], '.r', 'Markersize', 8);
        yyaxis left; plot([in(1).s.timcont]/(60*60), [in(1).s.temp], '.r', 'Markersize', 8);
    
  ax(3) = subplot(313); hold on; title('light transitions');
    plot([in(2).s.timcont]/(60*60), [in(1).s.light], '.', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');
    
  linkaxes(ax, 'x');

%click new figure bounds starting from left
    [x, ~] = ginput(2);
    
    %Make sure these are the ones we want before we over write the data  
    A = input('Wtf do you want to do?');
    if A == 1 
        tt = find([in(1).s.timcont] > x(1) & [in(1).s.timcont] < x(2));
        out(1).s = in(1).s(tt);
        tt = find([in(2).s.timcont] > x(1) & [in(2).s.timcont] < x(2));
        out(2).s = in(2).s(tt);
    else 
        return
   
    end        
     
   
    
