% this fuction is used to classify the type of response in a bee. It take a
% a movie as input in the form of a 3D matrix([length,width,n_frames])and feed it to the model prior resizing and
% normalization. it will return the vector Prob which contains the
% probability for the licking behavior of each frame in the movie
function Prob=eval_licking(frames,net)

I=double(frames);
inp_size=net.Layers(1,1).InputSize(1:2);
Prob=nan(size(I,3),1);
 h = waitbar(0,['Predicting cicle ']);
  object_handles = findall(h);
    set( object_handles(4), 'FontSize', 16)
    set(h,'Position',[500 499 300 70])
 dur=0;   
for i=1:size(I,3)
    tic
    img=I(:,:,i);
    img=(img-min(min(img)))./(max(max(img))-min(min(img))); 
    img = imresize(img, inp_size);
  
    [~,y] = classify(net,img,'Acceleration', 'auto');
    Prob(i)=y(2);
    dur=(dur+toc);  
    
    if rem(i,10)==0
     time_left=(size(I,3)-i)*dur/10;
     dur=0;
    waitbar(i / size(I,3),h,['time ',num2str(round(time_left))])
    end
end
close (h)


