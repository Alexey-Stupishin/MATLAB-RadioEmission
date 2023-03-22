function rd = ircRunDiff(vvk, vvk1)

rd = vvk - vvk1;

% [k, b] = xlinfit(vvk, vvk1);
% rd = (k*vvk+b) - vvk1;

% [Vx, Vy, beta, kb, kyx, kxy] = asmPrincComp2D(vvk, vvk1);
 
% xscatter(vvk, vvk1);
% disp([num2str(k) ' ' num2str(b)])
% xscatter(k*vvk+b, vvk1);
% disp([num2str(beta) ' ' num2str(kb) ' ' num2str(kyx) ' ' num2str(kxy)])

end
