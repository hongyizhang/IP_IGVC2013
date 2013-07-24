function [ msg ] = image2msg( imdata,encoding )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   encoding='rgb8'
[ix,iy,d]=size(imdata);
msg=org.ros.message.sensor_msgs.Image();
msg.height=ix;
msg.width=iy;
msg.step=msg.width*d;
msg.encoding=encoding;

switch(  encoding ) % use char convert java string to string
    
    case {'rgba8',  'bgra8','bgra8'}
        if (d~=4)
            error('rgba8 only can take NxMx4 array now')
        end
        if (~strcmp(class(imdata),'uint8'))
            error('rgba8 only can take NxMx4 uint8 array now')
        end
        
    case {'rgb8','bgr8'}
        
        if (d~=3)
            error('rgb8 only can take NxMx3 array now')
        end
        if (~strcmp(class(imdata),'uint8'))
            error('rgb8 only can take NxMx3 uint8 array now')
        end
        
        
    case 'mono8'
        if (d~=1)
            error('mono8 only can take NxMx1 array now')
        end
        if (~strcmp(class(imdata),'uint8'))
            error('mono8 only can take NxMx1 uint8 array now')
        end
        
    case 'mono16'
        if (d~=1)
            error('mono8 only can take NxMx1 array now')
        end
        if (~strcmp(class(imdata),'uint16'))
            error('mono8 only can take NxMx1 uint16 array now')
        end
        
    otherwise
        errorr(['[' encoding '] encoding not suppoted'])
        msg.data=[];
        
        
end

switch (d)
    case {4,3}
        % imdata = X x Y x RGBA
        imdata2=permute(imdata,[3 2 1]); % imdata2= RGBA x Y x X
        
        % convert from uint8 to int8
        msg.data=typecast(imdata2(:),'int8'); % serialize data Nx1 array
    case 1
        % imdata = X x Y x RGBA
        imdata2=permute(imdata,[2 1]); % imdata2= RGBA x Y x X
        
        % convert from uint8 to int8
        msg.data=typecast(imdata2(:),'int8'); % serialize data Nx1 array

    otherwise
        errorr(['[ d=' num2str(d) '] encoding not suppoted'])
        msg.data=[];

end

