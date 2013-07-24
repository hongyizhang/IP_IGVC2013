function [ EE ] = Print_Obstacl_Test(laser_ranges, angle ,Lidaroffset_x, HT,fc,cc,alpha_c,kc, T_robot_checker, im, nx, ny)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   % Transform laser angle or laser ranges coordinates to Cartesian
    j =1;
            laser_c = 0;
            angle_c = 0;
            for (i=1:1081)
                if (laser_ranges(1,i) < 15) 
                   laser_c(1,j) = laser_ranges(1,i); 
                   angle_c(1,j) = angle(1,i);
                   j = j+1;
                end
            end
   % Transform polar or cylindrical coordinates to Cartesian
   [x,y] = pol2cart(angle_c,laser_c);
    x = x*1000+ Lidaroffset_x*1000;
    y = y*1000;

   [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, x(:), y(:), zeros(length(x(:)),1));

   % Project point to Image plan
   [Xd_image,Yd_image]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
   Xd_image = Xd_image;
   Yd_image = Yd_image;

   
    RGB=im;
    
    figure(10);
    imshow(RGB);
    hold on,plot(Xd_image,Yd_image,'+'),hold off %,axis equal,axis([0 nx 0 ny])
    title (' Camera and Laser Combination Test')    
    EE = 0;

end

