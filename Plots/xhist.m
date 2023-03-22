function h = xhist(varargin)

figure; 
varargin{1} = reshape(varargin{1}, [numel(varargin{1}) 1 1]);
hp = histogram(varargin{:}); hold on
if nargout > 0
    h = hp;
end

end
