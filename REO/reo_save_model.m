function reo_save_model(Hcalc, Tcalc, Dcalc)

fid = fopen('c:\temp\11312_5e15.dat', 'w');

for k = 1:length(Hcalc)
    fprintf(fid, '%d %d %d\r\n', Hcalc(k), Tcalc(k), Dcalc(k));
end

fclose(fid);

% iouData2SAV('c:\temp\11312_2.sav', 'Hcalc', 'Tcalc', 'Dcalc')

end
