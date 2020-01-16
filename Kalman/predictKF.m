function d_posteriori = predictKF(x, d, n, A, H, Q, R)
d_priori = zeros(size(d));
d_posteriori = zeros(size(d));
P_priori = zeros([n size(Q)]);
P_posteriori = zeros([n size(Q)]);
K = zeros(n, length(Q), length(R));

% predict time=1
d_priori(1,:) = 0;
P_priori(1,:,:) = 1e9; % start from know nothing
% correct time=1
K(1,:,:) = squeeze(P_priori(1,:,:))*H'/(H*squeeze(P_priori(1,:,:))*H' + R); % compute the Kalman gain
d_posteriori(1,:) = (d_priori(1,:)' + squeeze(K(1,:,:))*(x(1,:)' - H*d_priori(1,:)'))'; % update estimation with measurement
P_posteriori(1,:,:) = (eye(2) - squeeze(K(1,:,:))*H)*squeeze(P_priori(1,:,:));

for k=2:n
  % predict
  d_priori(k,:) = d_posteriori(k-1,:)*A';
  P_priori(k,:,:) = A*squeeze(P_posteriori(k-1,:,:))*A' + Q;
  % correct
  K(k,:,:) = squeeze(P_priori(k,:,:))*H'/(H*squeeze(P_priori(k,:,:))*H' + R);
  d_posteriori(k,:) = (d_priori(k,:)' + squeeze(K(k,:,:))*(x(k,:)' - H*d_priori(k,:)'))';
  P_posteriori(k,:,:) = (eye(2) - squeeze(K(k,:,:))*H)*squeeze(P_priori(k,:,:));
end
end