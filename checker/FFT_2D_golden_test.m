clear all
close all
x=  fopen('outputs_imag_2.txt','r');
y=  fopen('outputs_real_2.txt','r');
z = fopen('output_imag.txt','r');
w = fopen('output_real.txt','r');
imag = fscanf(x,'%d',1024)
real = fscanf(y,'%d',1024)
imag_design = fscanf(z,'%d',1024)
real_design = fscanf(w,'%d',1024)
golden = complex(real,imag)
design = complex(real_design,imag_design)
error_design = (golden-design)
error_design_value = abs(error_design).^2
golden_value = abs(golden).^2
for i = 1:1
    if i==1
        Error_rms(i) = sqrt(sum(error_design_value(1:1024))/sum(golden_value(1:1024)))
    else 
        Error_rms(i) = sqrt(sum(error_design_value(1024*(i-1):1024*i))/sum(golden_value(1024*(i-1):1024*i)))
    end
end
final_error = sum(Error_rms(:))/1

fclose(x)
fclose(y)
fclose(z)
fclose(w)
        
