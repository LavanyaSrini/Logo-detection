
function [regionsOfLogo_6] = detectLogo(videoName)

%% Verify the name of the video exists
if nargin ==0
    disp('No input video')
    return;
end
%% In case the dimensions are very large, give the option to reduce

% Grab the video into an object, parameters will be extected from this object
videoObj=VideoReader(videoName);


% Probably it can be possible to grab all the frames and not have to read a second
% time, but with large videos there may be issues of memory.

% framesOfVideo = struct('cdata',zeros(videoObj.Height/reductionSize,videoObj.Width/reductionSize,3,'uint8'),...
%     'colormap',[]);



%% Read the first frame to prepare the average frame, get dimensions

vidFrame                = readFrame(videoObj);
% Grab dimensions
[rows,cols,levs]        = size(vidFrame);
% Frames every 20 / 50 / n frames will be recorded
%vidFrame_20             = vidFrame;

% Cross correlations will be calculated at every iteration, then these will be
% accummulated as the only constant cross correlation per line will be the text

avCorrFrame             = double(zeros(rows,cols*2-1));
%%
k                       = 2;

%% Iterate over all frames
% Cross correlations will be calculated and accummulated
% crossCorrelationPerLine = zeros(rows,cols*2-1);
 accummulatedEdge  = zeros(rows,cols);
% timeSample              = 50;

while hasFrame(videoObj)
    % grab current frame frame 

    vidFrame            = readFrame(videoObj);
    currFrame_edge      = edge(rgb2gray(vidFrame),'canny');
    accummulatedEdge    = accummulatedEdge+currFrame_edge;
    
    disp(k)
    
    k = k+1;
end


%% Find the region where there is consistent accummulation of the edges
  

regionsOfLogo           = accummulatedEdge>(0.5*k);
% clean
regionsOfLogo_2         = bwmorph(regionsOfLogo,'clean');
regionsOfLogo_3         = imclose(regionsOfLogo_2,strel('disk',12));
regionsOfLogo_4         = imfill(regionsOfLogo_3,'holes');
regionsOfLogo_5         = imopen(regionsOfLogo_4,strel('disk',8));
regionsOfLogo_6         = imdilate(regionsOfLogo_5,strel('disk',8));

%
imagesc(repmat(uint8(regionsOfLogo_6),[1 1 3]).*vidFrame + repmat(uint8(1-regionsOfLogo_6),[1 1 3]).*(0.34151*vidFrame))





