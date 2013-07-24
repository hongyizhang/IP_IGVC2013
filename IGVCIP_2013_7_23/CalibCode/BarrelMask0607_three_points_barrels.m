function [Mask,ImgGray] = BarrelMask0607_three_points_barrels(ImgGray,Obstacle,ObstacleNo,para,mode,EdgeRaising,EdgeFalling,LadarRange,Angle)
[m_I,n_I] =size(ImgGray);
% Mask = ones(size(Img));
% Parameters
Lidaroffset_x = para.Lidaroffset_x;
T_robot_checker = para.T_robot_checker;
HT = para.HT;
fc = para.fc;
cc = para.cc;
alpha_c = para.alpha_c;
kc = para.kc;
Im = para.Im;
In = para.In;

% BarrelHeight = 10;
if mode == 1
    BarrelHeight = 1200;
    for i=1:ObstacleNo
        if (Obstacle(i).Width > 0.19) && (Obstacle(i).Width < 0.6)
           [Mask] = nearbarrelmask(EdgeRaising,EdgeFalling,Obstacle,i,LadarRange,Angle,para,m_I,n_I);
        else
        %% Transform laser angle or laser ranges coordinates to Cartesian
        % Left side of the obstacle
        [xL,yL] = pol2cart(Obstacle(i).PositionLeft,Obstacle(i).RangeLeft);
        %xL = xL*1000+ Lidaroffset_x;
        xL = (xL+ Lidaroffset_x)*1000;
        yL = yL*1000;
        % yL = yL - 200;
        % Bottom
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xL, yL, -110); % traslate lidar points on lidar coordinates to checkboard coordinates
        [XLB,YLB]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        % Top
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xL, yL, BarrelHeight);
        [XLT,YLT]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        
        % Right side of the obstacle
        [xR,yR] = pol2cart(Obstacle(i).PositionRight,Obstacle(i).RangeRight);
        xR = (xR+ Lidaroffset_x)*1000;
        yR = yR*1000;
        % yR = yR + 200;
        % Bottom
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xR, yR, -110);
        [XRB,YRB]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        % Top
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xR, yR, BarrelHeight);
        [XRT,YRT]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        
        % Middle side of the obstacle
        [xM,yM] = pol2cart(Obstacle(i).PositionRange,Obstacle(i).Range);
        xM = (xM+ Lidaroffset_x)*1000;
        yM = yM*1000;
        % yR = yR + 200;
        % Bottom
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xM, yM, -110);
        [XMB,YMB]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        % Top
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xM, yM, BarrelHeight);
        [XMT,YMT]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        
        
        x = [XLB;XLT;XMB;XMT;XRT;XRB];
        y = [YLB;YLT;YMB;YMT;YRT;YRB];
        x = round(double(x));
        y = round(double(y));
        % filename = 'cerberus_stage'; % put the x,y points to image, then
                                       % check the barrel points is correct
                                       % or not.
%         RGB=imread([filename,'.jpg']);
%         figure();
%         imshow(RGB);
%         hold on, plot(x,y,'r*')

        % convhull returns the convex hull of a set of points in 2-D or 3-D space.
        K = convhull(x,y);
        % hold on,fill(x(K),y(K),'g');
        % get Mask form polygon
        Mask = poly2mask(x(K),y(K),m_I,n_I);
        end
        Mask = ~Mask;
        Mask = uint8(Mask);
%         RGB(:,:,1)=RGB(:,:,1).*Mask;
%         RGB(:,:,2)=RGB(:,:,2).*Mask;
%         RGB(:,:,3)=RGB(:,:,3).*Mask;
        ImgGray = ImgGray.*Mask;
       
    end
%     figure();
%     imshow(RGB);
else
    BarrelHeight = 1200;
    for i=1:ObstacleNo
        %% Transform laser angle or laser ranges coordinates to Cartesian
        % Left side of the obstacle
        [xL,yL] = pol2cart(Obstacle(i).PositionLeft,Obstacle(i).RangeLeft);
        xL = xL*1000+ Lidaroffset_x;
        yL = yL*1000;
        % Bottom
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xL, yL, 0);
        [XLB,YLB]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        % Top
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xL, yL, BarrelHeight);
        [XLT,YLT]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        % Right side of the obstacle
        [xR,yR] = pol2cart(Obstacle(i).PositionRight,Obstacle(i).RangeRight);
        xR = xR*1000+ Lidaroffset_x;
        yR = yR*1000;
        % Bottom
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xR, yR, 0);
        [XRB,YRB]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        % Top
        [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, xR, yR, BarrelHeight);
        [XRT,YRT]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
        
        x = [XLB;XLT;XRT;XRB];
        y = [YLB;YLT;YRT;YRB];
        x = round(double(x));
        y = round(double(y));
        % convhull returns the convex hull of a set of points in 2-D or 3-D space.
        K = convhull(x,y);
        % get Mask form polygon
        Mask = poly2mask(x(K),y(K),m_I,n_I);
        Mask = ~Mask;
    end
end