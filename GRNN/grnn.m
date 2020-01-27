close all;clear;clc;
load au_bin@10Hz_1750s.mat

maxCC = zeros(1, 185);
maxPos = zeros(1, 185);
for n=1:185
  cc = xcorr(x(1:10500,n), d(1:10500,1), 30);
  [maxcc, pos] = max(abs(cc));
  maxCC(n) = maxcc;
  maxPos(n) = pos-31;
  if (abs(maxPos(n))>15)
    maxPos(n) = 0;
  end
end

[~, index] = sort(maxCC, 'descend');
maxPos=maxPos(index);
x=normalize(x(:,index(1:60)));
for i=1:60
  x(:,i)=circshift(x(:,i), -maxPos(i));
end

trainN = 0.6*N;
trainX = x(1:trainN,:);
trainD = d(1:trainN,:);
testN = 0.4*N;
testX = x(trainN+1:end,:);
testD = d(trainN+1:end,:);

gamma = 0.15;
grnnPredict = zeros(testN, 2);
for i=1:testN
  delta = testX(i,:) - x(i:trainN+i-1,:);
  Dsquare = sum(delta.^2, 2);
  kernel = exp(-Dsquare*gamma);
  grnnPredict(i,:) = (kernel'*d(i:trainN+i-1,:))/sum(kernel);
end

mse=(testD-grnnPredict)'*(testD-grnnPredict)/testN;
cc = corrcoef(testD(:,1), grnnPredict(:,1));
disp(['MSE: ', num2str(mse(1)), ' CC: ', num2str(cc(2))])

figure(1)
subplot(2,1,1)
plot(testD(580:880,1))
hold on
plot(grnnPredict(580:880,1))
hold off
title(['gamma ', num2str(gamma), 'MSE: ', num2str(mse(1)), ' CC: ', num2str(cc(2))])
subplot(2,1,2)
plot(testD(580:880,2))
hold on
plot(grnnPredict(580:880,2))
hold off
cc = corrcoef(testD(:,2), grnnPredict(:,2));
title(['gamma ', num2str(gamma), 'MSE: ', num2str(mse(4)), ' CC: ', num2str(cc(2))])
