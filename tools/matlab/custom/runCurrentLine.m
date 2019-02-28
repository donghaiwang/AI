%% add comment for a script by press "Alt + 2"
% Home -> Favorites -> New Favorite -> 
% Label: comment
% Code:  addComment
% select 'Add to quick access toolbar' and 'Show label on quick acces
% toolbar'.
function runCurrentLine
    activeEditor = matlab.desktop.editor.getActive;
    
%     disp('hello');
    selectionPosition = activeEditor.Selection;
    selectLineIdx = selectionPosition(1);
    scriptContents = activeEditor.Text;
    contentsCell = splitlines(scriptContents);
    eval(contentsCell{selectLineIdx});  % run the line at cursor
end