function temp = reuFlux2Temp(flux, step, frequency)

if length(step) == 1
    step = [step step];
end

temp = reuInt2Temp(flux/(2.35e8*step(1)*step(2)), frequency);

end
