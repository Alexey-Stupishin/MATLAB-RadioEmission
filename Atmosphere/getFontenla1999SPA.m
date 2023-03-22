function [h, SNh, PNh, ANh, STh, PTh, ATh] = getFontenla1999SPA(dh, show)

% S - umbra
% P - Bright plage
% A - Faint supergranule cell interior

% T, N - log10 !

if ~exist('dh', 'var') || isempty(dh)
    dh = 50;
end
if ~exist('show', 'var')
    show = false;
end

[SN, PN, AN] = getFontenla1999N;
[ST, PT, AT] = getFontenla1999T;

shlim = [max(min(SN(:, 1)), min(ST(:, 1))) min(max(SN(:, 1)), max(ST(:, 1)))];
phlim = [max(min(PN(:, 1)), min(PT(:, 1))) min(max(PN(:, 1)), max(PT(:, 1)))];
ahlim = [max(min(AN(:, 1)), min(AT(:, 1))) min(max(AN(:, 1)), max(AT(:, 1)))];

wlim = [max([shlim(1) phlim(1) ahlim(1)]) min([shlim(2) phlim(2) ahlim(2)])];

nH = ceil((shlim(2)-shlim(1))/dh*1e-5);

h = linspace(wlim(1), wlim(2), nH);

SNh = interp1(SN(:, 1), SN(:, 2), h);
PNh = interp1(PN(:, 1), PN(:, 2), h);
ANh = interp1(AN(:, 1), AN(:, 2), h);
STh = interp1(ST(:, 1), ST(:, 2), h);
PTh = interp1(PT(:, 1), PT(:, 2), h);
ATh = interp1(AT(:, 1), AT(:, 2), h);

if show
    xplot(h, 10.^(STh+SNh), 'Color', 'k')
    plot(h, 10.^(PTh+PNh), 'Color', 'r')
    plot(h, 10.^(ATh+ANh), 'Color', 'b')
    set(gca, 'YScale', 'log');

    xplot(h, 10.^STh, 'Color', 'k')
    plot(h, 10.^PTh, 'Color', 'r')
    plot(h, 10.^ATh, 'Color', 'b')
    set(gca, 'YScale', 'log');
end

end
