function y = my_fft(source)

    % source: source signal, 默认是 1*n 维
    % implementation with recursion
    N = length(source);
    threshold = 1;
    
    if N == threshold
        %y = my_dft(source);
        y = source;
    else
    %even and odd
    odd_signal = source(1:2:end).';
    even_signal = source(2:2:end).';
    %rotators
    W = exp(-1j * 2 * pi *(0:N/2-1)/ N);
    y_even = my_fft(even_signal);
    y_odd =  my_fft(odd_signal);
    y = y_even + W.* y_odd;    
    end

end
