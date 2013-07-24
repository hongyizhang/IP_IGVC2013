function [ fc ] = readyaml2( yaml, Image_pid, Image_msgs, LaserScan_pid, LaserScan_msgs)
%Hongyi Zhang Yuting Wu
% 04/21/2013
% Update 5/14/2013
%%
%Load yaml file from folder, in this project the we have two yaml files
%1. '000a47011109416b.yaml';2. 'stage_husky.yaml'
[filename, pathname] = uigetfile('*.yaml','frame');
yaml=filename;
fid=fopen(yaml,'r')%read yaml file
tline = fgetl(fid);%read yaml file first line
%decide the yaml file is correct or not.
%because the the first line of yaml file is always 'image_width', we can
%use the standard to judge the yaml file.
if (~strcmp(tline(1:12),'image_width:'))
    error('this is not yaml file')
end
%The below function fgetl can store the information from yaml file line by line,
%convert string value to number, and then store them. For example
%the 'image_width','image_height'and 'camera_name'.
iy=str2num(tline(length('image_width:')+1:length(tline)));%read width
tline = fgetl(fid); %read height
ix=str2num(tline(length('image_height:')+1:length(tline)));
tline = fgetl(fid); %read camera_name
camera_name=(tline(length('camera_name:')+1:length(tline)));
tline = fgetl(fid); %read camera_matrix
tline = fgetl(fid); %read camera_matrix_rows
camera_matrix_rows=str2num(tline(length('  rows:')+1:length(tline)));
tline = fgetl(fid); %read camera_matrix_cols
camera_matrix_cols=str2num(tline(length('  cols:')+1:length(tline)));
tline = fgetl(fid); %read camera_matrix_data
camera_matrix_data=str2num(tline(length('  data:')+1:length(tline)));
tline = fgetl(fid); %read distortion_model
distortion_model=(tline(length('distortion_model:')+1:length(tline)));
tline = fgetl(fid); %read distortion_coefficients
tline = fgetl(fid); %read distortion_coefficients_rows
distortion_coefficients_rows=str2num(tline(length('  rows:')+1:length(tline)));
tline = fgetl(fid); %read distortion_coefficients_cols
distortion_coefficients_cols=str2num(tline(length('  cols:')+1:length(tline)));
tline = fgetl(fid); %read distortion_coefficients_data
distortion_coefficients_data=str2num(tline(length('  data:')+1:length(tline)));
tline = fgetl(fid); %read rectification_matrix
tline = fgetl(fid); %read rectification_matrix_rows
rectification_matrix_rows=str2num(tline(length('  rows:')+1:length(tline)));
tline = fgetl(fid); %read rectification_matrix_cols
rectification_matrix_cols=str2num(tline(length('  cols:')+1:length(tline)));
tline = fgetl(fid); %read rectification_matrix_data
rectification_matrix_data=str2num(tline(length('  data:')+1:length(tline)));
tline = fgetl(fid); %read projection_matrix
tline = fgetl(fid); %read projection_matrix_rows
projection_matrix_rows=str2num(tline(length('  rows:')+1:length(tline)));
tline = fgetl(fid); %read projection_matrix_cols
projection_matrix_cols=str2num(tline(length('  cols:')+1:length(tline)));
tline = fgetl(fid); %read projection_matrix_data
projection_matrix_data=str2num(tline(length('  data:')+1:length(tline)));

fclose(fid); %close the yaml file
%-- Focal length:
fc=[camera_matrix_data(1,1);camera_matrix_data(1,5)];
%-- Principal point:
cc=[camera_matrix_data(1,3);camera_matrix_data(1,6)];
%-- Distortion coefficients:
kc=distortion_coefficients_data;
%-- Skew coefficient:
alpha_c = 0.000000000000000;
% Extrinsic parameters
% Use Matlab calibration toolbox to get Extrinsic data
% http://www.vision.caltech.edu/bouguetj/calib_doc/
% we get the fc cc kc alpha_c data from above
% then we can run extrinsic_computation.m or extrinsic_computation2.m to
% get checker board's extrinsic data, you need addpath the toolbox_calib
% firstly and get the extrinsic_computation2.m
addpath('/home/administrator/Matlab/Matlab_clibration/toolbox_calib');
%check the extrinsic_computation function is existence or not, if it
%doesn't exist, notice user to download toolbox, and then do attpath.
if (2~=exist('extrinsic_computation'))
    display('===============================================')
    display('Matlab camera calibration toolbox not found!!!!')
    display('Please download matlab camera calibration toolbox')
    display('from http://www.vision.caltech.edu/bouguetj/calib_doc/')
    display('and get extrinsic_computation2 from udmyi@hotmail.com')
    display('and addpath to ../toolbox_calib)');
    display('===============================================')
    error('Please download matlab camera calibration toolbox from http://www.vision.caltech.edu/bouguetj/calib_doc/ and addpath to ../toolbox_calib)');
