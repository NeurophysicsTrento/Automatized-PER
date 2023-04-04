
function label_frames(mov1,y,i,gcf,fps)
 global i;
 global y;
 global fps;
 position=[1 1];
 position2=[1 30];
 currkey=get(gcf,'CurrentKey');
 if contains(currkey,'numpad')%assign  a value to each frame
            y(i-fps+1:i+fps)=str2num(currkey(end));
              img=mov1(:,:,i);
            RGB = insertText(img,position,['image ' num2str(i)],'FontSize',18,'BoxColor',...
                'red','BoxOpacity',0.4,'TextColor','white');
            RGB = insertText(RGB,position2,['val y:  ' num2str(y(i))],'FontSize',18,'BoxColor',...
                'blue','BoxOpacity',0.4,'TextColor','white');
            i=i+fps; 
            imshow(RGB);
        elseif strcmp(currkey,'leftarrow')%go backward
            i=i-round(fps);
            img=mov1(:,:,i);
            RGB = insertText(img,position,['image ' num2str(i)],'FontSize',18,'BoxColor',...
                'red','BoxOpacity',0.4,'TextColor','white');
            RGB = insertText(RGB,position2,['val y:  ' num2str(y(i))],'FontSize',18,'BoxColor',...
                'blue','BoxOpacity',0.4,'TextColor','white');
            imshow(RGB);
        elseif strcmp(currkey,'rightarrow')%go forward
            i=i+round(fps);
            img=mov1(:,:,i);
            RGB = insertText(img,position,['image ' num2str(i)],'FontSize',18,'BoxColor',...
                'red','BoxOpacity',0.4,'TextColor','white');
            RGB = insertText(RGB,position2,['val y:  ' num2str(y(i))],'FontSize',18,'BoxColor',...
                'blue','BoxOpacity',0.4,'TextColor','white');
            imshow(RGB);
        elseif strcmp(currkey,'q')%jump to the end
         
           close all
             
        elseif strcmp(currkey,'uparrow')%increase step
            fps=fps+1;
            img=mov1(:,:,i);
            RGB = insertText(img,position,['step ' num2str(fps)],'FontSize',18,'BoxColor',...
                'red','BoxOpacity',0.4,'TextColor','white');
            RGB = insertText(RGB,position2,['val y:  ' num2str(y(i))],'FontSize',18,'BoxColor',...
                'blue','BoxOpacity',0.4,'TextColor','white');
            imshow(RGB);
        elseif strcmp(currkey,'downarrow')%reduce step
            fps=fps-1;
            img=mov1(:,:,i);
            RGB = insertText(img,position,['step ' num2str(fps)],'FontSize',18,'BoxColor',...
               'red','BoxOpacity',0.4,'TextColor','white');
           RGB = insertText(RGB,position2,['val y:  ' num2str(y(i))],'FontSize',18,'BoxColor',...
                'blue','BoxOpacity',0.4,'TextColor','white');
            imshow(RGB);
            
        else
            img=mov1(:,:,i);
            RGB = insertText(img,position,'wrong choise, type again..','FontSize',18,'BoxColor',...
                'green','BoxOpacity',0.4,'TextColor','white');
             RGB = insertText(RGB,position2,['val y:  ' num2str(y(i))],'FontSize',18,'BoxColor',...
                'blue','BoxOpacity',0.4,'TextColor','white');
            imshow(RGB);
        end
 
end