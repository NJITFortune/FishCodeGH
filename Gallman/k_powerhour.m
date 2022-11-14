function k_powerhour(in)

ReFs = 20;
channel = 1;


in = l24kg(66);




[regtim, regfreq, regtemp, regobwpeaks] = k_datatrimmean(in, channel, ReFs);
lighttimes = k_lighttimes(in, 3);