end
%read stage_01.png,which can show user that where the original (0,0) point on the
%check_board and the coordinates of the husky.
stage_01=imread('stage_01.png');
title('robot_center to checker_board(0,0)');
imshow(stage_01)
%the below function can make you to choose GUI manual or automatic inputinput X,Y and lidar
%offset. Enter 'G'for GUI manual, 'L1' for huskystage, 'L2' for realhusky
%and case insensitive.
offset_choose=[];
while (~((strcmp('G',offset_choose))|(strcmp('g',offset_choose))...
        |(strcmp('L1',offset_choose))|(strcmp('l1',offset_choose))...
        |(strcmp('L2',offset_choose))|(strcmp('l2',offset_choose))))
    display('===============================================')
    display('If you want to GUI  manual input X,Y and Lidar offset, enter G')
    display('If you want to Lidar scan  automatic input X,Y and Lidar offset, enter "L1" for huskystage,enter "L2" for realhusky')
    display('===============================================')
    offset_choose = input('GUI or Lidar scan G/L1/L2: ','s');
    %judge the imput command is correct or not, if user input other characters
    %the function will notic user 'You enter a wrong command!!!' and user need
    %input again until the correct command.
    if ~((strcmp('G',offset_choose))|(strcmp('g',offset_choose))...
            |(strcmp('L1',offset_choose))|(strcmp('l1',offset_choose))...
            |(strcmp('L2',offset_choose))|(strcmp('l2',offset_choose)))
        display('You enter a wrong command!!!')
    end
end
%the below function can judge the input command, if input 'G'/'g', the
%function will change to GUI manual input and execute the
%extrinsic_compution, otherwise, function will choose extrinsic_compution2
%to do the automatic input, but the square size of each checkboard need manual
%input, because each checkboard is different.
if (offset_choose=='G'|offset_choose=='g')
    extrinsic_computation
    prompt = {'Enter x_axis offset(m):','Enter y_axis offset:(m)','Enter Lidaroffset:(m)'};
    dlg_title = 'Input From robot_center to checker_board(0,0) and Lidaroffset';
    num_lines = 1;
    %the default offset '0.57','-0.23','0.7'belong to real husky, the stage
    %husky offset are '1','-2','0'.
    def = {'0.57','-0.23','0.7'};
    options.Resize='on';
    answer = inputdlg(prompt,dlg_title,num_lines,def,options);
else
    extrinsic_computation2
end
%after extrinsic compution we can get
%Translation vector: Tc_ext
Tc_ext1=Tc_ext';
%Rotation matrix: Rc_ext
Rc_ext1=Rc_ext;
Tc=Tc_ext1,Rc=Rc_ext1;
%after that, we need to offset checker board's frame back to robot frame
HT = [  Rc(1,1:3) Tc(1) ;...
    Rc(2,1:3) Tc(2) ;...
    Rc(3,1:3) Tc(3) ;...
    zeros(1,3) 1    ];

%the below function can judge the input choose is GUI manual or automatic input
%all unit is meter.
if (offset_choose=='G'|offset_choose=='g')
    x_robot_to_checker=str2num(answer{1}) ; % m
    y_robot_to_checker=str2num(answer{2}) ; % m
    Lidaroffset_x=str2num(answer{3}) ; %m from GUI
    %for huskystage automatic input
elseif (offset_choose=='L1'|offset_choose=='l1')
    x_robot_to_checker=1 ; % m huskystage
    y_robot_to_checker=-2;% m  huskystage
    %laser offset from base_laser_link_base_link.txt, we create
    %a tf_listener.cpp file to get the txt file
    baser_laser_link=importdata('base_laser_link_base_link.txt');
    for baser_laser_link1=1:length(baser_laser_link)
        Lidaroffset_x1(1,baser_laser_link1)=baser_laser_link(1,baser_laser_link1);
    end
    Lidaroffset_x=Lidaroffset_x1(1,3) ;% m from automatic lidar scan
    %for realhusky automatic input
else
    x_robot_to_checker=0.57  ;% m realhusky x_robot_to_checker
    y_robot_to_checker=-0.23 ;% m realhusky y_robot_to_checker
    Lidaroffset_x=0.7        ;% m realhusky Lidaroffset_x
