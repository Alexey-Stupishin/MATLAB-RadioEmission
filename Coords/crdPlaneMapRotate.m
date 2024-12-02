function [outmap, hmlim, vmlim, hcrnew, vcrnew] = crdPlaneMapRotate(map, instep, angle, outstep, hcrpix, vcrpix, hcrval, vcrval, outval, intMeth, extMeth)
% angle - ccw
% steps = [h, v]

outmap = [];

if length(instep) == 1
    instep = [instep instep];
end
if ~exist('outstep', 'var') || isempty(outstep)
    outstep = instep;
end
if length(outstep) == 1
    outstep = [outstep outstep];
end

if ~exist('hcrpix', 'var') || isempty(hcrpix)
    hcrpix = (size(map,2)+1)/2;
end
if ~exist('vcrpix', 'var') || isempty(vcrpix)
    vcrpix = (size(map,1)+1)/2;
end
if ~exist('hcrval', 'var') || isempty(hcrval)
    hcrval = 0;
end
if ~exist('vcrval', 'var') || isempty(vcrval)
    vcrval = 0;
end
if ~exist('outval', 'var') || isempty(outval)
    outval = 0;
end
if ~exist('intMeth', 'var')
    intMeth = 'nearest';
end
if ~exist('extMeth', 'var')
    extMeth = 'none';
end

hbox(1) = -(hcrpix-1)*instep(1) - hcrval;
hbox(2) =  (hcrpix-1)*instep(1) - hcrval;
vbox(1) = -(vcrpix-1)*instep(2) - vcrval;
vbox(2) =  (vcrpix-1)*instep(2) - vcrval;



sp = sind(angle);
cp = cosd(angle);

hm = zeros(2, 2);
vm = zeros(2, 2);

for kh = 1:2
    for kv = 1:2
        hm(kh, kv) =   hbox(kh)*cp + vbox(kv)*sp;
        vm(kh, kv) = - hbox(kh)*sp + vbox(kv)*cp;
    end
end

hmlim = [xmin2(hm) xmax2(hm)];
vmlim = [xmin2(vm) xmax2(vm)];

nh = ceil((hmlim(2) - hmlim(1))/outstep(1));
nv = ceil((vmlim(2) - vmlim(1))/outstep(2));

hmlim(2) = hmlim(1) + (nh-1)*outstep(1);
vmlim(2) = vmlim(1) + (nv-1)*outstep(2);

hcrnew = -hmlim(1)/outstep(1);
vcrnew = -vmlim(1)/outstep(2);

if isempty(map)
    return
end

outmap = zeros(nh, nv);

F = griddedInterpolant(map, intMeth, extMeth);

for kh = 1:nh
    for kv = 1:nv
        ph = (kh-1)*outstep(1) + hmlim(1);
        pv = (kv-1)*outstep(2) + vmlim(1);
        % rotate back
        hb = (ph*cp - pv*sp);
        vb = (ph*sp + pv*cp);
        if hb < hbox(1) || hb > hbox(2) || vb < vbox(1) || vb > vbox(2)
            outmap(kv, kh) = outval;
        else
            outmap(kv, kh) = F((vb-vbox(1))/instep(2)+1, (hb-hbox(1))/instep(1)+1);
        end
    end
end

end
