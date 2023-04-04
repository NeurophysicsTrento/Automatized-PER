function movieScroll(src,callbackdata,mov,y,fps)
global i
global y
global fps
position=[1 1];
position2=[1 40]
len=length(mov);
if callbackdata.VerticalScrollCount > 0
    
    if isempty(i)
        i = 1
    elseif i<len
        i = i + fps
    end
  img=mov(:,:,i);
            RGB = insertText(img,position,['image ' num2str(i)],'FontSize',18,'BoxColor',...
                'red','BoxOpacity',0.4,'TextColor','white');
             RGB = insertText(RGB,position2,['val y:  ' num2str(y(i))],'FontSize',18,'BoxColor',...
                'blue','BoxOpacity',0.4,'TextColor','white');
            imshow(RGB);  
    
    
elseif callbackdata.VerticalScrollCount < 0 
   if isempty(i) || i <=fps+1
        i = fps
    else
    i = i - fps
   end

     img=mov(:,:,i);
            RGB = insertText(img,position,['image ' num2str(i)],'FontSize',18,'BoxColor',...
                'red','BoxOpacity',0.4,'TextColor','white');
             RGB = insertText(RGB,position2,['val y:  ' num2str(y(i))],'FontSize',18,'BoxColor',...
                'blue','BoxOpacity',0.4,'TextColor','white');
            imshow(RGB);
end