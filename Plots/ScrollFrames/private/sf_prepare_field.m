function [p, zrCommon, zrLevel, sz3] = sf_prepare_field(p)

zrCommon = [xmin3(p.B) xmax3(p.B)];
zrLevel = [xmin2(p.B(:, :, p.level)) xmax2(p.B(:, :, p.level))];
sz3 = size(p.B);

p = sf_filter_field(p);

if p.trim_draw % && ~isempty(p.trim)
    xrange = max(1, min(sz3(1), p.trim.xrange - p.bound_shift(1)));
    yrange = max(1, min(sz3(2), p.trim.yrange - p.bound_shift(2)));
    p.B = p.B(xrange(1):xrange(2), yrange(1):yrange(2), :);
    if ~isempty(p.Bq1)
        p.Bq1 = p.Bq1(xrange(1):xrange(2), yrange(1):yrange(2), :);
    end
    if ~isempty(p.Bq1)
        p.Bq2 = p.Bq2(xrange(1):xrange(2), yrange(1):yrange(2), :);
    end
end

p.B = p.B(:, :, p.level);
if ~isempty(p.Bq1)
    p.Bq1 = p.Bq1(:, :, p.level);
end
if ~isempty(p.Bq2)
    p.Bq2 = p.Bq2(:, :, p.level);
end

end