end
% unit mm, offset back to center of the robot
checkeroffset=[x_robot_to_checker;y_robot_to_checker;0]*1000;
T_robot_checker=eye(4);
T_robot_checker(1:3,4)=checkeroffset;

%% Add the IPC_bridge_matlab binaries to  path
% addpath('/opt/ros/fuerte/stacks/ipc-bridge/ipc_msgs/ipc_std_msgs/bin')
% addpath('/opt/ros/fuerte/stacks/ipc-bridge/ipc_msgs/ipc_sensor_msgs/bin')
% addpath('/opt/ros/fuerte/stacks/ipc-bridge/ipc_msgs/ipc_roslib/bin')
% addpath('/opt/ros/fuerte/stacks/ipc-bridge/ipc_msgs/ipc_nav_msgs/bin')
% addpath('/opt/ros/fuerte/stacks/ipc-bridge/ipc_msgs/ipc_geometry_msgs/bin')
% % IPC-Bridge Subscriber Image
% pid=sensor_msgs_Image('connect','subscriber','ipc_image_node','camera/image_color');
% LaserScan_pid=sensor_msgs_LaserScan('connect','subscriber','ipc_laser_node','/lidar/scan');
% Image_n = 0;
% %  Subscriber_LaserScant
% LaserScan_n = 0;
% % Read Image and Laser Scan
% while (Image_n == 0)
%     Image_msgs = sensor_msgs_Image('read',pid,100);
%     [Image_m,Image_n]=size(Image_msgs);
%     if (Image_n == 1)
%         ix=Image_msgs.height;
%         iy=Image_msgs.width;
%         % msg to image
%         % RGB=Msg2Image(Image_msgs);
%         % Img_RGB=Msg2Image(Image_msgs);
%         Img = Msg2Image(Image_msgs);
%         RGB = Img;
%         [row col channel] = size(Img);
%         %         RGB = Img(floor(row/3):row,:,:);
%         figure(1);
%         imshow(RGB)
%         %         LaserScan_n = 0;
%         % Read Laser Scan
%         while(LaserScan_n==0)
%             LaserScan_msgs = sensor_msgs_LaserScan('read',LaserScan_pid,100);
%             [LaserScan_m,LaserScan_n]=size(LaserScan_msgs);
%             if (LaserScan_n ==1);
%                 angle=LaserScan_msgs.angle_min:LaserScan_msgs.angle_increment:LaserScan_msgs.angle_max;
%                 figure(2);
%                 polar(angle,LaserScan_msgs.ranges,'.')
%                 laser_ranges = LaserScan_msgs.ranges;
%             end
%         end
%     end
% end
ix=388;
iy=516;
RGB=imread('realhusky3.jpg');
laser_ranges=0;
angle=0;

% Initialize Bridge
% addpath('/home/administrator/ros/mplab-ros-pkg/matlab_bridge');
% jmb_init();
% MASTER_URI = 'http://ros-minibox-1:11311';
% NODE_NAME = 'listener';
% node = jmb_init_node(NODE_NAME, MASTER_URI);
% sub = edu.ucsd.SubscriberAdapter(node,'camera/image_color','sensor_msgs/Image');
% pub = node.newPublisher('/image_out','sensor_msgs/Image');
% timeout = 5;
% % Ladar setup
% % Ladarsub = sensor_msgs_LaserScan('connect','subscriber','ipc_laser_node','/lidar/scan');
% NODE_NAME = 'LadarListener';
% node = jmb_init_node(NODE_NAME, MASTER_URI);
% Ladarsub = edu.ucsd.SubscriberAdapter(node,'/lidar/scan','sensor_msgs/LaserScan');
% % End of Ladar setup
%
% flagImage = 0;
% while (flagImage == 0)
%     msgImage = subImage.takeMessage(timeout);
%     if isempty(msgImage)
%         logger.warn('timeout');
%         flagImage = 0;
%         RGB = 0;
%     else
%         Img = Msg2Image(msgImage);
%         [row col channel] = size(Img);
%         RGB = Img(floor(row/3):row,:,:);
%         flagImage = 1;
%     end
% end
%%

img=RGB;
% Setup range for generate lookup table ( map )
% maxX=10000;      % mm
maxX=6000;
% minX=0;         % mm
minX=800; 
%maxY=5000;      % mm
maxY=3000;
minY=-maxY;     % mm
% mm_per_Pixel=20;
% mm_per_Pixel=12;
% mm_per_Pixel=13;
mm_per_Pixel=12;
% mm_per_Pixel=15;
%  mm_per_Pixel=16;
%mm_per_Pixel=40;
%mm_per_Pixel=50;
% mm_per_Pixel=10;

