classdef MCount < handle
%MCount counts the number of M-codes you have written
%
% MCount.lines(path) count the lines you have written under
%   directory filepath.
%
% MCount.reallines(path) count the lines you have written under
%   directory filepath, but omits the emtpy lines and comment lines.
%
% MCount.size(path) adds up the size of your m-files under directory
%   filepath
%
% All of them support multi-paths (in cells), for example,
% MCount.lines({'patha', 'pathb/pathc', 'filed'});
%
% My(zhang@zhiqiang.org) result: in recent 1 year, I wrote 19524 lines of
% M-codes totally, 12311 lines except for empty lines and comments lines,
% 603K in file size.
%
% author: zhang@zhiqiang.org, 2011,
% url: http://zhiqiang.org/blog/it/how-many-codes-have-you-written.html
% version: 2011-03-24 

    methods (Static = true)
        function l = lines(filepath)
            if nargin == 0
                filepath = pwd;
            end
            if iscell(filepath)
                l = 0;
                for i = 1:numel(filepath)
                    l = l + MCount.lines(filepath{i});
                end
                return
            end
            l = 0;
            if nargin == 0, filepath = cd; end

            if ~exist(filepath, 'file')
                error([filepath ' is not a file or directory']);
            end

            if exist(filepath, 'dir')
                files = dir(filepath);
                for i = 1:numel(files)
                    file = files(i);
                    if ~strcmp(file.name, '.') && ~strcmp(file.name, '..')
                        l = l + MCount.lines([filepath, '/', file.name]);
                    end
                end                                
            else
                if length(filepath) > 2 && filepath(end) == 'm' && filepath(end-1) == '.'
                    l = MCount.getfilelines(filepath);
                end
            end
        end

        function l = reallines(filepath)
            if nargin == 0
                filepath = pwd;
            end            
            if iscell(filepath)
                l = 0;
                for i = 1:numel(filepath)
                    l = l + MCount.reallines(filepath{i});
                end
                return
            end            
            l = 0;
            if nargin == 0, filepath = cd; end

            if ~exist(filepath, 'file')
                error([filepath ' is not a file or directory']);
            end

            if exist(filepath, 'dir')
                files = dir(filepath);
                for i = 1:numel(files)
                    file = files(i);
                    if ~strcmp(file.name, '.') && ~strcmp(file.name, '..')
                        l = l + MCount.reallines([filepath, '/', file.name]);
                    end
                end                                
            else
                if length(filepath) > 2 && filepath(end) == 'm' && filepath(end-1) == '.'
                    l = MCount.getfilereallines(filepath);
                end
            end
        end

        function l = size(filepath)
            if nargin == 0
                filepath = pwd;
            end         
            if iscell(filepath)
                l = 0;
                for i = 1:numel(filepath)
                    l = l + MCount.size(filepath{i});
                end
                return
            end            
            l = 0;
            if nargin == 0, filepath = cd; end

            if ~exist(filepath, 'file')
                error([filepath ' is not a file or directory']);
            end

            if exist(filepath, 'dir')
                files = dir(filepath);
                for i = 1:numel(files)
                    file = files(i);
                    if ~strcmp(file.name, '.') && ~strcmp(file.name, '..') && file.isdir == 1
                        l = l + MCount.size([filepath, '/', file.name]);
                    elseif length(file.name) > 2 && file.name(end) == 'm' && file.name(end-1) == '.'
                        l = l + file.bytes;
                    end
                end                                
            else
                if length(filepath) > 2 && filepath(end) == 'm' && filepath(end-1) == '.'
                    t = dir(filepath);
                    l = l + t(1).bytes;
                end
            end
        end        

        function l = getfilelines(filename)
            fid = fopen(filename, 'rt');
            if fid<0
                error(['Can''t open file for reading (' filename ')'])
            end

            l = 0;
            while(~feof(fid))
                fgetl(fid);
                l = l+1;
            end
            fclose(fid);
        end


        function l = getfilereallines(filename)
            fid = fopen(filename, 'r');
            if fid<0
                error(['Can''t open file for reading (' filename ')'])
            end

            l = 0;
            while ~feof(fid)
                t = fgetl(fid);        

                for i = 1:numel(t)
                    if t(i) ~= ' '
                        break; 
                    end
                end
                if numel(t) && i < numel(t) && t(i) ~= '%'
                    l = l + 1;
                end
            end
            fclose(fid);
        end        
    end
end