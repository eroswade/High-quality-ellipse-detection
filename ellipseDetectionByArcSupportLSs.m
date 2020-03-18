function [ellipses, L, posi, lsimg] = ellipseDetectionByArcSupportLSs(I, Tac, Tr, specified_polarity)
%input:
% I: input image
% Tac: elliptic angular coverage (completeness degree)
% Tni: ratio of support inliers on an ellipse
%output:
% ellipses: N by 5. (center_x, center_y, a, b, phi)
% reference:
% 1��von Gioi R Grompone, Jeremie Jakubowicz, Jean-
% Michel Morel, and Gregory Randall, ��Lsd: a fast line
% segment detector with a false detection control.,�� IEEE
% transactions on pattern analysis and machine intelligence,
% vol. 32, no. 4, pp. 722�C732, 2010.
    angleCoverage = Tac;%default 165��
    Tmin = Tr;%default 0.6 
    unit_dis_tolerance = 2; %max([2, 0.005 * min([size(I, 1), size(I, 2)])]);%�ڵ��������̲�С��max(2,0.5%*minsize)
    normal_tolerance = pi/9; %�������̽Ƕ�20��= pi/9
    t0 = clock;
    
    % ������� candidates ��Բ����
    % edge edgeͼ
    % normals �Ƕ� ������Բ�����ϵĵ�ĽǶ�
    % lsimg ���еĵ�ͼ
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
    if(candidates(1) == 0)%��ʾû���ҵ���ѡԲ
        candidates =  zeros(0, 5);
    end
    posi = candidates;
    normals    = normals';%norams matrix transposition
    [y, x]=find(edge);%�ҵ���0Ԫ�ص���(y)����(x)������
%     ellipses = [];L=[];
%     return;
    [mylabels,labels, ellipses] = ellipseDetection(candidates ,[x, y], normals, unit_dis_tolerance, normal_tolerance, Tmin, angleCoverage, I);%���ĸ����� 0.5% 20�� 0.6 180�� 
    disp('-----------------------------------------------------------');
    disp(['running time:',num2str(etime(clock,t0)),'s']);
%     labels
%     size(labels)
%     size(y)
    warning('on', 'all');
     L = zeros(size(I, 1), size(I, 2));%����������ͼ��Iһ����С��0����L
     L(sub2ind(size(L), y, x)) = mylabels;%labels,���ȵ���edge_pixel_n x 1,�����i����Ե������ʶ���˵�j��Բ������б��Ϊj,����Ϊ0����С edge_pixel_n x 1;����ת���浽ͼ���У���ͼ���б��
%     figure;imshow(L==2);%LLL
%     imwrite((L==2),'D:\Graduate Design\��ͼ\edge_result.jpg');
end
