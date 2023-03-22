function posangle = rtnGetPositionAngle(azimuth, sol_dec, solar_p)

if solar_p > 180
    solar_p = solar_p - 360;
end
if solar_p < -180
    solar_p = solar_p + 360;
end

posangle = solar_p + asind(-tand(azimuth)* tand(sol_dec));

end
