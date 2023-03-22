function [upd1, upd2] = crdAdjustMapOverlap(map1, map2, shift_v, shift_h)

upd1 = [];
upd2 = [];

sz1 = size(map1);
sz2 = size(map2);

[range1_v, range2_v] = crdGetShiftedRange(sz1(1), sz2(1), shift_v);
[range1_h, range2_h] = crdGetShiftedRange(sz1(2), sz2(2), shift_h);

if ~isempty(range1_v) && ~isempty(range1_h) && ~isempty(range2_v) && ~isempty(range2_h)
    upd1 = map1(range1_v(1):range1_v(2), range1_h(1):range1_h(2));
    upd2 = map2(range2_v(1):range2_v(2), range2_h(1):range2_h(2));
end

end
