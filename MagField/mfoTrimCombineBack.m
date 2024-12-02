function B = mfoTrimCombineBack(B, Btrim, x, y, z)

sz = size(Btrim.BX);
xr = x:(x+sz(1)-1);
yr = y:(y+sz(2)-1);
zr = z:(z+sz(3)-1);

B.BX(xr, yr, zr) = Btrim.BX;
B.BY(xr, yr, zr) = Btrim.BY;
B.BZ(xr, yr, zr) = Btrim.BZ;

end
