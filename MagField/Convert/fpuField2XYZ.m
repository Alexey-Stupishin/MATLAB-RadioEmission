function B = fpuField2XYZ(Bany)

if (~isstruct(Bany)) % suppose B3/B4
    if ndims(Bany) == 4
        B.x = Bany(:, :, :, 1);
        B.y = Bany(:, :, :, 2);
        B.z = Bany(:, :, :, 3);
    else
        B.x = Bany(:, 1);
        B.y = Bany(:, 2);
        B.z = Bany(:, 3);
    end
else
    if isfield(Bany, 'x')
        B = Bany;
    else
        if isfield(Bany, 'MFODATA')
            Bany = Bany.MFODATA;
        end
        
        if isfield(Bany, 'BX')
            B.x = Bany.BX;
            B.y = Bany.BY;
            B.z = Bany.BZ;
        elseif isfield(Bany, 'bx')
            B.x = Bany.bx;
            B.y = Bany.by;
            B.z = Bany.bz;
        else
            disp('Wrong Structure!')
            return
        end
    end
end

end
