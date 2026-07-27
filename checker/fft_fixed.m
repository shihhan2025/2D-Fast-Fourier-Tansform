clear all
close all
fft_in = fopen('inputs.txt','r');
x = fopen('output_imag.txt','r');
y = fopen('output_real.txt','r');
w_real = [1,0.98078528,0.923879533,0.831469612,0.707106781,0.555570233,0.382683432,0.195090322,0,-0.195090322,-0.382683432,-0.555570233,-0.707106781,-0.831469612,-0.923879533,-0.98078528]
w_imag = -[0,0.195090322,0.382683432,0.555570233,0.707106781,0.831469612,0.923879533,0.98078528,1,0.98078528,0.923879533,0.831469612,0.707106781,0.555570233,0.382683432,0.195090322]
design_imag = fscanf(x,'%d',32)
design_real = fscanf(y,'%d',32)
a = fscanf(fft_in,'%d',[32,32])
a = transpose(a)
r = a(:,4) 
fft_result = fft(r)
real_part = round(real(fft_result))
imag_part = round(imag(fft_result))
%first stage
for i = 1:16
    x1_real(i) = fi((r(i)+r(i+16)),1,19,9)
    x1_imag(i) = fi(0,1,19,9)
    x1_real(i+16) = fi(fi((r(i)-r(i+16)),1,19,9)*fi(w_real(i),1,9,8),1,19,9)
    x1_imag(i+16) = fi(fi((r(i)-r(i+16)),1,19,9)*fi(w_imag(i),1,9,8),1,19,9)
end
%second stage
for i = 1:8
    x2_real(i) = fi((x1_real(i)+x1_real(i+8)),1,19,8)
    x2_imag(i) = fi((x1_imag(i)+x1_imag(i+8)),1,19,8)
    x2_real(i+8) = fi(fi((x1_real(i)-x1_real(i+8)),1,19,8)*fi(w_real(2*(i-1)+1),1,9,8)-fi((x1_imag(i)-x1_imag(i+8)),1,19,8)*fi(w_imag(2*(i-1)+1),1,9,8),1,19,8)
    x2_imag(i+8) = fi(fi((x1_real(i)-x1_real(i+8)),1,19,8)*fi(w_imag(2*(i-1)+1),1,9,8)+fi((x1_imag(i)-x1_imag(i+8)),1,19,8)*fi(w_real(2*(i-1)+1),1,9,8),1,19,8)
end
for i = 17:24
    x2_real(i) = fi((x1_real(i)+x1_real(i+8)),1,19,8)
    x2_imag(i) = fi((x1_imag(i)+x1_imag(i+8)),1,19,8)
    x2_real(i+8) = fi(fi((x1_real(i)-x1_real(i+8)),1,19,8)*fi(w_real(2*(i-17)+1),1,9,8)-fi((x1_imag(i)-x1_imag(i+8)),1,19,8)*fi(w_imag(2*(i-17)+1),1,9,8),1,19,8)
    x2_imag(i+8) = fi(fi((x1_real(i)-x1_real(i+8)),1,19,8)*fi(w_imag(2*(i-17)+1),1,9,8)+fi((x1_imag(i)-x1_imag(i+8)),1,19,8)*fi(w_real(2*(i-17)+1),1,9,8),1,19,8)
end
%third stage
for i = 1:4
    x3_real(i) = fi((x2_real(i)+x2_real(i+4)),1,19,7)
    x3_imag(i) = fi((x2_imag(i)+x2_imag(i+4)),1,19,7)
    x3_real(i+4) = fi(fi((x2_real(i)-x2_real(i+4)),1,19,7)*fi(w_real(4*(i-1)+1),1,9,8)-fi((x2_imag(i)-x2_imag(i+4)),1,19,7)*fi(w_imag(4*(i-1)+1),1,9,8),1,19,7)
    x3_imag(i+4) = fi(fi((x2_real(i)-x2_real(i+4)),1,19,7)*fi(w_imag(4*(i-1)+1),1,9,8)+fi((x2_imag(i)-x2_imag(i+4)),1,19,7)*fi(w_real(4*(i-1)+1),1,9,8),1,19,7)
