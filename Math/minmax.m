function mm = minmax(A)

vmin = xmin3(A);
vmax = xmax3(A);

if nargout < 1
    disp([num2str(vmin) ' ' num2str(vmax)])
else
    mm = [vmin vmax];
end

end
