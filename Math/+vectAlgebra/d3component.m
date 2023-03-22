classdef d3component < handle
    properties
        primitive_name = ''
        factor = 1;
        parent = []
        component = ''
        derivative = []
    end
    
    methods
        function this = d3component(parent, component, primitive_name)
            if exist('parent', 'var')
                this.parent = parent;
            end
            if exist('component', 'var')
                this.component = component;
            end
            if exist('primitive_name', 'var')
                this.primitive_name = primitive_name;
            end
        end
        
        function c = clone_comp(this)
            c = vectAlgebra.d3component();
            this.copy_to(c);
        end
        
        function c = clone(this)
            c = this.clone_comp();
        end
        
        function copy_to(this, c)
            c.primitive_name = this.primitive_name;
            c.factor = this.factor;
            c.parent = this.parent;
            c.component = this.component;
            c.derivative = this.derivative;
        end
        
        function s = get_string(this)
            s = '';
            if ~isempty(this.parent)
                s = [s this.parent.title];
            end
            s = [s this.component];
            for k = 1:length(this.derivative)
                s = ['d' s '/d' vectAlgebra.d3vector.get_comp_s(this.derivative(k))];
            end
            if ~isempty(this.derivative)                
                s = ['[' s ']'];
            end
        end
        
        function s = get_code(this, ~)
            s = this.primitive_name;
            need_par = false;
            if isnumeric(s)
                need_par = s < 0;
                s = num2str(s);
            end
            if need_par
                s = ['(' s ')'];
            end
        end
        
        function s = get_code2(this, ~)
            s = this.primitive_name;
            need_par = false;
            if isnumeric(s)
                need_par = s < 0;
                s = num2str(s);
            end
            if need_par
                s = ['(' s ')'];
            end
        end
        
        function s = get_members(this)
            s = [this.parent.title this.component];
            for k = 1:length(this.derivative)
                s = ['d' s '_d' vectAlgebra.d3vector.get_comp_s(this.derivative(k))];
            end
            this.primitive_name = s;
        end
        
        function is = is_name(this, name)
            is = strcmp(name, this.primitive_name);
        end
        
        function comp = get_comp_by_name(this, name)
            comp = [];
            if strcmp(this.primitive_name, name)
                comp = this;
            end
        end

        function result = remove_by_name(this, name)
            assert(strcmp(this.primitive_name, name))
            result = vectAlgebra.d3component([], ''); 
            result.primitive_name = this.factor;
        end
        
        function [unique, counter] = statistics(this, unique, counter)
            if isempty(this.primitive_name) || isnumeric(this.primitive_name)
                return
            end
            idx = find(strcmp(this.primitive_name, unique));
            if isempty(idx)
                unique = [unique, {this.primitive_name}];
                idx = length(unique);
                counter(idx) = 0;
            end
            counter(idx) = counter(idx) + 1;
        end
            
        function simp = rem_parensis(this)
            if this.parent.base
                simp = this.clone;
            else
                simp = this.parent.components(vectAlgebra.d3vector.get_comp_n(this.component)).clone();
                simp = simp.rem_parensis();
                simp.derivative = this.derivative;
            end
            simp.derive_proceed();
        end
        
        function rem = post_correction(this)
            rem = this;
        end
        
        function derive(this, coord)
            this.derivative = [this.derivative vectAlgebra.d3vector.get_comp_n(coord)];
            this.derivative = sort(this.derivative);
        end
        
        function node_new = grouping(this) % need subclassing
            node_new = this;
        end

    end
    
    methods (Access = protected)
        function derv = derive_proceed(this)
            derv = this.clone();
            for k = 1:length(this.derivative)
                derv = derv.derive_proceed1(this.derivative(k));
            end
        end
        
        function derv = derive_proceed1(this, ~)
            derv = this;
        end
    end
end
