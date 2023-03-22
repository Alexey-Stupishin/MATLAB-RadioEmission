classdef d3derivative < vectAlgebra.d3component
    properties
        coordinate = '';
        v = [];
    end
    
    methods
        function this = d3derivative(v, coordinate)
            this.v = v;
            this.coordinate = coordinate;
        end
    end
end