% maxX=6000;      % mm
% minX=0;         % mm
% maxY=5000;      % mm
% minY=-maxY;     % mm
% mm_per_Pixel=20;
% generate map image
% Image size
R=RGB(:,:,1);
G=RGB(:,:,1);
B=RGB(:,:,1);
[m_I,n_I] =size(R);

Im=round((maxX-minX)/mm_per_Pixel+1);
In=round((maxY-minY)/mm_per_Pixel+1);
Image=uint8(zeros(Im,In));
Image_loc=zeros(Im*In,1);
I_loc=zeros(Im*In,1);
iY=0;
ind=0;
for i=maxX:-1*mm_per_Pixel:minX
    iY=iY+1;
    iX=0;
    for j=maxY:-1*mm_per_Pixel:minY
        iX=iX+1;
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, i, j, 0);
        [Xd_image,Yd_image]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        Xd_image=round(Xd_image);
        Yd_image=round(Yd_image);
        if (0<Xd_image && Xd_image<=n_I && 0<Yd_image && Yd_image<=m_I)
            %Image(iY,iX)=I(Yd_image,Xd_image);
            ind=ind+1;
            Image_loc(ind)=iY       + (iX-1)*Im;
            %             I_loc(ind)    =Yd_image + (Xd_image-1)*m_I;
            I_loc(ind)    =Xd_image + (Yd_image-1)*n_I;
            
        end
    end
end
% remove empty lookup table
Image_loc(ind+1:Im*In)=[];
I_loc(ind+1:Im*In)=[];
%
CalibrationDate='Stege_test'
RobotName='CaotopPro'
cali_info.CalibrationDate=CalibrationDate;
cali_info.RobotName=RobotName;
cali_info.maxX=maxX;
cali_info.minX=minX;
cali_info.maxY=maxY;
cali_info.minY=minY;
cali_info.mm_per_Pixel=mm_per_Pixel;
cali_info.Lens='StageFOV_110_94';
cali_info.Camera='Stage';
%cali_info.OrgImageSize=[nx ny];
cali_info.I_loc=I_loc;
cali_info.Image_loc=Image_loc;
cali_info.In=In;
cali_info.Im=Im;
%save the above paremeters to a .mat file, inlcude every varible for
%CameraCalibration main fuction. File name, for example, we input
%yaml ='000a47011109416b.yaml', the name will be
%'extrinsic_result_000a47011109416b.yaml.mat'
save(['extrinsic_result_' yaml '.mat'],'fc','cc','kc',...
    'alpha_c','Tc_ext','omc_ext','Rc_ext','yaml','Tc',...
    'Rc','HT','x_robot_to_checker','y_robot_to_checker',...
    'checkeroffset','T_robot_checker','Lidaroffset_x','ix',...
    'iy','img','Im','In','I_loc','Image_loc','mm_per_Pixel', 'cali_info',...
    'laser_ranges','angle')
%the below function is for check CameraCalibration is correct or
%not,depends on the yaml file, we put two choices, one is for realhuskystage
%('000a47011109416b.yaml'); another is for huskystage ('stage_husky(1).yaml')
% if strcmp(yaml,'000a47011109416b.yaml')
%     load('extrinsic_result_000a47011109416b.yaml.mat');
if strcmp(yaml,'cal.yaml')
    load('extrinsic_result_cal.yaml.mat');
    [x,y] = meshgrid(0:97:1000,0:97:970); % unit mm
    [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, x(:)+x_robot_to_checker*1000, y(:)+y_robot_to_checker*1000, zeros(length(x(:)),1));
    % Project point to Image plan
    [Xd_image,Yd_image]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
    % input 'realhusky' image.
    filename='realhusky3' %#ok<NOPTS>
    RGB=imread([filename '.jpg']);
    figure;imshow(RGB);
    %plot the calibration image for realhusky.
    hold on,plot(Xd_image,Yd_image,'r+','MarkerSize',10),hold off
else
    load('extrinsic_result_stage_husky.yaml.mat');
    [x,y] = meshgrid(0:1000:9000,-5000:1000:5000); % unit mm
    [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, x(:), y(:), zeros(length(x(:)),1));
    
    % Project point to Image plan
    [Xd_image,Yd_image]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
    
    % input 'huskystage' image.
    filename='cerberus_stage' %#ok<NOPTS>
    RGB=imread([filename '.jpg']);
    figure;imshow(RGB);
    %plot the calibration image for huskystage.
    hold on,plot(Xd_image,Yd_image,'r+','MarkerSize',10),hold off %,axis equal,axis([0 nx 0 ny])
end

