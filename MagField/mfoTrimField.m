function B = mfoTrimField(Bany, xrange, yrange, zrange)

B0 = fpuField2XYZ(Bany);

if ~exist('zrange', 'var') || size(B0.x, 3) == 1
    zrange = 1;
end

B.x = B0.x(xrange, yrange, zrange);
B.y = B0.y(xrange, yrange, zrange);
B.z = B0.z(xrange, yrange, zrange);

end
