% This function generates prediction of the new lane lines which comnes in
% current frame.
%   * Input: MaskHeur: Heuristic Mask (8x8) of previous frame; v: forward
%   speed, v>0 if the robot is moving forward; w: Angular speed, w>0 if
%   the robot is rotating counterclockwise
%   * Output: MaskPredict - Probable positions of the new lane lines in
%   current frame
%   * Call Function: MaskTrack = MaskTrackGenerate(MaskHeur,1,1);
function [MaskPredict] = MaskPredictGenerate(MaskHeur,v,w)
if nargin~=3
    MaskPredict.Overall = ones(8,8,1);
    MaskPredict.LeftLane = ones(8,8,1);
    MaskPredict.RightLane = ones(8,8,1);
else
    %% Check ends of lines
%     % Initialize Mask Predict
%     MaskPredict.Overall = zeros(8,8,1);
%     MaskPredict.LeftLane = zeros(8,8,1);
%     MaskPredict.RightLane = zeros(8,8,1);
%     % Initialize the flags
%     flagOverall = 0;
%     flagLeft = 0;
%     flagRight = 0;
%     % Consider the forward speed of the robot
%     if v>0 % going forward
%         for r=1:8
%             if flagOverall==0
%                 Temp = MaskHeur.Overall(r,:);
%                 S = sum(Temp(:));
%                 if S > 0
%                     flagOverall = 1;
%                     rowOverall = r;
%                 end
%             end
%             if flagLeft==0
%                 Temp = MaskHeur.LeftLane(r,:);
%                 S = sum(Temp(:));
%                 if S > 0
%                     flagLeft = 1;
%                     rowLeft = r;
%                 end
%             end
%             if flagRight==0
%                 Temp = MaskHeur.RightLane(r,:);
%                 S = sum(Temp(:));
%                 if S > 0
%                     flagRight = 1;
%                     rowRight = r;
%                 end
%             end
%         end
%         MaskPredict.Overall(1:rowOverall,:) = ones(rowOverall,8,1);
%         MaskPredict.LeftLane(1:rowLeft,:) = ones(rowLeft,8,1);
%         MaskPredict.RightLane(1:rowRight,:) = ones(rowRight,8,1);
%     else % going backward
%         for r=8:-1:1
%             if flagOverall==0
%                 Temp = MaskHeur.Overall(r,:);
%                 S = sum(Temp(:));
%                 if S > 0
%                     flagOverall = 1;
%                     rowOverall = r;
%                 end
%             end
%             if flagLeft==0
%                 Temp = MaskHeur.LeftLane(r,:);
%                 S = sum(Temp(:));
%                 if S > 0
%                     flagLeft = 1;
%                     rowLeft = r;
%                 end
%             end
%             if flagRight==0
%                 Temp = MaskHeur.RightLane(r,:);
%                 S = sum(Temp(:));
%                 if S > 0
%                     flagRight = 1;
%                     rowRight = r;
%                 end
%             end
%         end
%         MaskPredict.Overall(rowOverall:8,:) = ones(9-rowOverall,8,1);
%         MaskPredict.LeftLane(rowLeft:8,:) = ones(9-rowLeft,8,1);
%         MaskPredict.RightLane(rowRight:8,:) = ones(9-rowRight,8,1);
%     end
%    Check The velocity
        if max(MaskHeur.Overall(:)==0) % No Lane Line is detected
            MaskPredict.Overall = ones(8,8,1);
        else
            if v>0
                r = [];
                c = [];
                [r c] = find(MaskHeur.Overall==1);
                minr = min(r);
                MaskPredict.Overall(1:minr,:,:)=1;
            else
                r = [];
                c = [];
                [r c] = find(MaskHeur.Overall==1);
                maxr = max(r);
                MaskPredict.Overall(maxr:8,:,:)=1;
            end
        end
    
        if max(MaskHeur.LeftLane(:)==0) % No Lane Line is detected
            % MaskPredict.LeftLane = ones(8,8,1);
            MaskPredict.LeftLane = zeros(8,8,1);
        else
            if v>0
                r = [];
                c = [];
                [r c] = find(MaskHeur.LeftLane==1);
                minr = min(r);
                MaskPredict.LeftLane(1:minr,:,:)=1;
            else
                r = [];
                c = [];
                [r c] = find(MaskHeur.LeftLane==1);
                maxr = max(r);
                MaskPredict.LeftLane(maxr:8,:,:)=1;
            end
        end
    
        if max(MaskHeur.RightLane(:)==0) % No Lane Lines detect
            % MaskPredict.RightLane = ones(8,8,1);
            MaskPredict.RightLane = zeros(8,8,1);
        else
            if v>0
                r = [];
                c = [];
                [r c] = find(MaskHeur.RightLane==1);
                minr = min(r);
                MaskPredict.RightLane(1:minr,:,:)=1;
            else
                r = [];
                c = [];
                [r c] = find(MaskHeur.RightLane==1);
                maxr = max(r);
                MaskPredict.RightLane(maxr:8,:,:)=1;
            end
        end
    end
end