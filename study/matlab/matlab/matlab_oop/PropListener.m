classdef PropListener < handle
    % Define property listeners
    methods 
        function obj = PropListener(evtobj)
            if nargin > 0
                addlistener(evtobj, 'PropOne', 'PostSet', @PropListener.handlePropEvents);
                addlistener(evtobj, 'PropTwo', 'PostSet', @PropListener.handlePropEvents);
            end
        end
    end
    
    methods (Static)
        function handlePropEvents(src, evnt)
            switch src.Name
                case 'PropOne'
                    sprintf('PropOne is %s\n', num2str(evnt.AffectedObject.PropOne))
                case 'PropTwo'
                    sprintf('PropTwo is %s\n', num2str(evnt.AffectedObject.PropTwo))
            end
        end
    end
end
