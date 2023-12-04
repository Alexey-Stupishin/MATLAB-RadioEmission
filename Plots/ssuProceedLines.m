function [hAxp, hAxa, hAxv, xset, yset] = ssuProceedLines(hLib, mfoData, par, WOLines)

hAxp = [];
hAxa = [];
hAxv = [];
xset = [];
yset = [];

limpix = par.limharm/750/mfoData.step(3);
Bc2 = f2b_(par.freq, 2);
Bc3 = f2b_(par.freq, 3);

BB = fpuFieldVal(mfoData.B);
szb = size(BB);

ps = get(groot, 'ScreenSize');
h2ws = ps(4)/ps(3);

BB = fpuFieldVal(mfoData.B);
BB1 = mfoData.B.z(:, :, 1);
w2h = size(mfoData.B.z, 2) / size(mfoData.B.z, 1)*1.2;
figure('Units', 'normalized', 'OuterPosition', [0.02, 0, h2ws*w2h, 1]);
set(gca, 'DataAspectRatio', [1 1 mfoData.step(3)]);
[~, cb] = ssuImage(gca, BB1, mfoData.step); hold on
cb.Label.String = 'B_z, G';
hAxp = gca;
drawnow

if isfield(par, 'limVarc')
    par.limV = min(szb(1), max(1, round(par.limVarc/mfoData.step(1)+1)));
end
if isfield(par, 'limHarc')
    par.limH = min(szb(2), max(1, round(par.limHarc/mfoData.step(2)+1)));
end

if par.useinterp
    hAxa = [];
    if ~isempty(mfoData.AIA)
        aiaData = mfoData.AIA.data(:, :, par.aiaN);
        aiaSize = double(mfoData.AIA.size(:, par.aiaN));
        aiaCent = mfoData.AIA.center(:, par.aiaN);
        aiaStep = mfoData.AIA.step(:, par.aiaN)';
        aiax0 = aiaCent(1) - (aiaSize(1)-1)/2*aiaStep(1);
        aiay0 = aiaCent(2) - (aiaSize(2)-1)/2*aiaStep(2);
        aiaOff = [aiax0 aiay0];
        aiaMap = iouSAV2Data('s:\Projects\Matlab\MatlabUtils\Plots\Colormaps\aiaMaps\aia171.sav');
        cm.cmap = zeros(length(aiaMap.RED), 3);
        cm.cmap(:, 1) = double(aiaMap.RED)/256;
        cm.cmap(:, 2) = double(aiaMap.GREEN)/256;
        cm.cmap(:, 3) = double(aiaMap.BLUE)/256;
        cm.cmap = cm.cmap.^0.45;
        cm.nandata = 0;
        w2h = size(aiaData, 2) / size(aiaData, 1)*1.2;
        figure('Units', 'normalized', 'OuterPosition', [0.04, 0, h2ws*w2h, 1]);
        ssuImage(gca, aiaData, aiaStep, aiaOff, cm, false, false); hold on
        hAxa = gca;
        drawnow
    end

    hAxv = [];
    if isfield(mfoData, 'x_box') && ~isempty(mfoData.x_box)
        rstep = par.visstep/mfoData.R;
        xx = reshape(mfoData.x_box, [numel(mfoData.x_box) 1]);
        yy = reshape(mfoData.y_box, [numel(mfoData.y_box) 1]);
        zz = reshape(mfoData.B.z(:,:,1), [numel(mfoData.B.z(:,:,1)) 1]);
        F = scatteredInterpolant(xx, yy, zz, 'linear', 'none');
        xset = xmin2(mfoData.x_box):rstep:xmax2(mfoData.x_box);
        yset = xmin2(mfoData.y_box):rstep:xmax2(mfoData.y_box);
        result = zeros(length(xset), length(yset));
        for kx = 1:length(xset)
            for ky = 1:length(yset)
                result(kx, ky) = F(xset(kx), yset(ky));
            end
        end
        w2h = size(result, 2) / size(result, 1)*1.2;
        figure('Units', 'normalized', 'OuterPosition', [0.06, 0, h2ws*w2h, 1]);
        xset = xset*mfoData.R;
        yset = yset*mfoData.R;
        hAxv = gca;
        [~, cb] = ssuImage(gca, result, par.visstep, [xset(1), yset(1)]); hold on
        cb.Label.String = 'B_z, G';
        drawnow
    end

    xbox3 = [];
    ybox3 = [];
    if isfield(mfoData, 'stepP') && length(mfoData.stepP) == 3
        VAR2VCS = crdGet3DRotationMatrices(mfoData.lat, mfoData.lon);
        comps = VAR2VCS*[0; 0; mfoData.stepP(3)];
        xbox3 = zeros(size(mfoData.x_box,1), size(mfoData.x_box,2), size(mfoData.B.z, 3));
        xbox3(:,:,1) = mfoData.x_box;
        ybox3 = zeros(size(mfoData.y_box,1), size(mfoData.y_box,2), size(mfoData.B.z, 3));
        ybox3(:,:,1) = mfoData.y_box;
        for kx = 2:size(xbox3, 3)
            xbox3(:,:,kx) = xbox3(:,:,kx-1) + comps(1);
            ybox3(:,:,kx) = ybox3(:,:,kx-1) + comps(2);
        end
    end
