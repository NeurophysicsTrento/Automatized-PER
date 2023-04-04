%Load a dataset from PER test and perform the analyses over a 5D dataset whose dimensions are
%[H,W,frames,trials,bee].
function [exp_anal]=PER_predict(data,net)


%sequence={ST;bl;bl;ST;ST;bl;bl;ST;bl;ST};
%fps=20
frames=size(data,3);
trials=size(data,5);

bees=size(data,4);

exp_anal=zeros(frames,bees,trials);%1st dim is num_frames,2nd dim is bee
%3rd dim is cicle


for cicle=1:size(data,5)
    
   
        I=double(squeeze(data(:,:,:,:,cicle)));
        exp_anal(:,:,cicle)=predict_licking(I,net,cicle);
        
   
end
end


