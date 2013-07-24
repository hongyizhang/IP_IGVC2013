function ImgPredict = ProjectForward(MaskHeur)
NoPix = floor(500/8);
%% Left - Expand the mask
ImgPredict.LeftLane = zeros(600,600);
r = [];
c = [];
[r c] = find(MaskHeur.LeftLane>0);
if ~isempty(r)
    [Val Index] =  min(r);
    EndRow = r(Index);
    EndCol = c(Index);
    OffsetX = 100;
    OffsetY = 100;
%     XStart = (EndRow-1)*OffsetX+1;
%     XEnd = EndRow*OffsetX;
    XStart = (EndRow-1)*NoPix+1;
    XEnd =   (EndRow-1)*NoPix+OffsetX;
    YStart = (EndCol-1)*NoPix+1+floor(OffsetY/2);
    YEnd = (EndCol-1)*NoPix+OffsetY+floor(OffsetY/2);
    ImgPredict.LeftLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
    ImgPredict.LeftLane = ImgPredict.LeftLane.*10;
end
%% Right - Expand the mask
ImgPredict.RightLane = zeros(600,600);
r = [];
c = [];
[r c] = find(MaskHeur.RightLane>0);
if ~isempty(r)
    [Val Index] =  min(r);
    EndRow = r(Index);
    EndCol = c(Index);
    OffsetX = 100;
    OffsetY = 100;
    XStart = (EndRow-1)*NoPix+1;
    XEnd =   (EndRow-1)*NoPix+OffsetX;
    YStart = (EndCol-1)*NoPix+1+floor(OffsetY/2);
    YEnd = (EndCol-1)*NoPix+OffsetY+floor(OffsetY/2);
    ImgPredict.RightLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
%     ImgPredict.RightLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
    ImgPredict.RightLane = ImgPredict.RightLane.*20;
end