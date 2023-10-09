function out = reoParseDet(fname)

% M i j z h s      H        ^     cumTau[0]    cumTau[1]  ^      F[0]         k[00]        k[10]     ^      F[1]         k[11]        k[01]     ^      Hlow         Hhigh         Ht       
% ^      A[0]        Tau[0]     ^      A[1]        Tau[1]     ^       T            N            B           cos         kFFiso         U            V        ^^       n[0]      F[0]*f*f    ^^       n[1]      F[1]*f*f
% M  16  20  0 4 1 5.140920e+08 |t| 5.949881e-15 1.611045e-11 |R| 4.664369e-26 1.000000e+00 0.000000e+00 |L| 1.253107e-22 1.000000e+00 0.000000e+00 |H| 5.075000e+08 5.206839e+08 5.202719e+08 
% |o| 1.585536e-20 5.949881e-15 |e| 4.297902e-17 1.611045e-11 |p| 5.882821e+05 5.452147e+08 8.038778e+02 9.548004e-01 0.000000e+00 5.917012e-02 5.136217e-04 |mo| 9.997911e-01 0.000000e+00 |me| 9.996643e-01 0.000000e+00

out = [];
fid = fopen(fname, 'r');
s = fgetl(fid);
while ~feof(fid)
    s = fgetl(fid);
    res = textscan(s, '%s');
    f.i = str2double(res{1}{2});
    f.j = str2double(res{1}{3});
    f.zone = str2double(res{1}{4});
    f.harm = str2double(res{1}{5});
    f.sign = str2double(res{1}{6});
    f.H = str2double(res{1}{7});
    f.CumR = str2double(res{1}{9});
    f.CumL = str2double(res{1}{10});
    
    f.FR = str2double(res{1}{12});
    f.K00 = str2double(res{1}{13});
    f.K10 = str2double(res{1}{14});
    f.FL = str2double(res{1}{16});
    f.K11 = str2double(res{1}{17});
    f.K01 = str2double(res{1}{18});
    f.Hlow = str2double(res{1}{20});
    f.Hhigh = str2double(res{1}{21});
    f.Ht = str2double(res{1}{22});
    f.AR = str2double(res{1}{24});    
    f.TauR = str2double(res{1}{25});
    f.AL = str2double(res{1}{27});    
    f.TauL = str2double(res{1}{28});
    
    f.T = str2double(res{1}{30});
    f.D = str2double(res{1}{31});
    f.B = str2double(res{1}{32});
    f.cost = str2double(res{1}{33});
    f.KFF = str2double(res{1}{34});
    f.U = str2double(res{1}{35});
    f.V = str2double(res{1}{36});
    
    f.nR = str2double(res{1}{38});
    f.FF2R = str2double(res{1}{39});
    f.nL = str2double(res{1}{41});
    f.FF2L = str2double(res{1}{42});
    
    out = [out f];
end

fclose(fid);

end
