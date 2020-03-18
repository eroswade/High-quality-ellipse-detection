function [ellipses, L, posi, lsimg] = ellipseDetectionByArcSupportLSs(I, Tac, Tr, specified_polarity)
%input:
% I: input image
% Tac: elliptic angular coverage (completeness degree)
% Tni: ratio of support inliers on an ellipse
%output:
% ellipses: N by 5. (center_x, center_y, a, b, phi)
% reference:
% 1、von Gioi R Grompone, Jeremie Jakubowicz, Jean-
% Michel Morel, and Gregory Randall, “Lsd: a fast line
% segment detector with a false detection control.,” IEEE
% transactions on pattern analysis and machine intelligence,
% vol. 32, no. 4, pp. 722–732, 2010.
    angleCoverage = Tac;%default 165°
    Tmin = Tr;%default 0.6 
    unit_dis_tolerance = 2; %max([2, 0.005 * min([size(I, 1), size(I, 2)])]);%内点距离的容忍差小于max(2,0.5%*minsize)
    normal_tolerance = pi/9; %法线容忍角度20°= pi/9
    t0 = clock;
    
    % 输出参数 candidates 椭圆参数
    % edge edge图
    % normals 角度 所有椭圆参数上的点的角度
    % lsimg 所有的点图
    if(size(I,3)>1)
        I = rgb2gray(I);
        [candidates, edge, normals, lsimg] = generateEllipseCandidates(I, 2, specified_polarity);%1,sobel; 2,canny
    else
        [candidates, edge, normals, lsimg] = generateEllipseCandidates(I, 2, specified_polarity);%1,sobel; 2,canny
    end
%    figure; imshow(edge);
%     return;
%    subplot(1,2,1);imshow(edge);%show edge image
%    subplot(1,2,2);imshow(lsimg);%show LS image
    t1 = clock;
    disp(['the time of generating ellipse candidates:',num2str(etime(t1,t0))]);
    candidates = candidates';%ellipse candidates matrix Transposition
    if(candidates(1) == 0)%表示没有找到候选圆
        candidates =  zeros(0, 5);
    end
    posi = candidates;
    normals    = normals';%norams matrix transposition
    [y, x]=find(edge);%找到非0元素的行(y)、列(x)的索引
%     ellipses = [];L=[];
%     return;
    [mylabels,labels, ellipses] = ellipseDetection(candidates ,[x, y], normals, unit_dis_tolerance, normal_tolerance, Tmin, angleCoverage, I);%后四个参数 0.5% 20° 0.6 180° 
    disp('-----------------------------------------------------------');
    disp(['running time:',num2str(etime(clock,t0)),'s']);
%     labels
%     size(labels)
%     size(y)
    warning('on', 'all');
     L = zeros(size(I, 1), size(I, 2));%创建与输入图像I一样大小的0矩阵L
     L(sub2ind(size(L), y, x)) = mylabels;%labels,长度等于edge_pixel_n x 1,如果第i个边缘点用于识别了第j个圆，则该行标记为j,否则为0。大小 edge_pixel_n x 1;现在转化存到图像中，在图像中标记
%     figure;imshow(L==2);%LLL
%     imwrite((L==2),'D:\Graduate Design\画图\edge_result.jpg');
end
