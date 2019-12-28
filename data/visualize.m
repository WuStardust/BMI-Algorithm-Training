load au_bin@10Hz_1750s.mat

%% input data
figure('Name', 'Input Data')
imagesc(x')

%% trjectory sample
figure('Name', 'Trajectory')
plot(d(1:500,1), d(1:500,2))

%% cross correlation between target and single nuerons
cross_correlation = sort(abs(x'*d/N), 'descend');
figure('Name', 'Cross-correlation')
plot(cross_correlation(:,1))
hold on 
plot(cross_correlation(:,2))
hold off
