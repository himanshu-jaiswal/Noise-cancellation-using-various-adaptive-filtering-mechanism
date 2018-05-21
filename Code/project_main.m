%%% *Study of Noise cancellation using various adaptive filtering mechanism*
% 	
%   HIMANSHU JAISWAL         
%   B.tech Student  (ECE)
%   Vellore Institute of Technology
%% Input signal intialization
clc;
clear all;
close all
size=2;       % size is duration of audio file in secs                 
fs=8192;                        
t=[0:1/fs:size];
N=fs*size;                      
l=length(t);
%msg =1;
msg=input('Cosine Signal(1) or Audio File(2):');
switch msg
    case 1,
        f=35/2;
        voice=cos(2*pi*f*t);
        disp('cosine signal as voice');
    case 2,
        voice1=audioread('D:\Semester 5_fall_2017-18\DSP LAB\duck.wav');
        voice1=voice1';
        voice=100.*voice1(1,1:l);
    otherwise,
        disp('Error');
        quit;
end


%% initialization of noise signal
state=input('Enter  a number (1-7) for different noise signals :');
%state =2;
switch state
    case 1,
      noise=cos(2*pi*(99/2)*t.^2);
      disp('cosine signal with t raised to power 2 generated as noise');
    case 2,
       noise=wgn(1,l,0.01);
        disp('White Gaussian Noise generated as noise');
    case 3,
      noise=[zeros(1,(l-1)/2) ones(1,1) ones(1,(l-1)/2)];
      disp('unit step signal generated as noise');
    case 4,
       noise=t;
       disp('ramp');
    case 5,
        noise=sin(2*pi*(99/2)*t);
        disp('sine signal');
    case 6,
        noise=exp(0.25*t);
        disp('exponential signal generated as noise');
    case 7,
        noise1=audioread('D:\Semester 5_fall_2017-18\DSP LAB\soundfile.wav');
        noise1=noise1';
        noise=noise1(1,1:l);
        disp('Random Noise Signal Downloaded From Internet RANDOM.ORG https://www.random.org/audio-noise/');
    otherwise
        disp('invalid input');
        noise=.1*rand(1,l);
        disp('random signal generated as noise');
end    
%% Normalised LMS algorithm
input=voice+noise;

ref=noise+.25*rand;  %error signal                       

order=2;
w=zeros(order,1); % filter coefficient of adaptive filter
mu=.006;          %step size
for i=1:N-order
   buffer = ref(i:i+order-1);              
   desired(i) = input(i)-buffer*w;         
   w=w+(buffer.*mu*desired(i)/norm(buffer))';
end

%% figure
subplot(4,1,1)
plot(t,voice);
title('voice input');
hold on
subplot(4,1,2)
plot(t,input)
title('voice + noise')
subplot(4,1,3)
plot(t,ref)
title('reference noise');
subplot(4,1,4)
plot(t(order+1:N),desired)
title('Normalised LMS algorithm output')


%% LMS algorithm
w1=zeros(order,1); % filter coefficient of adaptive filter
mu=.006;          %step size
for i=1:N-order
   u = ref(i:i+order-1);  
%   y(i)=(w1(i-1).')*u(i);
   e(i) = input(i)-transpose(w1)*u';
   w1=w1+(mu*e(i)*(u'));  %LMS f(u(n),e(n),mu)= mu*e(n)*(u')
end
figure()
subplot(6,1,1)
plot(t,voice);
title('voice input');
subplot(6,1,4)
plot(t(order+1:N),e)
title('LMS algorithm output')

subplot(6,1,3)
plot(t(order+1:N),desired)
title('Normalised LMS algorithm output')



%% Sign-error LMS algorithm
w2=zeros(order,1); % filter coefficient of adaptive filter
mu=.006;          %step size
for i=1:N-order
   u2 = ref(i:i+order-1);              
   e2(i) = input(i)-u2*w2;         
   w2=w2+(mu*(sign(e2(i))*(u)))';   % sign-error LMS f(u(n),e(n),mu)= mu*e(n)*(u')
end
subplot(6,1,5)
plot(t(order+1:N),e2)
title('Sign-error LMS algorithm output')




%% sign-sign LMS algorithm
w3=zeros(order,1); % filter coefficient of adaptive filter
mu=.006;          %step size
for i=1:N-order
   u3 = ref(i:i+order-1);              
   e3(i) = input(i)-u3*w3;         
   w3=w3+(mu.*(sign(e2(i)).*sign(u))');   % sign-sign LMS f(u(n),e(n),mu)= mu*e(n)*(u')
end

subplot(6,1,6)
plot(t(order+1:N),e3)
title('Sign-sign LMS algorithm output')
subplot(6,1,2)
plot(t,input)
title('noisy signal')
%% SNR calculation
snr_input= snr(voice)
snr_input_noise = snr(input)
snr_NLMS= snr(desired)
snr_LMS= snr(e)
snr_Sign_Error_LMS= snr(e2)
snr_Sign_Sign_LMS= snr(e3)

%% Error curve plotting
figure
subplot(1,4,1)
semilogy((abs(desired))) ;
title('Error curve NLMS ') ;
xlabel('Samples')
ylabel('Error value')
hold on
subplot(1,4,2)
semilogy((abs(e))) ;
title('Error curve LMS ') ;
xlabel('Samples')
ylabel('Error value')
subplot(1,4,3)
semilogy((abs(e2))) ;
title('Error curve Sign-error LMS') ;
xlabel('Samples')
ylabel('Error value')
subplot(1,4,4)
semilogy((abs(e3))) ;
title('Error curve Sign-Sign LMS') ;
xlabel('Samples')
ylabel('Error value')

%% Error curve plotting individually
figure

semilogy((abs(desired))) ;
title('Error curve NLMS ') ;
xlabel('Samples')
ylabel('Error value')

figure

semilogy((abs(e))) ;
title('Error curve LMS ') ;
xlabel('Samples')
ylabel('Error value')

figure

semilogy((abs(e2))) ;
title('Error curve Sign-error LMS') ;
xlabel('Samples')
ylabel('Error value')

figure

semilogy((abs(e3))) ;
title('Error curve Sign-Sign LMS') ;
xlabel('Samples')
ylabel('Error value')