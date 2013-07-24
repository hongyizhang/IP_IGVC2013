function [MaskClassified] = ClassifyLaneLines(MaskHeur,MaskTrack,MaskPredict,MaskHough)
flag = 0;
%% Connect the label
% [L num] = bwlabel(MaskHeur.Overall,8);
%% Ebd of Label Connection
% se = strel('disk',1); 
se = [1 1; 1 1];
MaskHeur.Overall = imdilate(MaskHeur.Overall,se);
[L num] = bwlabel(MaskHeur.Overall,8);
if (num==2)
    Centroid = regionprops(L, 'Centroid');
    C1 = Centroid(1,1).Centroid;
    C2 = Centroid(2,1).Centroid;
    %     x1 = C1(1,1);
    %     y1 = C1(1,2);
    %     x2 = C2(1,1);
    %     y2 = C2(1,2);
    %% calculate the distance
    % Reconstruc the lines
    %     Ori = regionprops(L,'Orientation');
    %     Theta1 = Ori(1,1).Orientation;
    %     Theta2 = Ori(2,1).Orientation;
    %     x0 = 1;
    %     y0 = 4.5;
    %     if Theta1==90
    %         R1 = x1;
    %     else
    %         a1 = 1;
    %         b1 = -tan(Theta1);
    %         c1 = -y1+tan(Theta1)*x1;
    %         R1 = abs(a1*x0+b1*y0+c1)/sqrt(a1^2+b1^2);
    % %         y-tan(Theta1)*x-y1+tan(Theta1)*x1=0;
    %     end
    %     if Theta1==90
    %         R2 = x2;
    %     else
    %         a2 = 1;
    %         b2 = -tan(Theta2);
    %         c2 = -y2+tan(Theta2)*x2;
    %         R2 = abs(a2*x0+b2*y0+c2)/sqrt(a2^2+b2^2);
    %     end
    
    R1 = (C1(1,1)^2+(C1(1,2)-4.5)^2);
    R2 = (C2(1,1)^2+(C2(1,2)-4.5)^2);
    if ((R1-R2>4)||(R2-R1>4))
        if R1<R2
            left = 1;
            right = 2;
        else
            left = 2;
            right = 1;
        end
        MaskClassified.LeftLane = MaskHeur.Overall;
        MaskClassified.LeftLane(find(L==right)) = 0;
        MaskClassified.RightLane = MaskHeur.Overall;
        MaskClassified.RightLane(find(L==left)) = 0;
        flag = 1;
    end
end
% else
if flag ==0
    MaskTemp = [];
    MaskTemp = MaskTrack.LeftLane+MaskPredict.LeftLane;
    MaskClassified.LeftLane = MaskTemp.*MaskHough;
    MaskTemp = [];
    MaskTemp = MaskTrack.RightLane+MaskPredict.RightLane;
    MaskClassified.RightLane = MaskTemp.*MaskHough;
end
end