e
function one = k_phaselaser(expidx, expxpoint, channel, ReFs, light, kg)
clear k;
 %get the spline estimates for each sample
        for k = 1:length(expidx)
    
       
        [one(k).xx, one(k).fftyy, one(k).lighttimes] =  k_fftsubspliner(kg(expidx(k)), channel, ReFs, light, 0.9);
  

  %twelve hour to four hour transistions
     %first transistion idx - expecting 12 dark, get 4
     xpoint1= expxpoint(1);
        twidx1 = find(one(k).xx >= xpoint1 & one(k).xx <= (xpoint1 + 48));
        twlightidx1 = find(one(k).lighttimes >= xpoint1 & one(k).lighttimes <= (xpoint1 + 48));
       
        
        one(k).lighttimes1 = one(k).lighttimes(twlightidx1)-one(k).lighttimes(twlightidx1(1));
        one(k).xx1 = one(k).xx(twidx1)-one(k).xx(twidx1(1));
        one(k).fftyy1 = one(k).fftyy(twidx1);
    
         
        %raw data for plotting/spline check
        one(k).timcont = [kg(expidx(k)).e(1).s.timcont]/3600;  
        timcontidx = find(one(k).timcont >= one(k).lighttimes(3) & one(k).timcont <= (one(k).lighttimes(3) + 48));
        one(k).timcont1 = one(k).timcont(timcontidx) - one(k).timcont(timcontidx(1));
        one(k).fft = [kg(expidx(k)).e(1).s.sumfftAmp];
        one(k).fft1 = one(k).fft(timcontidx);
    
    
     %third transition - expecting 12 hours light, get 4
       xpoint2 = expxpoint(2);
        twidx2 = find(one(k).xx >= xpoint2 & one(k).xx <= (xpoint2 + 48));
        twlightidx2 = find(one(k).lighttimes >= xpoint2 & one(k).lighttimes <= (xpoint2 + 48));
        timcontidx2 = find(one(k).timcont >= xpoint2 & one(k).timcont <= (xpoint2 + 48));
        
        %spline
        one(k).lighttimes2 = one(k).lighttimes(twlightidx2) - one(k).lighttimes(twlightidx2(1));
        one(k).xx2 = one(k).xx(twidx2)-one(k).xx(twidx2(1));
        one(k).fftyy2 = one(k).fftyy(twidx2);
        
    
        %raw data for plotting/spline check
        one(k).timcont2 = one(k).timcont(timcontidx2)-one(k).timcont(timcontidx2(1));
        one(k).fft2 = one(k).fft(timcontidx2);
    
   %four hour to twelve hour transitions 
     %second transition - expecting 4 of dark and get 12
     xpoint3 = expxpoint(3);
        twidx3 = find(one(k).xx >= xpoint3 & one(k).xx <= (xpoint3 + 48));
        twlightidx3 = find(one(k).lighttimes >= xpoint3 & one(k).lighttimes <= (xpoint3 + 48));
        timcontidx3 = find(one(k).timcont >= xpoint3 & one(k).timcont <= (xpoint3 + 48));
    
        %spline
        one(k).lighttimes3 = one(k).lighttimes(twlightidx3)-one(k).lighttimes(twlightidx3(1));
        one(k).xx3 = one(k).xx(twidx3)-one(k).xx(twidx3(1));
        one(k).fftyy3 = one(k).fftyy(twidx3);
        
    
        %raw data for plotting/spline check
        one(k).timcont3 = one(k).timcont(timcontidx3)-one(k).timcont(timcontidx3(1));
        one(k).fft3 = one(k).fft(timcontidx3);
    
      %fourth transition - 4 hours to 12 hours
        %expecting 4 hours light and get 12
       xpoint4 = expxpoint(4);
        twidx4 = find(one(k).xx >= xpoint4 & one(k).xx <= (xpoint4 + 48));
        twlightidx4 = find(one(k).lighttimes >= xpoint4 & one(k).lighttimes <= (xpoint4 + 48));
        timcontidx4 = find(one(k).timcont >= xpoint4 & one(k).timcont <= (xpoint4 + 48));
    
        %spline
        one(k).lighttimes4 = one(k).lighttimes(twlightidx4)-one(k).lighttimes(twlightidx4(1));
        one(k).xx4 = one(k).xx(twidx4)-one(k).xx(twidx4(1));
        one(k).fftyy4 = one(k).fftyy(twidx4);
        
    
        %raw data for plotting/spline check
        one(k).timcont4 = one(k).timcont(timcontidx4)-one(k).timcont(timcontidx4(1));
        one(k).fft4 = one(k).fft(timcontidx4);
    
        end
