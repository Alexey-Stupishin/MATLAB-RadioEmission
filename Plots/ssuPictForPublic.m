function hF = ssuPictForPublic(hAx, title, fsize, iterpret, Xlabel, Ylabel)

if ~exist('fsize', 'var') || isempty(fsize)
    fsize = 24;
end
if ~exist('Xlabel', 'var') || isempty(Xlabel)
    Xlabel = 'arcsec';
end
if ~exist('Ylabel', 'var') || isempty(Ylabel)
    Ylabel = 'arcsec';
end
if exist('iterpret', 'var') && ~isempty(iterpret)
    hAx.Title.Interpreter = iterpret;
%    set(hAx, 'interpreter', iterpret);
end

if exist('title', 'var') && ~isempty(title)
    hAx.Title.String = title;
end
hAx.XLabel.String = Xlabel;
hAx.YLabel.String = Ylabel;

hF = get(hAx, 'Parent');
% set(hF, 'Units', 'normalized');
% set(hF, 'OuterPosition', [0, 0, 1, 1]);

set(hAx, 'FontSize', fsize);

end
