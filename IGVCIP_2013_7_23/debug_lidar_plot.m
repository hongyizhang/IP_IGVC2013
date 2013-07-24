%% debug lidar plot
[xL,yL] = pol2cart([Obstacle(:).PositionLeft],[Obstacle(:).RangeLeft]);
plot(xL,xL,'g*')
figure,plot(xL,xL,'g*'),axis equal, grid on
[xR,yR] = pol2cart([Obstacle(:).PositionRight],[Obstacle(:).RangeRight]);
figure,plot(xL,yL,'g*',xR,yR,'r*'),axis equal, grid on
set(gca,'XDir','reverse') % reverse x to y, y to x.