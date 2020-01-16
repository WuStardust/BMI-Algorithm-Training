close all;clear;clc;
load au_bin@10Hz_1750s.mat

% maxCC = zeros(1, 185);
% maxPos = zeros(1, 185);
% for n=1:185
%   cc = xcorr(x(1:10500,n), d(1:10500,1), 80);
%   [maxcc, pos] = max(abs(cc(1:81)));
%   maxCC(n) = maxcc;
%   maxPos(n) = pos-81;
% end
% 
% [~, index] = sort(maxCC, 'descend');
% x=x(:,index);

history = 8;
x=ensemble(x, history);
trainN = 10500;
trainX = x(1:trainN,:);
trainD = d(1:trainN,:);
testX = x(trainN + 1:end,:);
testD = d(trainN + 1:end,:);
testN = N - trainN - history + 1;

A = (trainD(2:end,:)'*trainD(1:end-1,:))/(trainD'*trainD); % transition matrix 2x2
H = (trainX'*trainD)/(trainD'*trainD); % measurement matrix 185x2
q = trainD(2:end,:)' - A * trainD(1:end-1,:)';
Q = q*q'/trainN;
v = trainX' - H*trainD';
R = v*v'/trainN;

d_priori = zeros(size(testD));
d_posteriori = zeros(size(testD));
P_priori = zeros([testN size(Q)]);
P_posteriori = zeros([testN size(Q)]);
K = zeros(testN, length(Q), length(R));

% predict time=1
d_priori(1,:) = 0;
P_priori(1,:,:) = 1e9; % start from know nothing
% correct time=1
K(1,:,:) = squeeze(P_priori(1,:,:))*H'/(H*squeeze(P_priori(1,:,:))*H' + R); % compute the Kalman gain
d_posteriori(1,:) = (d_priori(1,:)' + squeeze(K(1,:,:))*(x(1,:)' - H*d_priori(1,:)'))'; % update estimation with measurement
P_posteriori(1,:,:) = (eye(2) - squeeze(K(1,:,:))*H)*squeeze(P_priori(1,:,:));

for k=2:testN
  % predict
  d_priori(k,:) = d_posteriori(k-1,:)*A';
  P_priori(k,:,:) = A*squeeze(P_posteriori(k-1,:,:))*A' + Q;
  % correct
  K(k,:,:) = squeeze(P_priori(k,:,:))*H'/(H*squeeze(P_priori(k,:,:))*H' + R);
  d_posteriori(k,:) = (d_priori(k,:)' + squeeze(K(k,:,:))*(testX(k,:)' - H*d_priori(k,:)'))';
  P_posteriori(k,:,:) = (eye(2) - squeeze(K(k,:,:))*H)*squeeze(P_priori(k,:,:));
  
  % % plot
  % figure(1);
  % plot(testD(max(1,k-100):k,1))
  % hold on
  % plot(d_posteriori(max(1,k-100):k,1))
  % hold off
  % drawnow
end

% save results
KFpredict = d_posteriori;
save ./data/KFpredict.mat KFpredict

figure(1)
plot(d_posteriori(300:600,1)); hold on
plot(testD(300:600,1)); hold off
legend('predict', 'ground truth')

figure(2)
a = xcorr(KFpredict(:,1), testD(:,1), 30);
plot(-30:30, a)
grid on

mse = (d_posteriori(:,1)-testD(:,1))'*(d_posteriori(:,1)-testD(:,1))/testN;
cc = corrcoef(d_posteriori(:,1), testD(:,1));
disp(['MSE: ', num2str(mse), ' CC: ', num2str(cc(2))])