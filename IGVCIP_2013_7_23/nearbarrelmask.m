function [Mask] = nearbarrelmask(EdgeRaising,EdgeFalling,Obstacle,i,LadarRange,Angle,para,m_I,n_I)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
HT = para.HT;
fc = para.fc;
cc = para.cc;
alpha_c = para.alpha_c;
kc = para.kc;
Im = para.Im;
In = para.In;
Lidaroffset_x = para.Lidaroffset_x;
T_robot_checker = para.T_robot_checker;
scale = 0.3;

Barrel_radius_offset=0.3;
Index = floor((EdgeRaising(i) + EdgeFalling(i))/2);
Obstacle(i).Range = LadarRange(Index)+Barrel_radius_offset;
Obstacle(i).PositionRange = Angle(Index);

[xM,yM] = pol2cart(Obstacle(i).PositionRange,Obstacle(i).Range);

% xM = xM+ Lidaroffset_x;
% xM = xM-0.3;
% yM = yM-0.5;
xM = xM+ Lidaroffset_x;
yM = yM;
% X_c=[0.3	0.277164	0.2121321	0.1148049	0	-0.1148049	-0.2121321	-0.277164	-0.3	-0.277164	-0.2121321	-0.1148049	0	0.1148049	0.2121321	0.277164 0.3]'*1000;
% Y_c=[0	0.1148049	0.2121321	0.277164	0.3	0.277164	0.2121321	0.1148049	0	-0.1148049	-0.2121321	-0.277164	-0.3	-0.277164	-0.2121321	-0.1148049   0  ]'*1000;
% Z_c=zeros(length(X_c(:)),1);

% X_c=[xM+0.3	xM+0.277164	xM+0.2121321	xM+0.1148049	xM	xM-0.1148049	xM-0.2121321	xM-0.277164	xM-0.3	xM-0.277164	xM-0.2121321	xM-0.1148049	xM	xM+0.1148049	xM+0.2121321	xM+0.277164 xM+0.3]'*1000;
% Y_c=[yM	yM+0.1148049	yM+0.2121321	yM+0.277164	yM+0.3	yM+0.277164	yM+0.2121321	yM+0.1148049	yM	yM-0.1148049	yM-0.2121321	yM-0.277164	yM-0.3	yM-0.277164	yM-0.2121321	yM-0.1148049   yM]'*1000;
%% get a unit circle coordinates
X_c=([cos(0:2*pi/16:2*pi)]'*scale +xM)*1000;
Y_c=([sin(0:2*pi/16:2*pi)]'*scale +yM)*1000;
Z_c=zeros(length(X_c(:)),1);
%% add offset in x,y and z
X_b=[X_c(:)' X_c(:)']';  % add offset in x
Y_b=[Y_c(:)' Y_c(:)']';   % add offset in y
Z_b=[Z_c(:)'+0 Z_c(:)'+1000]';


[Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, X_b(:), Y_b(:), Z_b(:));
% [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xM*1000, yM*1000, -110);
        [XM1,YM1]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
%         figure();
%         imshow(RGB);
%         hold on,plot(XM1,YM1,'+-')
%         figure();imshow(RGB);
        XM1 = round(double(XM1));
        YM1 = round(double(YM1));
% find the edge
K = convhull(XM1,YM1);
%hold on,plot(Xd_image(K),Yd_image(K))
% plot the barrel mask in green
% hold on,fill(XM1(K),YM1(K),'g')

% get mask form polygon
Mask= poly2mask(XM1(K),YM1(K),m_I,n_I);
%   figure;imshow(Mask);


end

