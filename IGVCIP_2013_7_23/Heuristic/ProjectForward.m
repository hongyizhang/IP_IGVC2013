function ImgPredict = ProjectForward(MaskHeur,mm_per_Pixel,row,col)
% NoPix = floor(500/8);
ExtraRow = ceil(1000/mm_per_Pixel);
ExtraCol = ceil(1000/mm_per_Pixel);
% [row col] = size(MaskHeur.Overall);
NoPixrow = floor(row/8);
NoPixcol = floor(col/8);
row = row+ExtraRow;
col = col+ExtraCol;
ImgPredict.LeftLane =zeros(row,col);
ImgPredict.RightLane =zeros(row,col);
OffsetX = ExtraRow;
    OffsetY = ExtraCol;
%% Left - Expand the mask
% ImgPredict.LeftLane = zeros(600,600);
ImgPredict.LeftLane = zeros(row,col);
r = [];
c = [];
[r c] = find(MaskHeur.LeftLane>0);
if ~isempty(r)
    [Val Index] =  min(r);
    EndRow = r(Index);
    EndCol = c(Index);
    %% Mean of the Left Lane
    CenterRow = mean(r);
    CenterCol = mean(c);
    dr = CenterRow - EndRow;
    dc = CenterCol - EndCol;
    %     OffsetX = 100;
    %     OffsetY = 100;
%     OffsetX = ExtraRow;
%     OffsetY = ExtraCol;
    if dr~=0
        ColShift = floor(-31*dc/dr); % 31 = (500/8)/2: half of the height of a cell in 8x8 Mask
        %     XStart = (EndRow-1)*OffsetX+1;
        %     XEnd = EndRow*OffsetX;
        %         XStart = (EndRow-1)*NoPix+1;
        %         XEnd =   (EndRow-1)*NoPix+OffsetX;
        %         YStart = (EndCol-1)*NoPix+floor(NoPix/2)+1+floor(OffsetY/2)+ColShift;
        %         YEnd = (EndCol-1)*NoPix+floor(NoPix/2)+OffsetY+floor(OffsetY/2)+ColShift;
        XStart = (EndRow-1)*NoPixrow+1;
        XEnd =   (EndRow-1)*NoPixrow+OffsetX;
        YStart = (EndCol-1)*NoPixcol+floor(NoPixcol/2)+1+floor(OffsetY/2)+ColShift;
        YEnd = (EndCol-1)*NoPixcol+floor(NoPixcol/2)+OffsetY+floor(OffsetY/2)+ColShift;
        if YStart<0
            YStart = 1;
            %             YEnd = 100;
            YEnd = OffsetY;
            %         elseif YEnd > 600
        elseif YEnd > row
            %             YStart = 501;
            %             YEnd = 600;
            
            YEnd = row;
            YStart = YEnd-OffsetY+1;
        end
        ImgPredict.LeftLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
        % ImgPredict.LeftLane(YStart:YEnd,XStart:XEnd) = ones(OffsetX,OffsetY);
        ImgPredict.LeftLane = ImgPredict.LeftLane.*10;
    else
        %         XStart = (EndRow-1)*NoPix+floor(OffsetX/2)+1;
        %         XEnd =   (EndRow-1)*NoPix+floor(OffsetX*3/2);
        %         YStart = (EndCol-1)*NoPix+1+OffsetY;
        %         YEnd = (EndCol-1)*NoPix+OffsetY*2;
        XStart = (EndRow-1)*NoPixrow+1;
        XEnd =   (EndRow-1)*NoPixrow+OffsetX;
        YStart = (EndCol-1)*NoPixcol+floor(NoPixcol/2)+1+floor(OffsetY/2);
        YEnd = (EndCol-1)*NoPixcol+floor(NoPixcol/2)+OffsetY+floor(OffsetY/2);
        if YStart<0
            YStart = 1;
            YEnd = OffsetY;
        elseif YEnd > row
            YStart = row-OffsetY+1;
            YEnd = row;
        end
        ImgPredict.LeftLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
        ImgPredict.LeftLane = ImgPredict.LeftLane.*10;
    end
    %         if YStart<0
    %             YStart = 1;
    %             YEnd = 100;
    %         elseif YEnd > 600
    %             YStart = 501;
    %             YEnd = 600;
    %         end
    %         if YStart<0
    %             YStart = 1;
    %             YEnd = OffsetY;
    %         elseif YEnd > row
    %             YStart = row-OffsetY+1;
    %             YEnd = row;
    %         end
    %         ImgPredict.LeftLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
    %         ImgPredict.LeftLane = ImgPredict.LeftLane.*10;
