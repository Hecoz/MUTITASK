clear;
clc;
close;
warning off;
addpath('./MALSAR/functions/dirty/'); % load function
addpath('./MALSAR/c_files/prf_lbm/'); % load projection c libraries. 
addpath('./MALSAR/utils/');           % load utilities
addpath('./examples/train_and_test/'); 
addpath('./01data/SDPdata/');
addpath('./experiments/')
addpath('./02scripts/run01/')
addpath('./02scripts/evaluation/')
addpath('./02scripts/models/')

datasetName='softlab.mat';
%optimization options
opts.init      = 2;      % guess start point from a zero matrix. 
opts.tFlag     = 1;      % terminate after relative objective value does not changes much.
opts.tol       = 10^-5;  % tolerance. 
opts.maxIter   = 2;      % maximum iteration number of optimization.����������
%options for DE
opts.nvar      = 2;      %������
opts.nvar_min  = 0;      %��Сֵ
opts.nvar_max  = 5;      %���ֵ
opts.num_pop   = 50;     %��Ⱥ��С
opts.iter      = 50;     %��������
opts.beta_min  = 0;      %Lower bound of Scaling Factor
opts.beta_max  = 1;      %Upper bound of Scaling Factor
opts.Cross_Pro = 1;      %�������
%experiments options
obj_func_str       = 'Logistic_Dirty';      %model train function
eval_func_str      = 'eval_MTL_auc';        %object function
outTenFold         = 10;                    %independent execution numbers
out_cv_fold        = 2;                     %nested cross validation numbers
optional_cv_fold   = 3;
tenXtenFoldResults = cell(1,outTenFold);    %��������������ӵ�ѭ��

SDP_DATA=load(datasetName);
%init taskNum.
taskNum = size(SDP_DATA.X,1);
 
for randomIndex= 1:outTenFold
    fprintf("<<<<<<<<<<<<<<<<<<<<Independent Execution Number %d>>>>>>>>>>>>>>>>>>>\n",randomIndex);
    
    inner_allPerformance = build_models(SDP_DATA,...            %data
                                        opts,...                %options
                                        out_cv_fold,...         %2 fold
                                        optional_cv_fold,...    %optional_cv_fold 3
                                        obj_func_str,...        %model train function
                                        eval_func_str,...       %object function
                                        randomIndex);           %index of 10 folds
    tenXtenFoldResults{1,randomIndex} = inner_allPerformance(1,:);
    tenXtenFoldResults{2,randomIndex} = inner_allPerformance(2,:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save result
for i = 1:2
    if i == 1
        resultFile = fopen(strcat("./03results/MultiTask_",datasetName,".txt"),"w+");
    else
        resultFile = fopen(strcat("./03results/Logistic_",datasetName,".txt"),"w+");
    end
    %output impormant parameters
    fprintf(resultFile,"Dataset Name:%s\n",datasetName);
    fprintf(resultFile,"Time: %s\n",datestr(now,0));
    fprintf(resultFile,"Independent Execution: %d;    Cross-Validation: %d\n",outTenFold,out_cv_fold);
    fprintf(resultFile,"maxIter=%d\neval_func_str=%s\n",opts.maxIter,eval_func_str);
    fprintf(resultFile,"\n");
    save_result(resultFile,tenXtenFoldResults(i,:),taskNum,outTenFold,out_cv_fold);
    fclose(resultFile);
end
%save_result(resultFile,tenXtenFoldResults,taskNum,outTenFold,out_cv_fold);
for i = 1:2
    if i == 1
        SaveResult(tenXtenFoldResults(i,:),['./03results/MultiTask_',datasetName,'.csv'],outTenFold,out_cv_fold);
    else
        SaveResult(tenXtenFoldResults(i,:),['./03results/Logistic_',datasetName,'.csv'],outTenFold,out_cv_fold);
    end
end

fprintf("<<<<<<<<<<<<<<<<<<<<Succefful Execution>>>>>>>>>>>>>>>>>>>\n");