function ci = xinterp3(box3, xq, yq, zq)

% asserts

ci = zeros(size(xq));
sz = size(box3);
for k = 1:length(xq)
	indx = max(1, min(sz(1), floor(xq(k))));
    if abs(indx - sz(1)) < eps
        indx = indx - 1;
        tx = 1;
    else
        tx = xq(k) - indx;
    end
	indy = max(1, min(sz(2), floor(yq(k))));
    if abs(indy - sz(2)) < eps
        indy = indy - 1;
        ty = 1;
    else
        ty = yq(k) - indy;
    end
	indz = max(1, min(sz(3), floor(zq(k))));
    if abs(indz - sz(3)) < eps
        indz = indz - 1;
        tz = 1;
    else
        tz = zq(k) - indz;
    end
    
    c2 = box3(indx:indx+1, indy:indy+1, indz) + (box3(indx:indx+1, indy:indy+1, indz+1) - box3(indx:indx+1, indy:indy+1, indz))*tz;
    c1 = c2(1:2, 1) + (c2(1:2, 2) - c2(1:2, 1))*ty;
    ci(k) = c1(1) + (c1(2)-c1(1))*tx;
end

end

