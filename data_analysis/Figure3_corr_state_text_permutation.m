 % analyze the modulation of state dynamics by speech features, and assess 
 % statistical significance by permutation.
clear
close all
workpath='';
dest=[workpath,'modulation\'];

cd(workpath);
load('behav_exp_data\story_ID.mat');
load('HMM_results\task\HMMrun_rep_05.mat','Gamma');

prop_path=[workpath,'behav_exp_data\'];
filename={'young_ev_hrf_re', 'young_SI_ps_word' ,'young_SI_ps_clause'}; % SI_ps 代表当前词（t) 与前一个词（t-1)的相关
ROI=1; % intrested states ID  
property_name={'ev','word','clause'};
load([prop_path,filename{ROI},'.mat']);
state=reshape(Gamma,300,64,3); 
for  n=1:64
     sid=S_set(n);
     sub_gamma=squeeze(state(1:end,n,:));
     if sid==1
        txt_tmp=s1;% 
     elseif sid==2
         txt_tmp=s2;
  
     elseif sid==3
          txt_tmp=s3;  
     end
     if length(txt_tmp)<300
         pad=300-length(txt_tmp);
         txt_tmp=[zeros(pad,1);txt_tmp];  
     end
     x=sub_gamma(10:end-1,:); 
     y=txt_tmp(10:end-1,:); % discard the first few time points and the last time points to obtain more stable features 
     [r,p]=corr(x,y,'type','pearson');
     fishz=0.5*(log(1+r)-log(1-r));
     sub_fishz_true(n,:)=fishz;
     sub_r_true(n,:)=r;
     sub_p_true(n,:)=p;

end

[~,p,ci,stat1]=ttest(sub_fishz_true)

p,stat1
FDR(p,0.05)
fishz=mean(sub_fishz_true);
r=(exp(2*fishz)-1)./(exp(2*fishz)+1);

% permuation by shuffling gamma sequence
 permN=5000;
 for K=1:permN
     for n=1:64
         sid=S_set(n);
         sub_gamma=squeeze(state(1:end,n,:));
         if sid==1
            txt_tmp=s1;
         elseif sid==2
             txt_tmp=s2;
         elseif sid==3
              txt_tmp=s3;   
         end
         
         if length(txt_tmp)==299
             txt_tmp=[0;txt_tmp];  % for semantic similarity 
         end
         
         x=sub_gamma(10:end,:);   
         t0=randsample(1:300,1);
         x=circshift (x,t0); %
         y=txt_tmp(10:end,1);  
         [r,p]=corr(x,y);
         fishz=0.5*(log(1+r)-log(1-r));
         sub_fishz(n,:)=fishz;
         clear fishz x y t0 r p txt_tmp sid sub_gamma
     end
     perm_fishz_mean(K,:)=mean(sub_fishz);  
     perm_fishz_std(K,:)=std(sub_fishz);
 end
 clear p K n 
 
 %get statistic p
true_mean=mean(sub_fishz_true); 
for i=1:3
    perm_mean=perm_fishz_mean(:,i);
    perm_std=perm_fishz_std(:,i);
    if true_mean(i)>0
      tmp =find(perm_mean>true_mean(i));
      dif=true_mean(i)-max(perm_mean);
      [~,id]=max(perm_mean);
    
    elseif true_mean(i)<0          
      tmp =find(perm_mean<true_mean(i));
      dif=true_mean(i)-min(perm_mean);
       [~,id]=min(perm_mean);
    end
      p=length(tmp)/permN;
      perm_p(i,1)=p;
  
end

perm_p

% plot histogram
h=histogram(perm_fishz_mean);
h.FaceColor=[36/255,156/255,230/255];
hold on
x=mean(sub_fishz_true(:,ROI));
xlim([-0.05,0.05]);
ylim=[0,900];
line([x x], ylim, 'Color', 'r', 'LineWidth', 4)
f = gcf;
set(gca,'FontSize',20)
xlabel('permutated mean')
ylabel('frequency')
exportgraphics(f,[dest,'hist_',property_name{ROI},'.tif'],'Resolution',300)

hold off