end
for i = 9:12
    x3_real(i) = fi((x2_real(i)+x2_real(i+4)),1,19,7)
    x3_imag(i) = fi((x2_imag(i)+x2_imag(i+4)),1,19,7)
    x3_real(i+4) = fi(fi((x2_real(i)-x2_real(i+4)),1,19,7)*fi(w_real(4*(i-9)+1),1,9,8)-fi((x2_imag(i)-x2_imag(i+4)),1,19,7)*fi(w_imag(4*(i-9)+1),1,9,8),1,19,7)
    x3_imag(i+4) = fi(fi((x2_real(i)-x2_real(i+4)),1,19,7)*fi(w_imag(4*(i-9)+1),1,9,8)+fi((x2_imag(i)-x2_imag(i+4)),1,19,7)*fi(w_real(4*(i-9)+1),1,9,8),1,19,7)
end
for i = 17:20
    x3_real(i) = fi((x2_real(i)+x2_real(i+4)),1,19,7)
    x3_imag(i) = fi((x2_imag(i)+x2_imag(i+4)),1,19,7)
    x3_real(i+4) = fi(fi((x2_real(i)-x2_real(i+4)),1,19,7)*fi(w_real(4*(i-17)+1),1,9,8)-fi((x2_imag(i)-x2_imag(i+4)),1,19,7)*fi(w_imag(4*(i-17)+1),1,9,8),1,19,7)
    x3_imag(i+4) = fi(fi((x2_real(i)-x2_real(i+4)),1,19,7)*fi(w_imag(4*(i-17)+1),1,9,8)+fi((x2_imag(i)-x2_imag(i+4)),1,19,7)*fi(w_real(4*(i-17)+1),1,9,8),1,19,7)
end
for i = 25:28
    x3_real(i) = fi((x2_real(i)+x2_real(i+4)),1,19,7)
    x3_imag(i) = fi((x2_imag(i)+x2_imag(i+4)),1,19,7)
    x3_real(i+4) = fi(fi((x2_real(i)-x2_real(i+4)),1,19,7)*fi(w_real(4*(i-25)+1),1,9,8)-fi((x2_imag(i)-x2_imag(i+4)),1,19,7)*fi(w_imag(4*(i-25)+1),1,9,8),1,19,7)
    x3_imag(i+4) = fi(fi((x2_real(i)-x2_real(i+4)),1,19,7)*fi(w_imag(4*(i-25)+1),1,9,8)+fi((x2_imag(i)-x2_imag(i+4)),1,19,7)*fi(w_real(4*(i-25)+1),1,9,8),1,19,7)
end
%fourth stage
for i = 1:2
    x4_real(i) = fi((x3_real(i)+x3_real(i+2)),1,19,6)
    x4_imag(i) = fi((x3_imag(i)+x3_imag(i+2)),1,19,6)
    x4_real(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_real(8*(i-1)+1),1,9,8)-fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_imag(8*(i-1)+1),1,9,8),1,19,6)
    x4_imag(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_imag(8*(i-1)+1),1,9,8)+fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_real(8*(i-1)+1),1,9,8),1,19,6)
end
for i = 5:6
    x4_real(i) = fi((x3_real(i)+x3_real(i+2)),1,19,6)
    x4_imag(i) = fi((x3_imag(i)+x3_imag(i+2)),1,19,6)
    x4_real(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_real(8*(i-5)+1),1,9,8)-fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_imag(8*(i-5)+1),1,9,8),1,19,6)
    x4_imag(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_imag(8*(i-5)+1),1,9,8)+fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_real(8*(i-5)+1),1,9,8),1,19,6)
end
for i = 9:10
    x4_real(i) = fi((x3_real(i)+x3_real(i+2)),1,19,6)
    x4_imag(i) = fi((x3_imag(i)+x3_imag(i+2)),1,19,6)
    x4_real(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_real(8*(i-9)+1),1,9,8)-fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_imag(8*(i-9)+1),1,9,8),1,19,6)
    x4_imag(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_imag(8*(i-9)+1),1,9,8)+fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_real(8*(i-9)+1),1,9,8),1,19,6)
end
for i = 13:14
    x4_real(i) = fi((x3_real(i)+x3_real(i+2)),1,19,6)
    x4_imag(i) = fi((x3_imag(i)+x3_imag(i+2)),1,19,6)
    x4_real(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_real(8*(i-13)+1),1,9,8)-fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_imag(8*(i-13)+1),1,9,8),1,19,6)
    x4_imag(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_imag(8*(i-13)+1),1,9,8)+fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_real(8*(i-13)+1),1,9,8),1,19,6)
