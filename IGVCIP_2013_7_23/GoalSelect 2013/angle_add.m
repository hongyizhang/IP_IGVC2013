function [angle] = angle_add(x,y)

    if(x<0)
        x = x+360;
    end

    if(y<0)
        y = y+360;
    end

    angle = x+y;
    angle = angle - 360*floor(angle/360);

    if(angle > 180)
        angle = angle - 360;
    end
    
end

