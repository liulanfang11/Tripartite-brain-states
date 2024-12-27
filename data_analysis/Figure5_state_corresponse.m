% this code is used for find the matching state from other condition with
% the states from the main task
clear
close all

% load the model (standard ) states
workpath='.\behav_exp_data\';
cd(workpath)
load('task\Summary_measures_rep_05.mat','mean_em');
model_act=mean_em;
clear mean_em

% load the candidate (new) state, to be compared with the pattern of predefined state 
load('rest\Summary_measures_rep_09.mat','mean_em');
new_act=mean_em;
clear mean_em
Nstate=3;

% compare the three candidate state with each of the predifined state 
SI=corr(new_act,model_act);%
[~,label]=max(SI,[],2);  %
[value,new_id]=sort(label,'ascend') % 
new_act2=new_act(:,new_id);%  
%corr(reshape(model_act,27,1),reshape(new_act2,27,1))
clear value SI label new_act;

%% plot confusion matrix
SI2=corr(model_act,new_act2);
real_v=diag(SI2);

figure;
C=SI2;
imagesc(C);  
colormap('parula');
ax = gca; 
ax.FontSize = 15; 

xlabel('predifined state','FontSize',20);
ylabel('candidate state','FontSize',20);

numClasses = size(C, 1);
xticks(1:numClasses);
yticks(1:numClasses);

C=round(C, 3);
for i = 1:numClasses
    for j = 1:numClasses
        text(j, i, num2str(C(i, j)), 'HorizontalAlignment', 'center', 'Color', 'k', 'FontWeight', 'bold','FontSize',20);
    end
end

colorbar;
%exportgraphics(gcf, ['confusion_matrix_activity.png'], 'Resolution', 300)
clear i j text C SI2 



