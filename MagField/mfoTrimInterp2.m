function [BX, BY, BZ] = mfoTrimInterp2(B0, Bphoto)

BX = interp3(B0.BX);
BY = interp3(B0.BY);
BZ = interp3(B0.BZ);

BX(:,:,1) = Bphoto.BX(:,:,1);
BY(:,:,1) = Bphoto.BY(:,:,1);
BZ(:,:,1) = Bphoto.BZ(:,:,1);

end
