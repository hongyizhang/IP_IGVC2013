% MJP... June 4 2010 3:41 PM changed angle convention for rtheta and ltheta.  The angle data from hough 
% uses a different convention (see matlab documentation) that that of the robot (which uses
% Player convention locally (north = 0, west = +90).

MAX_SPEED = .3;   % Tell VFH/VPH max speed, scaled for special-lane case
GOAL_DIST = 15;    % Tell VFH/VPH goal is this many meters away
TAIL_LENGTH = 3.0; % meters
last_heading = [];
%set ups space for gps tail to tell if the Robot has turned around
gps_tail=  zeros(4,3);
counter = 0;
tail_index =1;
global LANE_CASE
clear global gps_history;
global gps_history gps_index gps_heading_past;
lastheading = [];
globalheading_previous = 0;
%data_log
i_data = 1;
ltheta = [];
rtheta = [];
ltheta_last = [];
rtheta_last = [];
globalheading = [];
globalheading_degree = [];
lane_case = [];

close all
hSet = [];
% getting the initial values
frame_i = 0;

while 1
        
        [left_line, right_line, img] = huff_img(img_in.img_o);
       
        
%         
%         %if(isempty(who('hSet')) || isempty(hSet))
%             fprintf('Creating plots...');
%              subplot(3,1,1)
%              hSet.gps_path = plot([0 0], [0 0], 'LineWidth', 1, 'Color', 'Black');
%              axis([-100 100 -100 100]);
%              subplot(3,1,2:3)
%             hSet.img1 = imshow(img);
%             hold on;
%             hSet.left = plot([0 0], [0 0], 'LineWidth', 5, 'Color', 'green');
%             hSet.right = plot([0 0], [0 0], 'LineWidth', 5, 'Color', 'cyan');
%             hSet.goal = plot([0 0], [0 0], 'LineWidth', 5, 'Color', 'red');
%             hSet.gps_heading = plot([0 0], [0 0], 'LineWidth', 3, 'Color', [1 .6 .6], 'LineStyle', '--');
%             hSet.lastheading = plot([0 0], [0 0], 'LineWidth', 2, 'Color', 'yellow');
%             hold off;    
%        % end
%   
%         try,
%             % Update plots
%             set(hSet.img1, 'CData', ~img_in.img_o);
%             %set(hSet.img2, 'CData', img);
%         end

        ltheta_last = ltheta;
        rtheta_last = rtheta;
        ltheta = [];
        rtheta = [];
        if(~isempty(left_line))
            
            ltheta = -left_line.theta; % change angle convention from hough to robot
            
%             try
                xy = [left_line.point1; left_line.point2];
%                 set(hSet.left, 'XData', xy(:, 1));
%                 set(hSet.left, 'YData', xy(:, 2));
%             end

%         else
%             try
%                 set(hSet.left, 'XData', 0);
%                 set(hSet.left, 'YData', 0);
%             end
        end
        
        if(~isempty(right_line))
            rtheta = -right_line.theta; % change angle convention from hough to robot
            
%             try
                xy = [right_line.point1; right_line.point2];
%                 set(hSet.right, 'XData', xy(:, 1));
%                 set(hSet.right, 'YData', xy(:, 2));
%             end
%                
%         else
%             try
%                 set(hSet.right, 'XData', 0);
%                 set(hSet.right, 'YData', 0);
%             end
        end
        %drawnow;
        
    end
%     if (player('isfresh', opaqueLanes))
%         lanes = player('matlab_unpack', ...
%                        opaqueLanes.data, opaqueLanes.data_count);
%     end
    
%     ltheta = lanes.left.theta;
%     rtheta = lanes.right.theta;

    [globalheading_degree, decide_case] = ...
        decideHeading(pos2d.px, pos2d.py, pos2d.pa * 180/pi, TAIL_LENGTH, ...
                      ltheta, rtheta, globalheading_degree, lane_case, ...
                      ltheta_last, rtheta_last);
                   
              
    %globalheading = globalheading_degree * pi/180;
    localheading = angle_add(globalheading, -1 * pos2d.pa*180/pi);
    localheading = localheading*pi/180;
    globalheading = globalheading_degree * pi/180;
    %localheading = atan2(sin(localheading), cos(localheading));
    % Filter local heading
    if (isempty(lastheading))
        'Warning: First run'
        %if this is the first heading to decide, there is no history to use
        %in low-pass filtering the heading. Therefore,use lane_heading and
        %initialize the the old_heading value "y(n-1)" to the current
        %lane_heading 
    else
        % calculate current heading and use the following low-pass filter
        % equation: Y(n)=(1-a)*[a*Y(n-1)+X(n)]
        % Y(n) is the final heading decision (filtered)
        % X(n) is the current heading decision before the low-pass filter
        % "current_heading"
        % Y(n-1) is the previouse final heading decision "old_heading"
        % a is the smooting factor a = [0,1] with 0 immulating step
        % behavior, and values towards one smoothen the output....
        
        %UTAYBA
        a = 0.7;
        localheading = a*lastheading + (1-a)*localheading;
    end
    
    try
        x1 = IN/2 * cos(lastheading + pi/2) + x0;
        y1 = y0 - (IN/2 * sin(lastheading + pi/2));
        set(hSet.lastheading, 'XData', [x0 x1]);
        set(hSet.lastheading, 'YData', [y0 y1]);
    end
    lastheading = localheading;

    
    
    % Recalculate globalheading from filtered localheading
    
    % globalheading = localheading + pos2d.pa;
    
    
    try
        IM = size(img, 1);
        IN = size(img, 2);
        x0 = IN/2;
        y0 = IM;
        x1 = IN/2 * cos(localheading + pi/2) + x0;
        y1 = y0 - (IN/2 * sin(localheading + pi/2));
        set(hSet.goal, 'XData', [x0 x1]);
        set(hSet.goal, 'YData', [y0 y1]);
        if (decide_case.case == LANE_CASE.DOUBLE || ...
            decide_case.case == LANE_CASE.DOUBLE_HORIZONTAL)
            if (localheading > pi/2 || localheading < -pi/2)
                set(hSet.goal, 'Color', 'blue');
            else
                set(hSet.goal, 'Color', 'red');
            end
        else
            set(hSet.goal, 'Color', [1 0 .5]);
        end
    end
    
    try
       gps_heading = decide_case.gps_debug.gps_heading * pi/180;
       gps_heading_local = gps_heading - pos2d.pa;
        x1 = IN/2 * cos(gps_heading_local + pi/2) + x0;
        y1 = y0 - (IN/2 * sin(gps_heading_local + pi/2));
        set(hSet.gps_heading, 'XData', [x0 x1]);
        set(hSet.gps_heading, 'YData', [y0 y1]);
    end
    

    
%     try,
%         set(hSet.gps_path, 'XData', gps_history(1:(gps_index-1), 1));
%         set(hSet.gps_path, 'YData', gps_history(1:(gps_index-1), 2));
%     end
  
    
    
    % for goalx and goaly, pick some distance (15 meters) and set them based
    % off the globalheading returned
    goaltheta = 0;
    
    %Check for the turnaround condition here
    
%     if(norm(gps_tail(tail_index,1:2) - [pos2d.px pos2d.py]) >2)
%     %update every meter
%         if(tail_index == size(gps_tail,1))
%             tail_index = 1;
%         else
%         tail_index = tail_index + 1;
%         end
%         globalheading_previous = globalheading;
%         gps_tail(tail_index,1:3) = [pos2d.px, pos2d.py, globalheading_previous];
%         mean_tail = gps_tail(:,3);
%         recent_direction = mean(mean_tail)
%     end
%     if(counter <size(gps_tail,1))
%         counter = counter + 1;
%     end
%     if (counter >= size(gps_tail,1))  %wait for the tail to accumulate before we try to use it
%         
%          %flip the direction if we have turned around
%         if(abs(recent_direction - globalheading) >= 135*pi/180)
%             globalheading = recent_direction
%             %globalheading = globalheading + pi;
%             %globalheading = globalheading - (floor(globalheading/pi))*pi;
%            
%         end
%     end
   % a = globalheading
    goal = [pos2d.px + GOAL_DIST * cos(globalheading), ...
            pos2d.py + GOAL_DIST * sin(globalheading), ...
            goaltheta];
    
    if( decide_case.case == LANE_CASE.DOUBLE )
        goalspeed = [ MAX_SPEED 0 0];
    elseif ( decide_case.case == LANE_CASE.NOTHING)
        goalspeed = [ MAX_SPEED/2 0 0];
    else
        goalspeed = [ MAX_SPEED/2 0 0];
    end
   
    player('position2d_set_cmd_pose_with_vel', pos2d, double(goal), double(goalspeed));
    
    if(frame_i >= 50)

        fps = frame_i/etime(clock, startclock);
      

        fprintf('%02.02f fps\n', fps);
        frame_i = 0;
        startclock = clock;
    else
        frame_i = frame_i + 1;
    end

    plotSet = plotPacker(hSet);
    player('opaque_cmd', opaqueWatcher, player('matlab_zpack', plotSet));
    drawnow;
    pause(.1); % Run slowly. Free the CPU for VFH.
%%%%%%%%%%%Data Logging%%%%%%%%%%%%%%%%%%%%%%%%
%data_log(i_data).decided_heading= globalheading;
%data_log(i_data).lane_case= lane_case;
%i_data= i_data + 1;

end
 
    
