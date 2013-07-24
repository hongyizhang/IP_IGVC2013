
%% Read Image Ladar function
%
% Author: Phuoc H. Nguyen, Tim Wu, Hongyi Zhang
%
% Edited: Phuoc H. Nguyen, Steven Chung
%
% First version:
%
% Last Updated: May 16, 2013
%
% Abstract: In this function, the Image and ladar data are subscribed from
% ROS.
%
% Call function: [Im, LadarRange, Angle] = ReadImageLadar(pidImage,pidLaser);
%
%% Function begins from here
function [RGB,flagImage] = ReadImageJava(subImage,timeout)
% flagImage = 0;
%% Read Image
% while(flagImage ==0)
msgImage = subImage.takeMessage(timeout);
if isempty(msgImage)
    logger.warn('timeout');
    flagImage = 0;
    RGB = 0;
else
    Img = Msg2Image(msgImage);
    [row col channel] = size(Img);
    RGB = Img;
%     RGB = Img(floor(row/3):row,:,:);
%     RGB = Img(119:388,:,:);
%     RGB = Img;
    flagImage = 1;
end

%     [Image_m,Image_n]=size(msgImage);
%     if (Image_n == 1)
%         RGB = Msg2Image(msgImage);
%         flagImage = 1;
%     else
%         flagImage = 0;
%         RGB = 0;
%     end
% enda
