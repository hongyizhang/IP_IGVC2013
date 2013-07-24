% IGVC 2013 IP - main function
%
% Authors: Phuoc H. Nguyen, Hongyi Zhang, Tim Wu, Christoper Smalley
%
% Revised by: Dr. Mark J. Paulik, Dr. Kristan Mohan, and Steven Chung
%
% First version: May 16, 2013
%
% Last Update: July 23, 2013
%
% Abstract: In this project, a set of seccutive RGB images, first, are captured
% from a IEEE1394 camera. The barrels are detetcted and removed from the
% images by using the Ladar data. Then, the images are processed to
% detect the lane lines.

%% Refresh Matlab
clear all;
close all;
clc;
% cd /home/amrl/fuerte_workspace/sandbox/IGVC_IP_0605/src
%% Select the Running mode
reply = input('Do You want to capture image from camera or use availabe data? Robot[C]/Stage[S]/Data[D]: ', 's');
if isempty(reply)
    reply = 'C';
end
if (reply=='D')||(reply=='d')
    mode = 0;
elseif (reply=='S')||(reply=='s')
    mode = 1;
else
    mode = 2;
end

%% Initialization
% Add matlab files
addpath('CalibCode/');
addpath('Heuristic/');
addpath('GoalSelect 2013/');
addpath('JavaFunctions/');
%addpath('stingray_images/');
% addpath('stingray_images2/');
%addpath('Calibration/');

% Heuristic Initialization
MaskHeur.Overall = ones(8,8,1);
MaskHeur.LeftLane = zeros(8,8,1);
MaskHeur.LeftLane(:,1:4,1) = ones(8,4,1);
MaskHeur.RightLane = zeros(8,8,1);
MaskHeur.RightLane(:,5:8,1) =  ones(8,4,1);
% Set forward and angular speeds
v = 1;
w = 0;
% Initialize flags
flagDisplayImg = 0;
flagDisplayLadar = 0;
flagStop = 1;
Display = 1;


%% %%%%%%%%%%%%%%%%%%%%% Using Pre-Captured Image Sets %%%%%%%%%%%%%%%%%%%%
if mode == 0
    addpath('calibration_mat_file/');
    %         load('calibration12mm.mat');
    load('calibration6m52m_12mm.mat');
    %     load('calibration62(20mm).mat');
    %     load('stingim3.mat');
    %     [a a a NoImg] = size(stingray3);
    load('practice.mat');
    [~,~,~, NoImg] = size(test1);
    % Setup the starting frame
    countframe = 1;
%     tic;
    while(flagStop)
        % Read Image
        % RGB = stingray3(:,:,:,countframe);
        RGB = test1(:,:,:,countframe);
        
        % RGB to grayscale
        Blue = RGB(:,:,3);
        Red = RGB(:,:,1);
        ImgGray = uint8(2*double(Blue)-double(Red));
        %     ImgGray(221:300,431:500) = zeros(80,70,1);
        % Bird eyes view - In the section, we would create bird-eyes view
        % image. "In" and "Im" are the size of bird-eyes view image.
        img_in = ImgGray'; % need to transpose for real pictures
        img_out = zeros(Im,In, 'uint8');
        img_out(Image_loc)=img_in(I_loc);
        % Basic IP
        BW = basicIP_noise_mt2(img_out);
        % Edge Detection
        BW = edge(BW,'sobel');
        %% Count Frame to calculate frame rate
        countframe = countframe + 1;
        if countframe>NoImg
            flagStop = 0;
        end
    end
    % Calculate Frame rate
%     t = toc
%     fps = countframe/t
    % node.shutdown()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END IMAGE SET TESTING %%%%%%%%%%%%%%%%%%%%%
    
    
%% %%%%%%%%%%%%%%%%%%% STAGE SIMULATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif mode == 1
    % Initialize Bridge Stage
    %addpath('/home/amrl/ros/mplab-ros-pkg/matlab_bridge/');
    addpath('/home/administrator/ros/mplab-ros-pkg/matlab_bridge/');
    jmb_init();
    MASTER_URI='http://localhost:11311';
    NODE_NAME='ImageSubscriber';
    node=jmb_init_node(NODE_NAME, MASTER_URI);
    sub=jmb_init_subscriber(node,'/image','sensor_msgs/Image');
    pub = node.newPublisher('/image_out','sensor_msgs/Image');
    timeout=5;
    logger=node.getLog();
    
    % Create Publisher
