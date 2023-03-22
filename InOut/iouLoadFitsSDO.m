function outsource = iouLoadFitsSDO(fname, hdr_only)

if ~exist('hdr_only', 'var')
    hdr_only = false;
end

outsource = [];

info = fitsinfo(fname);
keys = {'NAXIS1', 'NAXIS2', 'DATE_OBS', 'TELESCOP', 'INSTRUME', 'WAVELNTH', 'CRPIX1', 'CRPIX2', ...
        'CRVAL1', 'CRVAL2', 'CDELT1', 'CDELT2', 'CROTA2', 'RSUN_OBS', 'T_OBS'};

[content, source] =  iouHMIFindContent(info, keys);
    
if (isempty(content))
    % error
    return
end

outsource =  (source);

outsource.DATA_P = source.CROTA2;
if (abs(source.CROTA2) > 90)
    source.CRPIX1 = source.NAXIS1 - source.CRPIX1 + 1;
    source.CRPIX2 = source.NAXIS2 - source.CRPIX2 + 1;
    outsource.DATA_P = outsource.DATA_P - sign(outsource.DATA_P)*180;
end

outsource.XSCALE = source.CDELT1;
outsource.YSCALE = source.CDELT2;
outsource.XCEN = (- source.CRPIX1 + (source.NAXIS1+1)/2) * source.CDELT1 + source.CRVAL1;
outsource.YCEN = (- source.CRPIX2 + (source.NAXIS2+1)/2) * source.CDELT2 + source.CRVAL2;
outsource.SOLAR_R = source.RSUN_OBS;
p = strfind(source.DATE_OBS, 'T');
outsource.OBS_DATE = source.DATE_OBS(1:p-1);
outsource.OBS_TIME = source.DATE_OBS(p+1:end);
outsource.ABS_TIME = srvGetAbsTime(outsource.OBS_DATE, outsource.OBS_TIME);

if hdr_only
    return
end

limit = -10000;

image = fitsread(fname, content);
image(image < limit) = NaN;
if (abs(source.CROTA2) > 90)
    image = image(size(image,1):-1:1, size(image,2):-1:1);
end

outsource.image = image;

end
