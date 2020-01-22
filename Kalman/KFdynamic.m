close all;clear;clc;
load au_bin@10Hz_1750s.mat

history=500;

A = (d(2:history,:)'*d(1:history-1,:))/(d(1:history,:)'*d(1:history,:)); % transition matrix 2x2
H = (x(1:history,:)'*d(1:history,:))/(d(1:history,:)'*d(1:history,:)); % measurement matrix 185x2
q = d(2:history,:)' - A * d(1:history-1,:)';
Q = q*q'/19;
v = x(1:history,:)' - H*d(1:history,:)';
R = v*v'/history;

d_priori = zeros(size(d));
d_posteriori = zeros(size(d));
P_priori = zeros([N size(Q)]);
P_posteriori = zeros([N size(Q)]);
K = zeros(N, length(Q), length(R));

% predict time=21
d_priori(history+1,:) = 0;
P_priori(history+1,:,:) = 1e9; % start from know nothing
% correct time=101
K(history+1,:,:) = squeeze(P_priori(history+1,:,:))*H'/(H*squeeze(P_priori(history+1,:,:))*H' + R + 0.00001*eye(185)); % compute the Kalman gain
d_posteriori(history+1,:) = (d_priori(history+1,:)' + squeeze(K(history+1,:,:))*(x(history+1,:)' - H*d_priori(history+1,:)'))'; % update estimation with measurement
P_posteriori(history+1,:,:) = (eye(2) - squeeze(K(history+1,:,:))*H)*squeeze(P_priori(history+1,:,:));

for k=history+2:N
  % estimate AHQR
  A = (d(k-history+1:k-1,:)'*d(k-history:k-2,:))/(d(k-history:k-1,:)'*d(k-history:k-1,:)); % transition matrix 2x2
  H = (x(k-history:k-1,:)'*d(k-history:k-1,:))/(d(k-history:k-1,:)'*d(k-history:k-1,:)); % measurement matrix 185x2
  q = d(k-history+1:k-1,:)' - A * d(k-history:k-2,:)';
  Q = q*q'/(history-1);
  v = x(k-history:k-1,:)' - H*d(k-history:k-1,:)';
  R = v*v'/history;
  
  % predict
  d_priori(k,:) = d_posteriori(k-1,:)*A';
  P_priori(k,:,:) = A*squeeze(P_posteriori(k-1,:,:))*A' + Q;
  % correct
  K(k,:,:) = squeeze(P_priori(k,:,:))*H'/(H*squeeze(P_priori(k,:,:))*H' + R + 0.00001*eye(185));
  d_posteriori(k,:) = (d_priori(k,:)' + squeeze(K(k,:,:))*(x(k,:)' - H*d_priori(k,:)'))';
  P_posteriori(k,:,:) = (eye(2) - squeeze(K(k,:,:))*H)*squeeze(P_priori(k,:,:));

%   % plot
%   figure(1);
%   plot(d(max(1,k-100):k,1))
%   hold on
%   plot(d_posteriori(max(1,k-100):k,1))
%   hold off
%   legend('ground truth', 'predict')
%   drawnow
end

figure(1)
plot(d_posteriori(10501+300:10501+600,1)); hold on
plot(d(10501+300:10501+600,1)); hold off
legend('predict', 'ground truth')

mse = (d_posteriori(10501:end,1)-d(10501:end,1))'*(d_posteriori(10501:end,1)-d(10501:end,1))/testN;
cc = corrcoef(d_posteriori(10501:end,1), d(10501:end,1));
disp(['MSE: ', num2str(mse), ' CC: ', num2str(cc(2))])