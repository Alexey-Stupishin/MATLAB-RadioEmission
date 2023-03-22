classdef d3production < vectAlgebra.d3component
    properties
        multipliers = {};
    end
    
    methods % Utility methods
        
        function this = d3production(m1, m2)
            if ~exist('m1', 'var')
                return
            end
            this.multipliers = {m1};
            if exist('m2', 'var')
                this.d3mult(m2);
            end
        end
        
        function this = d3mult(this, m)
            this.multipliers = [this.multipliers {m}];
        end
        
        function c = clone_comp(this)
            c = vectAlgebra.d3production();
            this.copy_to(c);
        end
        
        function c = clone(this)
            c = this.clone_comp();
            c.multipliers = this.multipliers;
        end
        
        function s = get_string(this)
            s = '';
            for k = 1:length(this.multipliers)
                sk = this.multipliers{k}.get_string();
                if ~isempty(s)
                    s = [s '*'];
                end
                s = [s sk];
            end
        end
        
        function s = get_code(this, ~)
            s = '';
            for k = 1:length(this.multipliers)
                sk = this.multipliers{k}.get_code(false);
                if ~isempty(s)
                    s = [s '*'];
                end
                s = [s sk];
            end
        end
        
        function list = get_members(this)
            for k = 1:length(this.multipliers)
                list{k} = this.multipliers{k}.get_members();
            end
        end
        
        function comp = get_comp_by_name(this, name)
            comp = [];
            for k = 1:length(this.multipliers)
                if this.multipliers{k}.is_name(name)
                    comp = this.multipliers{k};
                    break
                end
            end
        end
        
        function result = remove_by_name(this, name)
            if length(this.multipliers) == 1
                %result = this.multipliers{1};
                result = vectAlgebra.d3component([], '', this.factor);
            else
                for k = 1:length(this.multipliers)
                    if this.multipliers{k}.is_name(name)
                        this.multipliers(k) = [];
                        break
                    end
                end
                result = this;
            end
        end
        
        function [unique, counter] = statistics(this, unique, counter)
            for k = 1:length(this.multipliers)
                [unique, counter] = this.multipliers{k}.statistics(unique, counter);
            end
        end
        
        function rem = rem_parensis(this)
            rem = this.clone().rem_parensis_proceed();
            rem = rem.derive_proceed();
            rem = rem.post_correction();
        end

        function simp = simplify2(this)
        	m1 = this.multipliers{1}.clone();
            if ~isa(m1, 'vectAlgebra.d3sum')
                m1 = vectAlgebra.d3sum('+', m1);
            end
                
        	m2 = this.multipliers{2}.clone();
            if ~isa(m2, 'vectAlgebra.d3sum')
                m2 = vectAlgebra.d3sum('+', m2);
            end
            
            simp = vectAlgebra.d3sum();
            for k1 = 1:length(m1.sum)
                for k2 = 1:length(m2.sum)
                    simp.d3add(m1.sign(k1)*m2.sign(k2), vectAlgebra.d3production(m1.sum{k1}, m2.sum{k2}));
                end
            end
        end
        
        function rem = rem_parensis_proceed(this)
            mults = this.multipliers;
            mrem = cell(1, length(mults));
            for kr = 1:length(mults)
                mrem{kr} = mults{kr}.clone().rem_parensis();
            end

            rem = mrem{end};
            for kr = length(mrem)-1:-1:1
                t = this.clone_comp();
                t.d3mult(mrem{kr});
                t.d3mult(rem);
                rem = t.simplify2();
            end
            
        end
        
        function rem = post_correction(this)
            rem = this.clone_comp();
            for k = 1:length(this.multipliers)
                upd = this.multipliers{k}.post_correction();
                if isa(this.multipliers{k}, 'vectAlgebra.d3production')
                    for ku = 1:length(upd.multipliers)
                        rem.d3mult(upd.multipliers{ku});
                    end
                else
                    rem.d3mult(upd);
                end
            end
        end
    end
    
    methods (Access = protected)
        function derv = derive_proceed1(this, coord)
            derv = vectAlgebra.d3sum();
            for k = 1:length(this.multipliers)
                prod_derv = vectAlgebra.d3production();

                for kd = 1:length(this.multipliers)
                    c = this.multipliers{kd}.clone();
                    if k == kd
                        c.derive(coord);
                        c = c.derive_proceed();
                    end
                    prod_derv.d3mult(c);
                end

                derv.d3add(1, prod_derv);
            end
        end
    end
end