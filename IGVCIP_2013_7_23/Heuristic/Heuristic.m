function [ImgLaneLines MaskHeur ImgPredict flagClassify] = Heuristic(BW,MaskHeur,v,w,mm_per_Pixel)
% Set weight of Masks
% w1 = 0.25;
w4 = 0.25;
w16 = 0.25;
% w64 = 0.25;
ExtraRow = ceil(1000/mm_per_Pixel);
ExtraCol = ceil(1000/mm_per_Pixel);
[row col] = size(BW);
% row = row+ExtraRow;
% col = col+ExtraCol;
% frame_count = 0;
% diag = false;
% H = [];
%% Generate Tracking Mask
MaskTrack = MaskTrackGenerate(MaskHeur,v,w);
%% Predict new lane lines
MaskPredict = MaskPredictGenerate(MaskHeur,v,w);
%% Start Process
I = BW;
% Extract the edge images using Hough transform
% E1 = HoughExtract(I,1,1,3);
E4 = HoughExtract(I,2,2,1);
E16 = HoughExtract(I,4,4,1);
% E64 = HoughExtract(I,8,8,1);
% Generate 8x8 Mask
% [M1] = MaskGenerate(E1);
[M4] = MaskGenerate(E4);
[M16] = MaskGenerate(E16);
% [M64] = MaskGenerate(E64);
% Threshold Mask
% MaskSum = w1*M1+w4*M4+w16*M16+w64*M64;
% MaskHough = im2bw(MaskSum,0.5);
MaskSum = w4*M4+w16*M16;
MaskHough = MaskSum;
% MaskHough(find(MaskHough<=.25)) = 0;
%% Update the Heuristic Mask
MaskTemp = MaskTrack.Overall+MaskPredict.Overall;
MaskHeur.Overall = MaskTemp.*MaskHough;
%% This section is implemented to display the result. It is expensive
% in computation. In order to make the program executes realtime,
% please comment this section
%
% Classify the Lane Lines
[MaskClassified] = ClassifyLaneLines(MaskHeur,MaskTrack,MaskPredict,MaskHough);
% Update the Left and Right Lane Lines
MaskHeur.LeftLane = MaskClassified.LeftLane;
MaskHeur.RightLane = MaskClassified.RightLane;
%% Verify The Classifaction
TempLeft = sum(MaskHeur.LeftLane(:));
TempRight = sum(MaskHeur.RightLane(:));
if (TempLeft == 0) && (TempRight == 0)
    flag = 1;
    flagClassify = 0;
elseif (TempLeft == 0) && (TempRight ~= 0)
    flag = 2;
    flagClassify = 1;
elseif    (TempLeft ~= 0) && (TempRight == 0)
    flag = 3;
    flagClassify = 1;
else
    Match = MaskHeur.LeftLane.*MaskHeur.RightLane;
    Temp = sum(Match(:));
    if Temp ~= 0
        flag = 4;
        flagClassify = 0;
    else
        flag = 5;
        flagClassify = 1;
    end
end
%% Resize the Heuristic Mask
if flag ==1
    Temp = sum(MaskHeur.Overall(:));
    if Temp==0
        ImgLaneLines.Overall = zeros(size(I));
    else
        ImgOverall.Overall = MaskResize(I,MaskHeur.Overall);
        ImgLaneLines.Overall = VoteLaneLines416(ImgOverall.Overall,M4,M16,E4,E16);
    end
    ImgLaneLines.LeftLane = zeros(size(I));
    ImgLaneLines.RightLane = zeros(size(I));
elseif flag == 2
    % Overall
    ImgOverall.Overall = MaskResize(I,MaskHeur.Overall);
    ImgLaneLines.Overall = VoteLaneLines416(ImgOverall.Overall,M4,M16,E4,E16);
    % Left
    ImgLaneLines.LeftLane = zeros(size(I));
    % Right
    ImgOverall.RightLane = MaskResize(I,MaskHeur.RightLane);
    ImgLaneLines.RightLane = VoteLaneLines416(ImgOverall.RightLane,M4,M16,E4,E16);
elseif flag == 3
    % Overall
    ImgOverall.Overall = MaskResize(I,MaskHeur.Overall);
    ImgLaneLines.Overall = VoteLaneLines416(ImgOverall.Overall,M4,M16,E4,E16);
    % Left
    ImgOverall.LeftLane = MaskResize(I,MaskHeur.LeftLane);
    ImgLaneLines.LeftLane = VoteLaneLines416(ImgOverall.LeftLane,M4,M16,E4,E16);
    % Right
    ImgLaneLines.RightLane = zeros(size(I));
elseif flag == 4
    % Overall
    ImgOverall.Overall = MaskResize(I,MaskHeur.Overall);
    ImgLaneLines.Overall = VoteLaneLines416(ImgOverall.Overall,M4,M16,E4,E16);
    % Left
    ImgLaneLines.LeftLane = zeros(size(I));
    % Right
    ImgLaneLines.RightLane = zeros(size(I));
else
    % Overall
    ImgOverall.Overall = MaskResize(I,MaskHeur.Overall);
    ImgLaneLines.Overall = VoteLaneLines416(ImgOverall.Overall,M4,M16,E4,E16);
    % Left
    ImgOverall.LeftLane = MaskResize(I,MaskHeur.LeftLane);
    ImgLaneLines.LeftLane = VoteLaneLines416(ImgOverall.LeftLane,M4,M16,E4,E16);
    % Right
    ImgOverall.RightLane = MaskResize(I,MaskHeur.RightLane);
    ImgLaneLines.RightLane = VoteLaneLines416(ImgOverall.RightLane,M4,M16,E4,E16);
end
% Vote for the lane lines
% ImgLaneLines.Overall = VoteLaneLines(ImgOverall.Overall,M1,M4,M16,M64,E1,E4,E16,E64);
% ImgLaneLines.LeftLane = VoteLaneLines(ImgOverall.LeftLane,M1,M4,M16,M64,E1,E4,E16,E64);
% ImgLaneLines.RightLane = VoteLaneLines(ImgOverall.RightLane,M1,M4,M16,M64,E1,E4,E16,E64);

% ImgLaneLines.Overall = VoteLaneLines416(ImgOverall.Overall,M4,M16,E4,E16);
% ImgLaneLines.LeftLane = VoteLaneLines416(ImgOverall.LeftLane,M4,M16,E4,E16);
% ImgLaneLines.RightLane = VoteLaneLines416(ImgOverall.RightLane,M4,M16,E4,E16);

%% Project the lane lines forward
if (flag~=1)&&(flag~=4)
    ImgPredict = ProjectForward(MaskHeur,mm_per_Pixel,row,col);
else
    %     ImgPredict.LeftLane =zeros(600,600);
    %     ImgPredict.RightLane =zeros(600,600);
    %     ExtraRow = ceil(2000/mm_per_Pixel);
    %     ExtraCol = ceil(2000/mm_per_Pixel);
    %     [row col] = size(MaskHeur.Overall);
    %     row = row+ExtraRow;
    %     col = col+ExtraCol;
    row = row+ExtraRow;
    col = col+ExtraCol;
    ImgPredict.LeftLane =zeros(row,col);
    ImgPredict.RightLane =zeros(row,col);
end
% ImgPredict.LeftLane(100:600,100:600) = ImgLaneLines.LeftLane;
% ImgPredict.RightLane(100:600,100:600) = ImgLaneLines.RightLane;
end