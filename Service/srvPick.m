function value = srvPick( index, varargin )
    % Returns second or latter parameter by logical or numerical index (first parameter)
    
    if islogical(index)
        assert(length(varargin) == 2);
        if index
            value = varargin{1};
        else
            value = varargin{2};
        end
        
    elseif isnumeric(index)
        value = varargin{index};
        
    else
        error('MD3:Pick', 'Value %g is not logical nor numeric', index);
    end
    
end

