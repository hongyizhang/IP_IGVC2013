function BW = preprocess(RGB)
Blue = RGB(:,:,3);
BW = im2bw(Blue);
end