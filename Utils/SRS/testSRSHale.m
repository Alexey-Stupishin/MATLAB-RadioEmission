function testSRSHale

load('e:\BIGData\ActiveRegions\Total_20110101_20210414\AR.mat')

collectHale = {};
for k = 1:length(AR)
    regs = AR(k).Regions;
    for r = 1:length(regs)
        if (~isempty(regs(r).Hale) && ~any(strcmp(collectHale, regs(r).Hale)))
            collectHale = [collectHale, {regs(r).Hale}];
        end
    end
end    

end
