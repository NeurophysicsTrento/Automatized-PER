function out = tismaq
%TISMAQ Code for creating a video input object.
%   
%   This is the machine generated representation of a video input object.
%   This MATLAB code file, TISMAQ.M, was generated from the OBJ2MFILE function.
%   A MAT-file is created if the object's UserData property is not 
%   empty or if any of the callback properties are set to a cell array  
%   or to a function handle. The MAT-file will have the same name as the 
%   code file but with a .MAT extension. To recreate this video input object,
%   type the name of the code file, tismaq, at the MATLAB command prompt.
%   
%   The code file, TISMAQ.M and its associated MAT-file, TISMAQ.MAT (if
%   it exists) must be on your MATLAB path.
%   
%   Example: 
%       vidobj = tismaq;
%   
%   See also VIDEOINPUT, IMAQDEVICE/PROPINFO, IMAQHELP, PATH.
%   

% Check if we can check out a license for the Image Acquisition Toolbox.
canCheckoutLicense = license('checkout', 'Image_Acquisition_Toolbox');

% Check if the Image Acquisition Toolbox is installed.
isToolboxInstalled = exist('videoinput', 'file');

if ~(canCheckoutLicense && isToolboxInstalled)
    % Toolbox could not be checked out or toolbox is not installed.
    error(message('imaq:obj2mfile:invalidToolbox'));
end

% Load the MAT-file containing UserData and CallBack property values.
try
    MATvar = load('D:\Users\ettore.tiraboschi\Desktop\tismaq');
    MATLoaded = true;
catch
    warning(message('imaq:obj2mfile:MATload'));
   MATLoaded = false;
end


% Device Properties.
adaptorName = 'tisimaq_r2013_64';
deviceID = 1;
vidFormat = 'RGB24 (1024x768)';
tag = '';

% Search for existing video input objects.
existingObjs1 = imaqfind('DeviceID', deviceID, 'VideoFormat', vidFormat, 'Tag', tag);

if isempty(existingObjs1)
    % If there are no existing video input objects, construct the object.
    vidObj1 = videoinput(adaptorName, deviceID, vidFormat);
else
    % There are existing video input objects in memory that have the same
    % DeviceID, VideoFormat, and Tag property values as the object we are
    % recreating. If any of those objects contains the same AdaptorName
    % value as the object being recreated, then we will reuse the object.
    % If more than one existing video input object contains that
    % AdaptorName value, then the first object found will be reused. If
    % there are no existing objects with the AdaptorName value, then the
    % video input object will be created.

    % Query through each existing object and check that their adaptor name
    % matches the adaptor name of the object being recreated.
    for i = 1:length(existingObjs1)
        % Get the object's device information.
        objhwinfo = imaqhwinfo(existingObjs1{i});
        % Compare the object's AdaptorName value with the AdaptorName value
        % being recreated.
        if strcmp(objhwinfo.AdaptorName, adaptorName)
            % The existing object has the same AdaptorName value as the
            % object being recreated. So reuse the object.
            vidObj1 = existingObjs1{i};
            % There is no need to check the rest of existing objects.
            % Break out of FOR loop.
            break;
        elseif(i == length(existingObjs1))
            % We have queried through all existing objects and no
            % AdaptorName values matches the AdaptorName value of the
            % object being recreated. So the object must be created.
            vidObj1 = videoinput(adaptorName, deviceID, vidFormat);
        end %if
    end %for
end %if

% Configure properties whose values are saved in D:\Users\ettore.tiraboschi\Desktop\tismaq.mat.
if (MATLoaded)
    % MAT-file loaded successfully. Configure the properties whose values
    % are saved in the MAT-file.
    set(vidObj1, 'ErrorFcn', MATvar.errorfcn1);
else
   % MAT-file could not be loaded. Configure properties whose values were
   % saved in the MAT-file to their default value.
    set(vidObj1, 'ErrorFcn', @imaqcallback);
end

% Configure vidObj1 properties.
set(vidObj1, 'FramesPerTrigger', 1);
set(vidObj1, 'ReturnedColorSpace', 'grayscale');
set(vidObj1, 'ROIPosition', [0 0 1024 768]);

% Configure vidObj1's video source properties.
srcObj1 = get(vidObj1, 'Source');
set(srcObj1(1), 'Brightness', 16);
set(srcObj1(1), 'Contrast', 0);
set(srcObj1(1), 'Denoise', 0);
set(srcObj1(1), 'Exposure', 0.01);
set(srcObj1(1), 'ExposureAuto', 'Off');
set(srcObj1(1), 'ExposureAutoMaxValue', 0.0038);
set(srcObj1(1), 'ExposureAutoReference', 128);
set(srcObj1(1), 'FrameRate', 263.158);
set(srcObj1(1), 'Gain', 9.7);
set(srcObj1(1), 'Gamma', 100);
set(srcObj1(1), 'GPIOGPIN', 0);
set(srcObj1(1), 'GPIOGPOut', 0);
set(srcObj1(1), 'SerialNo', 2.51204e+07);
set(srcObj1(1), 'Sharpness', 0);
set(srcObj1(1), 'StrobePolarity', 'Low');
set(srcObj1(1), 'ToneMappinga', 0);
set(srcObj1(1), 'ToneMappingc', 0);
set(srcObj1(1), 'ToneMappingGlobalBrightnessFactor', 0);
set(srcObj1(1), 'TriggerDelay', 15);
set(srcObj1(1), 'TriggerPolarity', 'Low');


out = vidObj1 ;
