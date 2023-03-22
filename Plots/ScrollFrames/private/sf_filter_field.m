function p = sf_filter_field(p)

global sf_types_filter_mode

p.maxBCommon.val = [];
p.maxBbyLevel.val = [];

if ~isempty(p.Bfilt)
    p.maxBCommon.val = xmax3(p.Bfilt);
    p.maxBbyLevel.val = zeros(1, size(p.Bfilt, 3));
    for k = 1:size(p.Bfilt, 3)
        p.maxBbyLevel.val(k) = xmax2(p.Bfilt(:, :, k));
    end
end

if ~p.filter || isempty(p.Bfilt)
    return
end

mask = false(size(p.B));

if p.filter_value_mode == sf_types_filter_mode.Abs
    mask = p.Bfilt < p.filter_value;
else
    if p.filter_common_val
        mask = p.Bfilt/p.maxBCommon.val < p.filter_value;
    else
        for k = 1:size(p.Bfilt, 3)
            mask(:, :, k) = p.Bfilt(:, :, k)/p.maxBbyLevel.val(k) < p.filter_value;
        end
    end
end

p.B(mask) = p.filter_replace;
if ~isempty(p.Bq1)
    p.Bq1(mask) = p.filter_replace;
end
if ~isempty(p.Bq2)
    p.Bq2(mask) = p.filter_replace;
end

end
