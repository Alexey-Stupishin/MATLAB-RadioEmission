classdef d3vector < handle
    properties
        title = ''
        components = []
        base = false
    end
    
    methods (Static)
        
        function n = get_comp_n(n)
            if ischar(n)
                switch n
                    case {'x', ''}
                        n = 1;
                    case 'y'
                        n = 2;
                    case 'z'
                        n = 3;
                end
            end
        end
        
        function n = get_comp_s(n)
            if isnumeric(n)
                switch n
                    case 1
                        n = 'x';
                    case 2
                        n = 'y';
                    case 3
                        n = 'z';
                end
            end
        end
        
        function v = cross(v1, v2, title)
            x = vectAlgebra.d3sum('+', vectAlgebra.d3production(vectAlgebra.d3component(v1, 'y'), vectAlgebra.d3component(v2, 'z')), ...
                                  '-', vectAlgebra.d3production(vectAlgebra.d3component(v1, 'z'), vectAlgebra.d3component(v2, 'y')));
            y = vectAlgebra.d3sum('+', vectAlgebra.d3production(vectAlgebra.d3component(v1, 'z'), vectAlgebra.d3component(v2, 'x')), ...
                                  '-', vectAlgebra.d3production(vectAlgebra.d3component(v1, 'x'), vectAlgebra.d3component(v2, 'z')));
            z = vectAlgebra.d3sum('+', vectAlgebra.d3production(vectAlgebra.d3component(v1, 'x'), vectAlgebra.d3component(v2, 'y')), ...
                                  '-', vectAlgebra.d3production(vectAlgebra.d3component(v1, 'y'), vectAlgebra.d3component(v2, 'x')));
            if ~exist('title', 'var')
                title = 'cross';
            end
            v = vectAlgebra.d3vector(title, x, y, z);
        end
        
        function v = dot(v1, v2, title)
            c = ...
                vectAlgebra.d3sum('+', vectAlgebra.d3production(vectAlgebra.d3component(v1, 'x'), vectAlgebra.d3component(v2, 'x'))); 
                c.d3add(          '+', vectAlgebra.d3production(vectAlgebra.d3component(v1, 'y'), vectAlgebra.d3component(v2, 'y'))); 
                c.d3add(          '+', vectAlgebra.d3production(vectAlgebra.d3component(v1, 'z'), vectAlgebra.d3component(v2, 'z'))); 
            if ~exist('title', 'var')
                title = 'dot';
            end
            v = vectAlgebra.d3scalar(title, c);
        end
        
        function v = mult(v1, v2, title)
            isVect1 = isa(v1, 'vectAlgebra.d3vector');
            isVect2 = isa(v2, 'vectAlgebra.d3vector');
            assert(isVect1 ~= isVect2);
            if isVect1
                x = vectAlgebra.d3production(vectAlgebra.d3component(v1, 'x'), vectAlgebra.d3component(v2));
                y = vectAlgebra.d3production(vectAlgebra.d3component(v1, 'y'), vectAlgebra.d3component(v2));
                z = vectAlgebra.d3production(vectAlgebra.d3component(v1, 'z'), vectAlgebra.d3component(v2));
            else
                x = vectAlgebra.d3production(vectAlgebra.d3component(v1), vectAlgebra.d3component(v2, 'x'));
                y = vectAlgebra.d3production(vectAlgebra.d3component(v1), vectAlgebra.d3component(v2, 'y'));
                z = vectAlgebra.d3production(vectAlgebra.d3component(v1), vectAlgebra.d3component(v2, 'z'));
            end
            if ~exist('title', 'var')
                title = 'mult';
            end
            v = vectAlgebra.d3vector(title, x, y, z);
        end
    end
    
    methods
        function this = d3vector(title, x, y, z, base)
            this.title = title;
            if ~exist('x', 'var') || isempty(x)
                x = vectAlgebra.d3component(this, 'x');
            end
            if ~exist('y', 'var') || isempty(y)
                y = vectAlgebra.d3component(this, 'y');
            end
            if ~exist('z', 'var') || isempty(z)
                z = vectAlgebra.d3component(this, 'z');
            end
            this.components = [x y z];
            if exist('base', 'var')
                this.base = base;
            end
        end
        
        function c = clone(this)
            c = vectAlgebra.d3vector(this.title, this.components(1), this.components(2), this.components(3));
            c.base = this.base;
        end
        
        function d3add(this, sign, v)
            this.components(1).d3add(sign, v.components(1));
            this.components(2).d3add(sign, v.components(2));
            this.components(3).d3add(sign, v.components(3));
        end
        
        function s = get_string(this, s)
            s = this.components(this.get_comp_n(s)).get_string();
        end
        
        function [sx, sy, sz] = get_members(this)
            sx = this.components(1).get_members();
            sy = this.components(2).get_members();
            sz = this.components(3).get_members();
        end
        
        function [gx, gy, gz] = grouping(this)
            gx = this.components(1).grouping();
            gy = this.components(2).grouping();
            gz = this.components(3).grouping();
        end
        
        function [s, cx, cy, cz, gx, gy, gz, mx, my, mz] = resolve(this)
            s = this.simplify();
            [mx, my, mz] = s.get_members();
            [gx, gy, gz] = s.grouping();
            cx = gx.get_code();
            cy = gy.get_code();
            cz = gz.get_code();
        end
        
        function rem = rem_parensis(this, s)
            rem = this.components(this.get_comp_n(s)).rem_parensis();
        end
        
        function s = simplify(this, s)
            if ~exist('s', 'var')
                sx = this.simplify('x');
                sy = this.simplify('y');
                sz = this.simplify('z');
                s = vectAlgebra.d3vector('simplified', sx, sy, sz);
                return
            end
            
            s = this.rem_parensis(s);
        end
        
        function r = rot(this, title)
            zy = this.components(3).clone(); zy.derive('y');
            yz = this.components(2).clone(); yz.derive('z');
            x = vectAlgebra.d3sum('+', zy, '-', yz);
            
            xz = this.components(1).clone(); xz.derive('z');
            zx = this.components(3).clone(); zx.derive('x');
            y = vectAlgebra.d3sum('+', xz, '-', zx);
            
            yx = this.components(2).clone(); yx.derive('x');
            xy = this.components(1).clone(); xy.derive('y');
            z = vectAlgebra.d3sum('+', yx, '-', xy);
            
            if ~exist('title', 'var')
                title = 'rot';
            end
            r = vectAlgebra.d3vector(title, x, y, z);
        end
        
        function d = div(this, title)
            x = this.components(1).clone(); x.derive('x');
            y = this.components(2).clone(); y.derive('y');
            z = this.components(3).clone(); z.derive('z');
            c = ...
                vectAlgebra.d3sum('+', x);
                c.d3add(          '+', y);
                c.d3add(          '+', z);
            if ~exist('title', 'var')
                title = 'div';
            end
            d = vectAlgebra.d3scalar(title, c);
        end
    end
end