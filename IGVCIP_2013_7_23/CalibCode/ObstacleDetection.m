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

function [Obstacle,ObstacleNo,flagObstacle,flagDisplayLadar] = ObstacleDetection(LadarRange,Angle,Display,flagDisplayLadar)
%% Parameters
Threshold = 0.5;
% Max_lidar_d =0;
% LadarRange(1,1) = Max_lidar_d;
%LadarRange(1,length(LadarRange)) = Max_lidar_d;

% LadarRange_Threshold = LadarRange;
% if LadarRange_Threshold(1)>0
%     LadarRange_Threshold(1)=LadarRange_Threshold(2)+Threshold*3;
% end
% if LadarRange_Threshold(length(LadarRange_Threshold-1))>0
%     LadarRange_Threshold(length(LadarRange_Threshold))=LadarRange_Threshold(length(LadarRange_Threshold))+Threshold*3;
% end

%% End of Parameters

%% Detect the gaps

% A1=[LadarRange_Threshold(1:length(LadarRange_Threshold)-1)]
% A2=[LadarRange_Threshold(2:length(LadarRange_Threshold))]
% RangeDiff1=(A1-A2);
% RangeDiff2=(A2-A1);
% EdgeRaising1 = find(RangeDiff1>Threshold)
% EdgeRaising2 = find(RangeDiff2>Threshold)
% 
% EdgeFalling1 = find(RangeDiff1<-Threshold)
% EdgeFalling2 = find(RangeDiff2<-Threshold)



% RangeDiff1 = abs(diff(LadarRange_Threshold));
% LadarRange2_Threshold=LadarRange_Threshold(length(LadarRange_Threshold):-1:1);
% RangeDiff2 = abs(diff(LadarRange2_Threshold));
% EdgeRaising = find(RangeDiff1>Threshold);
% EdgeFalling = find(RangeDiff2>Threshold);

% Mask1 = abs(RangeDiff1);
% Mask1(Mask1<Threshold) = 0;
% Mask1(Mask1>0) = 1;
% RangeDiff1 = RangeDiff1.*Mask1;
% 
% Mask2 = abs(RangeDiff2);
% Mask2(Mask2<Threshold) = 0;
% Mask2(Mask2>0) = 1;
% RangeDiff2 = RangeDiff2.*Mask2;
% 
% EdgeRaising = find(RangeDiff1>Threshold);
% EdgeFalling = find(RangeDiff2>Threshold);

RangeDiff = diff(LadarRange);
edge = find(abs(RangeDiff)>Threshold);
edge =[edge edge+1]; % use falling edge to create raising edge.
find(LadarRange(edge(:))==0);
edge(find(LadarRange(edge(:))==0))=[];
edge=sort(edge);

if(LadarRange(1)>0) 
   edge=[1 edge];
end
if(LadarRange(length(LadarRange))>0)
    edge=[edge length(LadarRange)];
end


% Mask(Mask<Threshold) = 0;
% Mask(Mask>0) = 1;
% RangeDiff = RangeDiff.*Mask;


% RangeDiff = RangeDiff./Mask;
%% Detect the raising and falling edges
EdgeRaising = find(RangeDiff>Threshold);
if ~isempty(EdgeRaising)
    EdgeRaising = EdgeRaising+1;
end
EdgeFalling = find(RangeDiff<-Threshold);
% if(~isempty(EdgeFalling))
%     EdgeFalling = EdgeFalling-1;
% end
%% Recording the obstacles
% Check if there is any obstacle
% TFRaising = isempty(EdgeRaising);
% TFFalling = isempty(EdgeFalling);
% If there is no obstacle
if (isempty(EdgeRaising)==1)||(isempty(EdgeFalling)==1)
    Obstacle = 0;
    flagObstacle = 0;
    ObstacleNo = 0;
    % If there is obstacle
else
%     [EdgeRaisingNo,Channel] = size(EdgeRaising);
%     [EdgeFallingNo,Channel] = size(EdgeFalling);
    [Channel,EdgeRaisingNo] = size(EdgeRaising);
    [Channel,EdgeFallingNo] = size(EdgeFalling);
    ObstacleNo = min(EdgeRaisingNo,EdgeFallingNo);
    for i=1:ObstacleNo
        %% Position of the obstacle
        %         Obstacle(i).PositionLeft = Angle(EdgeRaising(i));
        %         Obstacle(i).PositionRight = Angle(EdgeFalling(i));
        Obstacle(i).PositionRight = Angle(EdgeRaising(i));
        Obstacle(i).PositionLeft = Angle(EdgeFalling(i));
        %% Distance to obstacle
        Index = floor((EdgeRaising(i) + EdgeFalling(i))/2);
        % Left
        %         Obstacle(i).RangeLeft = LadarRange(EdgeRaising(i));
        Obstacle(i).RangeRight = LadarRange(EdgeFalling(i));
        % Middle
        Obstacle(i).Range = LadarRange(Index);
        % Right
        Obstacle(i).RangeLeft = LadarRange(EdgeRaising(i));
        %         Obstacle(i).RangeRight = LadarRange(EdgeFalling(i));
        %         Obstacle(i).Width = abs(EdgeRaising(i) + EdgeDeclining(i));
        %% Width of obstacle
        Obstacle(i).Width = 2*Obstacle(i).Range*tan((Obstacle(i).PositionLeft-Obstacle(i).PositionRight)/2);
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

