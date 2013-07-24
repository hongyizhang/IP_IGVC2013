% IGVC 2013 IP - Obstacle detection
%
% Authors: Phuoc H. Nguyen, Hongyi Zhang, Tim Wu
%
% Revised by: Dr. Mark J. Paulik, Dr. Kristan Mohan, and Steven Chung
%
% First version: May 21, 2013
%
% Last Update: May 21, 2013
%
% Abstract: In this function, The obstacles are deteced using the gaps of
% ladar data.
%
% Input: LadarRange, Angle
%
% Output: Obstacle, Obstcale number, obstacle flag.
%
% Call function: [Obstacle,ObstacleNo,flagObstacle] = ObstacleDetection(LadarRange,Angle);

function [Obstacle,ObstacleNo,flagObstacle,flagDisplayLadar,Index,EdgeRaising,EdgeFalling] = ObstacleDetection(LadarRange,Angle,Display,flagDisplayLadar)
%% Parameters
Threshold = 0.5;
%% End of Parameters

%% Detect the Raising edges and Falling edges
% [edge] = RaisingFallingEdgeDetection(LadarRange,Threshold);
   [EdgeRaising,EdgeFalling,edge] = RaisingFallingEdgeDet(LadarRange,Threshold);
%% Recording the obstacles
% If there is no obstacle
if (isempty(edge)==1)
    Obstacle = 0;
    flagObstacle = 0;
    ObstacleNo = 0;
    % If there is obstacle
else
%     [EdgeRaisingNo,Channel] = size(EdgeRaising);
%     [EdgeFallingNo,Channel] = size(EdgeFalling);
%     [Channel,EdgeRaisingNo] = size(EdgeRaising);
%     [Channel,EdgeFallingNo] = size(EdgeFalling);
%     ObstacleNo = min(EdgeRaisingNo,EdgeFallingNo);
       [Channel,EdgeNo] = size(edge);
       ObstacleNo = EdgeNo;
% seperate the raising edge and falling edge
% [EdgeRaising,EdgeFalling] = FallingRaisingEdgeSperate(ObstacleNo,edge);
       
    for i=1:ObstacleNo
         % Right
        %         Obstacle(i).RangeLeft = LadarRange(EdgeRaising(i));
         Index(i) = floor((EdgeRaising(i) + EdgeFalling(i))/2);
%         % Obstacle(i).RangeRight = LadarRange(EdgeFalling(i));
%         Obstacle(i).RangeLeft = LadarRange(EdgeFalling(i));
%         % Middle
%         Obstacle(i).Range = LadarRange(Index);
%         % Left
%         % Obstacle(i).RangeLeft = LadarRange(EdgeRaising(i));
%         Obstacle(i).RangeRight = LadarRange(EdgeRaising(i));
        
        
        
       %% detect the any near obstacle
        
        
        %% Position of the obstacle
        %         Obstacle(i).PositionLeft = Angle(EdgeRaising(i));
        %         Obstacle(i).PositionRight = Angle(EdgeFalling(i));
        Obstacle(i).PositionRight = Angle(EdgeRaising(i));
        Obstacle(i).PositionLeft = Angle(EdgeFalling(i));
        Obstacle(i).PositionRange = Angle(Index(i));
         %% Distance to obstacle
        % Left
        %         Obstacle(i).RangeLeft = LadarRange(EdgeRaising(i));
        Obstacle(i).RangeLeft = LadarRange(EdgeFalling(i));
        % Middle
        Obstacle(i).Range = LadarRange(Index(i));
        % Right
        Obstacle(i).RangeRight = LadarRange(EdgeRaising(i));
         %% Width of obstacle
        % Obstacle(i).Width = 2*Obstacle(i).Range*tan((Obstacle(i).PositionLeft-Obstacle(i).PositionRight)/2);
    Obstacle(i).Width = ((Obstacle(i).RangeLeft+Obstacle(i).RangeRight)/2)*(Obstacle(i).PositionLeft-Obstacle(i).PositionRight);
     if Obstacle(i).Width > 0.1
        Acc_offset = 0.05;
        Angle_offset = Acc_offset/Obstacle(i).RangeLeft;
        Obstacle(i).PositionRight = Angle(EdgeRaising(i))-Angle_offset ;
        Obstacle(i).PositionLeft = Angle(EdgeFalling(i))+Angle_offset ;
        Obstacle(i).PositionRange = Angle(Index(i));
     end
        %         Obstacle(i).RangeRight = LadarRange(EdgeFalling(i));
        %         Obstacle(i).Width = abs(EdgeRaising(i) + EdgeDeclining(i));
       
    end
    flagObstacle = 1;
end

%% Display
% % Debugging tool to verify 
% if Display >0
%     if flagDisplayLadar == 0
%         flagDisplayLadar = 1;
%         figure;
%         bar(RangeDiff');
%     else
%         bar(RangeDiff');
%     end
%     pause(.002);
% end
%% Original function done by Tim Wu and Hongyi
% r =[laser_ranges, 30]; % expand laser_ranges to 1082.
% r_=[30 laser_ranges];  % right switch laser_ranges to 1082.
% a = abs(r - r_) > 0.3;   % find each obstacle gap
% b = find(a > 0); % find  each obstacle gap position in laser_ranges
% [n, m] = size(b);
% j =1;
% for i=1:1:m-1
%     % Only leave desirous obstacles.
%     if (laser_ranges(1,b(1,i)) < obstacle_range)
%         obstacle_m(1,j) = b(1,i);
%         obstacle_m(2,j) = b(1,i+1)-1;
%         j=j+1;
%     end
% end
% % Find how many desirous obstacles.
% [n, obstacle_number] = size(obstacle_m);
% end

