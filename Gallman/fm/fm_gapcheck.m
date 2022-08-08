function gapidx = fm_gapcheck(in)
%in = fm(k).s
%in = dualfm(k).s

for i = 1:length(in) 

    %get filenumber from file name
    strfilename = char(in(i).filename);
    %get the indicies where there is a number in the name
    numsinnameidx = find(isstrprop(strfilename, 'digit'));

    %find the second time there is a space between number sequences 
    spaceidx = find(diff(numsinnameidx) == 2);
    numstart = numsinnameidx(spaceidx(2)+1);

    strfilenum = strfilename(numstart:numstart+3);
    idx = find(isstrprop(strfilenum, 'digit'));
    strnum = strfilenum(idx);
    filenum(i,:) = str2num(strnum);


end


gapidx = find(diff(filenum)>1);
gapidx = gapidx+1;