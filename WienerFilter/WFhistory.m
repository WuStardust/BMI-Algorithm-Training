close all;clear;clc;
load au_bin@10Hz_1750s.mat

maxCC = zeros(1, 185);
maxPos = zeros(1, 185);
for n=1:185
  cc = xcorr(x(1:10500,n), d(1:10500,1), 50);
  [maxcc, pos] = max(abs(cc));
  if (pos<51)
    maxCC(n) = cc(51);
    maxPos(n) = 0;
  else
    maxCC(n) = maxcc;
    maxPos(n) = pos - 51;
  end
end

[~, index] = sort(maxCC, 'descend');
x = x(:,index);

A = 30; B = 50;
resultCC = zeros(A, B);
preMse = zeros(A, B);
bestCC = 0; bestMse = 1e10;
for fL = 1:A
  for n = 1:B
    X = ensemble(x(:,1:n), fL);
    trainX = X(1:10500,:);
    trainD = d(fL:10500+fL-1,:);
    r = trainX'*trainX;
    Rzs = trainX'*trainD;
    hx = r\Rzs(:,1);

    pre = X(10501:end,:)*hx;
    cc = corrcoef(pre, d(10500+fL:end,1));
    resultCC(fL, n) = cc(2);
    if (cc(2)>bestCC)
      bestCC = cc(2);
      bestCCpre = pre;
      bestCCn = n; bestCCfL = fL;
    end
    preMse(fL, n) = ((pre - d(10500+fL:end,1))'*(pre - d(10500+fL:end,1))) / (N-10500-fL+1);
    if (preMse(fL, n)<bestMse)
      bestMse = preMse(fL, n);
      bestMsepre = pre;
      bestMsen = n; bestMsefL = fL;
    end
  end
end

figure(1)
mesh(resultCC);
title('Correlation coefficient')
xlabel('neurons')
ylabel('history')

figure(2)
mesh(-preMse);
title('Mean-square Error')
xlabel('neurons')
ylabel('history')

%%
figure(3)
subplot(2,1,1)
plot(bestCCpre(300-bestCCfL:600-bestCCfL), 'r'); hold on;
plot(d(10500+299:10500+599,1), 'k'); hold off
legend('best CC', 'Ground truth')
title(['neurons: ', num2str(bestCCn), ' history: ', num2str(bestCCfL), ' CC: ', num2str(bestCC)])
subplot(2,1,2)
plot(bestMsepre(300-bestMsefL:600-bestMsefL), 'b'); hold on
plot(d(10500+299:10500+599,1), 'k'); hold off
legend('best MSE', 'Ground truth')
title(['neurons: ', num2str(bestMsen), ' history: ', num2str(bestMsefL), ' MSE: ', num2str(bestMse)])

%%
a = xcorr(bestMsepre, d(10500+bestMsefL:end,1), 30);
b = xcorr(bestCCpre, d(10500+bestCCfL:end,1), 30);
figure(4)
plot(-30:30, a); hold on;
plot(-30:30, b); hold off;
grid on
