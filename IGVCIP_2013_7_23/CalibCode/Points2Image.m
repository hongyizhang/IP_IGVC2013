function [Xd_image,Yd_image]=Points2Image(Xs,Ys,Zs,HT,fc,cc,alpha_c,kc)
% [Xd_image,Yd_image]=Points2Image(Xs,Ys,Zs,HT,fc,cc,alpha_c,kc)
% 3D points to distroted image point
% HT:       Homogeneous transform
% fc:       Focal Length          
% cc:       Principal point       
% alpha_c:  Skew             
% kc:       Distortion            

% test input
% Xs=[0   30  30  0   0   0   0   0   0   30  30  30  30  30  30  0   ]*5;
% Ys=[0   0   30  30  0   0   30  30  30  30  30  30  0   0   0   0   ]*5;
% Zs=[0   0   0   0   0   30  30  0   30  30  0   30  30  0   30  30  ]*5;
% 
% % required camera parameters fc, cc, kc, alpha_c
% fc =1.0e+002 *[...
%    3.991760297342907;
%    3.990188385807028 ];
% cc = ...
%   1.0e+002 * [...
%    3.224312153095478;
%    2.482581185454145];
% kc =...
%   [ -0.274053542477266 ;
%    0.069735715734580 ;
%   -0.000077277289922 ;
%    0.000688988250296 ;
%                    0 ];
% alpha_c =      0;
% %% Exterior Orientation:
% Tc = [  -16.721687 	 80.591157 	 398.892001 ];
% Rc = [  -0.139017 	 0.984707 	 -0.105012
%         0.240292 	 -0.069330 	 -0.968222
%         -0.960695 	 -0.159832 	 -0.226979 ];
% HT = [  Rc(1,1:3) Tc(1) ;...
%         Rc(2,1:3) Tc(2) ;...
%         Rc(3,1:3) Tc(3) ;...
%         zeros(1,3) 1    ]

%% Xs to Xc
[Xc,Yc,Zc]=translatePoints(HT,Xs,Ys,Zs);

%% Xc to Xi
%Xi=Xc/Zc;
Xi=Xc./Zc ;
Yi=Yc./Zc ;

%% Xi to Xd
r_sq=[Xi.^2+Yi.^2];
XYi=Xi.*Yi;

X_Distortion_Radial=(1+kc(1)*r_sq + kc(2)*r_sq.^2 + kc(5)*r_sq.^3).*Xi;
Y_Distortion_Radial=(1+kc(1)*r_sq + kc(2)*r_sq.^2 + kc(5)*r_sq.^3).*Yi;
X_Distortion_Tangential=2*kc(3).*XYi + kc(4).*(r_sq+2*(Xi.^2));
Y_Distortion_Tangential=kc(3)*(r_sq+2*(Yi.^2)) + 2*kc(4)*XYi;
Xd=X_Distortion_Radial+X_Distortion_Tangential;
Yd=Y_Distortion_Radial+Y_Distortion_Tangential;
Xd_image=Xd *fc(1) + cc(1);
Yd_image=Yd *fc(2) + cc(2);





