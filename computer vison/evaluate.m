loadimagesets
filename = 'New Text Document.txt'
file_eval = fopen(filename,'r');
for i = 1:3
    tline = fgetl(file_eval);
    linei = strsplit(tline);
    classi = linei{2}
    idx = find(strcmp(classname, classi))
    %run(i) = idx
end
fclose(file_eval);
%groundtruth_filename = 'groundtruth.txt';
%{
function lines = get_lines(fid)
lines = 0;
while ~feof(fid)
fgetl(fid);
lines = lines + 1;
end
end
lines = get_lines(file_eval);
%}

%C & ones(1,4)
%C = A-B
%ap = sum(C)/len