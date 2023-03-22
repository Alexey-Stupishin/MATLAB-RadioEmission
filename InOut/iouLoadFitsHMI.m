function [outsource, original] = iouLoadFitsHMI(fnameBase)

ffield = [fnameBase '.field.fits'];
fincl = [fnameBase '.inclination.fits'];
fazim = [fnameBase '.azimuth.fits'];
fdisamb = [fnameBase '.disambig.fits'];

outsource = [];

% NAXIS   =                    2 / number of data axes                            
% NAXIS1  =                 4096 / length of data axis 1                          
% NAXIS2  =                 4096 / length of data axis 2                          

% DATE-OBS= '2012-01-01T06:58:10.30'                                              
% DATE_OBS= !!! NB !!!
% TELESCOP= 'SDO/HMI'                                                             
% INSTRUME= 'HMI_SIDE1'                                                           

% CRPIX1  = 2038.896362                                                           
% CRPIX2  = 2046.721313                                                           
% CRVAL1  = 0.000000                                                              
% CRVAL2  = 0.000000                                                              
% CDELT1  = 0.504271                                                              
% CDELT2  = 0.504271                                                              
% CROTA2  = 180.082626                                                            
% 
% RSUN_OBS= 975.739380                                                            
% T_OBS   = '2012.01.01_06:59:52_TAI'                                             
% 
% BZERO   =                   0.                                                  
% BSCALE  =                 0.01                                                  

info = fitsinfo(ffield);
% 4 blocks for main header

%'DATE-OBS' ???
%'BZERO', 'BSCALE' ???
keys = {'NAXIS1', 'NAXIS2', 'DATE_OBS', 'TELESCOP', 'INSTRUME', 'CRPIX1', 'CRPIX2', ...
        'CRVAL1', 'CRVAL2', 'CDELT1', 'CDELT2', 'CROTA2', 'RSUN_OBS', 'T_OBS'};

[content, source] =  iouHMIFindContent(info, keys);
    
if (isempty(content))
    % error
    return
end

% for k = 1:length(keys)
%     idx = find(strcmp(keys{k}, info.PrimaryData.Keywords(:, 1)));
%     name = strrep(keys{k}, '-', '_');
%     source.(name) = info.PrimaryData.Keywords{idx, 2};
% end

limit = -10000;

outsource = iouGetDataStructRoot(source);    
original.absB = fitsread(ffield, content);
outsource.data.absB = original.absB;
outsource.data.absB(outsource.data.absB < limit) = NaN;

info = fitsinfo(fincl);
content =  iouHMIFindContent(info, keys);
original.incl = fitsread(fincl, content);
outsource.data.incl = original.incl;
outsource.data.incl(outsource.data.incl < limit) = NaN;

info = fitsinfo(fazim);
content =  iouHMIFindContent(info, keys);
original.azim = fitsread(fazim, content);
outsource.data.azim = original.azim;
outsource.data.azim(outsource.data.azim < limit) = NaN;

if exist(fdisamb, 'file') == 2
    infoda = fitsinfo(fdisamb);
    content =  iouHMIFindContent(infoda, keys);
    original.disambig = fitsread(fdisamb, content);
    outsource.data.disambig = double(original.disambig);
end

fdx = [fnameBase '.alpha_err.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.alpha_err = fitsread(fdx, content);
end
fdx = [fnameBase '.alpha_mag.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.alpha_mag = fitsread(fdx, content);
end
fdx = [fnameBase '.azimuth_alpha_err.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.azimuth_alpha_err = fitsread(fdx, content);
end
fdx = [fnameBase '.azimuth_err.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.azimuth_err = fitsread(fdx, content);
end
fdx = [fnameBase '.chisq.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.chisq = fitsread(fdx, content);
end
fdx = [fnameBase '.conf_disambig.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.conf_disambig = fitsread(fdx, content);
end
fdx = [fnameBase '.confid_map.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.confid_map = fitsread(fdx, content);
end
fdx = [fnameBase '.conv_flag.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.conv_flag = fitsread(fdx, content);
end
fdx = [fnameBase '.damping.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.damping = fitsread(fdx, content);
end
fdx = [fnameBase '.dop_width.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.dop_width = fitsread(fdx, content);
end
fdx = [fnameBase '.eta_0.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.eta_0 = fitsread(fdx, content);
end
fdx = [fnameBase '.field_alpha_err.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.field_alpha_err = fitsread(fdx, content);
end
fdx = [fnameBase '.field_az_err.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.field_az_err = fitsread(fdx, content);
end
fdx = [fnameBase '.field_inclination_err.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.field_inclination_err = fitsread(fdx, content);
end
fdx = [fnameBase '.inclination_alpha_err.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.inclination_alpha_err = fitsread(fdx, content);
end
fdx = [fnameBase '.inclination_err.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.inclination_err = fitsread(fdx, content);
end
fdx = [fnameBase '.info_map.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.info_map = fitsread(fdx, content);
end
fdx = [fnameBase '.src_continuum.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.src_continuum = fitsread(fdx, content);
end
fdx = [fnameBase '.src_grad.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.src_grad = fitsread(fdx, content);
end
fdx = [fnameBase '.vlos_err.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.vlos_err = fitsread(fdx, content);
end
fdx = [fnameBase '.vlos_mag.fits'];
if exist(fdx, 'file') == 2
    infox = fitsinfo(fdx);
    content =  iouHMIFindContent(infox, keys);
    original.vlos_mag = fitsread(fdx, content);
end


outsource.DATA_P = source.CROTA2;
if (abs(outsource.DATA_P) > 90)
    outsource.data.absB = outsource.data.absB(size(outsource.data.absB,1):-1:1, size(outsource.data.absB,2):-1:1);
    outsource.data.incl = outsource.data.incl(size(outsource.data.incl,1):-1:1, size(outsource.data.incl,2):-1:1);
    outsource.data.azim = 180 - outsource.data.azim(size(outsource.data.azim,1):-1:1, size(outsource.data.azim,2):-1:1);
    if isfield(outsource.data, 'disambig')
        outsource.data.disambig = outsource.data.disambig(size(outsource.data.disambig,1):-1:1, size(outsource.data.disambig,2):-1:1);
    end
    source.CRPIX1 = source.NAXIS1 - source.CRPIX1 + 1;
    source.CRPIX2 = source.NAXIS2 - source.CRPIX2 + 1;
    outsource.DATA_P = outsource.DATA_P - sign(outsource.DATA_P)*180;
end

outsource.XSCALE = source.CDELT1;
outsource.YSCALE = source.CDELT2;
% outsource.XCEN = ((size(outsource.data.absB, 2)+1)/2 - source.CRPIX1) * outsource.XSCALE;
% outsource.YCEN = ((size(outsource.data.absB, 1)+1)/2 - source.CRPIX2) * outsource.YSCALE;
outsource.XCEN = (- source.CRPIX1 + (size(outsource.data.absB, 2)+1)/2) * source.CDELT1 + source.CRVAL1;
outsource.YCEN = (- source.CRPIX2 + (size(outsource.data.absB, 1)+1)/2) * source.CDELT2 + source.CRVAL2;
outsource.SOLAR_R = source.RSUN_OBS;
p = strfind(source.DATE_OBS, 'T');
outsource.OBS_DATE = source.DATE_OBS(1:p-1);
outsource.OBS_TIME = source.DATE_OBS(p+1:end);
outsource.ABS_TIME = srvGetAbsTime(outsource.OBS_DATE, outsource.OBS_TIME);

end
