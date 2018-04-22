function [trainedClassifier, validationAccuracy] = LR(trainingData)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: a table containing the same predictor and response
%       columns as imported into the app.
%
%  Output:
%      trainedClassifier: a struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: a function to make predictions on new
%       data.
%
%      validationAccuracy: a double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a table containing at least the same predictor columns as used
% during training. For details, enter:
%   trainedClassifier.HowToPredict

% Auto-generated by MATLAB on 2018-02-11 09:36:28


% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'ck_oo_numberOfPrivateMethods', 'LDHH_lcom', 'LDHH_fanIn', 'numberOfNonTrivialBugsFoundUntil', 'WCHU_numberOfPublicAttributes', 'WCHU_numberOfAttributes', 'CvsWEntropy', 'LDHH_numberOfPublicMethods', 'WCHU_fanIn', 'LDHH_numberOfPrivateAttributes', 'CvsEntropy', 'LDHH_numberOfPublicAttributes', 'WCHU_numberOfPrivateMethods', 'WCHU_numberOfMethods', 'ck_oo_numberOfPublicAttributes', 'ck_oo_noc', 'numberOfCriticalBugsFoundUntil', 'ck_oo_wmc', 'LDHH_numberOfPrivateMethods', 'WCHU_numberOfPrivateAttributes', 'CvsLogEntropy', 'WCHU_noc', 'LDHH_numberOfAttributesInherited', 'WCHU_wmc', 'ck_oo_fanOut', 'ck_oo_numberOfLinesOfCode', 'ck_oo_numberOfAttributesInherited', 'ck_oo_numberOfMethods', 'ck_oo_dit', 'ck_oo_fanIn', 'LDHH_noc', 'WCHU_dit', 'ck_oo_lcom', 'WCHU_numberOfAttributesInherited', 'ck_oo_rfc', 'LDHH_wmc', 'LDHH_numberOfAttributes', 'LDHH_numberOfLinesOfCode', 'WCHU_fanOut', 'WCHU_lcom', 'ck_oo_cbo', 'WCHU_rfc', 'ck_oo_numberOfAttributes', 'numberOfHighPriorityBugsFoundUntil', 'ck_oo_numberOfPrivateAttributes', 'numberOfMajorBugsFoundUntil', 'WCHU_numberOfPublicMethods', 'LDHH_dit', 'WCHU_cbo', 'CvsLinEntropy', 'WCHU_numberOfMethodsInherited', 'numberOfBugsFoundUntil', 'LDHH_fanOut', 'LDHH_numberOfMethodsInherited', 'LDHH_rfc', 'ck_oo_numberOfMethodsInherited', 'ck_oo_numberOfPublicMethods', 'LDHH_cbo', 'WCHU_numberOfLinesOfCode', 'CvsExpEntropy', 'LDHH_numberOfMethods'};
predictors = inputTable(:, predictorNames);
response = inputTable.Defective;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
% For logistic regression, the response values must be converted to zeros
% and ones because the responses are assumed to follow a binomial
% distribution.
% 1 or true = 'successful' class
% 0 or false = 'failure' class
% NaN - missing response.
successClass = double(1);
failureClass = double(-1);
% Compute the majority response class. If there is a NaN-prediction from
% fitglm, convert NaN to this majority class label.
numSuccess = sum(response == successClass);
numFailure = sum(response == failureClass);
if numSuccess > numFailure
    missingClass = successClass;
else
    missingClass = failureClass;
end
successFailureAndMissingClasses = [successClass; failureClass; missingClass];
isMissing = isnan(response);
zeroOneResponse = double(ismember(response, successClass));
zeroOneResponse(isMissing) = NaN;
% Prepare input arguments to fitglm.
concatenatedPredictorsAndResponse = [predictors, table(zeroOneResponse)];
% Train using fitglm.
GeneralizedLinearModel = fitglm(...
    concatenatedPredictorsAndResponse, ...
    'Distribution', 'binomial', ...
    'link', 'logit');

