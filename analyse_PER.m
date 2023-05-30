%Load a dataset from PER exp or memory test and perform the analyses over a 5D dataset whose dimensions are
%[H,W,frames,trials,bee].
net = importKerasNetwork('\\cimec-storage\albhaa\haaalb001a1p\ettore\important script\PER\Classifier_models\licking_model_100_19M_4.h5')
%%
thr=0.8;% probability threshold for  licking
fps=20;%set the frame rate

%exp_anal=PER_predict(data,net);%use this function if you need to reanalyze
%the movie of the experiment

%Extract the data from PER experiments.Per_Results it's a matrix of size
%[n_bees, trials] which contain value 1 if the bee has learned the
%association or zero if not. NR_bees is the same size matrix that labels
%when a bee did not respond to the antennaa touch at all
[PER_result,NR_bees]=PER_stat(exp_anal,t_CS,pre_stim,fps,thr, t_overlap, sequence);%count bee liking and non responders
final_per_result=PER_result;
final_per_result(isnan(NR_bees(:,size(NR_bees,2))),:)=nan;%set to nan bees that do not responds to sucrose on the last stimulus
ST_result=final_per_result(:,strcmp(sequence,'ST'));
bl_result=final_per_result(:,strcmp(sequence,'bl'));
figure
%plot the averaged trial response to rewarded and non rewarded stimuli
plot((nansum(ST_result)./sum(~isnan(ST_result)))*100,'-r')
hold on
plot((nansum(bl_result)./sum(~isnan(bl_result)))*100,'b')
ylim([0,100])
%xlim([1,size(ST_result,2)])
legend('CS+','CS-');
ylabel('% PER');
xlabel('Trials');
%plot the trial_wise response of each bee
figure
for i=1:size(ST_result,1)
    subplot(3,4,i)
    
    plot(ST_result(i,:),'*r')%rewarded
    hold on
    plot(bl_result(i,:),'ob')%non-rewarded
    
    ylim([-0.1,1.1])
    xlim([1,size(ST_result,2)])
    yticklabels({'0 ', [], '1 '})
    title(['Bee ', num2str(i)])
    %legend('RW','nRW')
end

%plot probability of response over time
clean_exp_anal=exp_anal;
clean_exp_anal(:,[1,2],:)=nan;%remove unusable bees
exp_st = clean_exp_anal(:,:,strcmp(sequence, 'ST'));
exp_bl = clean_exp_anal(:,:,strcmp(sequence, 'bl'));
%plot average probability over cicles
prob_ST_all=squeeze(nanmean(clean_exp_anal(:,:,strcmp(sequence,'ST')),[2]));
prob_bl_all=squeeze(nanmean(clean_exp_anal(:,:,strcmp(sequence,'bl')),[2]));
fig = figure
n=16
for i=1:n
    subplot(4,4,i)
    plot(prob_ST_all(:,i),'-r')
    hold on
    plot(prob_bl_all(:,i),'-b')
    rectangle('Position',[pre_stim*fps, -0.1, t_CS*fps, 1.3],'FaceColor', [1 1 0 0.1],....
        'EdgeColor',[0.9290 0.6940 0.1250 0.7])
    
    rectangle('Position',[(pre_stim+t_CS-t_overlap)*fps, -.1, t_US*fps, 1.3],'FaceColor', [1 0 1 0.1],....
        'EdgeColor',[0.9290 0.6940 0.1250 0.7])
    xticks((0:40:size(exp_anal,1)))
    xticklabels(string((0:2*fps:size(exp_anal,1))/fps))
    ylim([-0.1,1.2])
    title(['Trial ', num2str(i)])
end
han=axes(fig,'visible','off'); 
han.Title.Visible='off';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Probability');
xlabel(han,'Time (s)');
title(han,'yourTitle');

%plot area under the curve for all of bl trials and for st trials before
%sucrose, normalized over number of frames
cut_prob_ST_all = prob_ST_all(1:120,:);
auc_st = trapz(cut_prob_ST_all)/120;
%auc_st = trapz(prob_ST_all);
auc_bl = trapz(prob_bl_all)/210;
%std_st = std(cut_prob_ST_all);
%std_bl = std(prob_bl_all);
figure
%plot(auc_st)
hold on
shadedErrorBar([],mean(cut_prob_ST_all),std(cut_prob_ST_all)/sqrt(length(cut_prob_ST_all)),'lineprops','-r');
plot(auc_bl)
shadedErrorBar([],mean(prob_bl_all),std(prob_bl_all)/sqrt(length(prob_bl_all)),'lineprops','-b');
hold off
ylabel('AUC')
xlabel('Trials')
legend('CS+','CS-');

