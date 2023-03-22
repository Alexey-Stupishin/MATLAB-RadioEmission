classdef d3sum < vectAlgebra.d3component
    properties
        sum = {}
        sign = [];
    end
    
    methods % Utility methods
        function this = d3sum(sign1, s1, sign2, s2)
            if ~exist('sign1', 'var') || ~exist('s1', 'var')
                return
            end
            this.sign = this.set_sign(sign1);
            this.sum = {s1};
            
            if exist('sign2', 'var') && exist('s2', 'var')
                this.d3add(sign2, s2);
            end
        end
        
        function this = d3add(this, sign, s)
            this.sign = [this.sign this.set_sign(sign)];
            this.sum = [this.sum {s}];
        end

        function c = clone_comp(this)
            c = vectAlgebra.d3sum();
            this.copy_to(c);
        end

        function c = clone(this)
            c = this.clone_comp();
            c.sum = this.sum;
            c.sign = this.sign;
        end
        
        function s = get_string(this)
            s = '(';
            for k = 1:length(this.sum)
                sk = this.sum{k}.get_string();
                sgn = pick(this.sign(k) > 0, '+', '-');
                if k == 1 && strcmp(sgn, '+')
                    sgn = '';
                end
                s = [s sgn sk];
            end
            s = [s ')'];
        end
        
        function s = get_code(this, ext)
            if ~exist('ext', 'var')
                ext = true;
            end
%             if ~ext && length(this.sum) == 1 && (isa(this.sum{1}, 'vectAlgebra.d3production') || ...
%                                                  (isnumeric(this.sum{1}.primitive_name && this.sum{1}.primitive_name >= 0)))
%                 ext = true;
%             end
            s = pick(ext, '', '(');
            for k = 1:length(this.sum)
                try
                sk = this.sum{k}.get_code(false);
                catch sle
                    stophere = 1;
                end
                sgn = pick(this.sign(k) > 0, '+', '-');
                if k == 1 && strcmp(sgn, '+')
                    sgn = '';
                end
                s = [s sgn sk];
            end
            if ~ext
                s = [s ')'];
            end
        end
        
        function list = get_members(this)
            for k = 1:length(this.sum)
                v = this.sum{k}.get_members();
                list{k} = [{pick(this.sign(k) > 0, '+', '-')} v];
            end
        end
        
        function [unique, counter] = statistics(this, unique, counter)
            for k = 1:length(this.sum)
                [unique, counter] = this.sum{k}.statistics(unique, counter);
            end
        end
        
        function rem = rem_parensis(this)
            rem = this.clone().rem_parensis_proceed();
            rem = rem.derive_proceed();
            rem = rem.post_correction();
        end
        
        function rem = rem_parensis_proceed(this)
            sums = this.sum;
            rem = this.clone_comp();
            for ks = 1:length(sums)
                crem = sums{ks}.rem_parensis();
                if isa(crem, 'vectAlgebra.d3sum')
                    for kc = 1:length(crem.sum)
                        rem.d3add(this.sign(ks)*crem.sign(kc), crem.sum{kc});
                    end
                else
                    rem.d3add(this.sign(ks), crem.rem_parensis());
                end
            end
        end
        
        function rem = post_correction(this)
            rem = this.clone_comp();
            for k = 1:length(this.sum)
                upd = this.sum{k}.post_correction();
                if isa(this.sum{k}, 'vectAlgebra.d3sum')
                    for ku = 1:length(upd.sum)
                        rem.d3add(this.sign(k)*upd.sign(ku), upd.sum{ku});
                    end
                else
                    rem.d3add(this.sign(k), upd);
                end
            end
        end
        
        function node_new = grouping(this)
            [unique, counter] = this.statistics({}, []);

            rest1 = vectAlgebra.d3sum();
            rest2 = vectAlgebra.d3sum();
            mcomp = [];

            [maxn, im] = max(counter);
            if isempty(unique) || maxn == 1
                node_new = this.final_simplify();
                return
            end

            name = unique{im};
            for k = 1:length(this.sum)
                mc = this.sum{k}.get_comp_by_name(name); 
                if ~isempty(mc) && ~isa(mc, 'vectAlgebra.d3production')
                    if isempty(mcomp)
                        mcomp = mc; 
                    end
                    nprod = this.sum{k}.clone();
                    result = nprod.remove_by_name(name);
                    rest1.d3add(this.sign(k), result);
                else
                    rest2.d3add(this.sign(k), this.sum{k}.clone());
                end
            end

            node1 = [];
            if ~isempty(rest1.sum)
                node_rest1 = rest1.grouping();
                node1 = vectAlgebra.d3production(mcomp, node_rest1);
            end
            
            if isempty(rest2.sum)
                node_new = node1;
            else
                if ~isempty(rest1)
                    if length(rest2.sum) == 1 && isa(rest2.sum{1}, 'vectAlgebra.d3production')
                        node_rest2 = rest2.sum{1};
                    else
                        node_rest2 = rest2.grouping();
                    end
                    node_new = vectAlgebra.d3sum('+', node1, '+', node_rest2);
                else
                    node_new = rest2.final_simplify();
                end
            end
        end

        function rem = final_simplify(this)
            const = 0;
            remains = [];
            for k = 1:length(this.sum)
                if ~isa(this.sum{k}, 'vectAlgebra.d3production') && isnumeric(this.sum{k}.primitive_name)
                    const = const + this.sign(k)*this.sum{k}.primitive_name;
                else
                    remains = [remains k];
                end
            end
            rem = [];
            if isempty(remains)
                rem = vectAlgebra.d3component([], '', const);
            else
                rem = vectAlgebra.d3sum();
                for k = 1:length(remains)
                    rem.d3add(this.sign(remains(k)), this.sum{remains(k)});
                end
                if const ~= 0
                    rem.d3add(pick(const < 0, '-', '+'), abs(const));
                end
            end
        end
    end
    
    
    methods (Access = protected)
        function derv = derive_proceed1(this, coord)
            derv = vectAlgebra.d3sum();
            for k = 1:length(this.sum)
                m = this.sum{k}.clone();
                m.derive(coord);
                m = m.derive_proceed();
                derv.d3add(this.sign(k), m);
            end
        end
    end
    
    methods (Static)
        function c = set_sign(s)
            c = zeros(1, length(s));
            for k = 1:length(s)
                if ischar(s(k))
                    c(k) = pick(strcmp(s, '+'), 1, -1);
                else
                    c(k) = s(k);
                end
            end
        end
    end
end
