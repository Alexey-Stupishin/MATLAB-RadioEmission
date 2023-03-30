function res = asm_mmopen(im, kernel)

res = asm_dilate(asm_erode(im, kernel), kernel);

end
