function [range1, range2] = crdGetShiftedRange(N1, N2, shift)
% shift 2nd to the 1st

range1 = [];
range2 = [];

if shift+N2 <= 0 || shift > N1
    return
end

range1 = zeros(1, 2);
range2 = zeros(1, 2);

if shift < 0
    range1(1) = 1;
    range2(1) = - shift + 1;
else
    range1(1) = shift + 1;
    range2(1) = 1;
end

if shift +N2 - N1 <= 0
    range1(2) = shift + N2;
    range2(2) = N2;
else
    range1(2) = N1;
    range2(2) = - shift + N1;
end

end
