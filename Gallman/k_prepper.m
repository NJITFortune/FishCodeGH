function [Ampdata, Amptim] = k_prepper(in, Amp, ampidx)
%function inputs
%data
% k = 5;
% in = kg(k);
%analysis

%options for Amp
% obwAmp
% zAmp
% sumfftAmp

%options for ampidx
% obwidx
% zidk
% sumfftidx

%% Preparations    
    
%Subsample for good data        
   
        %run through data channels with for loop because fuck typing twice
        for j = 1:2
            
            %outlier exclusion
                %prepare data with outliers - not really a thing anymore but just in case
                tto{1} = 1:length([in.e(j).s.timcont]); 

                % Prepare the data without outliers
                if ~isempty(in.idx) 
                tto{j} = in.idx(j).ampidx; 
                end
            
           %Sample dataset by poweridx-window of good data to analyze [start end] 
           
                if isempty(in.info.poweridx) %if there are no values in poweridx []
                   obtt = 1:length([in.e(j).s(tto{j}).timcont]/(60*60)); %use the entire data set to perform the analysis
                else %if there are values in poweridx [X1 X2]
                    %perform the analysis between the poweridx values
                   obtt = find([in.e(j).s(tto{1}).timcont]/(60*60) > in.info.poweridx(1) & [in.e(1).s(tto{1}).timcont]/(60*60) < in.info.poweridx(2));
                end  

            
            %create data variables of poweridx 
                %data
                Ampdata(j) = [in.e(j).s(tto{j}(obtt)).Amp]; 
                %time
                Amptim(j) = [in.e(j).s(tto{j}(obtt)).timcont]/(60*60);
            
 
        end

    
    %Channel 1
 
    
   
    
%     %create data variables of poweridx 
%     obwdata1 = [in.e(1).s(tto{1}(obtt)).obwAmp]; 
%     obwtim1 = [in.e(1).s(tto{1}(obtt)).timcont]/(60*60);
%     
%         %summarize data
%             %ppform of cubic smoothing spline
%             spliney = csaps(obwtim1, obwdata1, p);
%             %fortune doesn't like linspace... I think he does it to confuse me
%             o.obw(1).x = obwtim1(1):1/ReFs:obwtim1(end);
%             %evaluate the csplined values of y for the new equally spaced values of x
%             o.obw(1).y = fnval(o.obw(1).x, spliney);