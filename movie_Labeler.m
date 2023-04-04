%Load a a movie in the for af a 3D array
%load('\\cimec-storage\albhaa\haaalb001a1p\ettore\important script\PER\bee movie\mov1.mat');
%mov1=squeeze(mov1);
%select a cicle
cicle=10
if length(size(exp))>4
I=squeeze(exp(:,:,:,:,cicle));
else%if dataset is a 5D matrix use this line
I=exp;%if dataset is a 4D matrix use this line
end
%%
%select a bee
bee=3
if length(size(exp))>4
I=squeeze(exp(:,:,:,bee,28:33));
else%if dataset is a 5D matrix use this line
I=exp;%if dataset is a 4D matrix use this line
end
%%
bee=1
mov1=I(:,:,:,1);

%command list:
%0 is the base class.1,2,3 are free class.
%%left and right arrow moves the movie. up and down arrow increases or
%%decreases the step of the movements.q is to terminate the labelling.
%%scroll the mouse wheel for running the movie
classification=zeros(size(mov1,3),size(I,4));

%%
warning('off','all')
close all
global y%y is the vectors with the labels
global i
global fps
%bee=1
mov1=I(:,:,:,bee);
fps=1;
i=fps;
y=zeros(length(mov1),1);%final array with frame values
hFig=figure;
set(hFig,'KeyPressFcn' , @(src,event)label_frames(mov1,y,i,gcf,fps))
set(hFig,'WindowScrollWheelFcn' , {@movieScroll,mov1,y,fps})
img=mov1(:,:,i);
RGB = insertText(img,[1 1],['step ' num2str(i)],...
    'FontSize',18,'BoxColor',...
    'red','BoxOpacity',0.4,'TextColor','white');


imshow(img);
title(['bee ',num2str(bee)])
size(I)


%%
plot(y)
class=0
length(y(y==class))%count the frame in a class
classification(:,bee)=y(1:size(mov1,3));
bee=bee+1
%%
mov1=I(:,:,:,bee);

for j =1:3:length(mov1)
img=mov1(:,:,j);
if classification(j,bee)==1
    colore='green';
else
    colore ='red';
end
RGB = insertText(img,[1 1],[num2str(classification(j,bee)),'    ',  num2str(j)],...
    'FontSize',18,'BoxColor',...
    colore,'BoxOpacity',0.4,'TextColor','white');


imshow(RGB)

end

bee=bee+1