end
for i = 17:18
    x4_real(i) = fi((x3_real(i)+x3_real(i+2)),1,19,6)
    x4_imag(i) = fi((x3_imag(i)+x3_imag(i+2)),1,19,6)
    x4_real(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_real(8*(i-17)+1),1,9,8)-fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_imag(8*(i-17)+1),1,9,8),1,19,7)
    x4_imag(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_imag(8*(i-17)+1),1,9,8)+fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_real(8*(i-17)+1),1,9,8),1,19,7)
end
for i = 21:22
    x4_real(i) = fi((x3_real(i)+x3_real(i+2)),1,19,6)
    x4_imag(i) = fi((x3_imag(i)+x3_imag(i+2)),1,19,6)
    x4_real(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_real(8*(i-21)+1),1,9,8)-fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_imag(8*(i-21)+1),1,9,8),1,19,6)
    x4_imag(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_imag(8*(i-21)+1),1,9,8)+fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_real(8*(i-21)+1),1,9,8),1,19,6)
end
for i = 25:26
    x4_real(i) = fi((x3_real(i)+x3_real(i+2)),1,19,6)
    x4_imag(i) = fi((x3_imag(i)+x3_imag(i+2)),1,19,6)
    x4_real(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_real(8*(i-25)+1),1,9,8)-fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_imag(8*(i-25)+1),1,9,8),1,19,6)
    x4_imag(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_imag(8*(i-25)+1),1,9,8)+fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_real(8*(i-25)+1),1,9,8),1,19,6)
end
for i = 29:30
    x4_real(i) = fi((x3_real(i)+x3_real(i+2)),1,19,6)
    x4_imag(i) = fi((x3_imag(i)+x3_imag(i+2)),1,19,6)
    x4_real(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_real(8*(i-29)+1),1,9,8)-fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_imag(8*(i-29)+1),1,9,8),1,19,6)
    x4_imag(i+2) = fi(fi((x3_real(i)-x3_real(i+2)),1,19,6)*fi(w_imag(8*(i-29)+1),1,9,8)+fi((x3_imag(i)-x3_imag(i+2)),1,19,6)*fi(w_real(8*(i-29)+1),1,9,8),1,19,6)
end
%fifth stage
for i = 1:16
    x5_real(2*(i-1)+1) = fi((x4_real(2*(i-1)+1)+x4_real(2*i)),1,19,5)
    x5_imag(2*(i-1)+1) = fi((x4_imag(2*(i-1)+1)+x4_imag(2*i)),1,19,5)
    x5_real(2*i) = fi((x4_real(2*(i-1)+1)-x4_real(2*i)),1,19,5)
    x5_imag(2*i) = fi((x4_imag(2*(i-1)+1)-x4_imag(2*i)),1,19,5)
end

%reorder
x = (0:31)
y = bitrevorder(x);
for i = 1:32
    j = y(i)
    x6_real(i) = x5_real(j+1)
    x6_imag(i) = x5_imag(j+1)
end
for i = 1:32
    j = y(i)
    real_test(j+1) = real_part(i)
    imag_test(j+1) = imag_part(i)
end


%error
for i = 1:32
    error_real(i) = real_part(i)-x6_real(i)
    error_imag(i) = imag_part(i)-x6_imag(i)
    abs_error(i) =  error_real(i).^2+error_imag(i).^2
end
for i = 1:32
    design_error_real(i) = real_test(i)-design_real(i)
    design_error_imag(i) = imag_test(i)-design_imag(i)
    design_abs_error(i) =  design_error_real(i).^2+design_error_imag(i).^2
end
x1_imag = transpose(x1_imag)
x2_imag = transpose(x2_imag)
x3_imag = transpose(x3_imag)
x4_imag = transpose(x4_imag)
x5_imag = transpose(x5_imag)
x6_imag = transpose(x6_imag)
x1_real = transpose(x1_real)
x2_real = transpose(x2_real)
x3_real = transpose(x3_real)
x4_real = transpose(x4_real)
x5_real = transpose(x5_real)
x6_real = transpose(x6_real)

sum_fft = sum(sum(abs(fft_result).^2));
sum_error = sum(abs_error(:))
error = sqrt(sum_error/sum_fft)
design_error = sqrt(sum(design_abs_error(:))/sum_fft)

