function [EdgeRaising,EdgeFalling] = FallingRaisingEdgeSperate(ObstacleNo,edge)
% seperate the raising edge and falling edge
k=1;
 for i=1:ObstacleNo
EdgeRaising(i)=edge(k);
EdgeFalling(i)=edge(k+1);
k=k+2;
end

end

