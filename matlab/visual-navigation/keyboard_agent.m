%% 键盘控制前后左右，浏览hdf5格式的场景文件
% python keyboard_agent.py --scene_dump ./data/bedroom_04.h5
h5FilePath = [pwd '\data\bedroom_04.h5'];
h5disp(h5FilePath);
global transitionGraph;
transitionGraph = h5read(h5FilePath, '/graph');     % 4x408
locations = h5read(h5FilePath, '/location');        % 2x408
global observation;
observation = h5read(h5FilePath, '/observation');   % 3x400x300x408（408张观测的图像 current_state_id）
features = h5read(h5FilePath, '/resnet_feature');   % 2048x10x408
rotation = h5read(h5FilePath, '/rotation');         % 408x1
shortestPathDistance = h5read(h5FilePath, '/shortest_path_distance');  % 408x408

[channels, width, height, stateNum] = size(observation);

fig = figure;
global currentStateID;
currentStateID = round(rand*stateNum);  % 随机初始化一个位置作为起始位置
% currentStateID = 113;
randImg = observation(:,:,:, currentStateID);
randImg = permute(randImg, [3, 2, 1]);
imshow(randImg);

set(fig, 'KeyPressFcn', @keypress)  % 绑定显示图形的工具的时间处理（方向箭头）

function keypress(~, evnt)
    global currentStateID;
    global observation;
    global transitionGraph;
%     disp(evnt.Key);
    switch lower(evnt.Key) % 2314 (3124)
        case 'rightarrow'
            action = 2;
        case 'leftarrow'
            action = 3;  % 左转
        case 'uparrow'
            action = 1;  % 2前进
        case 'downarrow'
            action = 4;
        case 'q'
            close(gcf); return;
        otherwise
            return
    end
    if transitionGraph(action, currentStateID) == -1  % 没有改变currentStateID的值
        disp('Collision occurs.');return;
    end
    currentStateID = transitionGraph(action, currentStateID);
    currentStateID = currentStateID+1;  % 转化图中对应方向数值的下一个
    currentImg = observation(:,:,:, currentStateID);
    currentImg = permute(currentImg, [3, 2, 1]);
    imshow(currentImg);
end


%%
%{
HDF5 bedroom_04.h5 
Group '/' 
    Attributes:
        'version':  1.000000
        'scene_name':  'THOR_BEDROOM_04'
    Dataset 'graph' 
        Size:  4x408
        MaxSize:  4x408
        Datatype:   H5T_STD_I64LE (int64)
        ChunkSize:  []
        Filters:  none
        FillValue:  0
    Dataset 'location' 
        Size:  2x408
        MaxSize:  2x408
        Datatype:   H5T_IEEE_F64LE (double)
        ChunkSize:  []
        Filters:  none
        FillValue:  0.000000
    Dataset 'observation' 
        Size:  3x400x300x408
        MaxSize:  3x400x300x408
        Datatype:   H5T_STD_U8LE (uint8)
        ChunkSize:  []
        Filters:  none
        FillValue:  0
    Dataset 'resnet_feature' 
        Size:  2048x10x408
        MaxSize:  2048x10x408
        Datatype:   H5T_IEEE_F32LE (single)
        ChunkSize:  []
        Filters:  none
        FillValue:  0.000000
    Dataset 'rotation' 
        Size:  408
        MaxSize:  408
        Datatype:   H5T_STD_U64LE (uint64)
        ChunkSize:  []
        Filters:  none
        FillValue:  0
    Dataset 'shortest_path_distance' 
        Size:  408x408
        MaxSize:  408x408
        Datatype:   H5T_STD_I64LE (int64)
        ChunkSize:  []
        Filters:  none
        FillValue:  0
%}


