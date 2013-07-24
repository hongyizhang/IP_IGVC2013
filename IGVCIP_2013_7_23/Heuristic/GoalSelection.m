function [Goal,flag] = GoalSelection(Mask,para)
% minX = para.minx;
% maxX = para.maxy;
% % minY = para.minY;
% maxY = para.maxx;
minX = 0.8;
maxX = 6;
% minY = para.minY;
maxY = 3;
flag  = 0;
cellX = (maxX-minX)/8;
cellY = maxY/4;
% Mask = MaskHeur.Overall;
% Goal.col = [];
% Goal.row = [];
for r =1:8
    row = Mask(r,:);
    col = find(row>0)';
    [NoCol Channel] = size(col);
    if NoCol==2
        colLeft = min(col);
        colRight = max(col);
        gap = colRight - colLeft;
        if (gap>1)&&(gap<6)
            colGoal = (colLeft+colRight)/2;
            rowGoal = r;
%             Goal.col = colGoal;
%             Goal.row = rowGoal;
            flag = 1;
%             Goal.col = [Goal.col;colGoal];
%             Goal.row = [Goal.row;rowGoal];
        end
    end
end
if flag == 1
    Goal.x = minX+(8-rowGoal+1)*cellX;
    Goal.y = (4-colGoal)*cellY;
    Goal.Heading = atan2(Goal.y,Goal.x);

else
Goal.x = 0;
    Goal.y = 0;
    Goal.Heading = 0;    
end
% x = Goal.row
end