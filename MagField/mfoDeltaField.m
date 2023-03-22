function db = mfoDeltaField(b1, b2)

if isfield(b1, 'BX')
    db.x = b1.BX - b2.BX;
    db.y = b1.BY - b2.BY;
    db.z = b1.BZ - b2.BZ;
else
    db.x = b1.x - b2.x;
    db.y = b1.y - b2.y;
    db.z = b1.z - b2.z;
end

end
