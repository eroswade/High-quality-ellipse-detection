Gx = [-1,0,1;-2,0,2;-1,0,1];
Gy = [1,2,1;0,0,0;-1,-2,-1];

filename = '666.jpg';
I = double(rgb2gray(imread(filename)));
dx = imfilter(I,Gx);
dy = imfilter(I,Gy);
obs = abs(dx)+abs(dy);