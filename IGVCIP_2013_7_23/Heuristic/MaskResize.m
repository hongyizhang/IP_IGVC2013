function MaskImg = MaskResize(I,Mask)
[R,C,CH] = size(I);
[RM,CM,CHM] = size(Mask);
SubImgHeight = floor(R/RM);
SybImgWidth = floor(C/CM);
MaskImg = zeros(R,C,1);
for r=0:1:RM-1
    r_start = r*SubImgHeight+1;
    r_end = (r+1)*SubImgHeight;
    for c=0:1:CM-1
        c_start = c*SybImgWidth+1;
        c_end = (c+1)*SybImgWidth;
        if Mask(r+1,c+1)>0
            MaskImg(r_start:r_end,c_start:c_end) = ones(r_end-r_start+1,c_end-c_start+1);
        end        
    end
end
end