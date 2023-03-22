function map = colormapIronHeat(contrast, blackT, linear)

table = [ ...
    550, 0.392,  0,  0; ...
    630, 0.471,  0,  0; ...
    680, 0.588,  0,  0; ...
    740, 0.667,  0,  0; ...
    770, 0.8,  0,  0; ...
    800, 0.867,  0,  0; ...
    850, 0.933,  0,  0; ...
    900, 1.0,  0,  0; ...
    950, 1.0,  0.6,  0.2; ...
   1000, 1.0,  0.8,  0; ...
   1100, 0.996,  0.996,  0.204; ...
   1200, 0.953,  0.976,  0.561; ...
   1300, 1.0,  1.0,  1.0; ...
    ];

if ~exist('blackT', 'var') || isempty(blackT)
    blackT = 520;
end

if blackT > 0
    table = [[blackT 0 0 0]; table];
end

if ~exist('linear', 'var')
    linear = false;
end
if linear
    scale = [1 size(table, 1)];
    inT = (scale(1):scale(2))';
else
    scale = [table(1, 1) table(end, 1)];
    inT = table(:, 1);
end

temps = linspace(scale(1), scale(2), 255)';

map = [interp1(inT, table(:,2), temps) interp1(inT, table(:,3), temps) interp1(inT, table(:,4), temps)];

if ~exist('contrast', 'var')
    contrast = 1;
end

if contrast ~= 1
    map = ssucApplyContrast(map, contrast);
end

end
