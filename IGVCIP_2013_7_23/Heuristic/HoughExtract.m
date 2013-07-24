% This function decomposes the binary image to multiple subimages and
% extracts the lines in subimages using Hough transform.
% * Input: Binary Image
% * Output: edge Image in binary
% * Call the function:
%       [EdgeImg] = HoughExtract(BW,4,4,1)

function   [EdgeImg] = HoughExtract(BW,NoRow,NoCol,NoPeaks)
%% Verify the inputs
% Verify arguments
switch nargin
    case 1
        NoRow = 1;
        NoCol = 1;
        NoPeaks = 1;
    case 2
        NoCol = 1;
        NoPeaks = 1;
    case 3
        NoPeaks = 1;
    case 4
    otherwise
        error('Number of input arguments of HoughExtract is from 1 to 4');
end
% Verify the Input Image
[R,C,CH] = size(BW);
if (R*C<1000)
    warning('Input Image is too small');
end
%% Decompose the image
EdgeImg = zeros(R,C,1);
SubImg_Height = floor(R/NoRow);
SubImg_Width = floor(C/NoCol);
% Check the Width and Height of subimage
if ((SubImg_Height<=1)||(SubImg_Width<=1))
    error('Subimage is too small, Please reduce the number of subimages');
end
% Start Process subimages
NoRow = uint16(NoRow);
NoCol = uint16(NoCol);   
for r=0:NoRow-1
    r_start = r*SubImg_Height+1;
    r_end = (r+1)*SubImg_Height;
    for c=0:NoCol-1
        c_start = c*SubImg_Width+1;
        c_end = (c+1)*SubImg_Width;
        Temp = [];
        Temp_E = [];
        Temp = BW(r_start:r_end,c_start:c_end);
        Temp_E = SubHough(Temp);
        EdgeImg(r_start:r_end,c_start:c_end) = Temp_E;    
    end
end
end