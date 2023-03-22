function xsurf(V, varargin)

figure;
if ~ismatrix(V)
    V = V(:, :, 1);
end
surf(double(V), varargin{:}, 'EdgeColor', 'none');
%set(gca, 'DataAspectRatio', [1 1 1]);

end
