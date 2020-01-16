close all;clear;clc;
load au_bin@10Hz_1750s.mat

maxCC = zeros(1, 185);
maxPos = zeros(1, 185);
for n=1:185
  cc = xcorr(x(1:10500,n), d(1:10500,1), 50);
  [maxcc, pos] = max(abs(cc(1:51)));
  maxCC(n) = maxcc;
  maxPos(n) = 51-pos;
end

[sortmaxCC, index] = sort(maxCC, 'descend');
sortmaxPos = maxPos(index);
figure(1)
subplot(2,1,1)
plot(sortmaxCC(1:60))
xlabel('neurons')
ylabel('max crosscorrelation')
subplot(2,1,2)
plot(sortmaxPos(1:60))
ylabel('time delay')
grid on
hold on
plot(0:22, 18*ones(1,23), 'b')
plot(22*ones(1,19), 0:18, 'b')
plot(0:37, 11*ones(1,38), 'r')
plot(37*ones(1,12), 0:11, 'r')
hold off
%%
figure(2);
for n=1:30
  cc=xcorr(x(1:10500,index(n)),d(1:10500,1), 30);
  [~,a] = max(cc);
  trainBias(n)=a-31;
  cc=xcorr(x(10501:end,index(n)),d(10501:end,1), 30);
  [~,a] = max(cc);
  testBias(n)=a-31;
end
plot(trainBias); hold on
plot(testBias); hold off
legend('train', 'test')
xlabel('neurons')
ylabel('time delay')
