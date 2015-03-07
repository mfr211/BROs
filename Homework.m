%% BMI Homework
set(0,'DefaultFigureWindowStyle','docked');
clc; clear all; close all;

load('monkeydata_training.mat')

% 1) Computing and displaying a raster plot for a single neuron i (i=1...98), single trial n
% (n=1...100) and angle k (k=1..8 for 3*pi/180...350*pi/180)

n=50;
k=4;
i=45;

figure
imagesc(trial(n,k).spikes(i,:))
set(gca,'YTick',[])
colormap(flipud(gray(256)));
xlabel('"Time"')
title('Raster plot for single trial')

% 1.5) Computing and displaying a population raster plot for all neurons , single trial n
% (n=1...100) and angle k (k=1..8 for 3*pi/180...350*pi/180)

k=6;
n=50;

for i=1:98
    population_raster(i,:)=trial(n,k).spikes(i,:);
end

figure  
imagesc(population_raster);
colormap(flipud(gray(256)));
xlabel('"Time"')
ylabel('Neuron')
title('Raster plot for all neurons of a single trial')


% 2) Computing and displaying a raster plot for one neuron i (i=1...98) and angle k (k=1...8 for 3*pi/180...350*pi/180) over the first m trials
clear
load('monkeydata_training.mat')

m=20;
k=6;
i=30;

for j=1:m
    trial_length(j)=length(trial(j,k).spikes(i,:));
end

max_length=max(trial_length);
trial_raster=zeros(m,max(trial_length));

for j=1:m
    trial_raster(j,1:trial_length(j))=trial(j,k).spikes(i,:);
end
    
imagesc(trial_raster);
colormap(flipud(gray(256)));
xlabel('"Time"')
ylabel('Trial Number')
title('Raster plot of a single neuron for m trials')

% 3) Compute the Peri-Stimulus Time Histogram (PSTH) of a neuron i (i=1...98), for a
% particular direction k (k=1...8 for for 3*pi/180...350*pi/180) for all
% trials

clear
load('monkeydata_training.mat')

delta_t=10;
k=4;
i=5;

for j=1:100
    trial_length(j)=length(trial(j,k).spikes(i,:));
end

max_length=max(trial_length);

trial_sum=zeros(1,max_length); 
    
    
for t=1:max_length-(delta_t-1)   
    
    for j=1:100 % For all trials
        
        padded_trial=[trial(j,k).spikes(i,:) zeros(1,max_length-length(trial(j,k).spikes(i,:)))]; % Zero padding the spike train of a single trial
        trial_sum(t)=trial_sum(t) + sum(padded_trial(t:t+delta_t-1));
    
    end

end 

p=trial_sum/(delta_t*100); % Calculating the PSTH

figure
plot(p);
ylabel('p')
title('Spike density in PSTH')

% Filtering the PSTH

windowsize=50;
b = (1/windowsize)*ones(1,windowsize);
a = 1;

filtered_psth=filter(b,a,p);
figure
plot(filtered_psth)
xlabel('"Time"')
ylabel('p')
title('Smoothed "continous" Spike Density in PSTH')


% 4) Plotting hand trajectories for trial n (n=1...100) at an angle k (k=1...8
% for 3*pi/180...350*pi/180)

clear
load('monkeydata_training.mat')

n=50;
k=4;

figure
plot(trial(n,k).handPos(1,:),trial(n,k).handPos(2,:))
xlabel('x position')
ylabel('y position')
title('Hand Trajectory for Trial n in the k Direction')

% 4.5) Plotting the average hand trajectories for all trials at all angles k (k=1...8
% for 3*pi/180...350*pi/180)

k=1 ;

for n=1:100
    trial_length(n)=length(trial(n,k).handPos(1,:));
end

max_length=max(trial_length);

for t=1:max_length

    x_sum=0;
    y_sum=0;
    
    for n=1:100
        
        x_pos=[trial(n,k).handPos(1,:) zeros(1,max_length-length(trial(n,k).handPos(1,:)))]; % Zero padding to ensure constant length
        y_pos=[trial(n,k).handPos(2,:) zeros(1,max_length-length(trial(n,k).handPos(2,:)))];
        x_sum=x_pos(t)+x_sum;
        y_sum=y_pos(t)+y_sum;
            
    end
    
    x_avg(t)=x_sum/100;
    y_avg(t)=y_sum/100;
end

min_length=min(trial_length);
x_avg=x_avg(1:min_length); % The average position vectors have to be cut to the size of the shortest trial (otherwise the trajectory will return to zero after reaching the desired destination)
y_avg=y_avg(1:min_length);

figure
plot(x_avg,y_avg)
xlabel('x position')
ylabel('y position')
title('Mean Trajecory of Hand in the k direction for 100 Trials')



% 4.75) Plotting the average hand trajectories for all trials at an angle k (k=1...8
% for 3*pi/180...350*pi/180)

figure

for k=1:8

    for n=1:100
        trial_length(n)=length(trial(n,k).handPos(1,:));
    end

    max_length=max(trial_length);

    for t=1:max_length

        x_sum=0;
        y_sum=0;
        for n=1:100
        
            x_pos=[trial(n,k).handPos(1,:) zeros(1,max_length-length(trial(n,k).handPos(1,:)))]; % Zero padding to ensure constant length
            y_pos=[trial(n,k).handPos(2,:) zeros(1,max_length-length(trial(n,k).handPos(2,:)))];
            x_sum=x_pos(t)+x_sum;
            y_sum=y_pos(t)+y_sum;
            
        end
    
        x_avg(t)=x_sum/100;
        y_avg(t)=y_sum/100;
    end



min_length=min(trial_length);
x_avg=x_avg(1:min_length); % The average position vectors have to be cut to the size of the shortest trial (otherwise the trajectory will return to zero after reaching the desired destination)
y_avg=y_avg(1:min_length);


plot(x_avg,y_avg)
hold on

end

hold off

xlabel('x position')
ylabel('y position')
title('Mean Trajectory of Hand in  all Directions for 100 Trials')
legend('30pi/180','70pi/180','110pi/180','150pi/180','190pi/180','230pi/180','310pi/180','350pi/180')

%% 5) Obtaining the tuning curve of a neuron i (i=1...98) by plotting the firing rate averaged across
%time and trials as a function of direction

i=63;

for k=1:length(trial(1,:)) % For all directions

    for n=1:length(trial) % For all trials
        total_spikes(n)=sum(trial(n,k).spikes(i,1:300));
        average_trial_spike_rate(n)=total_spikes(n)/length(trial(n,k).spikes(i,1:300));
    end
    
    average_spike_rate(k)=sum(average_trial_spike_rate)/length(average_trial_spike_rate);
    stdev(k)=std(average_trial_spike_rate/length(trial))
    
   % x(k)=sum(total_spikes)/(300*100)
    
end

figure
errorbar(1:8,average_spike_rate,stdev)
xlabel('Direction')
ylabel('Average Number of Spikes per Millisecond across all Trials')
title('Tuning Curve of Neuron "i" for all "k" Directions')




