function out = ritaCSVreader(filena)

    dat = csvread(filena, 3);

    out.fishx = dat(:,2);
    out.fishy = dat(:,3);
    out.shutx = dat(:,5);
    out.shuty = dat(:,6);

end