close all;clear;clc;
load au_bin@10Hz_1750s.mat
load WFpredict.mat
load KFpredict.mat

%% input data
figure('Name', 'Input Data')
imagesc(x')

%% trjectory sample
figure('Name', 'Trajectory')
plot3(d(181:330,1), d(181:330,2), 1:150)
xlabel('X position')
ylabel('Y position')
zlabel('Time')
grid on

%% cross correlation between target and single nuerons
cross_correlation = sort(abs(x'*d/N), 'descend');
figure('Name', 'Cross-correlation')
plot(cross_correlation(:,1))
hold on 
plot(cross_correlation(:,2))
hold off

%% show results
figure('Name', 'X position')
plot(d(5000:5300,1))
hold on
plot(WFpredict(5000:5300,1))
plot(KFpredict(5000:5300,1))
legend('target', 'Wiener', 'Kalman')

figure('Name', 'Y position')
plot(d(5000:5300,1))
hold on
plot(WFpredict(5000:5300,1))
plot(KFpredict(5000:5300,1))
legend('target', 'Wiener', 'Kalman')