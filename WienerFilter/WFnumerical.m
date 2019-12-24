close all;clear;clc;
load au_bin@10Hz_1750s.mat
fL = 8; % length of the winer filter
X = ensemble(x, fL);
[~, neurons] = size(x); % num of neurons

trainN = 0.8*N;
trainX = X(1:trainN,:);
traind = d(fL:trainN+fL-1,:);
maxIter = 500;
lr = 1e-3; % learning rate
h = zeros(fL*neurons+1, 2, maxIter); % initial the filter with zero
J = zeros(maxIter,2);

for i=1:maxIter % iter to convege
  % forward
  predict = trainX*h(:,:,i);
  error = predict - traind;
  J(i,:) = mean(error.^2);
  plot(J(:,1));
  drawnow

  % backward
  h(:,:,i+1) = h(:,:,i) - lr*trainX'*error/trainN;
end
