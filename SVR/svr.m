close all;clear;clc;
load au_bin@10Hz_1750s.mat
addpath SVR\libsvm

% split train & test
trainN = 0.6*N;
trainX = x(1:trainN,:);
trainD = d(1:trainN,:);
testX = x(trainN+1:end,:);
testD = d(trainN+1:end,:);

mse = 1e10;
for c=[0.01 0.1 0.5 0.7 1 2 5 10]
  for p=[0.01 0.05 0.1 0.3 0.5 0.7 1 1.5 2 2.5 3 4 5]
    model = svmtrain(trainD(:,1), trainX, ['-s 3 -t 0', ' -c ', num2str(c), ' -p ', num2str(p)]);
    [xpredict, accuracy, ~] = svmpredict(testD(:,1), testX, model);
    if (accuracy(2)<mse)
      mse=accuracy(2); bestc = c; bestp = p;
    end
    figure(1)
    plot(trainD(500:800,1))
    hold on
    plot(xpredict(500:800))
    hold off
    drawnow
  end
end

% [xpredict, accuracy] = svmpredict(trainD(500:800,1), trainX(500:800,:), model);

plot(trainD(500:800,:))
hold on
plot(xpredict)
accuracy