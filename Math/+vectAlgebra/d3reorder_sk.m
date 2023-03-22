function sk = d3reorder_sk(sk)

global d3utils
d3utils.unique = {};
d3utils.counter = [];

for k = 1:length(sk)
    sk{k}(2:end) = reorder(sk{k}(2:end));
end

end

%--------------------------------------------------------------------------
function idx = findthis(list, item)

idx = [];
for k = 1:length(list)
    if strcmp(list{k}, item)
        idx = [idx k];
    end
end

end

%--------------------------------------------------------------------------
function ord = reorder(list)

c = {'x' 'y' 'z'};
ord = {};
p = 1;

s = 'w';
idx = findthis(list, s);
for k = 1:length(idx)
    [ord, p] = process_ord(ord, p, s);
end

s = 'Z';
idx = findthis(list, s);
for k = 1:length(idx) 
    [ord, p] = process_ord(ord, p, s);
end
for kc = 1:length(c)
    s = ['dZ_d' c{kc}]; 
    idx = findthis(list, s);
    for k = 1:length(idx) 
        [ord, p] = process_ord(ord, p, s);
    end
end

for kc = 1:length(c)
    s = ['P' c{kc}]; 
    idx = findthis(list, s);
    for k = 1:length(idx) 
        [ord, p] = process_ord(ord, p, s);
    end
end

for kc = 1:length(c)
    s = ['B' c{kc}]; 
    idx = findthis(list, s);
    for k = 1:length(idx) 
        [ord, p] = process_ord(ord, p, s);
    end
end

for kc = 1:length(c)
    s = ['dw_d' c{kc}]; 
    idx = findthis(list, s);
    for k = 1:length(idx) 
        [ord, p] = process_ord(ord, p, s);
    end
end

for kc = 1:length(c)
    for kc2 = 1:length(c)
        s = ['dP' c{kc} '_d' c{kc2}]; 
        idx = findthis(list, s);
        for k = 1:length(idx) 
            [ord, p] = process_ord(ord, p, s);
        end
    end
end

for kc = 1:length(c)
    for kc2 = 1:length(c)
        s = ['dB' c{kc} '_d' c{kc2}]; 
        idx = findthis(list, s);
        for k = 1:length(idx) 
            [ord, p] = process_ord(ord, p, s);
        end
    end
end

for kc = 1:length(c)
    for kc2 = 1:length(c)
        for kc3 = 1:length(c)
            s = ['ddB' c{kc} '_d' c{kc2} '_d' c{kc3}]; 
            idx = findthis(list, s);
            for k = 1:length(idx) 
                [ord, p] = process_ord(ord, p, s);
            end
        end
    end
end

end

%--------------------------------------------------------------------------
function [ord, p] = process_ord(ord, p, s)

global d3utils

ord{p} = s;
p = p + 1;

idx = find(strcmp(s, d3utils.unique));
if isempty(idx)
    d3utils.unique = [d3utils.unique {s}];
    idx = length(d3utils.unique);
    d3utils.counter(idx) = 0;
end
d3utils.counter(idx) = d3utils.counter(idx) + 1;

end

