clear all
close all
clc

%----------------------------
% INPUT SIGNAL

fprintf("Enter the input signal\n");

numobser = input("Enter number of observations: ");

t = zeros(1,numobser);
y = zeros(1,numobser);

for j = 1:numobser
    fprintf("\nPoint %d\n",j);

    t(j) = input("Time = ");
    y(j) = input("Amplitude = ");
end

%----------------------------
% ORIGINAL SIGNAL

figure;
plot(t,y,'LineWidth',2);
hold on;

%----------------------------
% NOISE GENERATION

noise = 1.5*max(abs(y))*randn(size(y));
yn = y + noise;

plot(t,yn,'LineWidth',2);

legend('Original Signal','Noisy Signal');
title('Original vs Noisy Signal');
xlabel('Time');
ylabel('Amplitude');
grid on;

%----------------------------
% FFT OF ORIGINAL AND NOISY SIGNAL

Fs = input("Enter Sampling Frequency (Hz): ");

N = length(y);

f = (0:N-1)*(Fs/N);

Y = fft(y);
YN = fft(yn);

figure;
plot(f,abs(Y),'LineWidth',2);
hold on;
plot(f,abs(YN),'LineWidth',2);

legend('Original FFT','Noisy FFT');
title('Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

%----------------------------
% BUTTERWORTH LOW PASS FILTER

cutoffFreq =1591.5;
order =1;

[b,a] = butter(order,cutoffFreq/(Fs/2));

filteredSignal = filtfilt(b,a,yn);

%----------------------------
% FILTERED SIGNAL IN TIME DOMAIN

figure;
plot(t,y,'LineWidth',2);
hold on;
plot(t,yn,'LineWidth',2);
plot(t,filteredSignal,'LineWidth',2);

legend('Original Signal','Noisy Signal','Filtered Signal');
title('Time Domain Comparison');
xlabel('Time');
ylabel('Amplitude');
grid on;

%----------------------------
% FFT OF FILTERED SIGNAL

filteredFFT = fft(filteredSignal);

figure;
plot(f,abs(Y),'LineWidth',2);
hold on;
plot(f,abs(YN),'LineWidth',2);
plot(f,abs(filteredFFT),'LineWidth',2);

legend('Original FFT','Noisy FFT','Filtered FFT');
title('Frequency Domain Comparison');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

%----------------------------
% FILTER FREQUENCY RESPONSE

[H,w] = freqz(b,a,1024,Fs);

figure;
plot(w,20*log10(abs(H)),'LineWidth',2);

title('Butterworth Low Pass Filter Response');
xlabel('Frequency (Hz)');
ylabel('Gain');
grid on;

hold on;
xline(cutoffFreq,'r--','Cutoff Frequency');

%----------------------------
% SHOW ATTENUATION

fprintf('\n');
fprintf('Filter Type : Butterworth Low Pass Filter\n');
fprintf('Cutoff Frequency : %.2f Hz\n',cutoffFreq);
fprintf('Filter Order : %d\n',order);