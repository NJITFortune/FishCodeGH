figure(1); clf;
    subplot(211); plot(out.errorVEL.Xs, out.errorVEL.OccCorrHist, 'o-'); 
    subplot(212); hold on;
        yyaxis left; plot(out.errorVEL.Xs, out.errorVEL.responseHist, 'o-'); 
        yyaxis right; plot(out.errorVEL.Xs, out.errorVEL.stimulusHist, 'o-');
        
figure(2); clf;
    subplot(211); plot(out.errorACC.Xs, out.errorACC.OccCorrHist, 'o-'); 
    subplot(212); hold on; 
        yyaxis left; plot(out.errorACC.Xs, out.errorACC.responseHist, 'o-'); 
        yyaxis right; plot(out.errorACC.Xs, out.errorACC.stimulusHist, 'o-');

figure(3); clf;
    subplot(211); plot(out.errorJRK.Xs, out.errorJRK.OccCorrHist, 'o-'); 
    subplot(212); hold on; 
        yyaxis left; plot(out.errorJRK.Xs, out.errorJRK.responseHist, 'o-'); 
        yyaxis right; plot(out.errorJRK.Xs, out.errorJRK.stimulusHist, 'o-');
