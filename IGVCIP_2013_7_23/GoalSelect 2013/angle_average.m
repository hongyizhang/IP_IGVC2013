function [avg] = angle_average(x,y)
    diff = angle_add(x,(-1*y));
    diff = diff/2;
    avg = angle_add(y,diff);
end
    