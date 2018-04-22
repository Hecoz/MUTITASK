%% ʹ��MyEvaluation���������е�����ָ��
%����һ�����struct�ṹ������

function all_performance = eval_MTL_allPerformance (Y, X, W, C)
    %calculate accuracy for classification 
    task_num = length(X);    

    %��task_num��cell������ÿ������Ľ��,ÿ��cell�д�ŵ���struct�ṹ
    %all_performance = cell(1,task_num);
    %��ʼ�����ڴ��task_num����������ܽ����ÿһ���������һ��struct�ṹ
    all_performance = [];

    %calculate corrested classified numbers for every dataset
    for t = 1: task_num    
        %�˴������ۺ���Ҫ����ʵ��������������,sigmoid�����[0,1]��sign��>0Ϊ1��<0Ϊ-1
        %predicted = sigmoid(X{t} * W(:, t) + C(t)) >= 0.5;
        predicted = sign(X{t} * W(:, t) + C(t));
        EVAL = MyEvaluation(Y{t},predicted);
        all_performance = [all_performance EVAL];   
    end   
end