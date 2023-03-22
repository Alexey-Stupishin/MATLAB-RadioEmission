function v = asmAsym2Sig(x, A, xc, w1, w2, w3, y0)

if ~exist('y0', 'var')
    y0 = 0;
end

if length(A) > 1
    v = asmAsym2Sig(x, A(1), A(2), A(3), A(4), A(5), A(6));
    return
end

v = y0+ A*(1./(1+exp(-(x-xc+w1/2)/w2))).*(1-1./(1+exp(-(x-xc-w1/2)/w3)));

end
