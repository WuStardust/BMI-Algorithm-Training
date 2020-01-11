close all;clear;clc;
load au_bin@10Hz_1750s.mat

maxCC = zeros(1, 185);
maxPos = zeros(1, 185);
for n=1:185
  cc = xcorr(x(:,n), d(:,1), 50);
  [maxcc, pos] = max(abs(cc));
  if (pos<51)
    maxCC(n) = cc(51);
    maxPos(n) = 0;
  else
    maxCC(n) = maxcc;
    maxPos(n) = pos - 51;
  end
end

[sortmaxCC, index] = sort(maxCC, 'descend');
sortmaxPos = maxPos(index);
figure(1)
subplot(2,1,1)
plot(sortmaxCC(1:60))
subplot(2,1,2)
plot(sortmaxPos(1:60))
grid on