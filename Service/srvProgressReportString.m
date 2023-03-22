function s = srvProgressReportString(tocID, total, curr)

ss = toc(tocID);
part = (curr-1)/total;
s = ['k=' num2str(curr) ' of ' num2str(total) ' (' num2str(part*100) '%) at ' srvSecToDisp(ss), ' s, rest.ev = ' num2str(srvSecToDisp(ss*(1/part - 1))) ' s'];
        
end