pub_twist=jmb_init_publisher(node,'/cmd_vel','geometry_msgs/Twist');
msg_twist=org.ros.message.geometry_msgs.Twist();

    % Ladar setup
    %NODE_NAME = 'LadarListener';
    %node = jmb_init_node(NODE_NAME, MASTER_URI);
    Ladarsub = edu.ucsd.SubscriberAdapter(node,'/base_scan','sensor_msgs/LaserScan');
    
%     odomSub=edu.ucsd.SubscriberAdapter(node,'/odom','nav_msgs/Odometry');
    % Load camera projective parameters
    addpath('calibration_mat_file/');
    %     load('Calib10m10m.mat');
    load('CalibStage1010.mat');
    para.nx = iX;
    para.ny = iY;
    Lidaroffset_x=0.7; % unit meter for stage_cerberus_robot. you can check in ~/ros/stageroscam/world$ 
                       % do command 'cat cerberus_camera.inc', then see the
                       % line '# Draw LADA sicklaser270 ( pose [ 0.7 0 -0.1 0] )'
    para.Lidaroffset_x = Lidaroffset_x;
    para.HT = HT;
    para.fc = fc;
    para.cc = cc;
    para.alpha_c = alpha_c;
    para.kc = kc;
    para.T_robot_checker = T_robot_checker;
    para.Im = Im;
    para.In = In;
    countframe = 1;
    % Main Loop
    while(flagStop)
        
        % Read Image
        [RGB,flagImage] = ReadImageJava(sub,timeout);
       
        % RGB to grayscale
        Blue = RGB(:,:,3);
        Red = RGB(:,:,1);
        ImgGray = uint8(2*double(Blue)-double(Red));
        figure();
        imshow(ImgGray);
        % Read Odometry
%         odommsg=odomSub.takeMessage(timeout);
%         curr.x = odommsg.pose.pose.position.x;
%         curr.y = odommsg.pose.pose.position.y;imshow()
%         x= odommsg.pose.pose.orientation.x;
%         y= odommsg.pose.pose.orientation.y;
%         z= odommsg.pose.pose.orientation.z;
%         w= odommsg.pose.pose.orientation.w;
%         [curr.theta, pitch, roll] = quat2angle([w x y z]);
%         fprintf('x %f y %f theta %f\n',curr.x, curr.y, curr.theta*180/pi);
        % Barrel Remove
        % Read Ladar
        [LadarRange,Angle,flagLadar] = ReadLadarJava(Ladarsub,timeout);
       
        % Barrel Detection
        if flagLadar > 0
            % [Obstacle,ObstacleNo,flagObstacle,flagDisplayLadar] = ObstacleDetection(LadarRange,Angle,Display,flagDisplayLadar);
            [Obstacle,ObstacleNo,flagObstacle,flagDisplayLadar,Index,EdgeRaising,EdgeFalling] = ObstacleDetection_7_19_three_points_barrel(LadarRange,Angle,Display,flagDisplayLadar);
        else
            ObstacleNo = 0;
        end
        % Barrel Masking
        if ObstacleNo > 0
            [Mask,ImgGray] = BarrelMask0607_three_points_barrels(ImgGray,Obstacle,ObstacleNo,para,mode,EdgeRaising,EdgeFalling,LadarRange,Angle);
        end
        imshow(ImgGray);
%         figure();
%         imshow(ImgGray);
        % Gray scale
        img_in = ImgGray; % need to transpose for real pictures

        img_out = zeros(Im,In,'uint8');
        img_out(Image_loc)=img_in(I_loc);

        % Basic IP
        BW = img_out; %

        BW(BW<200) = 0;
        BW(BW>=255)=255;
        % Edge Detection
        BW = edge(BW,'sobel');
        % Extract Hough Transform
        lanelines = HoughExtract(BW,4,4,1);
%         subplot(1,2,1);imshow(lanelines);
        subplot(1,2,1);set(lanelines, 'Cdata',);
%         subplot(1,2,2);imshow(img_out);


       % subplot(1,3,3);imshow(ImgGray);
        pause(.02);
        
        % find the best angle to drive;
        angle=BW2angle(lanelines);
        
        % Publish velocity commands
        msg_twist.linear.x=1;
        msg_twist.angular.z=angle;
	    pub_twist.publish(msg_twist);

        %% Publish Image back to ROS
        ImgOut = uint8(200*lanelines);
        if mode == 1
            msg1=image2msg(ImgOut,'mono8');
            pub.publish(msg1)
        end
        %% Count Frame to calculate frame rate
        %countframe = countframe + 1;
%        t = toc
%        fps = 1/t
    end
    %% Calculate Frame rate
%     t = toc
%     fps = countframe/t
    node.shutdown()
