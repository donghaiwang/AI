%% add comment for a script by press "Alt + 1"
% Home -> Favorites -> New Favorite -> 
% Label: comment
% Code:  addComment
% select 'Add to quick access toolbar' and 'Show label on quick acces
% toolbar'.
function addComment
    activeEditor = matlab.desktop.editor.getActive;
    
    explainComment = "%   Explain:" + newline + ...
        "%       " + newline + ...
        "% " + newline;
    exampleComment = "%   Example:" + newline + ...
        "%       " + newline + ...
        "% " + newline;
    authorComment = "% Author: Haidong Wang" + newline + ...
        "% Email : nongfugengxia@163.com" + newline + ...
        "% " + newline;
    dateComment = "% " + datestr(now) + " created" + newline + ...
        "% " + newline;
    
    finishComment = repmat(newline, 1, 10);
    
    activeEditor.Text = explainComment + exampleComment + ...
        authorComment + dateComment + ...
        activeEditor.Text + finishComment;
end