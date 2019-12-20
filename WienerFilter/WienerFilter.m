close all;clear;clc;
load ./data/au_bin@10Hz_1750s.mat
x = gpuArray(x);
d = gpuArray(d);
[~, neurons] = size(x); % num of neurons
fL = 20; % length of the wiener filter

%% analytical solution
h = zeros(fL, neurons, 2, 'gpuArray');
for i=1:neurons % suppose neurons are independent
    % autocorelation matrix
    R = xcorr(x(:,i), fL-1);
    R = R(fL:end)/fL;
    r = toeplitz(R);
    % crosscorelation
    Rzsx = xcorr(x(:,i), d(:,1), fL-1);
    Rzsy = xcorr(x(:,i), d(:,2), fL-1);
    % 
    h(:,i,1) = r\Rzsx(fL:end);
    h(:,i,2) = r\Rzsy(fL:end);
end

%% numerical solution
