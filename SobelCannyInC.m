Gx = [-1,0,1;-2,0,2;-1,0,1];
Gy = [1,2,1;0,0,0;-1,-2,-1];

filename = '666.jpg';
I = rgb2gray(imread(filename));
%cvSobel( src, dx, 1, 0, aperture_size );

%% matlab
% dx = imfilter(I,Gx);
% dy = imfilter(I,Gy);
% obs = abs(dx)+abs(dy);
% edge = edge(I,'canny',[],'both',1/3);

%% cv
dx = cv.Sobel(I, 'XOrder',1, 'YOrder',0, 'DDepth','double');
dy = cv.Sobel(I, 'XOrder',0, 'YOrder',1, 'DDepth','double');
edge = cv.Canny(I,[1 3]);

candidates = [365.273046349205,374.410021755670,513.915895025283,191.000300972328,595.427291957905,427.474087361920,469.292009127394,225.119380709714,390.795009116042,593.813127667585,603.962224777539,171.506938156146,594.476449237431;69.8739399824909,73.4653885606388,148.857931868615,165.796899896276,217.605890033480,240.430792396329,278.667379119709,309.075609699424,309.320033353151,330.893402425936,435.465204476809,443.515971051858,443.465879158265;70.6799039787922,79.8611090584425,80.1728022010149,80.6035575504368,80.6165989812040,190.176961732887,201.400160084477,80.0896710986714,124.402889622087,167.169748429242,71.0889868969064,79.7983794337332,79.8404454495435;50.6193850936559,53.0492370666597,53.2954141527541,53.6881138037618,53.4619195497985,126.161606643977,81.9264652323043,53.7144799613027,82.5537484636705,120.714035900417,44.4441615198037,52.9874030368973,52.9792925251965;0.230964939681483,0.260291458185791,0.0131202891474772,1.30880895420164,-0.00503855433908562,-0.693868011461985,-0.469940595349861,-0.00300304710678283,-0.259259966629781,-1.47759566160650,0.147377397831089,1.95898747831047e-05,0.000994567802728141];

angleCoverage = 165;%default 165°
Tmin = 0.6;%default 0.6 
unit_dis_tolerance = 2; %max([2, 0.005 * min([size(I, 1), size(I, 2)])]);%内点距离的容忍差小于max(2,0.5%*minsize)
normal_tolerance = pi/9; %法线容忍角度20°= pi/9

angles = atan2(dx,dy);
angles = angles(find(edge));
normals = [sin(angles),cos(angles)];

candidates = candidates';%ellipse candidates matrix Transposition
if(candidates(1) == 0)%表示没有找到候选圆
    candidates =  zeros(0, 5);
end
posi = candidates;
% normals    = normals';%norams matrix transposition
[y, x]=find(edge);%找到非0元素的行(y)、列(x)的索引
%     ellipses = [];L=[];
%     return;
[mylabels,labels, ellipses] = ellipseDetection(candidates ,[x, y], normals, unit_dis_tolerance, normal_tolerance, Tmin, angleCoverage, I);%后四个参数 0.5% 20° 0.6 180° 
disp('-----------------------------------------------------------');
% disp(['running time:',num2str(etime(clock,t0)),'s']);
%     labels
%     size(labels)
%     size(y)
warning('on', 'all');
 L = zeros(size(I, 1), size(I, 2));%创建与输入图像I一样大小的0矩阵L
 L(sub2ind(size(L), y, x)) = mylabels;%labels,长度等于edge_pixel_n x 1,如果第i个边缘点用于识别了第j个圆，则该行标记为j,否则为0。大小 edge_pixel_n x 1;现在转化存到图像中，在图像中标记
 

 drawEllipses(ellipses',I);