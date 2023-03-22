classdef d3scalar < handle
    properties
        title = ''
        components = []
        base = false
    end
    
    methods(Static)
        function v = mult(v1, v2, title)
            isScal1 = isa(v1, 'vectAlgebra.d3scalar');
            isScal2 = isa(v2, 'vectAlgebra.d3scalar');
            assert(isScal1 && isScal2);
            c = vectAlgebra.d3production(vectAlgebra.d3component(v1), vectAlgebra.d3component(v2));
            if ~exist('title', 'var')
                title = 'mult';
            end
            v = vectAlgebra.d3scalar(title, c);
        end
    end
    
    methods
        function this = d3scalar(title, s, base)
            this.title = title;
            if ~exist('s', 'var') || isempty(s)
                s = vectAlgebra.d3component(this, '');
            end
            this.components = s;
            if exist('base', 'var')
                this.base = base;
            end
        end
        
        function c = clone(this)
            c = vectAlgebra.d3scalar(this.title, this.components);
            c.base = this.base;
        end
        
        function s = get_string(this)
            s = this.components(1).get_string();
        end
        
        function s = get_members(this)
            s = this.components(1).get_members();
        end
        
        function g = grouping(this)
            g = this.components(1).grouping();
        end
        
        function [s, c, g, m] = resolve(this)
            s = this.simplify();
            m = s.get_members();
            g = s.grouping();
            c = g.get_code();
        end
        
        function s = rem_parensis(this)
            s = this.components(1).rem_parensis();
        end
        
        function s = simplify(this)
            s = this.rem_parensis();
        end
        
        function r = grad(this, title)
            xc = this.components(1).clone(); xc.derive('x');
            x = vectAlgebra.d3sum('+', xc);
            yc = this.components(1).clone(); yc.derive('y');
            y = vectAlgebra.d3sum('+', yc);
            zc = this.components(1).clone(); zc.derive('z');
            z = vectAlgebra.d3sum('+', zc);
            
            if ~exist('title', 'var')
                title = 'grad';
            end
            r = vectAlgebra.d3vector(title, x, y, z);
        end
    end
end