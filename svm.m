clc;
clear;
info.dirvector = '/home/wcj/code/dtf_wcj_wlad/vector/';
info.ngroup = 25;
%info.cls = {'ApplyEyeMakeup'};
info.cls = {'ApplyEyeMakeup','ApplyLipstick','Archery'};
%info.cls = {'ApplyEyeMakeup','ApplyLipstick','Archery','BabyCrawling',...
   %'BalanceBeam','BandMarching','BaseballPitch','Basketball'};
t = 0;
y = 0;
 for i = 1:length(info.cls)
     for j = 1:info.ngroup
        idxgroup = sprintf('%02d',j);
         k = 1;
while 1
        idxVid = sprintf('%02d',k);
        if j <= 4
             sdvname = [info.dirvector,info.cls{i},'/v_',info.cls{i},'_g',...
        idxgroup,'_c',idxVid,'.mat'];
if ~exist(sdvname,'file')
            break;
end
    if exist(sdvname,'file')
    y = y+1;
    k = k+1;
    load (sdvname,'norm_ST_VLAD_encoding');
       test_data(y,:) = norm_ST_VLAD_encoding;
       test_labels(y,:) = i;
       continue;
    end      
        else if 4<j<15
    sdvname = [info.dirvector,info.cls{i},'/v_',info.cls{i},'_g',...
        idxgroup,'_c',idxVid,'.mat'];
if ~exist(sdvname,'file')
            break;
end
    if exist(sdvname,'file')
    t = t+1;
    k = k+1;
 
    load (sdvname,'norm_ST_VLAD_encoding');
       train_data(t,:) = norm_ST_VLAD_encoding;
       train_labels(t,:) = i;
 continue;
    end
            end
        end   
end
     end
 end
 train_data = sparse(train_data);
 model = train(train_labels,train_data);
 test_data = sparse(test_data);
[predicted_label,accuracy,decision_values] = predict(test_labels,test_data,model);
train_data = [train_data,train_data];
model = train(train_labels,train_data);
test_data = [test_data,test_data];
[predicted_label,accuracy,decision_values] = predict(test_labels,test_data,model);