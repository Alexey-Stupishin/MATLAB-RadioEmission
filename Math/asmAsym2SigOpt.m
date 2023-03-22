function [appr, A, xc, w1, w2, w3] = asmAsym2SigOpt(freqs, fluxes)

smoo = fluxes;
smoo(3:end-2) = (smoo(1:end-4) + smoo(2:end-3) + smoo(3:end-2) + smoo(4:end-1) + smoo(5:end))/5;
smoo(2) = sum(smoo(1:3))/3;
smoo(end-1) = sum(smoo(end-2:end))/3;
[A, im] = max(smoo);
xc = freqs(im);
wingidxs = find(smoo >= A*0.9);
limw = 2.1;
if isempty(wingidxs) || wingidxs(1) >= im
%    frleft = freqs(im-2);
    frleft = xc - limw;
else
    frleft = (xc - freqs(1))/2;
end
if isempty(wingidxs) || wingidxs(end) <= im
%    frright = freqs(im+2);
    frright = xc + limw;
else
    frright = (xc + freqs(end))/2;
end
w2 = max(limw, freqs(im) - frleft);
w3 = max(limw, frright - freqs(im));

% appr0 = asmAsym2Sig(freqs, A, xc, 10, w2, w3);
% A = max(appr0);

% initsimp = [ ...
%              A/2, xc-3, 0, w2, w3; ...
%              A*2, xc-3, 0, w2, w3; ...
%              A/2, xc+3, 0, w2, w3; ...
%              A/2, xc-3, 5, w2, w3; ...
%              A/2, xc-3, 0, w2+5, w3; ...
%              A/2, xc-3, 0, w2, w3+5; ...
%            ];

w2 = w2-limw+0.1;
w3 = w3-limw+0.1;
initsimp = [ ...
             A/2, xc-3, 0, w2, w3; ...
             A*2, xc-3, 0, w2, w3; ...
             A/2, xc+3, 0, w2, w3; ...
             A/2, xc-3, 3, w2, w3; ...
             A/2, xc-3, 0, w2+2, w3; ...
             A/2, xc-3, 0, w2, w3+2; ...
           ];


x = NelderMead(@l_calc, @l_crit, @l_bound, initsimp, 1, 2, 0.5, 0.5);

    function x = l_bound(x)
    end

    function f = l_calc(x)
        f = sum((fluxes - asmAsym2Sig(freqs, x(1), x(2), x(3), x(4), x(5))).^2);
    end

    function conv = l_crit(x, ~)
        conv = std(x(:, 1), 0, 1)/mean(x(:, 1), 1) < 1e-3 && all(std(x(:, 2:end), 0, 1) < 1e-3);
    end

A = x(1);
xc = x(2);
w1 = x(3);
w2 = x(4);
w3 = x(5);

appr = asmAsym2Sig(freqs, A, xc, w1, w2, w3);

end
