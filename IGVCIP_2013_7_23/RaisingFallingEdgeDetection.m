function [edge] = RaisingFallingEdgeDetection(LadarRange,Threshold)
% Detect the Raising edges and Falling edges
%RangeDiff = diff(LadarRange+Threshold); 
offset=(LadarRange>0)*Threshold; % add offset when is not zero, for special 
                                 % case edge, which is when some barrels very near
                                 % ladar, and the distance between the ladar
                                 % and the barrel is smaller than
                                 % threshold.
RangeDiff = diff(LadarRange+offset); % get the edge gaps
edge = find(abs(RangeDiff)>Threshold); % compare with threshold to create a 
                                       % edge matrix.
edge =[edge edge+1]; % use falling edge to create raising edge.
edge(find(LadarRange(edge(:))==0))=[]; % remove the 0 value from edge matrix,
                                       % which is not a edge.
edge=sort(edge); % arrange the edge number from small to large.

% check the LadarRange first and last value is bigger than '0' or not.
if(LadarRange(1)>0) 
   edge=[1 edge]; % if is bigger than '0', it is a edge, then put it in the 
                  % first position of edge matrix.
end
if(LadarRange(length(LadarRange))>0)
    edge=[edge length(LadarRange)]; % if is bigger than '0', it is a edge, 
                                    % then put it in the last position of
                                    % edge matrix.
end

end

