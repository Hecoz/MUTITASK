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

projects = {'AEEEM.mat','MORPH.mat','Relink.mat','softlab.mat'};
for p = 1:length(projects)
    project = projects{p};
    datasetName=project;
    %optimization options
    opts.init      = 2;      % guess start point from a zero matrix. 
    opts.tFlag     = 1;      % terminate after relative objective value does not changes much.
    opts.tol       = 10^-5;  % tolerance. 
    opts.maxIter   = 2;      % maximum iteration number of optimization.最大迭代次数
    %options for DE
    opts.nvar      = 2;      %特征数
    opts.nvar_min  = 0;      %最小值
    opts.nvar_max  = 5;      %最大值
    opts.num_pop   = 50;     %种群大小
    opts.iter      = 50;     %迭代次数
    opts.beta_min  = 0;      %Lower bound of Scaling Factor
    opts.beta_max  = 1;      %Upper bound of Scaling Factor
    opts.Cross_Pro = 1;      %交叉概率
    %experiments options
    obj_func_str       = 'Logistic_Dirty';      %model train function
    eval_func_str      = 'eval_MTL_auc';        %object function
    outTenFold         = 10;                    %independent execution numbers
    out_cv_fold        = 10;                     %nested cross validation numbers
    optional_cv_fold   = 3;
    tenXtenFoldResults = cell(1,outTenFold);    %最外层带有随机因子的循环

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
                                            randomIndex,...
                                            p);           %index of 10 folds
        tenXtenFoldResults{1,randomIndex} = inner_allPerformance(1,:);
        tenXtenFoldResults{2,randomIndex} = inner_allPerformance(2,:);
        tenXtenFoldResults{3,randomIndex} = inner_allPerformance(3,:);
        tenXtenFoldResults{4,randomIndex} = inner_allPerformance(4,:);
        tenXtenFoldResults{5,randomIndex} = inner_allPerformance(5,:);
        tenXtenFoldResults{6,randomIndex} = inner_allPerformance(6,:);
        tenXtenFoldResults{7,randomIndex} = inner_allPerformance(7,:);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %save result
    for i = 1:7
        switch i
            case{1}
                resultFile = fopen(strcat("./03results/MultiTask_",datasetName,".txt"),"w+");
            case{2}
                resultFile = fopen(strcat("./03results/Logistic_",datasetName,".txt"),"w+");
            case{3}
                resultFile = fopen(strcat("./03results/RandomForest_",datasetName,".txt"),"w+");
            case{4}
                resultFile = fopen(strcat("./03results/KNN_",datasetName,".txt"),"w+");
            case{5}
                resultFile = fopen(strcat("./03results/SVM_",datasetName,".txt"),"w+");
            case{6}
                resultFile = fopen(strcat("./03results/DecisionTree_",datasetName,".txt"),"w+");
            case{7}
                resultFile = fopen(strcat("./03results/Unsupervised_",datasetName,".txt"),"w+");
            otherwise
                disp("IMPOSSIBLE");
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
    for i = 1:7

        switch i
            case{1}
                SaveResult(tenXtenFoldResults(i,:),['./03results/MultiTask_',datasetName,'.csv'],outTenFold,out_cv_fold);
            case{2}
                SaveResult(tenXtenFoldResults(i,:),['./03results/Logistic_',datasetName,'.csv'],outTenFold,out_cv_fold);
            case{3}
                SaveResult(tenXtenFoldResults(i,:),['./03results/RandomForest_',datasetName,'.csv'],outTenFold,out_cv_fold);
            case{4}
                SaveResult(tenXtenFoldResults(i,:),['./03results/KNN_',datasetName,'.csv'],outTenFold,out_cv_fold);
            case{5}
                SaveResult(tenXtenFoldResults(i,:),['./03results/SVM_',datasetName,'.csv'],outTenFold,out_cv_fold);
            case{6}
                SaveResult(tenXtenFoldResults(i,:),['./03results/DecisionTree_',datasetName,'.csv'],outTenFold,out_cv_fold);
            case{7}
                SaveResult(tenXtenFoldResults(i,:),['./03results/Unsupervised_',datasetName,'.csv'],outTenFold,out_cv_fold);
            otherwise
                disp("IMPOSSIBLE");
        end
    end
end

fprintf("<<<<<<<<<<<<<<<<<<<<Succefful Execution>>>>>>>>>>>>>>>>>>>\n");
