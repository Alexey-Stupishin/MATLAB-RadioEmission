function db = fpu_deltaB(b1, b2)

B1 = fpuField2XYZ(b1);
B2 = fpuField2XYZ(b2);

db.BX = B1.x - B2.x;
db.BY = B1.y - B2.y;
db.BZ = B1.z - B2.z;

end
