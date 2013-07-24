% gps_decide_heading
% Function Arguments:
% gps_px and gps_py are x and y coordinates in UTM cartesian format offset
% by competition calibration point which is set to 0,0.  positive X is
% meters north of cal point and postive Y is meters West of cal point.
% Therefore, II quadrant angles are postive.
% gps_pa is the compass global heading in degrees
% lline_theta and rline_theta are sent in degrees extracted from the
% hough_l and hough_r structures with [] sent when no line is present.
% the returned output angle is the global heading angle in radians taken
% either directly from the gps_heading calculations herein or computed as
% gps_pa-hough_angle when we are following a line.
%
%   results-1 = gps_px 
%   results-2 = gps_py
%   results-3 = dx % current postion minus previous selected point which
%                  % satisfies the tail_length distance requirement
%   results-4 = dy
%   results-5 = case value to determine the decision history

function [gps_heading, gps_debug] = gpsDecideHeading(px, py, pa_degree, tail_length)
    global gps_history gps_index;
    
    last_index = gps_index-1;
    if(isempty(gps_history))
        gps_history = zeros(15000, 3, 'single');

        last_index = 1;
        gps_history(1, :) = [ px py pa_degree ];
        gps_index = 2;
    else
        last_history = gps_history(last_index, :);
        dist_from_last = norm(last_history(1:2) - [px py]);
        % Prevent us from flooding the tail, which computes fine, but is
        % hard to debug.
        if (dist_from_last > .5)
            % Save the current position
            gps_history(gps_index, :) = [ px py pa_degree ];
            gps_index = gps_index + 1;
        end
            
    end
    
    % Compute difference between current pose and history
    % Note this is absolute (as the bird flies) distance, not distance traveled
    % by the vehicle.
    dx = px - gps_history(last_index:-1:1, 1);
    dy = py - gps_history(last_index:-1:1, 2);

    
    [theta, rho] = cart2pol(dx,dy);
    
    % past_index is the dx/dy index of the previous pose
    % Check on this equation -- <=10 part
    past_index = find(rho >= tail_length, 1, 'first' );
    
    if (~isempty(past_index))
        % If we have a past index, then
        gps_heading = theta(past_index) * 180/pi;
        gps_dx = dx(past_index);
        gps_dy = dy(past_index);
        gps_tail_point = gps_history(past_index, 1:2);
        
    else
        % No past angle. Use initial heading.
        gps_heading = gps_history(1, 3);
        gps_dx = 0;
        gps_dy = 0;
        gps_tail_point = [];
    end
    
    gps_debug.past_index = past_index;
    gps_debug.gps_heading = gps_heading;
    gps_debug.gps_dx = gps_dx;
    gps_debug.gps_dy = gps_dy;
    gps_debug.gps_tail_point = gps_tail_point;

end
