% function of quantify Vector
function quantVector = quantify(vector,num)
len = length(vector);
quantvector = zeros(1,num);
pixel = 256/num;
for i=1:len
    for j = 1:num
        if vector(i) > (j-1)*pixel && vector(i) <= j*pixel
            quantvector(j) = quantvector(j) + 1;
        end
    end
    %{
    if vector(i) <= 32
        quantvector(1) = quantvector(1) + 1;
    end
    if vector(i) > 32 && vector(i) <= 64
        quantvector(2) = quantvector(2) + 1;
    end
    if vector(i) > 64 && vector(i) <= 96
        quantvector(3) = quantvector(3) + 1;
    end
    if vector(i) > 96 && vector(i) <= 128
        quantvector(4) = quantvector(4) + 1;
    end
    if vector(i) > 128 && vector(i) <= 160
        quantvector(5) = quantvector(5) + 1;
    end
    if vector(i) > 160 && vector(i) <= 192
        quantvector(6) = quantvector(6) + 1;
    end
    if vector(i) > 192 && vector(i) <= 224
        quantvector(7) = quantvector(7) + 1;
    end
    if vector(i) > 224 && vector(i) <= 256
        quantvector(8) = quantvector(8) + 1;
    end 
    %}
end
quantVector = quantvector;
%normalize???
end