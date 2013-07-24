% gps_decide_heading
% Function Arguments:
% gps_px and gps_py are x and y coordinates in UTM cartesian format offset
% by competition calibration point which is set to 0,0.  positive X is
% meters north of cal point and postive Y is meters West of cal point.
% Therefore, II quadrant angles are postive.
% gps_pa is the compass global heading in radians
% lline_theta and rline_theta are sent in degrees extracted from the
% hough_l and hough_r structures with [] sent when no line is present.
% the returned output angle is the global heading angle in radians taken
% either directly from the gps_heading calculations herein or computed as
% gps_pa-hough_angle when we are following a line.
%
%   results-1 = gps_px 
%   results-2 = gps_py
%   results-3 = dx % current postion minus previous selected point which
%                  % satisfies the gps_heading_tail distance requirement
%   results-4 = dy
%   results-5 = case value to determine the decision history


% Returns degrees
function [heading, results] = ...
    decideHeading(px, py, pa_degree, tail_length, ...
                  left_theta, right_theta, last_heading, ...
                  last_case, left_theta_last, right_theta_last)

    % All headings are GLOBAL/UTM based, but in degrees
    [gps_heading, gps_debug] = gpsDecideHeading(px, py, pa_degree, tail_length);
    
    
    [lane_heading, lane_case] = laneDecideHeading(pa_degree, left_theta, ...
                                    right_theta, gps_heading, ...
                                    last_heading, last_case, ...
                                    left_theta_last, right_theta_last);
    
%  switch lane_case
%      case LANE_CASE.DOUBLE
%          heading = lane_heading;
%      
%      case LANE_CASE.DOUBLE_HORIZONTAL
%          heading = lane_heading;
%      
%      case LANE_CASE.NOTHING
%          gps1 = 5;
%          gps2 = 3;
%      case LANE_CASE.VERTICAL
%          gps = 2;
%      case LANE_CASE.HORIZONTAL
%          
%      case LANE_CASE.NOTHING_HISTORY
%           heading = lane_heading;
% 
%          
%      otherwise
%          
%  end
    heading = lane_heading;
      if (abs(angle_add(gps_heading,-1*lane_heading))>90)           
             heading = gps_heading;
      end  

    results.pose = [px py pa_degree];
    results.gps_debug = gps_debug;
    results.lanes = [right_theta, left_theta];
    results.case = lane_case;
   
    %heading = lane_heading;
        
    
    
    
end
    
% gpsDecideHeading was moved to it's own M file to be shared with VFH

function [lane_heading, lane_case] = ...
    laneDecideHeading(pa_degree, left_theta, right_theta, gps_heading, ...
                      last_heading, last_case, last_left_theta, last_right_theta)
                  
    global LANE_CASE;
    
    SINGLE_LEFT = -1;
    SINGLE_RIGHT = +1;
    
    if (isempty(LANE_CASE))
        LANE_CASE.DOUBLE = 0;
        LANE_CASE.DOUBLE_HORIZONTAL = 1;
        LANE_CASE.NOTHING = 2;
        LANE_CASE.VERTICAL = 3;
        LANE_CASE.HORIZONTAL = 4;
        LANE_CASE.NOTHING_HISTORY = 5;
