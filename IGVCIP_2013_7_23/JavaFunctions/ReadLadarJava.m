%% Read Image Ladar function
%
% Author: Phuoc H. Nguyen, Tim Wu, Hongyi Zhang
%
% Edited: Phuoc H. Nguyen, Steven Chung
%
% Revised by Dr. Mark J. Paulik
%
% First version: May 16, 2013
%
% Last Updated: May 21, 2013
%
% Abstract: In this function, the Image and ladar data are subscribed from
% ROS.
%
% Call function: [Im, LadarRange, Angle] = ReadImageLadar(pidImage,pidLaser);
%
%% Function begins from here
function [LadarRange,Angle,flagLadar] = ReadLadarJava(Ladarsub,timeout)
%% Parameters
% AngleMin = -90;
% AngleMax = 90;
%AngleResolution = 1;
%AngleResolution = 1;
% AngleMin = -135;
% AngleMax = 135;
% AngleResolution = .5;
%% In Radian
% AngleMin = AngleMin*pi/180;
% AngleMax = AngleMax*pi/180;
%AngleResolution = AngleResolution*pi/180;
%% End of Parameter
% msgLadar = sensor_msgs_LaserScan('read',pidLadar,100);
% msgLadar = sensor_msgs_LaserScan('read',pidLadar,100);    
msgLadar = Ladarsub.takeMessage(timeout);

% [Ladar_m,Ladar_n]=size(msgLadar);
% if (Ladar_n ==1);
if ~isempty(msgLadar)
    %     Angle = msgLadar.angle_min:msgLadar.angle_increment:msgLadar.angle_max;
    %% Generate index
    AngleMin = msgLadar.angle_min;
    AngleMax = msgLadar.angle_max;
    AngleResolution=msgLadar.angle_increment; % must read from laser data
    IndexMin = round((AngleMin-msgLadar.angle_min)/msgLadar.angle_increment) + 1;
    IndexMax = round((AngleMax-msgLadar.angle_min)/msgLadar.angle_increment) + 1;
    IndexPace = round(AngleResolution/msgLadar.angle_increment);
%     Index = IndexMin:IndexPace:IndexMax;
%     Index = uint8(Index);
    Angle = (AngleMin:AngleResolution:AngleMax)';
    %LadarRange = msgLadar.ranges;
    LadarTemp = msgLadar.ranges;
    % Flip the Ladar Data
    Temp = LadarTemp(IndexMin:IndexPace:IndexMax)';
%     Temp = flipdim(Temp,1);
%     LadarRange = Temp';
    LadarRange = Temp;
    %LadarRange = LadarTemp;
    LadarRange(LadarRange>10) = 0;
    flagLadar = 1;
else
    flagLadar = 0;
    Angle = 0;
    LadarRange = 0;
end
end
