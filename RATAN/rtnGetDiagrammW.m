function dwidth = rtnGetDiagrammW(freq, mode, c, b)

if ~exist('mode', 'var')
    mode = 3;
end
lamb = 3e10./freq;

if mode == 1
    dwidth =            8.5 *lamb;
elseif mode == 2
    dwidth =   4.38 +  6.87 *lamb;
elseif mode == 3
    dwidth =  0.009 + 8.338 *lamb;
elseif mode == 5
    dwidth =    0.2 +   9.4 *lamb;
elseif mode == 6
    dwidth = -0.16  + 8.162 *lamb;
else
    dwidth =     c  +     b *lamb;
end

end
