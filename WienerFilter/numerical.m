close all;clear;clc;
load ./data/au_bin@10Hz_1750s.mat
x = gpuArray(x);
x = x - mean(x); % turn to zero mean
d = gpuArray(d);
[~, neurons] = size(x); % num of neurons
fL = 8; % length of the winer filter

trainN = 0.8*N;
trainx = x(1:trainN,:);
traind = d(1:trainN,:);
maxIter = 200;
lr = 1e-3; % learning rate
h = zeros(fL, neurons, 2, maxIter, 'gpuArray'); % initial the filter with zero
xpre = zeros(trainN,neurons);
ypre = zeros(trainN,neurons);
Jx = zeros(1, maxIter);
Jy = zeros(1, maxIter);

for n=1:neurons % for each neuron
    for i=1:maxIter % iter to convege
        % forward
        xconv = conv(trainx(:,n), h(:,n,1,i));
    end
end

% for i=1:maxIter % iter to converge
%     for n=1:neurons % for each neuron
%         % forward
%         xconv = conv(trainx(:,n), h(:,n,1,i));
%         xpre(:,n,i) = xconv(1:trainN);
%         yconv = conv(trainx(:,n), h(:,n,2,i));
%         ypre(:,n,i) = yconv(1:trainN);
%         ex = xpre(:,n,i) - d(:,1);
%         ey = ypre(:,n,i) - d(:,2);
%         Jx(n,i) = mean(ex.^2);
%         Jy(n,i) = mean(ey.^2);
% 
%         % backward
%         gx = xcorr(ex, x())
%     end
% end
