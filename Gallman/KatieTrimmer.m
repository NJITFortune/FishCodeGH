function out  = KatieTrimmer(in)
%Usage:kg(#).e = KatieTrimmer(kg(#).e);
 % Optional data trimming
        
 
%plot the data over time to check for problems 
figure (1); hold on; title('sumfftAmp');
    yyaxis right; plot([in(2).s.timcont]/(60*60), [in(2).s.obwAmp], '.');
    yyaxis left; plot([in(1).s.timcont]/(60*60), [in(1).s.obwAmp], '.');
   % plot([out.timcont]/(60*60), [out.Ch3sumAmp], '.');
 
 
   
   [x, ~] = ginput(2);
    tt = find([out(1).s.timcont] > x(1) & [out(1).s.timcont] < x(2));
    out(1).s = out.e(1).s(tt);
    tt = find([out(2).s.timcont] > x(1) & [out(2).s.timcont] < x(2));
    out(2).s = out(2).s(tt);
   
%Conditional dialogue box for reference
% %Trim data if it is problematic... or just plain weird
%  answer = questdlg('Do you want to trim the data?', ...
% 	'Trim data?', ...
% 	'Yes','No');
% 
% % Handle response
% switch answer
%     case 'Yes'
%         [x, ~] = ginput(2);
%         tt = find([out(1).s.timcont] > x(1) & [out(1).s.timcont] < x(2));
%         out(1).s = out.e(1).s(tt);
%         tt = find([out(2).s.timcont] > x(1) & [out(2).s.timcont] < x(2));
%         out(2).s = out(2).s(tt);
%         
%     case 'No'
%         return
%     
% end
 