%% %%%%%%%%%%%%%%% END STAGE SIMULATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %%%%%%%%%%%%%%%%%%%% REAL ROBOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    
    addpath('/home/administrator/ros/mplab-ros-pkg/matlab_bridge/');
    jmb_init();
    MASTER_URI = 'http://ros-minibox-2.local:11311';
    NODE_NAME='ImageSubscriber';
    node=jmb_init_node(NODE_NAME, MASTER_URI);
    sub=jmb_init_subscriber(node,'camera/image_color','sensor_msgs/Image');
    Impub = node.newPublisher('/image_out','sensor_msgs/Image');
    %twistpub=jmb_init_publisher(node,'/qsNode/cmd_vel','geometry_msgs/Twist');
    %twistmsg=org.ros.message.geometry_msgs.Twist();


    timeout=5;
%     NODE_NAME = 'LadarListener';
%     node = jmb_init_node(NODE_NAME, MASTER_URI);
    Ladarsub = edu.ucsd.SubscriberAdapter(node,'/lidar/scan','sensor_msgs/LaserScan');
 
    NODE_NAME = 'ImagePolarPub';
    node = jmb_init_node(NODE_NAME, MASTER_URI);
    mapPub=jmb_init_publisher(node,'/localmap1','sensor_msgs/LaserScan');%lanelines
    addpath('calibration_mat_file/');
    load('calibration6m52m_12mm.mat')
    para.nx = ix;
    para.ny = iy;
    para.Lidaroffset_x = Lidaroffset_x;
    para.HT = HT;
    para.fc = fc;
    para.cc = cc;
    para.alpha_c = alpha_c;
    para.kc = kc;
    para.T_robot_checker = T_robot_checker;
    para.Im = Im;
    para.In = In;
    %profile on
    
    while(flagStop)
        % Read Image
       
        
        [RGB,flagImage] = ReadImageJava(sub,timeout);
        %% RGB to grayscale
        Blue = RGB(:,:,3);
        Red = RGB(:,:,1);
        ImgGray = uint8(2*double(Blue)-double(Red));
        % Barrel Remove
        % Read Ladar
        [LadarRange,Angle,flagLadar] = ReadLadarJava(Ladarsub,timeout);
        
        % Barrel Detection
        if flagLadar > 0
            [Obstacle,ObstacleNo,flagObstacle,flagDisplayLadar] = ObstacleDetection(LadarRange,Angle,Display,flagDisplayLadar);
        else
            ObstacleNo = 0;
        end
        % Barrel Masking
        if ObstacleNo > 0
            Mask = BarrelMask0607(ImgGray,Obstacle,ObstacleNo,para,mode,I_loc,Image_loc);
            Mask = uint8(Mask);
            ImgGray = ImgGray.*Mask;
        end
        
        % Bird eyes view
        img_in = ImgGray'; % need to transpose for real pictures
        img_out = zeros(Im,In, 'uint8');
        img_out(Image_loc)=img_in(I_loc);
        
        % Basic IP
        BW = basicIP_noise_mt2(img_out);
        % Edge Detection
        BW = edge(BW,'sobel');
        % Extract Hough Transform
        lanelines = HoughExtract(BW,4,4,1);
%        figure; imshow(E16); pause(.02);

%        Mask88 = MaskGenerate(E16);
%         [Goal1 flag]= GoalSelection(Mask88,para);
%         if flag==1
%         d = sqrt(Goal1.x^2+Goal1.y^2);
%         v = 0.7;
%         time = d/0.5;
%         vrotate = Goal1.Heading/time;
%             twistmsg.linear.x=v;
%             twistmsg.angular.z=vrotate;
%             twistpub.publish(twistmsg);
%         end
        
        range_out = toladarQuick(lanelines, 434, 250, .012, -0.82,135, -135, 0.25);%lane_range_rati
       % polar(-135*pi/180:.25*pi/180:135*pi/180, range_out);
       % view([-90 90]);
        
%polar(0:.25:270,range_out)
        LaserMsg =[];
        LaserMsg=org.ros.message.sensor_msgs.LaserScan();
        % Publish Image back to ROS
        LaserMsg.range_max = 135;
        LaserMsg.range_min = -135;
        LaserMsg.ranges = range_out;
        mapPub.publish(LaserMsg)
        %% Publish Image back to ROS
        
            msg1=image2msg(uint8(lanelines)*255,'mono8');
            Impub.publish(msg1)

%            fps = 1/toc
%         
    end
    
    % Calculate Frame rate
%     t = toc
%     node.shutdown()
%% %%%%%%%%%%%%%%%%%%% REAL ROBOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end % end of function