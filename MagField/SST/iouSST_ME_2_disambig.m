function iouSST_ME_2_disambig(fname)

global mfrdata

load(fname);
iouSST3_to_disambig(B, index); % stored in global mfrdata
fout = [fname '.hmi'];
mfrdata.specification.filename = fout;
save(fout, '-struct', 'mfrdata');

end

