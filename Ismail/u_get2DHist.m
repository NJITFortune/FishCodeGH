function respbin = u_get2DHist(EV, EA, velrange, accrange)

for j=length(velrange):-1:2
    for k=length(accrange):-1:2

        respbin(j-1, k-1) = length(find(EV > velrange(j-1) & EV < velrange(j) & ...
            EA > accrange(k-1) & EA < accrange(k)) );

    end
end