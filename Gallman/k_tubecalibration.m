function out = k_tubecalibration(tube, in, multiplier)

 out(tube).pkamp = in(tube).pkamp * multiplier;
 out(tube).obwamp =  in(tube).obwamp * multiplier;