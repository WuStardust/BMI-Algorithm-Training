close all;clear;clc;
load au_bin@10Hz_1750s.mat

A = sum(x(1:end-1,:).*x(2:end,:)) ./ sum(x.^2);
H = (x'*x)\(x'*d);
Q = sum((x(2:end,:) - A .* x(1:end-1,:)).^2) / N;
R = sum((d - x*H).^2) / N; % seems too large
