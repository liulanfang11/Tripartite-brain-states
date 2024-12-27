
% get inter-brain alignment in brain states and correlate it with task
% performance; rule out the effect of head movement

clear

cd(workpath);

load('HMM_results\task\Summary_measures_rep_05.mat');
load('HMM_results\task\HMMrun_rep_05.mat');

load('behav_exp_data\story_ID.mat');
load('behav_exp_data\score.mat');
load('behav_exp_data\sub_rp_FD_Power.mat'); % the timecourses of headmovement
load ('behav_exp_data\score.mat')
Nstate=size(FO,2);
rp_mean=mean(sub_rp,2);

corr(rp_mean,score)
best_sub_id=find(score==100); best_sub_story=S_set(score==100); 
s1_ID=best_sub_id(best_sub_story==1);
s2_ID=best_sub_id(best_sub_story==2);
s3_ID=best_sub_id(best_sub_story==3);

Gamma=reshape(Gamma,300,64,Nstate);
data=Gamma;


for k=1:Nstate
    X=data(:,:,k);
    for i=1:size(X,2)
        tc1=X(:,i);
        tc1_rp=sub_rp(i,:);
        % get matched subjects_set hearing the same story;
        if S_set(i)==1
           tp_sub=s1_ID;
        elseif S_set(i)==2
           tp_sub=s2_ID;
        elseif S_set(i)==3
           tp_sub=s3_ID; 
        end
           
        % other subject belonging to the same sotry set;
        tc2=squeeze(Gamma(:,tp_sub,k)); 
        tc2_rp=sub_rp(tp_sub,:);

        %  obtain the correlation between each subject with the mean_FC of all
        %  other subjects
       r=corr(tc1,tc2);
       fishz=0.5*(log(1+r)-log(1-r));
       sub_isc_tp(i,k)=mean(fishz);
       clear r fishz
         r=corr(tc1_rp',tc2_rp');
       fishz=0.5*(log(1+r)-log(1-r));
       sub_isc_rp(i,1)=mean(fishz);
    end
end
ID=setdiff(1:64,best_sub_id);
[r,p]=corr(sub_isc_tp(ID,:),score(ID),'tail','right')

% estimate  inter-subject alignment in head movement
for k=1:64
    rp=sub_rp(k,:);
    state=squeeze(Gamma(:,k,:));
    [r,p]=corr(state,rp');
    sub_rp_state(k,:)=r;
end
    
[h,p,ci,st]=ttest(sub_rp_state)

[r,p]=partialcorr(sub_isc_tp(ID,:),score(ID),sub_isc_rp(ID,:),'tail','right')

