

function multi = k_multiphaselaser(expxpoint, kk, ReFs, light, kg2)

[hixx, loxx, HiAmp, HiTim, LoAmp, LoTim, Hifftyy, ~,  Lofftyy, ~, Hilighttimes, Lolighttimes] =  k_multifftsubspliner(kg2(kk), ReFs, light);



%twelve hour to four hour transistions
     %first transistion idx - expecting 12 dark, get 4
     xpoint1= expxpoint(1);
        twidx1 = find(hixx >= xpoint1 & hixx <= (xpoint1 + 48));
        twlightidx1 = find(Hilighttimes >= xpoint1 & Hilighttimes <= (xpoint1 + 48));
       
        
        multi.Hilighttimes1 = Hilighttimes(twlightidx1)-Hilighttimes(twlightidx1(1));
        multi.hixx1 = hixx(twidx1)-hixx(twidx1(1));
        multi.Hifftyy1 = Hifftyy(twidx1);
        multi.Lofftyy1 = Lofftyy(twidx1);
        multi.loxx1 = loxx(twidx1)-loxx(twidx1(1));
    
         
        %raw data for plotting/spline check
       
       hitimidx1 = find(HiTim >= xpoint1 & HiTim <= (xpoint1 + 48));
       lotimidx1 = find(LoTim >= xpoint1 & LoTim <= (xpoint1 + 48));
      
        multi.HiAmp = HiAmp;
        multi.HiAmp1 = HiAmp(hitimidx1);
        multi.LoAmp1 = LoAmp(lotimidx1);
        multi.LoAmp = LoAmp;
        multi.HiTim1 = HiTim(hitimidx1)-HiTim(hitimidx1(1));
        multi.LoTim1 = LoTim(lotimidx1)-LoTim(lotimidx1(1));
    
     %third transition - expecting 12 hours light, get 4
       xpoint2 = expxpoint(2);
       
        twidx2 = find(hixx >= xpoint2 & hixx <= (xpoint2 + 48));
        twlightidx2 = find(Hilighttimes >= xpoint2 & Hilighttimes <= (xpoint2 + 48));
       
        
        multi.Hilighttimes2 = Hilighttimes(twlightidx2)-Hilighttimes(twlightidx2(1));
        multi.hixx2 = hixx(twidx2)-hixx(twidx2(1));
        multi.Hifftyy2 = Hifftyy(twidx2);
        multi.Lofftyy2 = Lofftyy(twidx2);
        multi.loxx2 = loxx(twidx2)-loxx(twidx2(1));
    
         
        %raw data for plotting/spline check
       
       hitimidx2 = find(HiTim >= xpoint2 & HiTim <= (xpoint2 + 48));
       lotimidx2 = find(LoTim >= xpoint2 & LoTim <= (xpoint2 + 48));
      
      
        multi.HiAmp2 = HiAmp(hitimidx2);
        multi.LoAmp2 = LoAmp(lotimidx2);
  
        multi.HiTim2 = HiTim(hitimidx2)-HiTim(hitimidx2(1));
        multi.LoTim2 = LoTim(lotimidx2)-LoTim(lotimidx2(1));
    
   %four hour to twelve hour transitions 
     %second transition - expecting 4 of dark and get 12
     xpoint3 = expxpoint(3);
         twidx3 = find(hixx >= xpoint3 & hixx <= (xpoint3 + 48));
        twlightidx3 = find(Hilighttimes >= xpoint3 & Hilighttimes <= (xpoint3 + 48));
       
        
        multi.Hilighttimes3 = Hilighttimes(twlightidx3)-Hilighttimes(twlightidx3(1));
        multi.hixx3 = hixx(twidx3)-hixx(twidx3(1));
        multi.Hifftyy3 = Hifftyy(twidx3);
        multi.Lofftyy3 = Lofftyy(twidx3);
        multi.loxx3 = loxx(twidx3)-loxx(twidx3(1));
    
         
        %raw data for plotting/spline check
       
       hitimidx3 = find(HiTim >= xpoint3 & HiTim <= (xpoint3 + 48));
       lotimidx3 = find(LoTim >= xpoint3 & LoTim <= (xpoint3 + 48));
      
      
        multi.HiAmp3 = HiAmp(hitimidx3);
        multi.LoAmp3 = LoAmp(lotimidx3);
  
        multi.HiTim3 = HiTim(hitimidx3)-HiTim(hitimidx3(1));
        multi.LoTim3 = LoTim(lotimidx3)-LoTim(lotimidx3(1));
    
      %fourth transition - 4 hours to 12 hours
        %expecting 4 hours light and get 12
       xpoint4 = expxpoint(4);
         twidx4 = find(hixx >= xpoint4 & hixx <= (xpoint4 + 48));
        twlightidx4 = find(Hilighttimes >= xpoint4 & Hilighttimes <= (xpoint4 + 48));
       
        
        multi.Hilighttimes4 = Hilighttimes(twlightidx4)-Hilighttimes(twlightidx4(1));
        multi.hixx4 = hixx(twidx4)-hixx(twidx4(1));
        multi.Hifftyy4 = Hifftyy(twidx4);
        multi.Lofftyy4 = Lofftyy(twidx4);
        multi.loxx4 = loxx(twidx4)-loxx(twidx4(1));
    
         
        %raw data for plotting/spline check
       
       hitimidx4 = find(HiTim >= xpoint4 & HiTim <= (xpoint4 + 48));
       lotimidx4 = find(LoTim >= xpoint4 & LoTim <= (xpoint4 + 48));
      
      
        multi.HiAmp4 = HiAmp(hitimidx4);
        multi.LoAmp4 = LoAmp(lotimidx4);
  
        multi.HiTim4 = HiTim(hitimidx4)-HiTim(hitimidx4(1));
        multi.LoTim4 = LoTim(lotimidx4)-LoTim(lotimidx4(1));
     