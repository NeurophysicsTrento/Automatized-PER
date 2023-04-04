stim_ch=[1,2,3,4,5,6,7];%define channel numbers of the USB Nidaq board to be used. beware of the numbering,
%as the hardware port is 0-7 whereas the coding numbering is 1-8
%{'HP','LP','OD1','OD2','REW','PUN','NEXT_BEE'};%hardware fucntions  associated with the sequence of the channells(stim_ch)
%this part below must be adapted to your hardware specs
chan=stim_ch-1
s = daq.createSession('ni');
s.Rate=100;
Rate=s.Rate;
for k=1:length(chan)
    str=num2str(chan(k));
    addDigitalChannel(s,'Dev4',['port0/line',str],'OutputOnly');
end
%test the channels, initialize the USB Nidaq port. the PC sends out a
%string of 0/1 to the USB Nidaq port
off=[0     0     0     0     0     0     0  ];
outputSingleScan(s, off);%set to zero all the channels
%%
%Load the CNN model: set your path
net = importKerasNetwork('\\cimec-storage\albhaa\haaalb001a1p\ettore\important script\PER\Classifier_models\licking_model_100_19M_4.h5')
%% STIMULI
%this are fucntions that allow you to activate specific elements of your
%hardware
next_bee(s);%move the revolver a step forward
punish(s);%rotate the servo motor to deliver the punishment
reward(s);%rotate the servo motor to deliver the reward
HP(s,1);%open air valve at high flux
OD1(s,4);%deliver odor 1 for 4 sec
OD2(s,4);%deliver odor 2 for 4 sec
LP(s,1);%open air valve at low flux
%%
%initialize the camera. Also in this case the code must be adapted to your
%specific hardware
exp=0.01
vid=tismaq%tismaq is the adaptor for our camera. you need to use the proper one
preview(vid)
srcObj1 = get(vid, 'Source');
% set(srcObj1(1), 'FrameRate', 10);
set(srcObj1(1), 'Exposure', exp);
width=288;
height=288;
set(vid, 'ROIPosition', [420,340,width,height]);
triggerconfig(vid, 'manual')
set(vid,'Timeout',36000);


%stoppreview(vid)

%%
%PLACE THE REVOLVER SUCH THAT THE BEE 12 IS IN FRONT OF TTHE FEEDER,AS THE PROCEDURE WILL MOVE ON ONE BY ONE
%THROUGH THE BEES
% Define PER conditioning protocol
preview(vid)
ST='ST';%stimulus
bl='bl';%blanck
sequence={bl;bl;ST;ST;bl;ST;bl;ST;bl;ST;}; %randomized sequence of trials
%the following 5 lines define the string of 0/1s to be sent out to the USB
%nidaq port in order to execute the different part of the protocol
%this 2 lines below are the US.
rew=[0     0     0     0     1    0     0  ];
pun=[0     0     0     0     0     1     0   ];

%this 2 lines below are the CS
od1=[0     0     1     0     0    0     0  ];
od2=[0     0     0     1     0    0     0  ];
no_od=[0     0     0     0     0    0     0  ];

%Define the timiing of the protocol
pre_stim=2;%time recorded before_the stimulus
post_stim=2;
t_CS=4;%length of the conditional stimulus in sec
t_overlap=1;
t_US=3.5;%%length of the unconditional stimulus in sec.
%add .5 sec for moving the feeder 

%All the times are in seconds
n_bee=12%set the number of bees on the revolver. do not leave empty slots on the wheel
%if the bee are less than 12 put all of them in sequence
hab_time=25;%time spent by the bee in front of the feeder before receiving the stimulus
trial_time=40; %tot time of the trial
rec_time=pre_stim+t_CS+t_US-t_overlap+post_stim;%recording duration.start 2 sec before stim
n_cicles=length(sequence);
find_head_center%this script opens a window where you will select a fixed point on the head of the bee
%which will be used to ceter the camera frame

%initialize the dataset to allocate the recordings of
%[l,w]*n_frames*n_bees*n_cicles
data=zeros(288,288,ceil(rec_time/(exp*5)),n_bee,n_cicles,'uint8');%in our case we store 1 frame
%out of 5 since camera is recording at 100fps  so our rate is 20fps

srcObj1 = get(vid, 'Source');
set(vid,'Timeout',3600);
vid.FramesPerTrigger = rec_time/srcObj1.Exposure;

%% PROPER EXPERIMET CODE
%initialize the variable to store the frame classification
%[n_frame,n_bee,n_cicles]. n_cilces is the number of trials
exp_anal=zeros(rec_time/(exp*5),n_bee,n_cicles);
%START THE EXPERIMENT
for i = 1:n_cicles
    for k=1:n_bee
        fprintf('bee %.0f \n', k);
        fprintf('cicle %.0f \n', i);
        next_bee(s);
        dx=ROI_center(k,1);
        dy=ROI_center(k,2);
        set(vid, 'ROIPosition', [dx-80,dy-150,width,height]);
        close all
        a=tic;
        start(vid)
        pause(hab_time-pre_stim)%pre-stimulus only air, habituation.start recording 2 sec before stimulus
        trigger(vid)      
        pause(pre_stim)
        
        if strcmp(sequence(i),ST) %check what stimulus is to be delivered according to the sequence
            %HERE YOU SET WAHT STIMULUS TO USE, SO DEFINE WHICH ARRAY TO
            %DELIVER( eg. od1,LP)AND WHICH us (rew, pun)
            stim_prot (s,od1,rew,t_CS,t_overlap, t_US);%it last for t_stim+t_cond-t_overlap secds
           
            frames = getdata(vid);
            frames=squeeze(frames);
            data(:,:,:,k,i)=frames(:,:,1:5:end);
            stop(vid)
            exp_anal(:,k,i)=eval_licking(frames(:,:,1:5:end),net);%classify the movie
            pause(trial_time-toc(a))%defaukt 15
            
       
        else
            %HERE YOU SET WAHT STIMULUS TO USE, SO DEFINE WHICH ARRAY TO
            %DELIVER( eg. od1,LP)AND WHICH us (rew, pun)
            stim_prot (s,off,pun,t_CS,t_overlap, t_US);%it last for t_stim+t_cond-t_overlap secds
            while(toc(a)<rec_time)
            end
            
            frames = getdata(vid);
            frames=squeeze(frames);
            data(:,:,:,k,i)=frames(:,:,1:5:end);
            stop(vid)
            exp_anal(:,k,i)=eval_licking(frames(:,:,1:5:end),net);
%             plot(exp_anal(:,k,i));
%             ylim([0,1])
            pause(trial_time-toc(a))
        end       
    end
    %if there are less than 12 bees on the rebolver it will take into
    %account and move it accordingly for the next trial
    if n_bee<12
    for l=1:(12-n_bee)
     next_bee(s);
     pause(trial_time)
    end
    end
end
%save the file exp.mat
save('exp','exp_anal','t_CS','t_overlap','t_US','hab_time',....
    'trial_time','sequence','pre_stim','data','-v7.3');%nome file sal


