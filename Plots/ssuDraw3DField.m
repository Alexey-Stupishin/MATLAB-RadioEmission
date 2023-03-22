function hFig = ssuDraw3DField(B, title1, title2, aiaTrim, aiaN, title3, rat, hmi, aia)

if ~exist('title1', 'var')
    title1 = '';
end

if ~exist('title2', 'var')
    title2 = '';
end

if ~exist('aiaTrim', 'var')
    aiaTrim = [];
end

if ~exist('aiaN', 'var')
    aiaN = 0;
end

if ~exist('title3', 'var')
    title3 = '';
end

if ~exist('rat', 'var')
    rat = [];
end

if ~exist('hmi', 'var')
    hmi = [];
end

if ~exist('aia', 'var')
    aia = [];
end

BB = fpuFieldVal(B);

useAIATrim = aiaN > 0 && ~isempty(aiaTrim);
isAnyAIA = useAIATrim || ~isempty(aia);
isAnyFull = ~isempty(aia) || ~isempty(hmi);
nrows = 1;
ncols = 2;
if isAnyAIA
    ncols = 3;
end
if isAnyFull
    nrows = 2;
end

hAIATrim = [];
hHMI_I = [];
hHMI_V = [];
hAIA = [];
[hFig, hAxes] = ssuCreateMultiAxesFig(nrows, ncols, '', true, false);
hAbsB = hAxes(1,1);
hBz = hAxes(1,2);
if isAnyAIA && useAIATrim
    hAIATrim = hAxes(1,3);
end
if isAnyAIA && ~isempty(aia)
    hAIA = hAxes(2,3);
end
if ~isempty(hmi)
    hHMI_I = hAxes(2,1);
    hHMI_V = hAxes(2,2);
end

B1 = BB(:,:,1);
sz = size(B1);
c = xmax2(B1)/sqrt(sz(1)*sz(2));
surf(hAbsB, B1, 'EdgeColor', 'none');
set(hAbsB, 'DataAspectRatio', [1 1 c*1.5], 'FontSize', 24);
view(hAbsB, 3)
if ~isempty(title1)
    hAbsB.Title.String = djsStr2TeX(title1);
end

ssuImage(hBz, B.z(:,:,1)); % , scale, offset, cmapdata, nodatascale, isbar, alpha)
set(hBz, 'DataAspectRatio', [1 1 1], 'FontSize', 24);
if ~isempty(title2)
    hBz.Title.String = djsStr2TeX(title2);
end

if useAIATrim
    aiaData = aiaTrim.data(:, :, aiaN);
    aiaSize = double(aiaTrim.size(:, aiaN));
    aiaCent = aiaTrim.center(:, aiaN);
    aiaStep = aiaTrim.step(:, aiaN)';
    aiax0 = aiaCent(1) - (aiaSize(1)-1)/2*aiaStep(1);
    aiay0 = aiaCent(2) - (aiaSize(2)-1)/2*aiaStep(2);
    aiaOff = [aiax0 aiay0];
    cm = colormapAIA(171);
    ssuImage(hAxes(1, 3), aiaData, aiaStep, aiaOff, cm, false, false);
    set(hAxes(1, 3), 'DataAspectRatio', [1 1 1], 'FontSize', 24);
    if ~isempty(title3)
        hAxes(1, 3).Title.String = title3;
    end
end

end
