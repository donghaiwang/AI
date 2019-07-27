% Example :
% p = PropEvent(1, 2)
% pl = PropListener(p)

classdef PropEvent < handle
    properties (SetObservable, AbortSet)
        PropOne
        PropTwo
    end
    
    methods
        function obj = PropEvent(p1, p2)
            if nargin > 0
                obj.PropOne = p1;
                obj.PropTwo = p2;
            end
        end
    end
end
