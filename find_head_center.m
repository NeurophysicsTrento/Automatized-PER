%find bee head
%set(vid, 'ROIPosition', [0 0 1280 960]);
set(vid, 'ROIPosition', [0 0 1024 768]);
[y,Fs] = audioread('click.wav');
start(vid)
ROI_center=zeros(n_bee,2);
for k=1:n_bee
    next_bee(s);
    pause(3)
    mov = peekdata(vid,1);
    figure
    img=mov(:,:,1);
    %img=video(i).cdata;
    imshow(img)
    
    % search_bee
    % ROI_center(k,:)=ceil(centroid_final)
    ROI_center(k,:)=ginput(1);
    pause(0.05);
    sound(y,Fs);
    pause(0.1);
    close all
end
stop(vid);
close all

%%
delta_frame=diff(data(:,:,:,1:1),3);