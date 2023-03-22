function [mask, av] = ircGetMask(rd, sigma)

av = mean(reshape(rd, [1 numel(rd)]));
st = std(reshape(rd, [1 numel(rd)]));
mask = true(size(rd));
mask(rd > av-sigma*st & rd < av+sigma*st) = false;

end
