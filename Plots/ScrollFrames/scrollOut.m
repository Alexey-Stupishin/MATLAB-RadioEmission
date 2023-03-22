function scrollOut(fname, fname2)

bin = iouBIN2Data(fname);
B.x = bin.BX;
B.y = bin.BY;
B.z = bin.BZ;

% if exist('fname2', 'var')
%     mfo2 = mfoLoadField(fname2);
%     B2 = mfo2.B;
%     B.x = B.x - B2.x;
%     B.y = B.y - B2.y;
%     B.z = B.z - B2.z;
% end

ScrollFrame(B);

end
