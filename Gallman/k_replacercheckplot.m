function k_replacercheckplot(in) 
% innumb determines whether the input is for the high or low frequency fish
% out = kg2(k);
% str = 'high frequency fish' etc.


% inumb = 6;
% out = kg2(k);
%% prep
 
     tto = in.idx2.obwidx;


    
%%    

figure(457); clf;  hold on;


    ax(1) = subplot(311); title('amp'); hold on; %ylim([0,2]);
           
%             plot([in.timcont]/3600, [in.pkAmp], 'ko');
%             plot([in(ttpk).timcont]/3600, [in(ttpk).pkAmp], 'ro');
            
   % ax(2) = subplot(412); title('obw'); hold on; %ylim([0,3]);        
            plot([in.s.timcont]/3600, [in.s.obwAmp], 'ko');
            plot([in.s(tto).timcont]/3600, [in.s(tto).obwAmp], 'co');
         
            
    ax(2) = subplot(312); title('frequency'); hold on; %ylim([0,3]);
%
          
            plot([in.s.timcont]/3600, [in.s.freq], 'ko');
            plot([in.s(tto).timcont]/3600, [in.s(tto).freq], 'o');
    
    ax(3) = subplot(313); title('light cycle'); hold on;
            plot([in.s.timcont]/3600, [in.s.light]);
            

linkaxes(ax, 'x');
