function [ BW ] = Print_Obstacle( obstacle_m, obstacle_number, obstacle_h, laser_ranges, angle ,Lidaroffset_x, HT,fc,cc,alpha_c,kc, T_robot_checker, im, nx, ny)
%   Function name: Print Obstacle out
%   This function will transform Transform polar or cylindrical coordinates to Cartesian data to image and create the
%   obstacle mask. 
    % Transform laser angle or laser ranges coordinates to Cartesian
    [x,y] = pol2cart(angle(1,obstacle_m(1,1):obstacle_m(2,1)), laser_ranges(1,obstacle_m(1,1):obstacle_m(2,1)));
    
    % Transform unit to mm form m and add lidar offset of x.
    x = x*1000+ Lidaroffset_x*1000; 
    y = y*1000;

    % Transform Lidaro data in Camera Image coordinates
    [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, x(:), y(:), zeros(length(x(:)),1));
    [Xd_image,Yd_image]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
    
    % Load Camera Image 
    RGB=im;
    

    %figure();
    %imshow(RGB); %Show Camera Image with Lidaro data 
    %hold on,plot(Xd_image,Yd_image,'+'),hold off %,axis equal,axis([0 nx 0 ny])

    % Expand Lidaro data to Z dominant for the obstacle mask.
    % Different obstacle has diferent hight.
    Z_c=zeros(length(x(:)),1);
    X_b=[x(:)' x(:)' x(:)' x(:)']';
    Y_b=[y(:)' y(:)' y(:)' y(:)']';
    Z_b=[Z_c(:)'+0 Z_c(:)'+obstacle_h*0.2 Z_c(:)'+obstacle_h*0.5 Z_c(:)'+obstacle_h]';
    
    % Transform Lidaro data in Camera Image coordinates
    [Xchecker, Ychecker, Zchecker] = translatePoints(T_robot_checker^-1, X_b(:), Y_b(:), Z_b(:));    
    [Xd_image,Yd_image]=Points2Image(Xchecker, Ychecker, Zchecker,HT,fc,cc,alpha_c,kc);
    
    % Filter over size Lidaro data points after TF. 
    loc=find((Xd_image>ny | Xd_image<0) |(Yd_image>nx | Yd_image<0));
    Xd_image(loc)=[];    
    Yd_image(loc)=[];
    
    
    %figure();
    %imshow(RGB); %Show Camera Image with Lidaro data 
    %hold on,plot(Xd_image,Yd_image,'+'),hold off %,axis equal,axis([0 nx 0 ny])
   
    
    try
    % convhull returns the convex hull of a set of points in 2-D or 3-D space.
    K = convhull(Xd_image,Yd_image);


    % get Mask form polygon
    BW = poly2mask(Xd_image(K),Yd_image(K),nx, ny);
    catch
    BW = ~(ones(nx,ny));    
    end
    

    %figure()
    %imshow(BW)  

    

end

