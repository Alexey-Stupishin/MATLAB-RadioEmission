function s = d3getcpp(fid, root, level)

if isempty(root)
    return
end

b = blanks(17*level);

for k = 1:length(root)
    sm = '';
    if k > 1 || root(k).mult ~= 1
        sm = '';
        if abs(root(k).mult) ~= 1
            m = num2str(abs(root(k).mult));
            sm = m;
        end
        if k > 1 || root(k).mult < 0
            sm = [pick(root(k).mult > 0, '+', '-') sm];
        end
    end
    se = l_getelem(root(k));
    if isempty(sm)
        s = [b se];
    else
        s = [b sm];
        if abs(root(k).mult) ~= 1
            s = [s '*'];
        end
        s = [s se];
    end
    if ~isempty(root(k).tree)
        fprintf(fid, '%s\r\n', [s '*(']);
        st = vectAlgebra.d3getcpp(fid, root(k).tree, level+1);
        fprintf(fid, '%s\r\n', [b ')']);
    else
        fprintf(fid, '%s\r\n', s);
    end
end

end

%--------------------------------------------------------------------------
function s = l_getelem(elem)

switch elem.num(1)
    case 0
        s = 'w[idx]';
    case 1
        s = ['dw[' num2str(elem.num(2)) '][idx]'];
    case 2
        s = ['P[' num2str(elem.num(2)) '][idx]'];
    case 3
        s = ['B[' num2str(elem.num(2)) '][idx]'];
    case 4
        s = ['dP[' num2str(3*elem.num(2) + elem.num(3)) '][idx]'];
    case 5
        s = ['dB[' num2str(3*elem.num(2) + elem.num(3)) '][idx]'];
    case 6
        s = ['ddB[' num2str(3*(3*elem.num(2) + elem.num(3)) + elem.num(4)) '][idx]'];
end

end

% %--------------------------------------------------------------------------
% function s = l_getelem(elem)
% 
% switch elem.num(1)
%     case 0
%         s = 'w[bidx]';
%     case 1
%         s = ['dw[' num2str(elem.num(2)) '][bidx]'];
%     case 2
%         s = ['P[' num2str(elem.num(2)) '][bidx]'];
%     case 3
%         s = ['B[' num2str(elem.num(2)) '][bidx]'];
%     case 4
%         s = ['dP[' num2str(3*elem.num(2) + elem.num(3)) '][didx]'];
%     case 5
%         s = ['dB[' num2str(3*elem.num(2) + elem.num(3)) '][didx]'];
%     case 6
%         s = ['ddB[' num2str(3*(3*elem.num(2) + elem.num(3)) + elem.num(4)) '][didx]'];
% end
% 
% end
% 
%--------------------------------------------------------------------------
function out = l_str(s)

n = length(s);
out = [blanks(17-n) s];
    
end
