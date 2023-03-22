function  flux = reuTemp2Flux(temp, step, frequency)

if length(step) == 1
    step = [step step];
end

flux = (2.35e8*step(1)*step(2)) * reuTemp2Int(temp, frequency);

end
