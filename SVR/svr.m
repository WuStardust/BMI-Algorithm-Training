close all;clear;clc;
load au_bin@10Hz_1750s.mat
addpath SVR\libsvm

maxCC = zeros(1, 185);
maxPos = zeros(1, 185);
for n=1:185
  cc = xcorr(x(1:10500,n), d(1:10500,1), 80);
  [maxcc, pos] = max(abs(cc(1:81)));
  maxCC(n) = maxcc;
  maxPos(n) = pos-81;
end

[~, index] = sort(maxCC, 'descend');
maxPos=maxPos(index);
x=normalize(x(:,index(1:60)));
for i=1:60
  x(:,i)=circshift(x(:,i), -maxPos(i));
end

trainN = 0.6*N;
trainX = x(1:trainN,:);
trainD = d(1:trainN,:);
valN = 0.2*N;
valX = x(trainN+1:trainN+valN,:);
valD = d(trainN+1:trainN+valN,:);
testN = 0.2*N-7;
testX = x(trainN+valN+1:end,:);
testD = d(trainN+valN+1:end,:);

% mse = 1e10;
mse=[];
% for p=[0.0001 0.005 0.01 0.05 0.1 1]
  for c=[0.01 0.1 1 5 10]
    c=5; p=0.001; g=0.01;
    model = svmtrain(trainD(:,1), trainX, ['-s 3 -t 2 -h 0', ' -c ', num2str(c), ' -p ', num2str(p), ' -g ', num2str(g)]);
    [xpredict, accuracy, ~] = svmpredict(trainD(:,1), trainX, model);
%     if (accuracy(2)<mse)
%       mse=accuracy(2); bestc = c; bestp = p;
%     end
    figure(1)
    plot(trainD(500:800,1))
    hold on
    plot(xpredict(500:800))
    hold off
    title(['-c ', num2str(c), ' -p ', num2str(p)])
    drawnow
  end
% end

% % [xpredict, accuracy] = svmpredict(trainD(500:800,1), trainX(500:800,:), model);
% 
% plot(trainD(500:800,:))
% hold on
% plot(xpredict)
% accuracy
