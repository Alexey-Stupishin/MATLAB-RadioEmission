function [num, charn] = d3str2num(s)

num = zeros(1, 4);
if strcmp(s, 'w')
    num(1) = 0;
elseif ~strcmp(s(1), 'd')
    num(1) = pick(strcmp(s(1), 'P'), 2, 3);
    num(2) = l_s2n(s(2));    
else % deriv
    s = s(2:end);
    if ~strcmp(s(1), 'd') % 1st deriv
        if strcmp(s(1), 'w')
            num(1) = 1;    
            num(2) = l_s2n(s(4));    
        else
            num(1) = pick(strcmp(s(1), 'P'), 4, 5);
            num(2) = l_s2n(s(2));    
            num(3) = l_s2n(s(5));    
        end
    else % 2nd deriv
        s = s(2:end);
        num(1) = 6;
        num(2) = l_s2n(s(2));    
        num(3) = l_s2n(s(5));    
        num(4) = l_s2n(s(8));    
    end
end

charn = ((num(1)*10 + num(2))*3 + num(3))*3 + num(4);

end

%--------------------------------------------------------------------------
function n = l_s2n(s)

switch s
    case 'x'
        n = 0;
    case 'y'
        n = 1;
    case 'z'
        n = 2;
end

end
