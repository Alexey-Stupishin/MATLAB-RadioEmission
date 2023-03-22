function s = reuMGQScalc(srow, npeak, x, qmode, qsonly)

global gQS_mode

if ~exist('qsonly', 'var')
    qsonly = false;
end

s = zeros(1, length(srow));
if ~qsonly
    for kd = 1:npeak
        idx = (kd-1)*3 + 1;
        s = s + x(idx)*exp(-x(idx+1).*(x(idx+2)-srow).^2);
    end
end

if qmode == gQS_mode.pow4
    s = s + x(end-6) + x(end-5)*exp(x(end-3).*(x(end-4)-srow).^2+x(end-2).*(x(end-4)-srow).^4) ...
                       .*sqrt(1-x(end-1).*(x(end-4)-srow).^2-x(end).*(x(end-4)-srow).^4);
elseif qmode == gQS_mode.pow2
    s = s + x(end-4) + x(end-3)*exp(x(end-1).*(x(end-2)-srow).^2) ...
                       .*sqrt(1-x(end).*(x(end-2)-srow).^2);
end

s(imag(s) ~= 0) = 0;

end
