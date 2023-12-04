function Bres = asm_medianFill(B, Bart)

Bres = B;

iter = 0;
while any(any(Bart))
    
    iter = iter + 1;
    disp(num2str(xsum2(Bart)))
    
    Bext = zeros(size(B,1)+2, size(B,2)+2, 8);
    Bext(1:end-2, 1:end-2, 1) = Bres;
    Bext(1:end-2, 2:end-1, 2) = Bres;
    Bext(1:end-2, 3:end, 3) = Bres;
    Bext(2:end-1, 1:end-2, 4) = Bres;
    Bext(2:end-1, 3:end, 5) = Bres;
    Bext(3:end, 1:end-2, 6) = Bres;
    Bext(3:end, 2:end-1, 7) = Bres;
    Bext(3:end, 3:end, 8) = Bres;

    Bext = Bext(2:end-1, 2:end-1, :);

    Bae = ones(size(B,1)+2, size(B,2)+2, 8);
    Bae(1:end-2, 1:end-2, 1) = Bart;
    Bae(1:end-2, 2:end-1, 2) = Bart;
    Bae(1:end-2, 3:end, 3) = Bart;
    Bae(2:end-1, 1:end-2, 4) = Bart;
    Bae(2:end-1, 3:end, 5) = Bart;
    Bae(3:end, 1:end-2, 6) = Bart;
    Bae(3:end, 2:end-1, 7) = Bart;
    Bae(3:end, 3:end, 8) = Bart;
    
    cnt = sum(Bae, 3);

    Bae = Bae(2:end-1, 2:end-1, :);
    cnt = cnt(2:end-1, 2:end-1);

    loc_med = zeros(1, 8);
    cnt = 8-cnt;
    cnt(~Bart) = 0;
    cmax = xmax2(cnt);
    check = Bart & cnt == cmax;
    [row, col] = find(check);
    for k = 1:length(row)
        cmed = 0;
        for kz = 1:8
            if ~Bae(row(k), col(k), kz)
                cmed = cmed + 1;
                loc_med(cmed) = Bext(row(k), col(k), kz);
            end
        end
        if cmed > 0
            %Bres(row(k), col(k)) = sum(loc_med(1:cmed))/cmed;
            Bres(row(k), col(k)) = median(loc_med(1:cmed));
        end
        Bart(row(k), col(k)) = false;
    end
    
end

end
