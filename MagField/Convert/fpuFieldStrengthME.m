function [BS, azim, incl, transv, Bz] = fpuFieldStrengthME(B, varargin)

[B, transv, Bz] = fpuXYZField2ME(B, varargin{:});
BS = B.absB;
incl = B.incl;
azim = B.azim;

end
