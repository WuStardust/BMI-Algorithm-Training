close all;clear;clc;
load ./data/au_bin@10Hz_1750s.mat
x = gpuArray(x);
x = x - mean(x); % turn to zero mean
d = gpuArray(d);
[~, neurons] = size(x); % num of neurons
fL = 8; % length of the winer filter

h = zeros(fL, neurons, 2, 'gpuArray');
xpre = 0; ypre = 0;
for i=1:neurons % suppose neurons are independent
    % autocorelation matrix
    % main
    R = xcorr(x(:,i), fL-1);
    R = R(fL:end);
    r = toeplitz(R);

    % crosscorelation
    Rzsx = xcorr(d(:,1), x(:,i), fL-1);
    Rzsx = Rzsx(fL:end);

    Rzsy = xcorr(d(:,2), x(:,i), fL-1);
    Rzsy = Rzsy(fL:end);
    % filter impulse response
    h(:,i,1) = r\Rzsx;
    h(:,i,2) = r\Rzsy;
    % apply the filter
    xpre = xpre + conv(x(:,i), h(:,i,1));
    ypre = ypre + conv(x(:,i), h(:,i,2));
end
% plot results
figure('Name', 'X position')
plot(d(5000:5600,1))
hold on
plot(xpre(5000:5600))
figure('Name', 'Y position')
plot(d(5000:5600,2))
hold on
plot(ypre(5000:5600))
