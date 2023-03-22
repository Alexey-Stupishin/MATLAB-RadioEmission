function reoSetAtmosphere3D(hLib, H, T, D, model_mask, model_mask_used)

sz = size(H);
Lmask = ones(1, sz(1)) * sz(2);

gstSetAtmosphereMask(hLib, int32(model_mask), int32(model_mask_used), H', T', D', int32(Lmask));

end
