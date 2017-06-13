function [positions, features] = readSingleFileSTIP(file)
count = 1;
fp = fopen(file, 'r');
% read header
%fgetl(fp); fgetl(fp); fgetl(fp);
%fgetl(fp);fgetl(fp);
% read keys and descriptors
while ~isempty(fscanf(fp, '%d', 1))%read point type
    fscanf(fp, '%f', 6);
    positions(count, :) = fscanf(fp, '%f', 3);%read x y t 
    features(count, :) = fscanf(fp, '%f', 426);
    count = count + 1;
end
fclose(fp);
end