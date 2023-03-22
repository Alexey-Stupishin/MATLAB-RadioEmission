function [solar_p, solar_b, solar_r, sol_dec] = asuGetSolarPar(jd)

jd0 = jd - 2455197.5;

solar_p =  -0.01714 + 26.4732  * sin(pi * (jd0 - 187.45076)/182.63224);
solar_b =   0.05526 +  7.24325 * sin(pi * (jd0 - 157.55261)/182.63492);
solar_r = 958.965   + 16.01591 * sin(pi * (jd0 +  88.75546)/182.63375);
sol_dec =   0.37784 + 23.26099 * sin(pi * (jd0 -  80.56224)/182.62583);

end
