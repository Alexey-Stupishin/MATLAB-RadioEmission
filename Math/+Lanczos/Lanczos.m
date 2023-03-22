classdef Lanczos < handle
    properties
        a = 2
        n_steps = 100000
        lanz_win = []
        lanz_step = 0
    end
    
    methods
        function this = Lanczos(a_, n_steps_)
            if ~exist('a_', 'var')
                a_= 2;
            end
            this.a = a_;
            if ~exist('n_steps_', 'var')
                n_steps_= 100000;
            end
            this.n_steps = n_steps_;
            
            this.lanz_win = asmGetLanczosWindow(this.a, this.n_steps);
            this.lanz_step = 1/this.n_steps;
        end
        
        function [nsteps, xf] = get_size(~, f, f_step)
            [nsteps, xf] = asmGetLanczosSize(f, f_step);
        end
         
        function [resamp, xres] = resample(this, f, f_step)
            [resamp, xres] = asmGetLanczosResample(f, f_step, this.lanz_win, this.a, this.lanz_step);
        end
         
        function [resamp, xres1, xres2] = resample2D(this, f, f_step)
            nsteps1 = asmGetLanczosSize(f(:, 1), f_step);
            nsteps2 = asmGetLanczosSize(f(1, :), f_step);
            res1 = zeros(size(f, 1), nsteps2);
            for k = 1:size(res1, 1)
                [res1(k, :), xres2] = asmGetLanczosResample(f(k, :), f_step, this.lanz_win, this.a, this.lanz_step);
            end
            resamp = zeros(nsteps1, nsteps2);
            for k = 1:nsteps2
                [r, xres1] = asmGetLanczosResample(res1(:, k), f_step, this.lanz_win, this.a, this.lanz_step);
                resamp(:, k) = r';
            end
        end
    end
end