% Convert predicted probabilities to predicted class labels and scores.
convertSuccessProbsToPredictions = @(p) successFailureAndMissingClasses( ~isnan(p).*( (p<0.5) + 1 ) + isnan(p)*3 );
returnMultipleValuesFcn = @(varargin) varargin{1:max(1,nargout)};
scoresFcn = @(p) [1-p, p];
predictionsAndScoresFcn = @(p) returnMultipleValuesFcn( convertSuccessProbsToPredictions(p), scoresFcn(p) );

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
logisticRegressionPredictFcn = @(x) predictionsAndScoresFcn( predict(GeneralizedLinearModel, x) );
trainedClassifier.predictFcn = @(x) logisticRegressionPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = {'ck_oo_numberOfPrivateMethods', 'LDHH_lcom', 'LDHH_fanIn', 'numberOfNonTrivialBugsFoundUntil', 'WCHU_numberOfPublicAttributes', 'WCHU_numberOfAttributes', 'CvsWEntropy', 'LDHH_numberOfPublicMethods', 'WCHU_fanIn', 'LDHH_numberOfPrivateAttributes', 'CvsEntropy', 'LDHH_numberOfPublicAttributes', 'WCHU_numberOfPrivateMethods', 'WCHU_numberOfMethods', 'ck_oo_numberOfPublicAttributes', 'ck_oo_noc', 'numberOfCriticalBugsFoundUntil', 'ck_oo_wmc', 'LDHH_numberOfPrivateMethods', 'WCHU_numberOfPrivateAttributes', 'CvsLogEntropy', 'WCHU_noc', 'LDHH_numberOfAttributesInherited', 'WCHU_wmc', 'ck_oo_fanOut', 'ck_oo_numberOfLinesOfCode', 'ck_oo_numberOfAttributesInherited', 'ck_oo_numberOfMethods', 'ck_oo_dit', 'ck_oo_fanIn', 'LDHH_noc', 'WCHU_dit', 'ck_oo_lcom', 'WCHU_numberOfAttributesInherited', 'ck_oo_rfc', 'LDHH_wmc', 'LDHH_numberOfAttributes', 'LDHH_numberOfLinesOfCode', 'WCHU_fanOut', 'WCHU_lcom', 'ck_oo_cbo', 'WCHU_rfc', 'ck_oo_numberOfAttributes', 'numberOfHighPriorityBugsFoundUntil', 'ck_oo_numberOfPrivateAttributes', 'numberOfMajorBugsFoundUntil', 'WCHU_numberOfPublicMethods', 'LDHH_dit', 'WCHU_cbo', 'CvsLinEntropy', 'WCHU_numberOfMethodsInherited', 'numberOfBugsFoundUntil', 'LDHH_fanOut', 'LDHH_numberOfMethodsInherited', 'LDHH_rfc', 'ck_oo_numberOfMethodsInherited', 'ck_oo_numberOfPublicMethods', 'LDHH_cbo', 'WCHU_numberOfLinesOfCode', 'CvsExpEntropy', 'LDHH_numberOfMethods'};
trainedClassifier.GeneralizedLinearModel = GeneralizedLinearModel;
trainedClassifier.SuccessClass = successClass;
trainedClassifier.FailureClass = failureClass;
trainedClassifier.MissingClass = missingClass;
trainedClassifier.ClassNames = {successClass; failureClass};
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2017b.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'ck_oo_numberOfPrivateMethods', 'LDHH_lcom', 'LDHH_fanIn', 'numberOfNonTrivialBugsFoundUntil', 'WCHU_numberOfPublicAttributes', 'WCHU_numberOfAttributes', 'CvsWEntropy', 'LDHH_numberOfPublicMethods', 'WCHU_fanIn', 'LDHH_numberOfPrivateAttributes', 'CvsEntropy', 'LDHH_numberOfPublicAttributes', 'WCHU_numberOfPrivateMethods', 'WCHU_numberOfMethods', 'ck_oo_numberOfPublicAttributes', 'ck_oo_noc', 'numberOfCriticalBugsFoundUntil', 'ck_oo_wmc', 'LDHH_numberOfPrivateMethods', 'WCHU_numberOfPrivateAttributes', 'CvsLogEntropy', 'WCHU_noc', 'LDHH_numberOfAttributesInherited', 'WCHU_wmc', 'ck_oo_fanOut', 'ck_oo_numberOfLinesOfCode', 'ck_oo_numberOfAttributesInherited', 'ck_oo_numberOfMethods', 'ck_oo_dit', 'ck_oo_fanIn', 'LDHH_noc', 'WCHU_dit', 'ck_oo_lcom', 'WCHU_numberOfAttributesInherited', 'ck_oo_rfc', 'LDHH_wmc', 'LDHH_numberOfAttributes', 'LDHH_numberOfLinesOfCode', 'WCHU_fanOut', 'WCHU_lcom', 'ck_oo_cbo', 'WCHU_rfc', 'ck_oo_numberOfAttributes', 'numberOfHighPriorityBugsFoundUntil', 'ck_oo_numberOfPrivateAttributes', 'numberOfMajorBugsFoundUntil', 'WCHU_numberOfPublicMethods', 'LDHH_dit', 'WCHU_cbo', 'CvsLinEntropy', 'WCHU_numberOfMethodsInherited', 'numberOfBugsFoundUntil', 'LDHH_fanOut', 'LDHH_numberOfMethodsInherited', 'LDHH_rfc', 'ck_oo_numberOfMethodsInherited', 'ck_oo_numberOfPublicMethods', 'LDHH_cbo', 'WCHU_numberOfLinesOfCode', 'CvsExpEntropy', 'LDHH_numberOfMethods'};
predictors = inputTable(:, predictorNames);
response = inputTable.Defective;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Perform cross-validation
KFolds = 10;
cvp = cvpartition(response, 'KFold', KFolds);
% Initialize the predictions to the proper sizes
validationPredictions = response;
numObservations = size(predictors, 1);
numClasses = 2;
validationScores = NaN(numObservations, numClasses);
for fold = 1:KFolds
    trainingPredictors = predictors(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);
    foldIsCategoricalPredictor = isCategoricalPredictor;
    
    % Train a classifier
    % This code specifies all the classifier options and trains the classifier.
    % For logistic regression, the response values must be converted to zeros
    % and ones because the responses are assumed to follow a binomial
    % distribution.
    % 1 or true = 'successful' class
    % 0 or false = 'failure' class
    % NaN - missing response.
    successClass = double(1);
    failureClass = double(-1);
    % Compute the majority response class. If there is a NaN-prediction from
    % fitglm, convert NaN to this majority class label.
    numSuccess = sum(trainingResponse == successClass);
    numFailure = sum(trainingResponse == failureClass);
    if numSuccess > numFailure
        missingClass = successClass;
    else
        missingClass = failureClass;
    end
    successFailureAndMissingClasses = [successClass; failureClass; missingClass];
    isMissing = isnan(trainingResponse);
    zeroOneResponse = double(ismember(trainingResponse, successClass));
    zeroOneResponse(isMissing) = NaN;
    % Prepare input arguments to fitglm.
    concatenatedPredictorsAndResponse = [trainingPredictors, table(zeroOneResponse)];
    % Train using fitglm.
    GeneralizedLinearModel = fitglm(...
        concatenatedPredictorsAndResponse, ...
        'Distribution', 'binomial', ...
        'link', 'logit');
    
    % Convert predicted probabilities to predicted class labels and scores.
    convertSuccessProbsToPredictions = @(p) successFailureAndMissingClasses( ~isnan(p).*( (p<0.5) + 1 ) + isnan(p)*3 );
    returnMultipleValuesFcn = @(varargin) varargin{1:max(1,nargout)};
    scoresFcn = @(p) [1-p, p];
    predictionsAndScoresFcn = @(p) returnMultipleValuesFcn( convertSuccessProbsToPredictions(p), scoresFcn(p) );
    
    % Create the result struct with predict function
    logisticRegressionPredictFcn = @(x) predictionsAndScoresFcn( predict(GeneralizedLinearModel, x) );
    validationPredictFcn = @(x) logisticRegressionPredictFcn(x);
    
    % Add additional fields to the result struct
    
    % Compute validation predictions
    validationPredictors = predictors(cvp.test(fold), :);
    [foldPredictions, foldScores] = validationPredictFcn(validationPredictors);
    
    % Store predictions in the original order
    validationPredictions(cvp.test(fold), :) = foldPredictions;
    validationScores(cvp.test(fold), :) = foldScores;
end

% Compute validation accuracy
correctPredictions = (validationPredictions == response);
isMissing = isnan(response);
correctPredictions = correctPredictions(~isMissing);
validationAccuracy = sum(correctPredictions)/length(correctPredictions);
