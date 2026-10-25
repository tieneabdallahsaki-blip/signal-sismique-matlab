function [f, A] = ts_spectre(x, fs)
x = x(:);
N = length(x);
X = 2*abs(fft(x))/N;
f = (0:floor(N/2))' * fs/N;
A = X(1:floor(N/2)+1);
A(1) = A(1)/2;
if nargout == 0
    plot(f, A); grid on;
    xlabel('Fréquence (Hz)'); ylabel('Amplitude');
end
end