%         LANE_CASE.LOOKUP = ...
%             ['Double'; 'Double Horizontal', 'Nothing', ...
%              'Vertical', 'Horizontal' ];
    end
    
    
    if (~isempty(left_theta) && ~isempty(right_theta))
        % Two lines!
        [left_heading, left_case]   = singleLaneDecideHeading(left_theta,  pa_degree, gps_heading, SINGLE_LEFT);
        [right_heading, right_case] = singleLaneDecideHeading(right_theta, pa_degree, gps_heading, SINGLE_RIGHT);
        
        if (left_case == LANE_CASE.HORIZONTAL && right_case == LANE_CASE.HORIZONTAL)
            % Double horizontal.
            % Turn left or right depending on gps_history
            lane_heading = left_heading; % left_heading == right_heading
            lane_case = LANE_CASE.DOUBLE_HORIZONTAL;
        else
            % Not double horizontal! Use gps_heading
            lane_heading = angle_average(left_heading,right_heading); % average angles in the robot convention
            %There are two solutions here, one to use the averaging of the
            %two headings of the left and right lanes (faulty IP will cause
            %problems) and the other one is to choose the heading that is
            %closer to the gps heading.
            lane_case = LANE_CASE.DOUBLE;
        end
    else
        if (isempty(left_theta) && isempty(right_theta))
            % No lines!
            
            if(~isempty(last_left_theta) && isempty(last_right_theta))
                % We had been seening a left lane.
                % It's probably dashed. Head towards the right lane.
    % 15 may not be large enough
            %Since we don't see any lanes, we look back at the last frame. If the previous 
            %left lane exited by the right one didn't in the last frame. The we will try to get the
            %right lane by deviating to the right by 30 degree.
            deviateToRight = -30;
            lane_heading = angle_add(pa_degree, deviatToRight);
            lane_case = LANE_CASE.NOTHING_HISTORY;
 
            
            elseif(isempty(last_left_theta) && ~isempty(last_right_theta))
                deviateToLeft = 30;
                lane_heading = angle_add(pa_degree,deviateToLeft);
                %lane_heading = pa_degree + 15;
                lane_case = LANE_CASE.NOTHING_HISTORY;
            else
                lane_heading = pa_degree;%This covers two cases double and no lane (for last case)
                lane_case = LANE_CASE.NOTHING;
            end
            
            % Alternatively
            % Flip the gps heading around our current heading.
            % GPS                         FlippedTarget
            %             Vehicle->
            %                             NormalTarget
            %
            % if (last_case ~= LANE_CASE.NOTHING)
            %   lane_heading = pa_heading - (gps_heading - pa_heading)
            % else
            %   lane_heading = last_heading;
            % end
            
            
        else
            % Single lane
            if(isempty(left_theta))
                % Right Lane. No Left lane.
                [lane_heading, lane_case] = singleLaneDecideHeading(right_theta, pa_degree, gps_heading, SINGLE_RIGHT);
            else
                % Left lane, No right lane.
                [lane_heading, lane_case] = singleLaneDecideHeading(left_theta, pa_degree, gps_heading, SINGLE_LEFT);
            end
        end
    end
end

    
function [lane_heading, lane_case] = singleLaneDecideHeading(theta, pa_degree, gps_heading, leftright)
    global LANE_CASE;
    if(((75 <= theta) && (theta <= 90)) || ((-90 <= theta) && (theta <= -75)))
        % Horizontal lane. Pick direction to turn (left or right)
        diff_angle = pa_degree - gps_heading;
        % We are only concerned with the sign of diff_angle. the value is not wrapped up, but we don't care... 
        % If 
        %if(sum(sign([gps_heading gps_pa]))==0)
        if ((sign(gps_heading) ~= sign(pa_degree))&&(abs(diff_angle)>180))
            diff_angle = -diff_angle;
        end

        if(diff_angle >= 0)
            lane_heading = angle_add(pa_degree, -45);   % Turn to right 
        else
            lane_heading = angle_add(pa_degree, 45);   % Turn to left
        end

        lane_case = LANE_CASE.HORIZONTAL;
    else
        % Vertical lane, drive along side it.
%         theta_norm = theta;
%         if (abs(theta) > 45)
%             theta_norm = 0;
%         end
                        % leftright is -1 for right and +1 for left
        lane_heading = angle_add(pa_degree,theta);
        %pa_degree - (theta_norm + leftright * 12);  % Hug Right line (R-Vert alone)
        %lane_heading = pa_degree - (leftright * 15);  %
                %Hug Right line (R-Vert alone)
        lane_case = LANE_CASE.VERTICAL;
    end
end
