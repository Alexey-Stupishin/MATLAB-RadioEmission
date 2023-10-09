function xquiv(B3, sshow, level, lineStep)

B3 = fpuField2XYZ(B3);

figure('Units','normalized', 'Position', [0.5 0.05 0.45 0.8], 'Name', 'Bz');
hAx = gca;
hAx_x = [];
hAx_y = [];

if ~exist('sshow', 'var') || isempty(sshow)
    sshow = 'C';
end
if ~exist('level', 'var') || isempty(level)
    level = 1;
end
if ~exist('lineStep', 'var') || isempty(lineStep)
    sz = size(B3.x);
    lineStep = floor(sqrt(sz(1)*sz(2))/100);
end

if ~isempty(strfind(sshow, 'Z'))
    ssuShowQuiv4(hAx, [], [], 0, B3, level, lineStep);
end

isQuiv = ~isempty(strfind(sshow, 'C'));

if ~isempty(strfind(sshow, 'X'));
    figure('Units','normalized', 'Position', [0.5 0.05 0.45 0.8], 'Name', 'Bx');
    hAx_x = gca;
end
if ~isempty(strfind(sshow, 'Y'));
    figure('Units','normalized', 'Position', [0.5 0.05 0.45 0.8], 'Name', 'By');
    hAx_y = gca;
end

ssuShowQuiv4(hAx, hAx_x, hAx_y, isQuiv, B3, level, lineStep);

end
