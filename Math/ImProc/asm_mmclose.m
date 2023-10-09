function res = asm_mmclose(im, kernel)

res = asm_erode(asm_dilate(im, kernel), kernel);

end
