% 排除dir命令返回的无效文件名： ".", ".."
% 用法： 
%       segs = segs(cellfun(@valid_dir_name, {segs.name}))
function v = valid_dir_name(dir_name)
    if strcmp(dir_name, '.') == 1 || strcmp(dir_name, '..')
        v = false;
    else
        v = true;
    end
end