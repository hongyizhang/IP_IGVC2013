function angle_radius=BW2angle(bw)
global TEST
if isempty(TEST)
    TEST=0;
end


%imin=image;
% im=imread('test01.jpg'); bw=im(:,:,3)>200;
% TEST=1
if (TEST>=9)
    figure(4);imshow(bw)
end
%[y,x]=ginput(2)
% y =
%   210.0000
%   350.0000
% x =
%   335.0000
%   418.0000

bw(335:418,210:350)=0; % block radar part0------
if (TEST>=9)
    figure(5);imshow(bw);drawnow;
end
%%
% remove sky part
[m,n]=size(bw);
%bw(1:round(m/2),:)=[];
%resize
%a=imresize(bw,.2);
a=imresize(bw(round(m/2):m,:),.2);

if (TEST>=9)
    figure(6);imshow(a);drawnow;
end

%%% copy left line to right side, right line to left side
%%
[m,n]=size(a);
% m =   418
% n =   557
w=uint16(n/3);
b=a;
%b(:,1:w)=a(:,1:w)|a(:,n-w+1:n);  % or the B&W image ,--> copy the right line to left
%b(:,n-w+1:n)=b(:,1:w);
if (TEST>=9)
    figure(6);imshow(b);
end
% b is the result for copy line
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% This part using polar coondinate

[m,n]=size(b);
[x,y]=find(b==1) ;                  % get white point

x=x-m ;                                  % image size 48X128, Center point [48,64]
y=y-n/2 ;
[t,r]=cart2pol(x,y);                        % convert to polar codinite [Thita,r]
% figure; polar(t,r,'ro'); % t range -2pi~2pi
%   change to 0 ~ 2 pi
t2=((t<0)*2*pi)+t ;
t2=t2-pi/2;  %change to -pi/2 ~ 1.5 pi
if (TEST>=2)
    figure(7); polar(t2,r,'ro');
end
%%
% % % the vehicle is 2.5 ft wide for the gape it can get through is
% % % tand(x)*distance=80 cm , we set distance is 3 m
% % % tand(x)=.8/3 x= 15 degree


dt=uint8((t2/pi)*180)+1; % convert to every degree (use +1 skip 0 ,1-180)
%figure;plot(dt,r,'ro') % convert to membership function  use for defuzz
fuzzymfin(1:181) =90 ; % 0-180 degre , set the max pixel is 100
[m,n]=size(dt);
fuzzymfin(dt(1:m))=min(fuzzymfin(dt(1:m)'),r(1:m)');
if (TEST>=2)
figure(8) ; plot(1:181,fuzzymfin);axis([0 180 0 100])  % plot MF function
end
%%
% apply lowpass filter kill the small gap
MFout=imfilter(fuzzymfin,[1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8 ])  ;
MFout=imfilter(MFout,[1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8] )  ;
if (TEST>=2)
figure(9) ; plot(1:181,MFout);axis([0 180 0 100])  % plot MF function
end
% angle=defuzz(1:181,MFout(:),'som') ;
% angle=defuzz(1:181,MFout(:),'lom') ;
angle=defuzz(1:181,MFout(:),'mom') ;
% figure ; plot(1:181,MFout);axis([0 180 0 100])  % plot MF function
% hold on; line([angle angle],[0 100]);title(strcat('Angle: ',num2str(angle)));

if TEST>=1
    figure(1); polar(t2,r,'ro');
    hold on;
    polar([angle*pi/180, angle*pi/180],[0,100],'b-');
    title(strcat('Angle: ',num2str(angle)));
    hold off
    drawnow
end

% now angle is from 0 to pi , must convert to heading to drive , 
angle_degree=angle -90;
angle_radius=angle_degree/180*pi;
end



