function azim = fpuApplyHMIDisambig(azim, HIMdisamb, isMinus)

if ~exist('isMinus', 'var')
    isMinus = false;
end

sgn = pick(isMinus, -1, 1);

% ;				bit 1 indicates the azimuth needs to be flipped (plus 180)
% ;				For full disk, three bits are set, giving three disambiguation
% ;				solutions from different methods. Note the strong field pixels
% ;				have the same solution (000 or 111, that is, 0 or 7) from the 
% ;				annealing method. The weak field regions differ 
% ;				lowest: potential field acute
% ;				middle: radial acute (default)
% ;				highest: random

ann = (HIMdisamb == 2 | HIMdisamb == 3 | HIMdisamb == 6 | HIMdisamb == 7);
azim(ann) = azim(ann) + 180*sgn;

end
