function [Mask88] = MaskGenerate(BW)
[R,C,CH] = size(BW);
q_Height = floor(R/8);
q_Width = floor(C/8);
Mask = zeros(R,C,1);
Mask88 = zeros(8,8,1);
for r=0:1:7
    r_start = r*q_Height+1;
    r_end = (r+1)*q_Height;
    for c=0:1:7
        c_start = c*q_Width+1;
        c_end = (c+1)*q_Width;
        Temp = [];
        Temp = BW(r_start:r_end,c_start:c_end);
        S = sum(Temp(:));
        if S >0
            Mask(r_start:r_end,c_start:c_end) = ones(r_end-r_start+1,c_end-c_start+1);
            Mask88(r+1,c+1) = 1;
        end
    end
end
end