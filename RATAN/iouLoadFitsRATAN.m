function [outsource, im] = iouLoadFitsRATAN(fname, hdr_only, f_recal, d_recal)

im = [];

info = fitsinfo(fname);

if ~exist('hdr_only', 'var')
    hdr_only = false;
end

% SIMPLE  =                    T / Written by TFitsHdr (GVI 2005)                 
% BITPIX  =                  -32 /                                                
% EXTEND  =                    T / FITS data may contain extensions               
% NAXIS   =                    3 /                                                
% NAXIS1  =                 2833 /                                                
% NAXIS2  =                    2 /                                                
% NAXIS3  =                   95 /                                                
% DATANAME= 'newpas  '           /                                                
% TELESCOP= 'RATAN-600'          /                                                
% ORIGIN  = 'PAS-120 '           /                                                
% DATE-OBS= '2012/01/01'         /                                                %
% TIME-OBS= '08:50:47.700'       /                                                
% STARTOBS=           1325407553 /                                                
% STOPOBS =           1325408148 /                                                
% NSAMPLES=                84998 / NAXIS1 = (NSAMPLES + lostpixs)/SMOOTH          
% LOSTPIXS=                    3 /                                                
% SMOOTH  =                   30 /                                                
% ARMSMOOT=                    1 /                                                
% ARMDT   =             0.007000 /                                                
% CRPIX1  =          1432.164795 /                                                
% CDELT1  =   2.894874622768E+00 / arcsec                                         
% FLAG_IV =                    1 / 1- data is RL; 0- data is IV                   
% CALIBR  =                    1 /                                                
% COMMENT   *** Object parameters ***                                             
% OBJECT  = 'sun     '           /                                                
% AZIMUTH =             6.000000 /                                                
% ALTITUDE=            23.043444 /                                                
% SOL_DEC =           -23.037001 /                                                
% SOL_RA  =            18.749001 /                                                
% SOLAR_R =           975.929993 / arcsec                                         
% SOLAR_P =             2.200000 /                                                
% SOLAR_B =            -3.000000 /                                                
% SOL_VALH=             1.230000 /                                                
% COMMENT   *** Frequencies ***                                                   
% FREQ001 =             0.758800 / GHz                      

keys = {'NAXIS1', 'NAXIS2', 'NAXIS3', 'DATE-OBS', 'TIME-OBS', 'TELESCOP', 'ORIGIN', ...
        'CRPIX1', 'CDELT1', 'FLAG_IV', ...
        'AZIMUTH', 'ALTITUDE', 'SOL_DEC', 'SOL_RA', 'SOLAR_R', 'SOLAR_P', 'SOLAR_B', ...
        };

for k = 1:length(keys)
    idx = find(strcmp(keys{k}, info.PrimaryData.Keywords(:, 1)));
    name = strrep(keys{k}, '-', '_');
    source.(name) = info.PrimaryData.Keywords{idx, 2};
end

outsource = iouGetDataStructRoot(source);    
outsource.INSTRUME  =source.ORIGIN;
outsource.AZIMUTH   = source.AZIMUTH;
outsource.ALTITUDE  = source.ALTITUDE;
outsource.NAXIS1  = source.NAXIS1;
outsource.SOL_DEC   = source.SOL_DEC;
outsource.SOL_RA    = source.SOL_RA;
outsource.SOLAR_R   = source.SOLAR_R;
outsource.SOLAR_P   = source.SOLAR_P;
outsource.SOLAR_B   = source.SOLAR_B;
outsource.DATA_P    = source.SOLAR_P;
outsource.DATA_B    = source.SOLAR_B;

outsource.OBS_DATE = strrep(source.DATE_OBS, '/', '-');
outsource.OBS_TIME = source.TIME_OBS;
outsource.ABS_TIME = srvGetAbsTime(outsource.OBS_DATE, outsource.OBS_TIME);

if hdr_only
    return
end

s = fitsread(fname);
set1 = permute(s(1, :, :), [3 2 1]);
set2 = permute(s(2, :, :), [3 2 1]);

sext = fitsread(fname, 'bintable');
%     'TTYPE1'      'DATE'           ''                                                                        
%     'TTYPE2'      'TIME'           ''                                                                        
%     'TTYPE3'      'OBJECT'         ''                                                                        
%     'TTYPE4'      'FREQ'           ''                                                                        
%     'TTYPE5'      'CDELT'          ''                                                                        
%     'TTYPE6'      'CRPIX'          ''                                                                        
%     'TTYPE7'      'TQSUN'          ''                                                                        
%     'TTYPE8'      'THETA'          ''                                                                        
%     'TTYPE9'      'KFLUX'          ''                                                                        
%     'TTYPE10'     'SOLAR_B'        ''                                                                        
%     'TTYPE11'     'SOLAR_P'        ''                                                                        
%     'TTYPE12'     'SOLAR_R'        ''                                                                        
%     'TTYPE13'     'AZIMUTH'        ''                                                                        
%     'TTYPE14'     'ALTITUDE'       ''                                                                        
%     'TTYPE15'     'FIV'            ''                                                                        
%     'TTYPE16'     'FCALIBR'        ''                                                                        

freqs = sext{4};
cdelt = sext{5};
crpix = sext{6};
tqsun = sext{7};
diagr = sext{8};
kflux = sext{9};
flag_IV = sext{15};
for k = 1:size(set1, 1)
    if (flag_IV(k) == 1)
        st = set1(k, :) - set2(k, :);
        set1(k, :) = set1(k, :) + set2(k, :);
        set2(k, :) = st;
    end
end

outsource.Freqs = [];
for k = 1:size(set1, 1)
    f.freq = freqs(k);
    s = set1(k, :);
    f.I = s;
    f.V = set2(k, :);
    f.XSCALE = cdelt(k);
    f.XCEN = ((length(s)+1)/2 - crpix(k)) * f.XSCALE;
    f.crpix = crpix(k);
    f.tqsun = tqsun(k);
    f.diagr = diagr(k);
    f.kflux = kflux(k);
    
    tlim = f.tqsun/3;
    %disp(['k=' num2str(k) ' freq=' num2str(f.freq) ' min_s=' num2str(min(s)) ' max_s=' num2str(max(s)) ' tqsun=' num2str(f.tqsun)])
    s(s > tlim) = tlim;
    w = conv(s, s, 'same');
    [~, idx] = max(w);
    f.XCENQ = ((length(s)+1)/2 - idx) * f.XSCALE;
    
    outsource.Freqs = [outsource.Freqs f];
end

if exist('f_recal', 'var') && exist('d_recal', 'var')
    [outsource, im] = rtnRecalibration(outsource, f_recal, d_recal);
end

outsource.XSCALE = outsource.Freqs(1).XSCALE;
outsource.XCEN = outsource.Freqs(1).XCEN;

end
