library("effsize")

projects = c("AEEEM.mat","MORPH.mat","Relink.mat","softlab.mat")
projectsdata <- NULL
for (i in seq(length(projects))) {
  
  project = projects[i]
  multitaskpath <- file.path("..", "..","03results",paste("MultiTask_",project,".csv",sep=""), fsep=.Platform$file.sep)
  MultiData <- read.csv(multitaskpath,header=F)
  logisticpath <- file.path("..", "..","03results",paste("Logistic_",project,".csv",sep=""), fsep=.Platform$file.sep)
  LogisticData <- read.csv(logisticpath,header=F)
  logisticallpath <- file.path("..", "..","03results",paste("Logistic_",project,"_alldatafortrain.csv",sep=""), fsep=.Platform$file.sep)
  LogisticAll <- read.csv(logisticallpath,header=F)
  
  Fmeasure <- NULL
  AUCdata  <- NULL
  Fmeasure <- cbind(MultiData[,4],LogisticData[,4],LogisticAll[,4])
  AUCdata <- cbind(MultiData[,5],LogisticData[,5],LogisticAll[,5])
  
  datalen <- nrow(Fmeasure)
  modelnum <- 3

  result <- NULL
  for(k in seq(1,datalen,by = 20)){

    tmp1 <- wilcox.test(Fmeasure[k:(k+19),1],Fmeasure[k:(k+19),2],exact=FALSE,conf.level = 0.95)[3]$p.value
    tmp2 <- cliff.delta(Fmeasure[k:(k+19),1],Fmeasure[k:(k+19),2],conf.level = 0.95)[1]$estimate
    tmp3 <- wilcox.test(AUCdata[k:(k+19),1],AUCdata[k:(k+19),2],exact=FALSE,conf.level = 0.95)[3]$p.value
    tmp4 <- cliff.delta(AUCdata[k:(k+19),1],AUCdata[k:(k+19),2],conf.level = 0.95)[1]$estimate
    
    if(k == 101){
      tmp5 = NaN
      tmp6 = NaN
      tmp7 = NaN
      tmp8 = NaN
    }else{
      tmp5 <- wilcox.test(Fmeasure[k:(k+19),1],Fmeasure[k:(k+19),3],exact=FALSE,conf.level = 0.95)[3]$p.value
      tmp6 <- cliff.delta(Fmeasure[k:(k+19),1],Fmeasure[k:(k+19),3],conf.level = 0.95)[1]$estimate
      tmp7 <- wilcox.test(AUCdata[k:(k+19),1],AUCdata[k:(k+19),3],exact=FALSE,conf.level = 0.95)[3]$p.value
      tmp8 <- cliff.delta(AUCdata[k:(k+19),1],AUCdata[k:(k+19),3],conf.level = 0.95)[1]$estimate
    }
    
    tmp <- cbind(tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8)
    result <- rbind(result,tmp)
  }
  
  projectsdata <- rbind(projectsdata,result)
}
write.csv(projectsdata,"pvalue-delta-2.csv")






