function [outmap, hmlim, vmlim, hcrnew, vcrnew] = crdPlaneMapRotate(map, instep, angle, outstep, hcrpix, vcrpix, hcrval, vcrval, outval)
% angle - ccw
% steps = [h, v]

outmap = [];

if length(instep) == 1
    instep = [instep instep];
end
if ~exist('outstep', 'var')
    outstep = instep;
end
if length(outstep) == 1
    outstep = [outstep outstep];
end

if ~exist('hcrpix', 'var') || isempty(hcrpix)
    hcrpix = (size(map,2)-1)/2;
end
if ~exist('vcrpix', 'var') || isempty(vcrpix)
    vcrpix = (size(map,1)-1)/2;
end
if ~exist('hcrval', 'var') || isempty(hcrval)
    hcrval = 0;
end
if ~exist('vcrval', 'var') || isempty(vcrval)
    vcrval = 0;
end
if ~exist('outval', 'var')
    outval = 0;
end

hbox(1) = -hcrpix*instep(1) - hcrval;
hbox(2) = hbox(1) + instep(1)*(size(map,2)-1);
vbox(1) = -vcrpix*instep(2) - vcrval;
vbox(2) = vbox(1) + instep(2)*(size(map,1)-1);

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

F = griddedInterpolant(map);

for kh = 1:nh
    for kv = 1:nv
        ph = (kh-1)*outstep(1) + hmlim(1);
        pv = (kv-1)*outstep(2) + vmlim(1);
        % rotate back
        hb = (ph*cp - pv*sp);
        vb = (ph*sp + pv*cp);
        if hb < hbox(1) || hb > hbox(2) || vb < vbox(1) || vb > vbox(2)
            outmap(kh, kv) = outval;
        else
            outmap(kh, kv) = F((hb-hbox(1))/instep(1)+1, (vb-vbox(1))/instep(2)+1);
        end
    end
end

end
