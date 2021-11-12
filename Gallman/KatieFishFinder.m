function out = KatieFishFinder(in)

%figure(987); clf; hold on;
    %Indicies when each fish was in each tube
        %when each fish was in tube 2
        intube2hi = find([in.e2hiamp] ./ [in.e1hiamp] > 2.5);
            %plot([out(intube2hi).timcont], [out(intube2hi).e2hiamp], 'b.');
        intube2lo = find([in.e2loamp] ./ [in.e1loamp] > 2.5);
            %plot([out(intube2lo).timcont], [out(intube2lo).e2loamp], 'm.');

        %when each fish was in tube 1
        intube1hi = find([in.e1hiamp] ./ [in.e2hiamp] > 2.5);
             %plot([out(intube1hi).timcont], [out(intube1hi).e1hiamp], 'bo');
        intube1lo = find([in.e1loamp] ./ [in.e2loamp] > 2.5);
            %plot([out(intube1lo).timcont], [out(intube1lo).e1loamp], 'mo');
      

    %test alternative eric
        %hi frequency fish
        %out.HiAmp = zeros(1, length(intube2hi));
            %tube 2
            for j=1:length(intube2hi)
                out.his(intube2hi(j)).HiAmp = in(intube2hi(j)).e2hiamp;
                out.his(intube2hi(j)).HiTim = in(intube2hi(j)).timcont/3600;
                out.his(intube2hi(j)).HIfreq = [in(intube2hi(j)).hifreq];
            end
            %tube 1
            for j=1:length(intube1hi)
                out.his(intube1hi(j)).HiAmp = in(intube1hi(j)).e1hiamp;
                out.his(intube1hi(j)).HiTim = in(intube1hi(j)).timcont/3600;
                out.his(intube1hi(j)).HIfreq = [in(intube1hi(j)).hifreq];
            end

            



        %low frequency fish
       % out.LoAmp = zeros(1, length(intube2lo));
            %tube 2    
            for j=1:length(intube2lo)
                out.los(intube2lo(j)).LoAmp = in(intube2lo(j)).e2loamp;
                out.los(intube2lo(j)).LoTim = in(intube2lo(j)).timcont/3600;
                out.los(intube2lo(j)).LOfreq(:) = [in(intube2lo(j)).lofreq];
            end
            %tube 1
            for j=1:length(intube1lo)
                out.los(intube1lo(j)).LoAmp = in(intube1lo(j)).e1loamp;
                out.los(intube1lo(j)).LoTim = in(intube1lo(j)).timcont/3600;
                out.los(intube1lo(j)).LOfreq(:) = [in(intube1lo(j)).lofreq];
            end 
            
            fields = fieldnames(out.his);
            fields
            out.his = rmfield(out.his, fields(structfun(@isempty, out.his)));
%% Plot fish against light/temp
figure(1); clf; 

    
    assx(1) = subplot(411); hold on; 
        plot([out.his.HiTim], [out.his.HiAmp], '.');
        plot([out.los.LoTim], [out.los.LoAmp], '.');

        legend('High frequency fish', 'Low frequency fish');
        
    assx(2) = subplot(412); hold on;
        plot([out.his.HiTim], [out.his.HIfreq], '.'); 
        plot([out.los.LoTim], [out.los.LOfreq], '.');
        
    
    assx(3) = subplot(413); hold on; 
            plot([in.timcont]/(60*60), [in.temp], '.');
    
    assx(4) = subplot(414); hold on;
        plot([in.timcont]/(60*60), [in.light]);
        ylim([-1, 6]);
        
linkaxes(assx, 'x');