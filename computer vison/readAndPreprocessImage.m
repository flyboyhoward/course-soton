function Iout = readAndPreprocessImage(filename)
    %Replicate the image 3 times to create an RGB image.
   
    I = imread(filename);
    if ismatrix(I)
        I = cat(3,I,I,I);
    end
    Iout = imresize(I, [224 224]);
end