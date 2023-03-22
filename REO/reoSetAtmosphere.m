function reoSetAtmosphere(hLib, n, H, D, init)

if exist('init', 'var')
    init = 0;
end

gstSetAtmosphere(hLib, n, H, D, init);

end
