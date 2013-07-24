function [EdgeRaising,EdgeFalling,edge] = RaisingFallingEdgeDet(LadarRange,Threshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
rangemax=0; %lidar maximum
% thd=0.5 % threshold


offset=(LadarRange>0)*Threshold*2; % add offset when is not zero

%abs(diff(LadarRange))>thd % the edge without offset

 edge=abs(diff(LadarRange+offset))>Threshold; % the edge with offset
% edge=abs(diff(LadarRange+offset))>0.4;
edge_loc=[1 find(edge) find(edge)+1 length(LadarRange)]; % add first and last , left edge , right edge
edge_loc=sort(edge_loc);
% edge check , remove the none obstacle edge

%
zero_loc=find(LadarRange(edge_loc)==rangemax); % find the range data is 0
zero_loc=sort(zero_loc,'descend');
if (~isempty(zero_loc))
    for i=1:length(zero_loc)
        edge_loc(zero_loc(i))=[]; % remove them
    end
end
edge_loc=reshape(edge_loc,2,length(edge_loc)/2); % convert 1xK array to 2xK/2 array left edge first row , right edge second row
edge = edge_loc;
EdgeRaising=edge_loc(1,:);
EdgeFalling=edge_loc(2,:);

end

