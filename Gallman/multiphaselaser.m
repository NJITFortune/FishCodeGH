


function multi(k) = k_multiphaselaser(k, expxpoint, kk, ReFs, light)

[hixx, loxx, HiAmp, HiTim, LoAmp, LoTim, Hifftyy, ~,  Lofftyy, ~, Hilighttimes, Lolighttimes] =  k_multifftsubspliner(kg2(kk), ReFs, light);



%twelve hour to four hour transistions
     %first transistion idx - expecting 12 dark, get 4
     xpoint1= expxpoint(1);
        twidx1 = find(hixx >= xpoint1 & hixx <= (xpoint1 + 48));
        twlightidx1 = find(Hilighttimes >= xpoint1 & Hilighttimes <= (xpoint1 + 48));
       
        
        multi(k).Hilighttimes1 = Hilighttimes(twlightidx1);
        multi(k).hixx1 = hixx(twidx1);
        multi(k).Hifftyy1 = Hifftyy(twidx1);
        multi(k).Lofftyy1 = Lofftyy(twidx1);
        multi(k).loxx1 = loxx(twidx1);
    
         
        %raw data for plotting/spline check
       
       hitimidx1 = find(HiTim >= xpoint1 & HiTim <= (xpoint1 + 48));
       lotimidx1 = find(LoTim >= xpoint1 & LoTim <= (xpoint1 + 48));
      
        multi(k).HiAmp = HiAmp;
        multi(k).HiAmp1 = HiAmp(hitimidx1);
        multi(k).LoAmp1 = LoAmp(lotimidx1);
        multi(k).LoAmp = LoAmp;
        multi(k).HiTim1 = HiTim(hitimidx1);
        multi(k).LoTim1 = LoTim(lotimidx1);
    
     %third transition - expecting 12 hours light, get 4
       xpoint2 = expxpoint(2);
       
        twidx2 = find(hixx >= xpoint2 & hixx <= (xpoint2 + 48));
        twlightidx2 = find(Hilighttimes >= xpoint2 & Hilighttimes <= (xpoint2 + 48));
       
        
        multi(k).Hilighttimes2 = Hilighttimes(twlightidx2);
        multi(k).hixx2 = hixx(twidx2);
        multi(k).Hifftyy2 = Hifftyy(twidx2);
        multi(k).Lofftyy2 = Lofftyy(twidx2);
        multi(k).loxx2 = loxx(twidx2);
    
         
        %raw data for plotting/spline check
       
       hitimidx2 = find(HiTim >= xpoint2 & HiTim <= (xpoint2 + 48));
       lotimidx2 = find(LoTim >= xpoint2 & LoTim <= (xpoint2 + 48));
      
      
        multi(k).HiAmp2 = HiAmp(hitimidx2);
        multi(k).LoAmp2 = LoAmp(lotimidx2);
  
        multi(k).HiTim2 = HiTim(hitimidx2);
        multi(k).LoTim2 = LoTim(lotimidx2);
    
   %four hour to twelve hour transitions 
     %second transition - expecting 4 of dark and get 12
     xpoint3 = expxpoint(3);
         twidx3 = find(hixx >= xpoint3 & hixx <= (xpoint3 + 48));
        twlightidx3 = find(Hilighttimes >= xpoint3 & Hilighttimes <= (xpoint3 + 48));
       
        
        multi(k).Hilighttimes3 = Hilighttimes(twlightidx3);
        multi(k).hixx3 = hixx(twidx3);
        multi(k).Hifftyy3 = Hifftyy(twidx3);
        multi(k).Lofftyy3 = Lofftyy(twidx3);
        multi(k).loxx3 = loxx(twidx3);
    
         
        %raw data for plotting/spline check
       
       hitimidx3 = find(HiTim >= xpoint3 & HiTim <= (xpoint3 + 48));
       lotimidx3 = find(LoTim >= xpoint3 & LoTim <= (xpoint3 + 48));
      
      
        multi(k).HiAmp3 = HiAmp(hitimidx3);
        multi(k).LoAmp3 = LoAmp(lotimidx3);
  
        multi(k).HiTim3 = HiTim(hitimidx3);
        multi(k).LoTim3 = LoTim(lotimidx3);
    
      %fourth transition - 4 hours to 12 hours
        %expecting 4 hours light and get 12
       xpoint4 = expxpoint(4);
         twidx4 = find(hixx >= xpoint4 & hixx <= (xpoint4 + 48));
        twlightidx4 = find(Hilighttimes >= xpoint4 & Hilighttimes <= (xpoint4 + 48));
       
        
        multi(k).Hilighttimes4 = Hilighttimes(twlightidx4);
        multi(k).hixx4 = hixx(twidx4);
        multi(k).Hifftyy4 = Hifftyy(twidx4);
        multi(k).Lofftyy4 = Lofftyy(twidx4);
        multi(k).loxx4 = loxx(twidx4);
    
         
        %raw data for plotting/spline check
       
       hitimidx4 = find(HiTim >= xpoint4 & HiTim <= (xpoint4 + 48));
       lotimidx4 = find(LoTim >= xpoint4 & LoTim <= (xpoint4 + 48));
      
      
        multi(k).HiAmp4 = HiAmp(hitimidx4);
        multi(k).LoAmp4 = LoAmp(lotimidx4);
  
        multi(k).HiTim4 = HiTim(hitimidx4);
        multi(k).LoTim4 = LoTim(lotimidx4);
     