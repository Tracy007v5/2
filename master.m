close all; 
clear;
clc;
%data information
info.suffix = '.features';
%info.cls = {'ApplyEyeMakeup','ApplyLipstick','Archery'};
info.cls = {'ApplyEyeMakeup','ApplyLipstick','Archery','BabyCrawling',...
 'BalanceBeam','BandMarching','BaseballPitch','Basketball'}
info.ngroup = 25;
info.dirfeat = '/home/wcj/UCF101_DTF/';
info.dirfrm = '/home/wcj/SSCV-master/Frames/';
info.dirvector = '/home/wcj/code/dtf_wcj_wlad/vector/';
[feats,keys] = readFeatSTIP(info);
%create the features vocabulary with the standard k-means, can be quite slow process
k1=256; % the number of visual words for the vocabulary of the features
[~, vocabFeatures]=kmeans(feats, k1); 
%create the vocabulary of the features position with the standard k-means
k2=18; % the number of visual words for the vocabulary of the features position
[~, vocabPositions]=kmeans(keys, k2); 
 for i = 1:length(info.cls)
    for j = 1:info.ngroup
        k = 1;
        idxGroup = sprintf('%02d', j);
        while 1
            idxVid = sprintf('%02d', k);
            featFileName = [info.dirfeat, info.cls{i}, ...
                            '/v_', info.cls{i}, '_g', idxGroup, '_c', idxVid, info.suffix]; 
                        if ~exist(featFileName, 'file')
                break;
            end
            vectorname = [info.dirvector, info.cls{i}, ...
                            '/v_', info.cls{i}, '_g', idxGroup, '_c', idxVid, '.mat'];
                if exist(vectorname, 'file')
                k = k + 1;
                continue;
                end
            [positions,features] = readSingleFileSTIP(featFileName);
if isempty(features)
                norm_ST_VLAD_encoding = zeros(1, numel(stbasis));
                save(vectorname, 'norm_ST_VLAD_encoding');
                k = k + 1;
                continue;
end
            frmFileName = [info.dirfrm, info.cls{i}, '/v_', info.cls{i}, '_g', idxGroup, '_c', idxVid];
            frm = readFrameInfo(frmFileName);
            % normalize keys
           positions(:, 1) = positions(:, 1) / frm.ncol;
           positions(:, 2) = positions(:, 2) / frm.nrow;
           positions(:, 3) = positions(:, 3) / frm.nfrm;
ST_VLAD_encoding=ST_VLAD(features, vocabFeatures, positions, vocabPositions);
%after you obtain the final representation, before classification, 
%you may want to normalize the vector as in our paper: 
%apply power normalization followed by L2 normalization
%apply power normalization
alpha=0.1;
norm_ST_VLAD_encoding=PowerNormalization(ST_VLAD_encoding, alpha);
%apply L2 normalization for making unit length
norm_ST_VLAD_encoding=NormalizeRowsUnit(norm_ST_VLAD_encoding);
save(vectorname, 'norm_ST_VLAD_encoding');
k = k + 1;
        end
    end
 end