end

if (WOLines)
    return
end

[coords, linesLength, avField, status] = mfoCalcLinesSet(hLib, mfoData.B, par);

if isempty(par.hrange)
    par.hrange = [0 Inf];
end
hmult = mfoData.R/6.96e5/mfoData.step(3);
par.hrange = hmult*par.hrange;
par.hmax = hmult*par.hmax;

disp('start...')
ticID = tic;
Fx = griddedInterpolant(xbox3);
Fy = griddedInterpolant(ybox3);
ncw = length(coords)/4;
ccr = reshape(coords, [4 ncw]);
ccw = ccr(1:3, :)';
ccwx = Fx(ccw+1)'*mfoData.R;
ccwy = Fy(ccw+1)'*mfoData.R;
toc(ticID)

% disp('start...')
% ticID = tic;
% ncw = length(coords)/4;
% ccw = reshape(coords, [4 ncw]);
% ccwx = xinterp3(xbox3, ccw(1, :)+1, ccw(2, :)+1, ccw(3, :)+1)*mfoData.R;
% ccwy = xinterp3(ybox3, ccw(1, :)+1, ccw(2, :)+1, ccw(3, :)+1)*mfoData.R;
% toc(ticID)

pos = 1;
posp = 1;
ticID = tic;
for k = 1:length(linesLength)
    next = pos + 4*linesLength(k);
    nextp = posp + linesLength(k);
    select = coords(pos:next-1);
    nc = length(select)/4;
    cc = reshape(select, [4 nc]);
    idx = find(cc(3, :) > par.hmax);
    if ~isempty(idx)
        cc(:, idx(1):end) = [];
    end
    isClosed = bitand(status(k), 4) ~= 0;
    isHalfOpened = bitand(status(k), 16) ~= 0;
    
    if ~isempty(cc) && avField(k) > par.Bmax && size(cc, 2) >= par.lngmax ...
     && par.hrange(1) <= max(cc(3, :)) && max(cc(3, :)) <= par.hrange(2) ...
     && (isClosed && par.closed || isHalfOpened && par.half_opened || ~(isClosed || isHalfOpened) && par.opened)
        ccp = cc*mfoData.step(1);
        %plot3(hAxp, ccp(2, :)+1, ccp(1, :)+1, ccp(3, :)+1, 'Color', par.lcol, 'LineWidth', par.lw); hold on
        patch(hAxp, [ccp(2, :)+1 NaN],[ccp(1, :)+1 NaN],[ccp(3, :)+1 NaN],'black','EdgeColor',par.lcol, 'LineWidth', par.lw,...
                'FaceVertexAlphaData',par.alphav*ones(size(ccp, 2)+1, 1),'AlphaDataMapping','none',...
                'EdgeAlpha','interp')                    

        if par.useinterp && ~isempty(xbox3)
            ccx = ccwx(posp:nextp-1);
            ccy = ccwy(posp:nextp-1);
            if ~isempty(hAxv)
                patch(hAxv, [ccy NaN],[ccx NaN],'black','EdgeColor',par.lcol, 'LineWidth', par.lw,...
                        'FaceVertexAlphaData',par.alphav*ones(length(ccx)+1, 1),'AlphaDataMapping','none',...
                        'EdgeAlpha','interp')                    
            end
            if ~isempty(hAxa)
                patch(hAxa, [ccy NaN],[ccx NaN],'black','EdgeColor',par.lcola, 'LineWidth', par.lwa,...
                        'FaceVertexAlphaData',par.alphaa*ones(length(ccx)+1, 1),'AlphaDataMapping','none',...
                        'EdgeAlpha','interp')                    
            end
        end
        
        if par.draw
            drawnow
        end
    end
    pos = next;
    posp = nextp;

    if mod(k, 100) == 0
        srvProgressReport(ticID, length(linesLength), k);
    end
end

end

%--------------------------------------------------------------------------
function hv = l_findHarm(BB, cc, Bc, limpix)

hv = [];

% if ~isempty(cc) && ((cc(1,1) > 18.02 && cc(1,1) < 18.04 && cc(2,1) > 92.01 && cc(2,1) < 92.03) || (cc(1,end) > 18.02 && cc(1,end) < 18.04 && cc(2,end) > 92.01 && cc(2,end) < 92.03))
%     stophere = 1;
% end

Bi = interp3(BB, cc(2, :)+1, cc(1, :)+1, cc(3, :)+1);
for k = 2:length(Bi)
    if Bc >= min(Bi(k-1), Bi(k)) && Bc <= max(Bi(k-1), Bi(k))
        t = (Bc - Bi(k-1))/(Bi(k) - Bi(k-1));
        z = cc(3, k-1) + t*(cc(3, k) - cc(3, k-1));
        if z > limpix
            x = cc(1, k-1) + t*(cc(1, k) - cc(1, k-1));
            y = cc(2, k-1) + t*(cc(2, k) - cc(2, k-1));
            hv = [hv [x; y; z]];
        else
            sss=1;
        end
    end
end

end
