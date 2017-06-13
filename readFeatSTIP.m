function [feats,keys] = readFeatSTIP(info)
ncls = length(info.cls);
for i = 1:ncls
    disp(['from class: ', info.cls{i}, ' ...']); 
    for j = 1:info.ngroup
        k = 1;
        idxGroup = sprintf('%02d', j); 
        while 1
            idxVid = sprintf('%02d', k);
            featFileName = [info.dirfeat, info.cls{i}, ...
                            '/v_', info.cls{i}, '_g', idxGroup, '_c', idxVid, info.suffix];
            fp = fopen(featFileName, 'r');
            if fp < 0
                break;
            end
            count = 1;
            % read header
           %fgetl(fp); fgetl(fp); fgetl(fp);
           %fgetl(fp);fgetl(fp);
            % read feature
            while ~isempty(fscanf(fp, '%d', 1))
                % read detector
                fscanf(fp, '%f', 6);
                keys(count, :) = fscanf(fp, '%f', 3);%read x y t
                 feats(count, :) = fscanf(fp, '%f', 426);
                frmname = [info.dirfrm, info.cls{i}, '/v_', info.cls{i}, '_g', idxGroup, '_c', idxVid];
            fp1 = fopen(frmname, 'r');
fgetl(fp1);
frm.ncol = fscanf(fp1, '%d', 1);
frm.nrow = fscanf(fp1, '%d', 1);
frm.nfrm = fscanf(fp1, '%d', 1);
 keys(count, 1) = keys(count, 1) / frm.ncol;
  keys(count,2) = keys(count, 1) / frm.nrow;
   keys(count, 3) = keys(count, 1) / frm.nfrm;
fclose(fp1);
count = count + 1;
            end
            fclose(fp);
            k = k + 1;
        end
    end
end


end