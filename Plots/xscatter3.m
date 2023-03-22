function xscatter3(x, y, dirn, dirv)

if ~exist('dirn', 'var')
    dirn = 3;
end
if ~exist('dirv', 'var')
    dirv = 1;
end

if dirn == 1
    xx = x(dirv, :, :);
    yy = y(dirv, :, :);
elseif dirn == 2
    xx = x(:, dirv, :);
    yy = y(:, dirv, :);
elseif dirn == 3
    xx = x(:, :, dirv);
    yy = y(:, :, dirv);
end

xx = reshape(xx, [1 numel(xx)]);
yy = reshape(yy, [1 numel(yy)]);

figure; scatter(xx, yy)

end
