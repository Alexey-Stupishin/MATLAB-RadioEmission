function cm = colormapAIA(wave)

if ~exist('wave', 'var')
    wave = 171;
end

cm.cmap = colormapAIACore(wave);
cm.nandata = 0;
    
end
