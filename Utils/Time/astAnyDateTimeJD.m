function [jd, tf] = astAnyDateTimeJD(s)

tf = astAnyDateTime(s);
jd = juliandate(datetime(tf.Year, tf.Month, tf.Day, tf.Hour, tf.Minute, tf.Second));

end

