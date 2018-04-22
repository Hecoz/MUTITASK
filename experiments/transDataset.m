%% SCRIPT transDataset.m 
%   ��SDP�е����ݸ�ʽת���ɵ�ǰ����еĸ�ʽ

clear; clc;

%ѡ�����ݼ�����Ŀ¼
mainDir=uigetdir('��ѡ�����ݼ�����Ŀ¼...ע�����datasetName�ַ���');


%���ݼ�������
%datasetName='AEEEM';
%datasetName='MORPH';
%datasetName='Relink';
%datasetName='softlab';
datasetName='Eclipse';




%�������ݼ�ȫ·��
fileLists=dir(fullfile(mainDir,datasetName));
fileNums=length(fileLists)-2;

%����ѵ�����ݺ�������ݵ�cell
%X=cell(1,fileNums);
%Y=cell(1,fileNums);
X=cell(fileNums,1);
Y=cell(fileNums,1);

%ѭ�����뵱ǰ���ݼ��µ����е���Ŀ��Ȼ�󴴽�һ��cell
index = 1;
for i =1 : length(fileLists)
        if(isequal(fileLists(i).name, '.')||...
           isequal(fileLists(i).name, '..')||...
           fileLists(i).isdir)
            %fprintf("continued: %d\r ",i);    
            continue;
        end
        
        
        % fprintf("file name is:%s \r",fileLists(i));
        currentFile=fullfile(mainDir,datasetName,fileLists(i).name);
        
        project=xlsread(currentFile);

        projectX=project(:,1:(size(project,2)-1));
        projectY=project(:,size(project,2)); 
        
        %X{1,index}=projectX;
        %Y{1,index}=projectY;
        X{index,1}=projectX;
        Y{index,1}=projectY;
        
        index=index+1;
end

%�������cell�ϳ�һ��struct

%s=sprintf(strcat('save',32,datasetName,' X',' Y'));
%eval(s);

eval(['save ',' data\SDPdata\',datasetName,' X',' Y']);
fprintf('save the data successfully!\r');

        
        



