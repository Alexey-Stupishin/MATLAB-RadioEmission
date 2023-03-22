function h = xplot(varargin)

figure; 
hp = plot(varargin{:}); hold on
if nargout > 0
    h = hp;
end

end
