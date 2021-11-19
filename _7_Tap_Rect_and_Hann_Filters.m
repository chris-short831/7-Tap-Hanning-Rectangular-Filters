%% Graphing Impulse responses of 7-Tap Hanning and Rectangular Windows
%The impulse response of ideal low-pass digital filter 
%has unit magnitude for digital frequencies F∈[−1/4,1/4] 
%and zero magnitude for digital frequencies F∈[−1/2,−1/4)∪(1/4,1/2] was
%determined by hand and implemented in MATLAB.

fs =16e3; %Sampling frequency in Hz
fc = 4e3; %Cutoff frequency in Hz
M =7; %Samples in h (Filter Tap number)
D = (M-1)/2; %Shift of Samples
F = fc/fs; %Digital Freq
n = 0:M-1; %sample vector beginning at 0
h = F*2*sinc(2*(n-D).*F); %impulse response of ideal low-pass filter

%This filter is a 7-Tap Rectangular window that will be used to filter .wav
%files. It was to be compared to a 7-Tap Hanning Window, so it's filter coefficients
%were scaled by those of a Hanning Window.


w_h = [0.146,0.5,0.854,1,0.854,0.5,0.146]; %Scaling coefficients of Hanning window
h_hanning = h.*w_h; %create Hanning window impulse response

%These two impulse responses were graphed to be compared visually
figure
stem(n,h);
hold on;
stem(n,h_hanning);
title('Impulse Responses of 7-Tap Rectangular and 7-Tap Hanning Windows');
xlabel('Time [n]');
ylabel('Magnitude (V)');
legend('7-Tap Rectangular','7-Tap Hanning','Location','South');
grid on;

%% Graph the Frequency and Phase Responses of both Filters to compare them 

subplot(2,1,1);
F = linspace(0,0.5);
%Find frequency response H(F) by taking the DTFT of h[n]
H_rect = -0.1061 + 0.0*exp(-1j*2*pi*F) + 0.3183*exp(-1j*2*pi*2*F) + 0.5*exp(-1j*2*pi*3*F) + 0.3183*exp(-1j*2*pi*4*F) + 0.0*exp(-1j*2*pi*5*F) + -0.1061*exp(-j*2*pi*6*F);
%Find magnitude of H(F)
mag_rect = 20*log10(abs(H_rect));
%create analog frequency vector
Fanalog = 16000*F;
plot(Fanalog,mag_rect);

hold on;

%Find frequency response H(F) by taking the DTFT of h[n] of the Hanning
%window
H_hann = -0.1061*0.146 + 0.0*0.5*exp(-1j*2*pi*F) + 0.3183*0.854*exp(-1j*2*pi*2*F) + 0.5*1*exp(-1j*2*pi*3*F) + 0.3183*0.8540*exp(-1j*2*pi*4*F) + 0.0*0.5*exp(-1j*2*pi*5*F) + -0.1061*0.1460*exp(-j*2*pi*6*F);
%Find magnitude of H(F)
mag_hann = 20*log10(abs(H_hann));
plot(Fanalog,mag_hann);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Magnitude Response of 7-Tap Rectangular and 7-Tap Hanning Window');
grid on;
legend('7-Tap Rectangular Filter','7-Tap Hanning Filter','Location','southwest');

%Plot Phase Responses of Rectangular and Hanning Window
subplot(2,1,2);
plot(Fanalog,angle(H_rect*(180/pi)));
hold on;
plot(Fanalog,angle(H_hann*(180/pi)));
grid on
xlabel('Frequency (Hz)');
ylabel('Phase (Degrees)')
title('Phase Response 7-Tap Rectangular and 7-Tap Hanning Window');
legend('7-Tap Rectangular Filter','7-Tap Hanning Filter','Location','northwest');




%% Sample a .wav file and Filter it with the 7-Tap Rectangular Filter
%Sample the .wav file 
[y_tea,Fs_tearect] = audioread('tea.wav');

%Take the FT of the .wav file and create the frequency-axis vector 
%to plot the response
ff_tea = fft(y_tea);   
N = length(y_tea);
K_vec = 0:1:(N-1);
F_vec = K_vec*(1/N);
f_vec = F_vec*(Fs_tearect);

%Filter the .wav file using digital_filter_rect function and take the FFT
rect_tea = digital_filter_rect('tea.wav','rect_filter.wav');
fft_rect_tea = fft(rect_tea);

%Plot the magnitude response of the filtered and unfiltered responses 
figure;
plot((f_vec-(Fs_tearect/(2))), fftshift(20*log10(abs(ff_tea))));
title('Magnitude Response of Unfiltered tea.wav');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)')
grid on;

figure;
plot((f_vec-(Fs_tearect/(2))), fftshift(20*log10(abs(ff_tea))));
hold on;
plot((f_vec-(16000/(2))), fftshift(20*log10(abs(fft_rect_tea))));
grid;
title('tea.wav Unfiltered vs. tea.wav Filtered With 7-Tap Rectangular Window');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend('Unfiltered Signal','Filtered Signal','Location','South');






%% %% Compare the Hanning Window and Rectangular Windows
% Filter the .wav file using digital_filter_hann
%compare the filters
rect_tea = digital_filter_rect('tea.wav','rect_filter.wav');
fft_rect_tea = fft(rect_tea);
N = length(rect_tea);
K_vec = 0:1:(N-1);
F_vec = K_vec*(1/N);
f_vec = F_vec*16000;

hanning_tea = digital_filter_hann('tea.wav','hanning_filter.wav');
fft_hanning_tea = fft(hanning_tea);
N = length(hanning_tea);
K_vec = 0:1:(N-1);

plot((f_vec-(16000/(2))), fftshift(20*log10(abs(fft_rect_tea))));
hold on;
plot((f_vec-(16000/(2))), fftshift(20*log10(abs(fft_hanning_tea))));
legend('tea.wav Filtered by Rect','tea.wav Filtered by Hanning');
xlabel('Frequency Hz');
ylabel('Magnitude dB');
grid;
title('Tea.wav filtered by 7-Tap Hanning and 7-Tap Rect Window')



