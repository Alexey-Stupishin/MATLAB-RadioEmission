function [subst2mod_x, subst2mod_x_w, subst2mod_x_j, subst2mod_y, subst2mod_y_w, subst2mod_y_j, subst2mod_z, subst2mod_z_w, subst2mod_z_j ...
        , subst2mod_a, subst2mod_a_w, subst2mod_a_j ...
        , subst2mod_t, subst2mod_t_w, subst2mod_t_j ...
        , subst2mod_m, subst2mod_m_w, subst2mod_m_j ...
        , subst2mod_r, subst2mod_r_w, subst2mod_r_j ...
        , subst2rest_x, subst2rest_x_w, subst2rest_x_j, subst2rest_y, subst2rest_y_w, subst2rest_y_j, subst2rest_z, subst2rest_z_w, subst2rest_z_j ...
        , subst2rest_a, subst2rest_a_w, subst2rest_a_j ...
        , subst2rest_t, subst2rest_t_w, subst2rest_t_j ...
        , subst2rest_m, subst2rest_m_w, subst2rest_m_j ...
        , subst2rest_r, subst2rest_r_w, subst2rest_r_j ...
        ] = mfm_compare_2_with_model_arrays(rest, mod, phys, bin, pattern_func, n_levels)

if ~exist('n_levels', 'var')
    n_levels = max(phys(:, 3));
end

subst2rest_x = zeros(n_levels, max(phys(:, 3)));
subst2rest_x_w = zeros(n_levels, max(phys(:, 3)));
subst2rest_x_j = zeros(n_levels, max(phys(:, 3)));
subst2rest_y = zeros(n_levels, max(phys(:, 3)));
subst2rest_y_w = zeros(n_levels, max(phys(:, 3)));
subst2rest_y_j = zeros(n_levels, max(phys(:, 3)));
subst2rest_z = zeros(n_levels, max(phys(:, 3)));
subst2rest_z_w = zeros(n_levels, max(phys(:, 3)));
subst2rest_z_j = zeros(n_levels, max(phys(:, 3)));
subst2rest_a = zeros(n_levels, max(phys(:, 3)));
subst2rest_a_w = zeros(n_levels, max(phys(:, 3)));
subst2rest_a_j = zeros(n_levels, max(phys(:, 3)));
subst2rest_t = zeros(n_levels, max(phys(:, 3)));
subst2rest_t_w = zeros(n_levels, max(phys(:, 3)));
subst2rest_t_j = zeros(n_levels, max(phys(:, 3)));
subst2rest_m = zeros(n_levels, max(phys(:, 3)));
subst2rest_m_w = zeros(n_levels, max(phys(:, 3)));
subst2rest_m_j = zeros(n_levels, max(phys(:, 3)));
subst2rest_r = zeros(n_levels, max(phys(:, 3)));
subst2rest_r_w = zeros(n_levels, max(phys(:, 3)));
subst2rest_r_j = zeros(n_levels, max(phys(:, 3)));
subst2mod_x = zeros(n_levels, max(phys(:, 3)));
subst2mod_x_w = zeros(n_levels, max(phys(:, 3)));
subst2mod_x_j = zeros(n_levels, max(phys(:, 3)));
subst2mod_y = zeros(n_levels, max(phys(:, 3)));
subst2mod_y_w = zeros(n_levels, max(phys(:, 3)));
subst2mod_y_j = zeros(n_levels, max(phys(:, 3)));
subst2mod_z = zeros(n_levels, max(phys(:, 3)));
subst2mod_z_w = zeros(n_levels, max(phys(:, 3)));
subst2mod_z_j = zeros(n_levels, max(phys(:, 3)));
subst2mod_a = zeros(n_levels, max(phys(:, 3)));
subst2mod_a_w = zeros(n_levels, max(phys(:, 3)));
subst2mod_a_j = zeros(n_levels, max(phys(:, 3)));
subst2mod_t = zeros(n_levels, max(phys(:, 3)));
subst2mod_t_w = zeros(n_levels, max(phys(:, 3)));
subst2mod_t_j = zeros(n_levels, max(phys(:, 3)));
subst2mod_m = zeros(n_levels, max(phys(:, 3)));
subst2mod_m_w = zeros(n_levels, max(phys(:, 3)));
subst2mod_m_j = zeros(n_levels, max(phys(:, 3)));
subst2mod_r = zeros(n_levels, max(phys(:, 3)));
subst2mod_r_w = zeros(n_levels, max(phys(:, 3)));
subst2mod_r_j = zeros(n_levels, max(phys(:, 3)));

[subst2mod_x(1,:), subst2mod_x_w(1,:), subst2mod_x_j(1,:), subst2mod_y(1,:), subst2mod_y_w(1,:), subst2mod_y_j(1,:), subst2mod_z(1,:), subst2mod_z_w(1,:), subst2mod_z_j(1,:) ...
    , subst2mod_a(1,:), subst2mod_a_w(1,:), subst2mod_a_j(1,:) ...
    , subst2mod_t(1,:), subst2mod_t_w(1,:), subst2mod_t_j(1,:) ...
    , subst2mod_m(1,:), subst2mod_m_w(1,:), subst2mod_m_j(1,:) ...
    , subst2mod_r(1,:), subst2mod_r_w(1,:), subst2mod_r_j(1,:) ...
    ] = mfaBaseMetrics(rest, mod, phys(:, 1), phys(:, 2), phys(:, 3));

for k = 2:n_levels
    path = feval(pattern_func, bin, k);
    subst = iouSAV2Data(path);
    if isempty(subst)
        return
    end

    [subst2mod_x(k,:), subst2mod_x_w(k,:), subst2mod_x_j(k,:), subst2mod_y(k,:), subst2mod_y_w(k,:), subst2mod_y_j(k,:), subst2mod_z(k,:), subst2mod_z_w(k,:), subst2mod_z_j(k,:) ...
        , subst2mod_a(k,:), subst2mod_a_w(k,:), subst2mod_a_j(k,:) ...
        , subst2mod_t(k,:), subst2mod_t_w(k,:), subst2mod_t_j(k,:) ...
        , subst2mod_m(k,:), subst2mod_m_w(k,:), subst2mod_m_j(k,:) ...
        , subst2mod_r(k,:), subst2mod_r_w(k,:), subst2mod_r_j(k,:) ...
        ] = mfaBaseMetrics(subst, mod, phys(:, 1), phys(:, 2), phys(:, 3));
    
    [subst2rest_x(k,:), subst2rest_x_w(k,:), subst2rest_x_j(k,:), subst2rest_y(k,:), subst2rest_y_w(k,:), subst2rest_y_j(k,:), subst2rest_z(k,:), subst2rest_z_w(k,:), subst2rest_z_j(k,:) ...
        , subst2rest_a(k,:), subst2rest_a_w(k,:), subst2rest_a_j(k,:) ...
        , subst2rest_t(k,:), subst2rest_t_w(k,:), subst2rest_t_j(k,:) ...
        , subst2rest_m(k,:), subst2rest_m_w(k,:), subst2rest_m_j(k,:) ...
        , subst2rest_r(k,:), subst2rest_r_w(k,:), subst2rest_r_j(k,:) ...
        ] = mfaBaseMetrics(subst, rest, phys(:, 1), phys(:, 2), phys(:, 3));
end

end