%plot average probability overall
prob_ST=squeeze(nanmean(clean_exp_anal(:,:,strcmp(sequence,'ST')),[2,3]));
prob_bl=squeeze(nanmean(clean_exp_anal(:,:,strcmp(sequence,'bl')),[2,3]));
figure
 plot(prob_ST,'-r')
 shadedErrorBar([],mean(prob_ST_all'),std(prob_ST_all'),'lineprops','-r');
    hold on
    plot(prob_bl,'-b')
    shadedErrorBar([],mean(prob_bl_all'),std(prob_bl_all'),'lineprops','-b');
    rectangle('Position',[pre_stim*fps, -0.1, t_CS*fps, 1.3],'FaceColor', [1 1 0 0.1],....
        'EdgeColor',[0.9290 0.6940 0.1250 0.7])
    
    rectangle('Position',[(pre_stim+t_CS-t_overlap)*fps, -.1, t_US*fps, 1.3],'FaceColor', [0 0 1 0.1],....
        'EdgeColor',[0.9290 0.6940 0.1250 0.7])
    xticks((0:40:size(exp_anal,1)))
    xticklabels(string((0:2*fps:size(exp_anal,1))/fps))
    ylim([-0.1,1.2])
    p1 = plot(prob_ST,'-r');
    p2 = plot(prob_bl,'-b');
    legend([p1 p2],{'RW','nRW'})
    ylabel('Probability')
    xlabel('Time(s)')
    hold off
%%
%plot  bee response. you can decide whether to plot all the trials for a
%single bee or all the bees for a single trial changing the variable ind
%below. The plot shows a red line which is the bynary response obtained
%thresoholding the filtered probability array of licking to the thr value set in the
%previuos section. the blue line is a low pass filtered version of the
%probability array you get out from the AI model for a trial movie of a
%bee. the low pas filter is meant to remove random mislabeled frames
Pos = [10 550 800 400];
set(0, 'DefaultFigurePosition', Pos);
%close all
%define wihic bee or cicle to plot
bee=24
cicle=1
close all
thr=0.8 %change the thr of probability  if you want a more or less stringent classification
ind=3 %set the ind variable accordingly, 2 for a bee and 3 for a cicle
for i=1:size(exp_anal,ind)
    if ind==2
        y_filt=lowpass(exp_anal(:,i,cicle),round(fps/6),fps); %plot a bee
    elseif ind==3
        y_filt=lowpass(exp_anal(:,bee,i),round(fps/6),fps);%plot a cicle
    end
    if ind==3
        n_row=6;
        n_col=ceil(length(sequence)/n_row);
        
    else
        n_col=3;
        n_row=4;
    end
    subplot(n_row,n_col,i)
    plot(y_filt)
    hold on
    
    y_filt(y_filt>thr)=1;
    y_filt(y_filt<=thr)=0;
    plot(y_filt);
    rectangle('Position',[pre_stim*fps, -0.1, t_CS*fps, 1.3],'FaceColor', [1 1 0 0.1],....
        'EdgeColor',[0.9290 0.6940 0.1250 0.7])
    
    rectangle('Position',[(pre_stim+t_CS-t_overlap)*fps, -.1, t_US*fps, 1.3],'FaceColor', [0 0 1 0.1],....
        'EdgeColor',[0.9290 0.6940 0.1250 0.7])
    if ind==2
        title(['bee ', num2str(i)])
    elseif ind==3
        title(sequence(i))
    end
    xticks((0:40:size(exp_anal,1)))
    xticklabels(string((0:2*fps:size(exp_anal,1))/fps))
    ylim([-0.1,1.2])
end
%bee=bee+1
%%
%Show the response of the bee by plotting its probability graph and showing
%its movie with labeled frames. REQUIRES THE VIDEO DATA, NOT UPLOADED HERE.
bee=11;
cicle=1
speed=1
diff=0%set to 1 if you want to display movments
manual=0%set to 1 if you want to manually advance the frames
movie=0%set to 1 if you want to record a video
%view_PER (exp_anal,data, speed,bee,cicle,t_CS,t_overlap,t_US)
view_PER(exp_anal,data,speed,bee,cicle,pre_stim,t_CS,t_overlap,t_US,fps,manual,movie,diff)
%%
%cicle=cicle+1
bee=bee+1
























