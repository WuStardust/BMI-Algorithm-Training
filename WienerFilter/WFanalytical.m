close all;clear;clc;
fL = 20; % length of the winer filter
load au_bin@10Hz_1750s.mat
X = ensemble(x, fL);
[~, neurons] = size(x); % num of neurons
r = X'*X; % autocorelation matrix
Rzs = X'*d(fL:end,:); % crosscorelation
% filter impulse response
hx = r\Rzs(:,1);
hy = r\Rzs(:,2);
% apply the filter
pre = X*[hx hy];
% plot results
figure('Name', 'X position')
plot(d(5000+fL:5600+fL,1))
hold on
plot(pre(5000:5600,1))
figure('Name', 'Y position')
plot(d(5000+fL:5600+fL,2))
hold on
plot(pre(5000:5600,2))

%% Following codes suppose the channels are independent
% for i=1:1 % suppose neurons are independent
%     % autocorelation matrix
%     R = xcorr(x(:,i), fL-1);
%     R = R(fL:end);
%     r = toeplitz(R);
%     % crosscorelation
%     Rzsx = xcorr(d(:,1), x(:,i), fL-1);
%     Rzsx = Rzsx(fL:end);
%     Rzsy = xcorr(d(:,2), x(:,i), fL-1);
%     Rzsy = Rzsy(fL:end);
%     % filter impulse response
%     h(:,i,1) = r\Rzsx;
%     h(:,i,2) = r\Rzsy;
%     % apply the filter
%     xpre = xpre + conv(x(:,i), h(:,i,1));
%     ypre = ypre + conv(x(:,i), h(:,i,2));
% end
