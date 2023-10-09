function B = iouHMIgetB(fname, mode)

load(fname, '-mat');

if (strcmp(mode, 'src'))
    B.x = trim.Source.x;
    B.y = trim.Source.y;
    B.z = trim.Source.z;
else
    B = trim.Result.minEn.Bres;
end

end
