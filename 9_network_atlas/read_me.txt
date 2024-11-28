Tripartite organization of brain state dynamics underlying spoken narrative comprehension.  Liu Lanfang,   Jiang Jiahao, Hehui Li,  Guosheng Ding


This folder contains the nine-networks atlas used for brain parcellation, obtained by the following procedure: 

Network detection was performed following the method proposed by (Ji et al., 2019), using fMRI data from the 64 participants engaged in narrative comprehension. First, the mean time series of 246 regions defined by the Brainnetome atlas (Fan et al., 2016) was extracted, and a functional connectivity (FC) matrix was computed for each participant and then averaged across them. This atlas covers both cortical and subcortical regions and is made based on both anatomical and functional connectivity (FC) patterns. Next, community detection was performed on the group-averaged FC matrix applying the Louvain clustering algorithm in the Brain connectivity toolbox (https://sites.google.com/site/bctnet/). Three criteria were taken into account when determining the Gamma parameter in the algorithm, including (1) separation of primary sensory-motor network (visual, auditory and somatomotor) from all other networks (i.e., neurobiologically sensible); (2) high similarity of network partitions across nearby parameters (i.e., statistically stable); and (3) high with-network connectivity relative to between-network connectivity (i.e., high modularity).
   
A set of gamma values ranging from 1.2 to 2.5 with a step size of 0.01 were tested. For every tested gamma, we ran the algorithm 1,000 times and measured how consistent a given partition was to every other partition using a z-rand score. Each z-rand score averaged across the iterations was then multiplied by its corresponding modularity score to find a modularity-weighted z-rand score. Finally, the gamma value (gamma =2.5) was selected, which corresponded to the peak of the modularity-weighted z-rand score meanwhile satisfying the three criteria of finding a plausible number of networks including the primary sensory/motor networks. We implemented network detection using codes published by a prior study (Barnett et al., 2021). 

A total of 11 networks were obtained by the above method. We discarded two networks which comprised too few nodes (less than three), and subsequent analyses .

Naming for the nine  networks:  
{'frontal-parietal',' auditory','language','medial temporal','somatomotor','ventral attention','DMN','visual','subcortical'};

Reference:
Barnett, A. J., Reilly, W., Dimsdale-Zucker, H. R., Mizrak, E., Reagh, Z., & Ranganath, C. (2021). Intrinsic connectivity reveals functionally distinct cortico-hippocampal networks in the human brain. PLoS Biology, 19(6), e3001275. doi:10.1371/journal.pbio.3001275

Ji, J. L., Spronk, M., Kulkarni, K., Repovš, G., Anticevic, A., & Cole, M. W. (2019). Mapping the human brain's cortical-subcortical functional network organization. NeuroImage, 185, 35-57. doi:10.1016/j.neuroimage.2018.10.006

Fan, L., Li, H., Zhuo, J., Zhang, Y., Wang, J., Chen, L., . . . Jiang, T. (2016). The Human Brainnetome Atlas: A New Brain Atlas Based on Connectional Architecture. Cerebral Cortex, 26(8), 3508-3526. doi:10.1093/cercor/bhw157


