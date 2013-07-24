function range_out = toladarQuick(bw, p_row, p_col, meters_per_pixel, laser_offset,max_laser_ang, min_laser_ang, laser_res)%lane_range_ratio
    % This function is updated on Jun 5, 2012 by Utayba Mohammad and Bo Cui

    % bw: received image (any size)
    % p_row: the row at wich the image is centered in reference to the drivetrain
    % p_col: the column at wich the image is centered in reference to the drivetrain
    % (p_row,p_column) is the coordinate of the the center of drivetrain in
    % the image
    % meters_per_pixel: linear interprtation of distance presented by each
    %   pixel in meters
    % laser_offset: the distance between the laser and the center of the
    % drivetrain. has a negative value if the lidar is infront of the
    % center of drive train and positive otherwise
    % max_laser_ang: The maximum positive angle in the laser convention
    % min_laser_ang: The minimum negative angle in the laser convention
    % laser_res: the angle resolution in the ladar
    

%%  
    % bw coordinates will follow the figure below
    % (1,1) --------------------------->  max x diminsion (max_col) 
    %       |
    %       |
    %       |          
    %       |       
    %       |           
    %       |          *(p_row,p_column)
    %       V
    %      max y 
    %    dircetion 
    %    (max_row)
    
    
    
    % [x, y] = pol2cart(((-90:.5:90) * pi/180)', laser_ranges);
    % x = x + laser_offset;
    %for test purposes
    %bw=imread('imgbw.jpg');
    %imtool('imgbw.jpg');
   
    %for testing only
%     bw=zeros(276,551)>0;
%     % generate point every meter
%     for x=276:-50:26
%             for y=551:-50:1
%                 bw(x,y)=1;
%             end
%     end
%     imshow(bw)
%     p_row = 276;
%     p_col = 276;
%     meters_per_pixel = 0.020;
%     laser_offset =-0.82;
%     laser_res=.25;
%     max_laser_ang= 135;
%     min_laser_ang=-135;
    %%%% testing segment ends here%%%
    
    [yimg, ximg] = find(bw); %find the white , [row, col]=find(bw);
    ximg = (ximg - p_col) * meters_per_pixel; %
    
   %  --------------|--------------->  max x
   %               p_col
   %
   %  -             0              +
   
    % Subtract ladar offset from X
    %% 
     % the value assumes the LADAR is in front of the 
    % camera at .82m distance and its reading need to b
    %ximg = ximg ;
    yimg = (p_row - yimg) * meters_per_pixel + laser_offset; 
    % We center the y axis around the lidar which has the same x coordinate
    % as the center of drivetrian but is shifted up by laseroffset.
    
    % supposedly, distances are now represented as:
   %              + ^ max y       
   %                |      
   %                |      
   %                |     
   %                |     
   %  --------------|--------------->  max x
   %              LIDAR
   %
   %  -           (0,0)              +
    
   [th, ranges] = cart2pol(ximg, yimg);
   % ranges = lane_range_ratio .* ranges;
    deg = th * 180/pi;
    % adjust angle convention to match laser angle convention
    % Laser to the right is negative angles, laser to the left is positive
    % angles
    deg = deg-90;
    if deg >180
        deg = deg-360;
    end
    if deg <-180
        deg = deg+360;
    end
    
    % for ladar ranges I want 1:end = min_laser_ang:laser_res:max_laser_ang
    % convert angles to their location in the lidar data array ... not
    % really location as some of them have negative values. but they do
    % match the lidar angle convention given the min, max, and res of lidar
    deg = round(deg/laser_res);
    % eleminate all values outside the lidar field of view.
    m =deg < min_laser_ang/laser_res | deg > max_laser_ang/laser_res;
    ranges(m) = [];
    deg(m) = [];
    deg = deg+max_laser_ang/laser_res +1;
    %     
    indexrho = [deg(:), ranges(:)];
    
    % If merged with laser (Normally done in LaserOpaque)
    %indexrho = [deg(:), ranges(:); (1:361)', laser_ranges];
    indexrho = sortrows(indexrho, -2);
    % Sort by rho, with the smallest rho at the bottom.
     range_out = 10 * ones(1, ((max_laser_ang-min_laser_ang)/laser_res)+1, 'single');
%     range_out(indexrho(:, 1)) = indexrho(:, 2);

    range_out(indexrho(:, 1))=indexrho(:, 2); % this assignment takes place
    %sequentially, and hence if two distances correspond to angle 5, then
    %the larger one is first assigned and the lower one is assigned
    %afterwared. hence, the corresponding angle element always has the
    %minimum distance corresponding to an angle.
     
end
    