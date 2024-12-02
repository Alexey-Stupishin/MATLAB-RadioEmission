function ximq(B)

hAx = xssuImage(B.z);
hold(hAx, 'on')

ssuQuiver(hAx, B.x, B.y, 'g');

end
