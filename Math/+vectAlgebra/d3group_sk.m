function root = d3group_sk(sk, mostused)

if ~exist('mostused', 'var')
    mostused = true;
end

root = [];

curr = sk;
while ~isempty(curr)
    if mostused
        count = l_count(curr);
        [~, im] = max([count.count]);
        member = count(im).member;
    else
        member = curr{1}{2};
    end
    
    dept = {};
    rest = {};
    for k = 1:length(curr)
        idx = find(strcmp(curr{k}(2:end), member));
        if isempty(idx)
            rest = {rest{:} curr{k}};
        elseif length(curr{k}) == 2
            v = curr{1}{1};
            if ~isnumeric(curr{1}{1})
                v = str2double(v);
            else
            end
            s.name = member;
            [s.num, s.charn] = vectAlgebra.d3str2num(member);
            s.tree = [];
            s.mult = v;
            root = [root s];
        else
            skk = curr{k};
            skk(idx(1)+1) = [];
            dept = {dept{:} skk};
        end
    end

    if ~isempty(dept)
        s.name = member;
        [s.num, s.charn] = vectAlgebra.d3str2num(member);
        s.tree = vectAlgebra.d3group_sk(dept, mostused);
        s.mult = 1;
        root = [root s];
    end
    
    curr = rest;
end

end

%--------------------------------------------------------------------------
function count = l_count(sk)

count = [];
for k = 1:length(sk)
    locmem = {};
    for p = 2:length(sk{k})
        idx = find(strcmp(sk{k}{p}, locmem), 1);
        if isempty(idx)
            locmem = [locmem sk{k}{p}];
        end
    end
    for p = 1:length(locmem)
        v = locmem{p};
        idx = [];
        if ~isempty(count)
            idx = find(strcmp(v, {count.member}));
        end
        if isempty(idx)
            count = [count struct('member', v, 'count', 0)];
            idx = length(count);
        end
        count(idx).count = count(idx).count + 1;
    end
end

end

%--------------------------------------------------------------------------
function v = l_getsign(s)

if isnumeric(s)
    v = sprintf('%+1d', s);
else
    v = s;
end

end

% function parent = d3group_sk(sk, parent)
% 
% if ~exist('parent', 'var')
%     parent = {};
% end
% 
% count = l_count(sk);
% if isempty(count)
%     return
% end
% [~, im] = max([count.count]);
% 
% member = count(im).member;
% skmax = {};
% skrest = {};
% for k = 1:length(sk)
%     idx = find(strcmp(sk{k}(2:end), member));
%     if isempty(idx)
%         skrest = {skrest{:} sk{k}};
%     elseif length(sk{k}) == 2
%         
%     else
%         skk = sk{k};
%         skk(idx(1)+1) = [];
%         skmax = {skmax{:} skk};
%     end
% end
% 
% if length(skmax) == 1
%     group = {};
%     if isnumeric(skmax{1}{1})
%         v = sprintf('%+1d', skmax{1}{1});
%     else
%         v = skmax{1}{1};
%     end
%     member = [v ' ' member];
% else
%     group = vectAlgebra.d3group_sk(skmax);
% end
% parent{length(parent)+1} = {member group};
% parent = vectAlgebra.d3group_sk(skrest, parent);
% 
% end
