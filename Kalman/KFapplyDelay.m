close all;clear;clc;
load au_bin@10Hz_1750s.mat

maxCC = zeros(1, 185);
maxPos = zeros(1, 185);
for n=1:185
  cc = xcorr(x(1:10500,n), d(1:10500,1), 80);
  [maxcc, pos] = max(cc);
  maxCC(n) = maxcc;
  maxPos(n) = pos-81;
end

[~, index] = sort(maxCC, 'descend');
x=x(:,index);
sortmaxPos = maxPos(index);

%% donot apply delay
trainN = 10500;
trainX = x(1:trainN,1:50);
trainD = d(1:trainN,:);
testX = x(trainN + 1:end,1:50);
testD = d(trainN + 1:end,:);
testN = N - trainN;

A = (trainD(2:end,:)'*trainD(1:end-1,:))/(trainD'*trainD); % transition matrix 2x2
H = (trainX'*trainD)/(trainD'*trainD); % measurement matrix 185x2
q = trainD(2:end,:)' - A * trainD(1:end-1,:)';
Q = q*q'/trainN;
v = trainX' - H*trainD';
R = v*v'/trainN;

testPre = predictKF(testX, testD, testN, A, H, Q, R);
mse = (testPre(:,1)-testD(:,1))'*(testPre(:,1)-testD(:,1))/testN;
cc = corrcoef(testPre(:,1), testD(:,1));
disp(['MSE: ', num2str(mse), ' CC: ', num2str(cc(2))])
figure(1)
plot(testPre(300:600,1)); hold on
plot(testD(300:600,1)); hold off
legend('predict', 'ground truth')

% trainPre = predictKF(trainX, trainD, trainN, A, H, Q, R);
% testPre = predictKF(testX, testD, testN, A, H, Q, R);
% a = xcorr(trainPre(:,1), trainD(:,1), 30);
b = xcorr(testPre(:,1), testD(:,1), 30);
figure(2)
% plot(-30:30, a); hold on
plot(-30:30, b); % hold off
% legend('train', 'test');
grid on

%% apply delay
for i=1:185
  newX(:,i) = x(47+sortmaxPos(i):17400+sortmaxPos(i),i);
end
newD = d(47:17400,:);

ccList = zeros(1,185);
mseList= zeros(1,185);
for i=2:185
trainN = 10500;
trainX = newX(1:trainN,1:i);
trainD = newD(1:trainN,:);
testX = newX(trainN + 1:end,1:i);
testD = newD(trainN + 1:end,:);
testN = 17400 - 46 - trainN;

A = (trainD(2:end,:)'*trainD(1:end-1,:))/(trainD'*trainD); % transition matrix 2x2
H = (trainX'*trainD)/(trainD'*trainD); % measurement matrix 185x2
q = trainD(2:end,:)' - A * trainD(1:end-1,:)';
Q = q*q'/trainN;
v = trainX' - H*trainD';
R = v*v'/trainN;

testPre = predictKF(testX, testD, testN, A, H, Q, R);
mse = (testPre(:,1)-testD(:,1))'*(testPre(:,1)-testD(:,1))/testN;
cc = corrcoef(testPre(:,1), testD(:,1));
disp(['MSE: ', num2str(mse), ' CC: ', num2str(cc(2))])
ccList(i) =cc(2);
mseList(i)=mse;
figure(3)
plot(testPre(300:600,1)); hold on
plot(testD(300:600,1)); hold off
legend('predict', 'ground truth')

b = xcorr(testPre(:,1), testD(:,1), 30);
figure(4)
plot(-30:30, b);
grid on

drawnow
end