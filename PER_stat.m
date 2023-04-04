function [PER_result,NR_bees]=PER_stat(exp_anal,t_CS,pre_stim,fps,thr, t_overlap, sequence)

trials=size(exp_anal,3);
bees=size(exp_anal,2);
NR_bees=zeros(bees,trials);
PER_result=zeros(bees,trials);
stims = strcmp(sequence,'ST');
laststim = find(stims,1,'last');
for j=1:trials
    for i=1:bees
        y_filt=lowpass(exp_anal(:,i,j),round(fps/6),fps);
        %y_filt=lowpass(PER_anal(:,bee,i),round(fps/6),fps);
        %plot(y_filt)
        %hold on
        y_filt(y_filt>thr)=1;
        y_filt(y_filt<=thr)=0;
        val=y_filt((pre_stim-1)* fps:pre_stim*fps);%1 sec before stim check for unstimulated licking
        if sum(val)<10 %if licking last less then 0.5 sec  in the last sec before stim  check for stim response  
            val=y_filt((pre_stim)*fps:(pre_stim+t_CS-t_overlap+1)*fps);
            if sum(val)>=5
                PER_result(i,j)=1;
            end
        end
        if j == laststim
        %labelling bees that don't respond to sucrose stimulus
            NR_bees=remove_NR_bees(y_filt,NR_bees,j,i,pre_stim,t_CS, t_overlap,fps);
        end
    end
end