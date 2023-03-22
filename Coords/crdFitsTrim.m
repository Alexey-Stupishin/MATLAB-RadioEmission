function [trimmap, hmlim, vmlim, trimindex] = crdFitsTrim(map, index, harc, varc, scale, outval)

if ~exist('scale', 'var')
    scale = 1;
end
if ~exist('outval', 'var')
    outval = 0;
end

instep = [index.CDELT1 index.CDELT2];
outstep = scale*instep;

hbox(1) = -index.CRPIX1*instep(1) - index.CRVAL1;
hbox(2) = hbox(1) + instep(1)*(size(map,2)-1);
vbox(1) = -index.CRPIX2*instep(2) - index.CRVAL2;
vbox(2) = vbox(1) + instep(2)*(size(map,1)-1);

nh = ceil((harc(2) - harc(1))/outstep(1));
nv = ceil((varc(2) - varc(1))/outstep(2));

hmlim = harc(1) + [0 outstep(1)*(nh-1)];
vmlim = varc(1) + [0 outstep(2)*(nv-1)];

hcrnew = -hmlim(1)/outstep(1);
vcrnew = -vmlim(1)/outstep(2);

if isempty(map)
    return
end

trimmap = zeros(nh, nv);

F = griddedInterpolant(map);

for kh = 1:nh
    for kv = 1:nv
        ph = (kh-1)*outstep(1) + hmlim(1);
        pv = (kv-1)*outstep(2) + vmlim(1);
        if ph < hbox(1) || ph > hbox(2) || pv < vbox(1) || pv > vbox(2)
            trimmap(kh, kv) = outval;
        else
            trimmap(kh, kv) = F((ph-hbox(1))/instep(1)+1, (pv-vbox(1))/instep(2)+1);
        end
    end
end

trimindex.CDELT1 = outstep(1);
trimindex.CDELT2 = outstep(2);
trimindex.CRPIX1 = hcrnew;
trimindex.CRPIX2 = vcrnew;
trimindex.CRVAL1 = 0;
trimindex.CRVAL2 = 0;

end
