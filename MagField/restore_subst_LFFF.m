function restore_subst_LFFF

% dirname = 's:\University\Work\Bifrost\Results\photo\AS2022_LFFF_subst_bin3\';
dirname = 's:\University\Work\Bifrost\Results\photo\AS2022_LFFF_subst_bin9\';
%patt1 = 'B3_ph_LFFF_lev';
patt1 = 'B9_ph_LFFF_lev';
patt2 = '_M25_S3.out';
% s = iouSAV2Data('s:\University\Work\Bifrost\LFFF\photo\bnfff_bifrost_B3L06_vectorb_168_168_78.sav');
s = iouSAV2Data('s:\University\Work\Bifrost\LFFF\photo\bnfff_bifrost_B9L02_vectorb_56_56_26.sav');

lng = size(s.BVZ, 3);

for k = 2:lng
    out = iouBIN2Data([dirname patt1 num2str(k) patt2]);
    if isempty(out)
        break
    end
    BX = s.BVX;
    BY = s.BVY;
    BZ = s.BVZ;
    BX(:, :, k:end) = out.BX;
    BY(:, :, k:end) = out.BY;
    BZ(:, :, k:end) = out.BZ;
    outfile = [dirname patt1 num2str(k) '_res.sav'];
    iouData2SAV(outfile, 'BX', 'BY', 'BZ');
end

end
