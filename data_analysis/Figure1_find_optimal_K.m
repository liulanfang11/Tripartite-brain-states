% Codes used in Liu et al. (2024, eLife) for determining the optimal number
% of states 
% The core codes for HMM estimation are adapted from Vidaurre et al. (2017) PNAS
% https://github.com/OHBA-analysis/HMM-MAR

%% SETUP THE MATLAB PATHS 
clear
rng(123)
addpath(genpath('toolbox\HMM-MAR-master'));
workpath='.\sub_network_tc\';
mydir=workpath;
load([workpath,'sub_tc_standard_sub64.mat'])
sub_tc_full=sub_tc;
clear sub_tc;
load('story_ID.mat');


N=size(sub_tc_full,3); % number of sujbects
J=9; % the number of networks
 
TR = 2;  
total_TR=300;
options = struct();
options.order = 0; % no autoregressive components
options.zeromean = 0; % model the mean
options.covtype = 'full'; % full covariance matrix
options.Fs = 1/TR; 
options.verbose = 1;
options.standardise = 1;
options.inittype = 'HMM-MAR';
options.cyc = 500;
options.initcyc = 10;
options.initrep = 3;

use_stochastic = 0; % set to 1 if you have loads of data
clust_cal=zeros(10,N);
repetitions=1; % to run it multiple times (keeping all the results)

sub_acc=zeros(9,64); clust_cal=zeros(9,64);
for K=2:10
    options.K = K; % number of states 
    sub_hmm_list=cell(repetitions,N);sub_fe_final=nan(repetitions,N);
    
    % In the leave-one-out procedure, using the data from N-1 subjects to obtain the HMM model,... 
    % repeat this 10 times. Select the model with the smallest free energy to estimate the
    % reamining subjects' vpath and to calculate the clustering performance. 
    for left_sub=1:N
        train_ID=setdiff(1:N,left_sub);
        sub_tc=sub_tc_full(:,:,train_ID);
        subN=length(train_ID);
        f = cell(subN,1); T = cell(subN,1);
        left_data=sub_tc_full(:,:,left_sub);left_T=300;
            
        for j=1:subN
            f{j} = sub_tc(:,:,j);
            T{j} = 300; %T{j} contains the lengths of each session (in time points)
        end
        clear j
        
        hmm_list=cell(repetitions,1);fe_final=nan(repetitions,1);
        %% run the HMM multiple times     
        for  r = 1:repetitions
             disp(['RUN ' num2str(r)]);
             [hmm, ~, ~, vpath , ~, ~, ~] = hmmmar(f,T,options);
             hmm_list{r}=hmm;        
             fe_list(r)= hmmfe(f,T,hmm);
             vpath_list{r}=vpath;
        end
         clear hmm r vpath
         
         % choose from the 10 instances with smallest fe_final as the best model
         [~,idd]=min(fe_final);
         hmm_best=hmm_list{idd};  
         vpath_best=vpath_list{idd};
         clear idd hmm_list vpath_list
         % use the best model to decode vpath for the left-out subject
         vpath_decode = hmmdecode(left_data,left_T,hmm_best,1);
         
         % calculate clustering performance;
         ev=evalclusters(left_data,vpath_decode,'CalinskiHarabasz');  
         clust_cal(K-1,left_sub)=ev.CriterionValues; 
         clear ev 
         
         %decoding narrative contents based on the overlap of vapth between
         %the left-out subject and the train subjects 
         vpath_best=reshape(vpath_best,total_TR,63);
         for j=1:63
             tmp=vpath_decode./vpath_best(:,j);
             overlap(j)=length(find(tmp==1))./total_TR;
         end
         clear j
         story_ans=S_set(left_sub);
         S_set2=S_set(train_ID);   
         s1=find(S_set2==1);
         s2=find(S_set2==2);
         s3=find(S_set2==3);
         
         x=[mean(overlap(s1)),mean(overlap(s2)),mean(overlap(s3))];
         [~,prd_id]=max(x);
         if prd_id==story_ans 
            sub_acc(K-1,left_sub)=1;
         end
         clear prd_id x s1 s2 s3 S_set2 vpath_best vpath_decode story_ans
    end
end

acc=mean(sub_acc,2); % prediction accuray 
clust=mean(clust_cal,2);% clustering performance
summed_score=zscore(acc)+zscore(clust);  %+zscore(cons)

x=2:1:10;
y=summed_score;
plot(x,y,'linewidth',6,'color',[0.1,0.1,0.1])
set(gca, 'fontsize', 20)
xticks(x);
xlabel('number of states')
ylabel('summed_score')
f = gcf;
exportgraphics(f,'K_clus.tif','Resolution',300)


    
   