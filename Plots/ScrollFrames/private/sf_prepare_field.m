function [p, zrCommon, zrLevel, sz3] = sf_prepare_field(p)

zrCommon = [xmin3(p.B) xmax3(p.B)];
zrLevel = [xmin2(p.B(:, :, p.level)) xmax2(p.B(:, :, p.level))];
sz3 = size(p.B);

p = sf_filter_field(p);

if p.trim_draw % && ~isempty(p.trim)
    p.B = p.B(p.trim.xrange(1):p.trim.xrange(2), p.trim.yrange(1):p.trim.yrange(2), :);
    if ~isempty(p.Bq1)
        p.Bq1 = p.Bq1(p.trim.xrange(1):p.trim.xrange(2), p.trim.yrange(1):p.trim.yrange(2), :);
    end
    if ~isempty(p.Bq1)
        p.Bq2 = p.Bq2(p.trim.xrange(1):p.trim.xrange(2), p.trim.yrange(1):p.trim.yrange(2), :);
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