end
%% Find the project direction
%     if EndRow < 8
%         Temp = MaskHeur.LeftLane(EndRow+1);
%         IndexLeft = find(Temp>0);
%         if isempty(IndexLeft)
%             if EndRow < 7
%                 Temp = MaskHeur.LeftLane(EndRow+2);
%                 IndexLeft = find(Temp>0);
%             end
%             if isempty(IndexLeft)
%             end
%         end
%
%     end
%     OffsetX = 100;
%     OffsetY = 100;
%     %     XStart = (EndRow-1)*OffsetX+1;
%     %     XEnd = EndRow*OffsetX;
%     XStart = (EndRow-1)*NoPix+1;
%     XEnd =   (EndRow-1)*NoPix+OffsetX;
%     YStart = (EndCol-1)*NoPix+1+floor(OffsetY/2);
%     YEnd = (EndCol-1)*NoPix+OffsetY+floor(OffsetY/2);
%     ImgPredict.LeftLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
%     ImgPredict.LeftLane = ImgPredict.LeftLane.*10;
% end
%% Right - Expand the mask
% ImgPredict.RightLane = zeros(600,600);
% ImgPredict.RightLane = zeros(row,col);
r = [];
c = [];
[r c] = find(MaskHeur.RightLane>0);
% if ~isempty(r)
%     [Val Index] =  min(r);
%     EndRow = r(Index);
%     EndCol = c(Index);
%     OffsetX = 100;
%     OffsetY = 100;
%     XStart = (EndRow-1)*NoPix+1;
%     XEnd =   (EndRow-1)*NoPix+OffsetX;
%     YStart = (EndCol-1)*NoPix+1+floor(OffsetY/2);
%     YEnd = (EndCol-1)*NoPix+OffsetY+floor(OffsetY/2);
%     ImgPredict.RightLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
%     %     ImgPredict.RightLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
%     ImgPredict.RightLane = ImgPredict.RightLane.*20;
% end
if ~isempty(r)
    [Val Index] =  min(r);
    EndRow = r(Index);
    EndCol = c(Index);
    %% Mean of the Left Lane
    CenterRow = mean(r);
    CenterCol = mean(c);
    dr = CenterRow - EndRow;
    dc = CenterCol - EndCol;
    %     OffsetX = 100;
    %     OffsetY = 100;
    if dr~=0
        ColShift = floor(-31*dc/dr); % 31 = (500/8)/2: half of the height of a cell in 8x8 Mask
        %     XStart = (EndRow-1)*OffsetX+1;
        %     XEnd = EndRow*OffsetX;
        %         XStart = (EndRow-1)*NoPix+1;
        %         XEnd =   (EndRow-1)*NoPix+OffsetX;
        %         YStart = (EndCol-1)*NoPix+floor(NoPix/2)+1+floor(OffsetY/2)+ColShift;
        %         YEnd = (EndCol-1)*NoPix+floor(NoPix/2)+OffsetY+floor(OffsetY/2)+ColShift;
        XStart = (EndRow-1)*NoPixrow+1;
        XEnd =   (EndRow-1)*NoPixrow+OffsetX;
        YStart = (EndCol-1)*NoPixcol+floor(NoPixcol/2)+1+floor(OffsetY/2)+ColShift;
        YEnd = (EndCol-1)*NoPixcol+floor(NoPixcol/2)+OffsetY+floor(OffsetY/2)+ColShift;
        %         if YStart<0
        %             YStart = 1;
        %             YEnd = 100;
        %         elseif YEnd > 600
        %             YStart = 501;
        %             YEnd = 600;
        %         end
        if YStart<0
            YStart = 1;
            YEnd = OffsetY;
        elseif YEnd > row
            YStart = row-OffsetY+1;
            YEnd = row;
        end
        ImgPredict.RightLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
        ImgPredict.RightLane = ImgPredict.RightLane.*20;
    else
        XStart = (EndRow-1)*NoPixrow+1;
        XEnd =   (EndRow-1)*NoPixrow+OffsetX;
        YStart = (EndCol-1)*NoPixcol+floor(NoPixcol/2)+1+floor(OffsetY/2);
        YEnd = (EndCol-1)*NoPixcol+floor(NoPixcol/2)+OffsetY+floor(OffsetY/2);
        %         XStart = (EndRow-1)*NoPix+floor(OffsetX/2)+1;
        %         XEnd =   (EndRow-1)*NoPix+floor(OffsetX*3/2);
        %         YStart = (EndCol-1)*NoPix+1+OffsetY;
        %         YEnd = (EndCol-1)*NoPix+OffsetY*2;
        %         if YStart<0
        %             YStart = 1;
        %             YEnd = 100;
        %         elseif YEnd > 600
        %             YStart = 501;
        %             YEnd = 600;
        %         end
        if YStart<0
            YStart = 1;
            YEnd = OffsetY;
        elseif YEnd > row
            YStart = row-OffsetY+1;
            YEnd = row;
        end
        ImgPredict.RightLane(XStart:XEnd,YStart:YEnd) = ones(OffsetX,OffsetY);
        ImgPredict.RightLane = ImgPredict.RightLane.*20;
    end
end