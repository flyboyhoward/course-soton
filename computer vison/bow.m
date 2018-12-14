% function of BOVW
function bowimage = bow(img, gridStep, patchsize)
    [height,width,Channels] = size(img);
    if (height ~= 256)||(width ~= 256)
        img = imresize(img,[256 256]);  %resize image into 256*256 if it is not 256*256
    else 
        img = img;
    end
    imgVector = [];
    iter = 63; %256/gridStep - 1;
    for x = 1:iter
        for y = 1:iter
            patch = imcrop(img,[(x-1)*gridStep+1 (y-1)*gridStep+1 patchsize-1 patchsize-1]);
            %patch = normalize(double(patch));%normalize
            patchVector = []; %transfer image into vector
            for k = 1:patchsize
               patchVector = cat(2, patchVector, patch(k,:));
            end
            patchVector = quantify(patchVector,64);
            %patchVector = normalize(patchVector,'center','mean');
            imgVector = cat(1,imgVector ,patchVector);
            %patchVector = sum(patch,2); % or flatten like this?
        end
    end
    bowimage = double(imgVector);
end