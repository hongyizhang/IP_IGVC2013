if Obstacle(i).Width > 0.25 
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

X_c=[xM+0.3	xM+0.277164	xM+0.2121321	xM+0.1148049	xM	xM-0.1148049	xM-0.2121321	xM-0.277164	xM-0.3	xM-0.277164	xM-0.2121321	xM-0.1148049	xM	xM+0.1148049	xM+0.2121321	xM+0.277164 xM+0.3]'*1000;
Y_c=[yM	yM+0.1148049	yM+0.2121321	yM+0.277164	yM+0.3	yM+0.277164	yM+0.2121321	yM+0.1148049	yM	yM-0.1148049	yM-0.2121321	yM-0.277164	yM-0.3	yM-0.277164	yM-0.2121321	yM-0.1148049   yM]'*1000;
Z_c=zeros(length(X_c(:)),1);
X_b=[X_c(:)' X_c(:)' X_c(:)' X_c(:)']';  % add offset in x
Y_b=[Y_c(:)' Y_c(:)' Y_c(:)' Y_c(:)']';   % add offset in y
Z_b=[Z_c(:)'+0 Z_c(:)'+300 Z_c(:)'+600 Z_c(:)'+1000]';

[Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, X_b(:), Y_b(:), Z_b(:));
% [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xM*1000, yM*1000, -110);
        [XM1,YM1]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        figure();
        imshow(RGB);
        hold on,plot(XM1,YM1,'+-')
        figure();imshow(RGB);
        XM1 = round(double(XM1));
        YM1 = round(double(YM1));
% find the edge
K = convhull(XM1,YM1)
%hold on,plot(Xd_image(K),Yd_image(K))
% plot the barrel mask in green
hold on,fill(XM1(K),YM1(K),'g')

% get mask form polygon
BW = poly2mask(XM1(K),YM1(K),m_I,n_I);
figure;imshow(BW)
        
end