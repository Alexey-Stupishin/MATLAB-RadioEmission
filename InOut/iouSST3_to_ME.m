function [ME, index] = iouSST3_to_ME(file_pattern, saveit)

pos = strfind(file_pattern, '*');
ffield = [file_pattern(1:pos-1) 'BTOT' file_pattern(pos+1:end)];
fincl = [file_pattern(1:pos-1) 'BINC' file_pattern(pos+1:end)];
fazim = [file_pattern(1:pos-1) 'BAZI' file_pattern(pos+1:end)];

info = fitsinfo(ffield);
index.cdelt1 = iouFitsInfoKey(info, 'CDELT1');
index.cdelt2 = iouFitsInfoKey(info, 'CDELT2');
index.crval1 = iouFitsInfoKey(info, 'CRVAL1');
index.crval2 = iouFitsInfoKey(info, 'CRVAL2');
index.crpix1 = iouFitsInfoKey(info, 'CRPIX1');
index.crpix2 = iouFitsInfoKey(info, 'CRPIX2');
index.date_obs = iouFitsInfoKey(info, 'DATE_OBS');
index.telescope = iouFitsInfoKey(info, 'TELESCOP');

ME.absB = fitsread(ffield);
ME.incl = fitsread(fincl)*180/pi;
ME.azim = 180 - fitsread(fazim)*180/pi;

% %---------------------------------------
% bt = ME.absB .* sind(ME.incl);
% bv =  bt .* cosd(ME.azim);
% bh =  bt .* sind(ME.azim);
% %---------------------------------------

% %---------------------------------------
% d=iouBIN2Data('g:\BIGData\Work\ISSI\Work\Disambig\SFQ\sfq_results.sav_left.bin');
% % x = 70:79;
% % y = 42:51;
% x = 141:150;
% y = 48:57;
% xx = x + 499;
% yy = y + 238;
% as = atan2d(d.BX(x,y), d.BY(x,y));
% as(as < 0) = as(as < 0) + 180;
% %---------------------------------------

% azim = ME.azim;
% azim(ME.azim > 90) = ME.azim(ME.azim > 90) - 90;
% azim(ME.azim < 90) = ME.azim(ME.azim < 90) + 90;
% ME.azim = azim;

sz = size(ME.absB);

info = fitsinfo(ffield);
index.naxis1 = sz(2);
index.naxis2 = sz(1);
index.cdelt1 = iouFitsInfoKey(info, 'CDELT1');
index.cdelt2 = iouFitsInfoKey(info, 'CDELT2');
index.crval1 = iouFitsInfoKey(info, 'CRVAL1');
index.crval2 = iouFitsInfoKey(info, 'CRVAL2');
index.crpix1 = iouFitsInfoKey(info, 'CRPIX1');
index.crpix2 = iouFitsInfoKey(info, 'CRPIX2');
index.date_obs = iouFitsInfoKey(info, 'DATE_OBS');
index.telescope = iouFitsInfoKey(info, 'TELESCOP');
index.wave = iouFitsInfoKey(info, 'WAVE');
index.wcs = iouFitsInfoKey(info, 'WCSNAME');

if exist('saveit', 'var') && saveit
   foutname = [file_pattern(1:pos-1) 'SST' file_pattern(pos+1:end) '.mat'];
   save(foutname, 'ME', 'index');
end

end
