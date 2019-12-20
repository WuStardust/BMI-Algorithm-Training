load au_bin@10Hz_1750s.mat

figure('Name', 'Input Data')
imagesc(x')

figure('Name', 'Trajectory')
plot(d(1:500,1), d(1:500,2))
