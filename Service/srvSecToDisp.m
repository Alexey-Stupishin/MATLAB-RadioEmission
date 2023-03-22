function s = srvSecToDisp(sec)

if (sec < 60)
    s = num2str(round(sec), '%ds');
else
    if (sec < 3600)
        min = floor(sec/60);
        sec = round(sec-min*60);
        s = [num2str(min, '%dm') num2str(sec, '%ds')];
    else
        hr = floor(sec/3600);
        min = round((sec-hr*3600)/60);
        s = [num2str(hr, '%dh') num2str(min, '%dm')];
    end
end

end
