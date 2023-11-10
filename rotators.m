%% 计算旋转因子
% 范围：0~N/2-1
clear;
clc;
N = 16;
n = 0 : (N/2)-1;
factor = 65536;
width = 18;
depth = 512;
LAYERS = 14;
MAX_DEPTH = 2^(LAYERS - 1);


%% 存储每一级的旋转因子
rotators_real_shifted = zeros(LAYERS, MAX_DEPTH);
rotators_img_shifted = zeros(LAYERS, MAX_DEPTH);

for layer = 1 : 1: LAYERS
    N = 2 ^ (layer);
    n = 0 : 1 : N/2 - 1;
    Wn = exp(-1i*2*pi/N);
    rotators_N = Wn.^n;
    rotators_N_real = real(rotators_N);
    rotators_N_img = imag(rotators_N);
    %扩大65536后截位
    rotators_N_real_shifted = fix (rotators_N_real * factor );
    rotators_N_img_shifted = fix (rotators_N_img * factor );
    
    rotators_real_shifted(layer,1:N/2) = rotators_N_real_shifted;
    rotators_img_shifted(layer,1:N/2) = rotators_N_img_shifted;
end



%% 数据转补码，并写入coe
%也可以不转补码，让计算机自己转
rotators_real_bin = char(zeros(LAYERS, MAX_DEPTH, width));
rotators_img_bin = char(zeros(LAYERS, MAX_DEPTH, width));
length = zeros(1, N/2);
for layer = 1 : 1: LAYERS
    N = 2 ^ (layer);
    n = 0 : 1 : N/2 - 1;
    layer_rotators_real_shifted = rotators_real_shifted(layer, 1:N/2);
    
    name1 = 'rotator_%d_real.coe';
    name1 = sprintf(name1, N);

    fid = fopen(name1,'w');
    fprintf(fid,'memory_initialization_radix = 2;\n');
    fprintf(fid,'memory_initialization_vector = \n');

    for i=1:N/2
        if(layer_rotators_real_shifted(1,i)<0)
            i_rotator_real_bin = dec2bin(layer_rotators_real_shifted(1,i)+2^18, 18);
        else 
            i_rotator_real_bin = dec2bin(layer_rotators_real_shifted(1,i), 18);
        end
        
        fprintf(fid, i_rotator_real_bin);
    
        if i == N/2
          fprintf(fid,';');
        else
          fprintf(fid,',');
        end
        
        if mod(i,1) == 0
          fprintf(fid,'\n');
        end
    end
    fclose(fid);
   
end


for layer = 1 : 1: LAYERS
    N = 2 ^ (layer);
    n = 0 : 1 : N/2 - 1;
    layer_rotators_img_shifted = rotators_img_shifted(layer, 1:N/2);
    
    name1 = 'rotator_%d_img.coe';
    name1 = sprintf(name1, N);

    fid = fopen(name1,'w');
    fprintf(fid,'memory_initialization_radix = 2;\n');
    fprintf(fid,'memory_initialization_vector = \n');

    for i=1:N/2
        if(layer_rotators_img_shifted(1,i)<0)
            i_rotator_img_bin = dec2bin(layer_rotators_img_shifted(1,i)+2^18, 18);
        else 
            i_rotator_img_bin = dec2bin(layer_rotators_img_shifted(1,i), 18);
        end
        
        fprintf(fid, i_rotator_img_bin);
    
        if i == N/2
          fprintf(fid,';');
        else
          fprintf(fid,',');
        end
        
        if mod(i,1) == 0
          fprintf(fid,'\n');
        end
    end
    fclose(fid);
   
end


% 
% rotators_N_real_bin = char(zeros(N/2, width));
% rotators_N_img_bin = char(zeros(N/2, width));
% for i=1:N/2
%     if(rotators_N_real_shifted(1,i)<0)
%         rotators_N_real_bin(i,:) = dec2bin(rotators_N_real_shifted(1,i)+2^18, 18);
%     else 
%         rotators_N_real_bin(i,:) = dec2bin(rotators_N_real_shifted(1,i), 18);
%     end
%     if(rotators_N_img_shifted(1,i)<0)
%         rotators_N_img_bin(i,:) = dec2bin(rotators_N_img_shifted(1,i)+2^18, 18);
%     else 
%         rotators_N_img_bin(i,:) = dec2bin(rotators_N_img_shifted(1,i), 18);
%     end
% end


%% 生成mif文件
% depth = 16; %存储器的深度
% widths = 18; %数据宽度为18位
% max_depth = 512;
% 
% qqq = fopen('Rotator16.mif','wt') %使用fopen函数生成***.mif
% 
% fprintf(qqq, 'WIDTH = %d;\n',widths); %使用fprintf打印depth
% fprintf(qqq, 'DEPTH = %d;\n',depth); %使用fprintf打印width
% fprintf(qqq, 'ADDRESS_RADIX = UNS;\n'); %使用fprintf打印address_radix
% fprintf(qqq,'DATA_RADIX = BIN;\n'); %使用fprintf打印data_radix 
% fprintf(qqq,'CONTENT BEGIN\n'); %使用fprintf打印content begin
% for(x = 1 : depth/2) 
%     fprintf(qqq,'%d:%s;\n',x-1,rotators_N_real_bin(x,:)); 
% end
% for(x = 1 : depth/2) 
%     fprintf(qqq,'%d:%s;\n',x-1+depth/2,rotators_N_img_bin(x,:)); 
% end
% for(x = 1 : max_depth - depth) 
%     fprintf(qqq,'%d:%s;\n',x + depth,rotators_N_real_bin(1,:)); 
% end
% fprintf(qqq, 'END;'); %使用fprintf打印end;
% fclose(qqq);


% fid=fopen('T2.mif','W' );           % 打开T1.mif文件向里面写数据，如果还没有建立这个文件，会自动建立之后打开
% fprintf(fid,'WIDTH=8;\n');          % 数据宽度为8位（灰度值是0-255,8位的数据）
% fprintf(fid,'DEPTH=32400;\n\n');     % 数据的深度（180*180的图片，32400个数据）
% fprintf(fid,'ADDRESS_RADIX=UNS;\n');% 地址数据为无符号数（unsigned）
% fprintf(fid,'DATA_RADIX=UNS;\n\n'); % 像素数据也是无符号数
% fprintf(fid,'CONTENT BEGIN\n');     
% for x = 1:32400                      % 32400个数据
%     fprintf(fid,'%d:%d;\n',x-1,image_1(x)); % 写入数据
% end
% fprintf(fid,'END;');                % 文件结束    
% fclose(fid); 








