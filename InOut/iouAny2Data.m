function out = iouAny2Data(filename)

out = iouBIN2Data(filename);
if isempty(out)
    disp('no BIN file')
    out = iouSAV2Data(filename);
    if isempty(out)
        disp('no SAV file')
    else
        if isfield(out, 'MFODATA')
            out = out.MFODATA;
        end
    end
end

end
