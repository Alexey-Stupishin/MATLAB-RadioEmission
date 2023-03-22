function alpha_z = fpuGetAlphaZ(B, x, y, step)

if ~exist('step', 'var')
    step = 1;
end
if length(step) == 1
    step = [step step];
end

Babs = fpuFieldVal(B);
%alpha_z = ((B.y(x+1, y) - B.y(x-1, y))/step(1) - (B.x(x, y+1) - B.x(x, y-1))/step(2))./B.z(x, y)*0.5;
alpha_z = ((B.y(x+1, y) - B.y(x-1, y))/step(1) - (B.x(x, y+1) - B.x(x, y-1))/step(2))./Babs(x, y)*0.5 * 3;

end

