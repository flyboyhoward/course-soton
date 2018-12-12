function imgVector = tinyimage(img)
    %crop image into square 
    [height, width, dim] = size(img);
    if height == width
        tinyimg = img;
    elseif height > width   %when image length is larger than width 
        cropsize = int8((height - width)/2);
        tinyimg = imcrop(img,[0 cropsize width width]);
    elseif height < width   %when image length is smaller than width 
        cropsize = int8((width - height)/2);
        tinyimg = imcrop(img,[cropsize 0 height height]);
    end
    K = imresize(tinyimg,[16 16]); %resizes it to a small, fixed, 16x16
    % zero mean image
    K = double(K);
    Sum = sum(K);
    Sum = sum(Sum,2);
    %disp(Sum);
    K = K - Sum/256; % zero means
    % packed into a vector by concatenating each image row
    imgVector = cat(2,K(1,:),K(2,:));
    for k = 3:16
        imgVector = cat(2, imgVector, K(k,:));
    end
end

