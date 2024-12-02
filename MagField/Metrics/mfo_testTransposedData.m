function mfo_testTransposedData(d1, d2)

if isfield(d1, 'S')
    dd = l_delta(d1.S, d2.S);
    disp(['S: ' num2str(~any(any(any(dd ~= 0))))])
else
    dd = l_delta(d1.BX, d2.BY);
    disp(['X: ' num2str(~any(any(any(dd ~= 0)))) ', max = ' num2str(xmax3(abs(dd)))])
    dd = l_delta(d1.BY, d2.BX);
    disp(['Y: ' num2str(~any(any(any(dd ~= 0)))) ', max = ' num2str(xmax3(abs(dd)))])
    dd = l_delta(d1.BZ, d2.BZ);
    disp(['Z: ' num2str(~any(any(any(dd ~= 0)))) ', max = ' num2str(xmax3(abs(dd)))])
end

end

function dd = l_delta(v1, v2)

dd = v1 - permute(v2, [2 1 3]);

end
