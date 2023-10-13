fs = 1200   ;
N = 128     ;
t = (0:N-1)/fs;


source = sin(2*pi*fs*t) + cos(2*pi*(fs/2)*t);
x = source + 2*randn(size(t));
subplot(3,1,1)
plot(1000*t(1:50),X(1:50))
title("Signal Corrupted with Zero-Mean Random Noise")
xlabel("t (milliseconds)")
ylabel("X(t)")



N = length(source);
threshold = 4;

if N <= threshold
    y = my_dft(source);
else
%even and odd
odd_signal = source(1:2:end).';
even_signal = source(2:2:end).';
%rotators
Wn = exp(-1j * 2 * pi / N);
n = 0:N-1;
k = n.';
n_half = 0:(N/2)-1;
k_half = n_half.';
y_even = my_fft(even_signal);
y_odd = diag(Wn.^k) * my_fft(odd_signal)
end

%% test2
%测试用数据
x = [1 2 -3 -1]
X_fft = fft(x)








