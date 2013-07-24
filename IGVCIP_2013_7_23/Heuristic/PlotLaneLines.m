function PlotLaneLines(BW,ImgLaneLines,str)
if ((max(ImgLaneLines.LeftLane(:))>0)||(max(ImgLaneLines.RightLane(:))>0))
    imshow(BW);title (str);
    hold on;
    row = [];
    col = [];
    x = [];
    y = [];
    %if Lane_Left~=0
    [row col] = find(ImgLaneLines.LeftLane>0);
    x = row';
    y = col';
    plot(y,x,'Color','blue','LineWidth',4);
    %end
    row = [];
    col = [];
    x = [];
    y = [];
    %if Lane_Right~=0
    [row col] = find(ImgLaneLines.RightLane>0);
    x = row';
    y = col';
    plot(y,x,'Color','green','LineWidth',4);
    %end
else
    [R C] = size(BW);
    Temp = BW;
    Temp(find(ImgLaneLines.Overall>0)) = 0;
    % Increase size of lines
    TempL = Temp;
    TempR = Temp;
    TempL(:,1:C-1) = Temp(:,2:C);
    TempR(:,2:C) = Temp(:,1:C-1);
    Temp = Temp.*TempR.*TempL;
    
    % Create output image
    BW = BW*255;
    Img(:,:,1) = BW;
    Img(:,:,2) = BW.*Temp;
    Img(:,:,3) = BW.*Temp;
    imshow(Img); title(str);
    %     row = [];
    %     col = [];
    %     x = [];
    %     y = [];
    %     [row col] = find(ImgLaneLines.Overall>0);
    %     x = row';
    %     y = col';
    %     plot(y,x,'Color','red','LineWidth',4);
    %     [L num] = bwlabel(ImgLaneLines.Overall,8);
    %     if num > 0
    %         for n=1:num
    %             Temp = ImgLaneLines.Overall;
    %             Tem(find(L~=n)) = 0;
    %             [row col] = find(Temp>0);
    %             x = row';
    %             y = col';
    %             plot(y,x,'Color','red','LineWidth',4);
    %         end
    %     end
end
end