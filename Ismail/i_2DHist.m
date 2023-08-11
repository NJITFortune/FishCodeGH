
velrange = -250:50:250;
accrange = -2500:500:2500;

for j=length(velrange):-1:2
    for k=length(accrange):-1:2

    respbin(j-1,k-1) = length(find(outdat.ev > velrange(j-1) & outdat.ev < velrange(j) & ...
        outdat.ea > accrange(k-1) & outdat.ea < accrange(k)) );

    stimbin(j-1,k-1) = length(find(curfish.error_vel > velrange(j-1) & curfish.error_vel < velrange(j) & ...
        curfish.error_acc > accrange(k-1) & curfish.error_acc < accrange(k)) );



    end
end
