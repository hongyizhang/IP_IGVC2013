function [Obstacle, ObstacleNo ] = Recognize_obstacle( laser_ranges, angle, obstacle_range )
%  Function name: Recognize Obstacle
%  This function will find each obstacle gap and filter too far Obstacles.    

    r =[laser_ranges, 30]; % expand laser_ranges to 1082.
    r_=[30 laser_ranges];  % right switch laser_ranges to 1082. 
    a = abs(r - r_) > 0.3;   % find each obstacle gap
    b = find(a > 0); % find  each obstacle gap position in laser_ranges
    [n, m] = size(b);
    j =1;
    for i=1:1:m-1
        % Only leave desirous obstacles. 
        if (laser_ranges(1,b(1,i)) < obstacle_range)
        obstacle_m(1,j) = b(1,i);
        obstacle_m(2,j) = b(1,i+1)-1;
        j=j+1;
        end
    end
    % Find how many desirous obstacles.
    [n, obstacle_number] = size(obstacle_m);
    
end

