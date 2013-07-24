function [ image ] = Msg2Image( msg )
%MSG2IMAGE Summary of this function goes here
%   Detailed explanation goes here
%   [ image ] = Msg2Image( msg )
%   msg : image data from IPC bridge
%   image: NxMx3 unit8 image
%msg =
%
%           header: [1x1 struct]
%           height: 418
%            width: 745
%         encoding: 'rgba8'
%     is_bigendian: 0
%             step: 2980
%             data: [1x1245640 double]
%msg.header: [1x1 struct]


if (strcmp(msg.encoding,'rgba8'))
    % From here convert msg to image that we can display
    
    % find out what is the size of the image
    d=length(msg.data)/msg.height/msg.width;
    ix=msg.height;
    iy=msg.width;
    
    % msg.data : 1xN double array
    % format is rgba8 , so each pixel is R+G+B+A(alpha) , each 8 bits ( 1 byte)
    % IPC use double to read Uint8 data , we have to convert it back
    % use int8(msg.data) , convert double back to int8 first
    % then use typecast(Array,'uint8') , convert array to UINT8
    % then use reshap(Array,d,iy,ix) to convert it back from c format array 4 x IY x IX
    %image_rgba=reshape(typecast(int8(msg.data),'uint8'),4,iy,ix); % convert to 4x iy x ix array
    
    % Use permute(array, [3 2 1]) , convert 4 x IY x IX , array to IX x IY x 4
    %image2=permute(image_rgba,[3 2 1]); % reshape order to ix x iy x 4
    
    % one line solution
    image3=permute(reshape(typecast(int8(msg.data),'uint8'),4,iy,ix),[3 2 1]);
    
    %figure,imshow(image3(:,:,1:3)) % display rgb (1:3) image
    %title('Image form IPC msg.data')
    image=image3(:,:,1:3);
else
    error('Msg2Image.m : Msg2Image only can take encoding=rgba8 now')
    
end

end

