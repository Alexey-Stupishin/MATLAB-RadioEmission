function intensity = reuTemp2Int(temp, frequency)

intensity = temp .* frequency.^2 / 6.513e36;

end
