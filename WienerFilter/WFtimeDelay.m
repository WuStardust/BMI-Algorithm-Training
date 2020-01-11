close all;clear;clc;
load au_bin@10Hz_1750s.mat

maxCC = zeros(1, 185);
maxPos = zeros(1, 185);
for n=1:185
  cc = xcorr(x(1:10500,n), d(1:10500,1), 50);
  [maxcc, pos] = max(abs(cc));
  if (pos<51)
    maxCC(n) = cc(51);
    maxPos(n) = 0;
  else
    maxCC(n) = maxcc;
    maxPos(n) = pos - 51;
  end
end

[~, index] = sort(maxCC, 'descend');
x = x(:,index);
sortPos = maxPos(index);
% sortPos = zeros(1, 185);

fL = 5; H = 5;
[timeBins, channels] = size(x);
maxD = max(sortPos(1:channels));
channels = 30;
X = zeros(timeBins-H-maxD+1, channels*H+1);
for h=1:H
  for n=1:channels
    X(:,channels*(h-1)+n) = x(H-h+1+maxD-sortPos(n):timeBins-h+1-sortPos(n), n);
  end
end
X(:, channels*H+1) = ones(timeBins-H-maxD+1, 1);

trainX = X(1:10500,:);
trainD = d(fL+maxD:10500+fL+maxD-1,:);
r = trainX'*trainX;
Rzs = trainX'*trainD;
hx = r\Rzs(:,1);

pre = X(10501:end,:)*hx;
cc = corrcoef(pre, d(10500+fL+maxD:end,1));
resultCC = cc(2);
preMse = ((pre - d(10500+fL+maxD:end,1))'*(pre - d(10500+fL+maxD:end,1))) / (N-10500-fL-maxD+1);