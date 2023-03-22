function [xout, yout] = crdXYRotate(xin, yin, rot)

sf = sind(rot);
cf = cosd(rot);

xout =  xin*cf + yin*sf;
yout = -xin*sf + yin*cf;
    
end
