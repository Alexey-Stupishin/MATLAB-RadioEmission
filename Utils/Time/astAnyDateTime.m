function t = astAnyDateTime(s)

[t, rest] = astAnyDate(s);
if ~isempty(rest)
    [ttime, found] = astAnyTime(rest);
    if found
        t.Hour = ttime.Hour;
        t.Minute = ttime.Minute;
        t.Second = ttime.Second;
    end
end

end
