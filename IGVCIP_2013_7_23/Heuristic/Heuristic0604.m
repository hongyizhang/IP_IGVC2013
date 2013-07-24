function [ImgLaneLines MaskHeur ImgPredict] = Heuristic(BW,MaskHeur,v,w)
% Set weight of Masks
% w1 = 0.25;
w4 = 0.25;
w16 = 0.25;
% w64 = 0.25;

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
MaskHough(find(MaskHough<=.25)) = 0;
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
% Resize the Heuristic Mask
ImgOverall.Overall = MaskResize(I,MaskHeur.Overall);
ImgOverall.LeftLane = MaskResize(I,MaskHeur.LeftLane);
ImgOverall.RightLane = MaskResize(I,MaskHeur.RightLane);

% Vote for the lane lines
% ImgLaneLines.Overall = VoteLaneLines(ImgOverall.Overall,M1,M4,M16,M64,E1,E4,E16,E64);
% ImgLaneLines.LeftLane = VoteLaneLines(ImgOverall.LeftLane,M1,M4,M16,M64,E1,E4,E16,E64);
% ImgLaneLines.RightLane = VoteLaneLines(ImgOverall.RightLane,M1,M4,M16,M64,E1,E4,E16,E64);

ImgLaneLines.Overall = VoteLaneLines416(ImgOverall.Overall,M4,M16,E4,E16);
ImgLaneLines.LeftLane = VoteLaneLines416(ImgOverall.LeftLane,M4,M16,E4,E16);
ImgLaneLines.RightLane = VoteLaneLines416(ImgOverall.RightLane,M4,M16,E4,E16);

%% Project the lane lines forward
ImgPredict = ProjectForward(MaskHeur);
% ImgPredict.LeftLane(100:600,100:600) = ImgLaneLines.LeftLane;
% ImgPredict.RightLane(100:600,100:600) = ImgLaneLines.RightLane;
end