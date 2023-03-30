function ssuSetAspectRatio(hAx, cube)

sz3 = size(cube);
M = sqrt(sz3(1)*sz3(2));
asp = 1/M;
set(hAx, 'DataAspectRatio', [1,1,asp]);
        
end        
