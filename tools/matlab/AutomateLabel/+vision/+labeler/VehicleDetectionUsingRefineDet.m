%% Test
% groundTruthLabeler 05_highway_lanechange_25s.mp4
% groundTruthLabeler /data/cidi.wmv

%%
classdef VehicleDetectionUsingRefineDet < vision.labeler.AutomationAlgorithm
    %VehicleDetectionAndDistanceEstimation Automation algorithm to detect
    %   vehicles and estimate their distances.
    %   VehicleDetectionAndDistanceEstimation is an automation algorithm
    %   for detecting vehicles using Aggregated Channel Features. This
    %   algorithm also uses the monocular camera configuration to estimate
    %   distances of the vehicles from the camera mounted on the ego
    %   vehicle. This alogirthm is used in the Ground Truth Labeler App.
    %
    %   See also groundTruthLabeler, vision.labeler.AutomationAlgorithm,
    %   imageLabeler
    
    % Copyright 2018 The MathWorks, Inc.
    
    %----------------------------------------------------------------------
    % Algorithm Description
    %----------------------------------------------------------------------
    properties(Constant)
        %Name Algorithm Name
        %   Character vector specifying name of algorithm.
        Name = 'Vehicle Detection Using RefineDet';
        
        %Description Algorithm Description
        %   Character vector specifying short description of algorithm.
        Description = 'Detect vehicles using a pretrained RefineDet vehicle detector';
        
        %UserDirections Algorithm Usage Directions
        %   Cell array of character vectors specifying directions for
        %   algorithm users to follow in order to use algorithm.
        UserDirections = {...
            'Define a rectangle ROI Label to label vehicles.',...
            'For the label definition created, define an Attribute with name Distance, type Numeric Value and default value 0.', ...
            'Run the algorithm',...
            'Manually inspect and modify results if needed'};

    end
    
    %----------------------------------------------------------------------
    % Vehicle Detector Properties
    %----------------------------------------------------------------------
    properties
        %SelectedLabelName Selected label name
        %   Name of selected label. Vehicles detected by the algorithm will
        %   be assigned this variable name.
        SelectedLabelName
        
        %Detector Detector
        %   Pre-trained vehicle detector, an object of class
        %   acfObjectDetector.
        Detector
        
        %VehicleModelName Vehicle detector model name
        %   Name of pre-trained vehicle detector model.
        VehicleModelName = 'full-view';
        
        %OverlapThreshold Overlap threshold
        %   Threshold value used to eliminate overlapping bounding boxes
        %   around the reference bounding box, between 0 and 1. The
        %   bounding box overlap ratio denominator, 'RatioType' is set to
        %   'Min'
        OverlapThreshold = 0.65;
        
        %ScoreThreshold Classification Score Threshold
        %   Threshold value used to reject detections with low detection
        %   scores.
        ScoreThreshold = 0.9;
        
        %ConfigureDetector Boolean value to decide on configuring the detector 
        %   Boolean value which decides if the detector is configured using
        %   monoCamera sensor.
        ConfigureDetector = true;
        
        %SensorObj monoCamera sensor
        %   Monocular Camera Sensor object used to configure the detector.
        %   A configured detector will run faster and can potentially
        %   result in better detections.
        SensorObj = [];
        
        %SensorStr monoCamera sensor variable name
        %   Monocular Camera Sensor object variable name used to configure
        %   the detector.
        SensorStr = '';
        
        %VehicleWidth Vehicle Width
        %   Vehicle Width used to configure the detector, specified as
        %   [minWidth, maxWidth] describing the approximate width of the
        %   object in world units.
        VehicleWidth = [1.5 2.5];
        
        %VehicleLength Vehicle Length
        %   Vehicle Length used to configure the detector, specified as
        %   [minLength, maxLength] describing the approximate length of the
        %   object in world units.
        VehicleLength = [ ];    
    end
    
    %----------------------------------------------------------------------
    % Attribute automation Properties
    %----------------------------------------------------------------------    
    properties (Constant, Access = private)
        
        % Flag to enable Distance attribute automation
        AutomateDistanceAttriibute = true;
        
        % Supported Distance attribute name. 
        % The label must have an attribute with the name specified.
        SupportedDistanceAttribName = 'Distance';
    end
    
    properties (Access = private)
        
        % Actual attribute name for distance
        DistanceAttributeName;
        
        % Flag to check if attribute specified is a valid distance
        % attribute
        HasValidDistanceAttribute = false;
    end
    
    %----------------------------------------------------------------------
    % Setup
    %----------------------------------------------------------------------
    methods
        
        function flag = supportsReverseAutomation(~)            
            flag = true;
        end  
        
        function isValid = checkLabelDefinition(~, labelDef)
            
            % Only Rectangular ROI Label definitions are valid for the
            % Vehicle Detector.
            isValid = labelDef.Type==labelType.Rectangle;
        end
        
        function isReady = checkSetup(algObj)
            
            % Is there one selected ROI Label definition to automate.
            isReady = ~isempty(algObj.SelectedLabelDefinitions);
        end
    end
    
    %----------------------------------------------------------------------
    % Execution
    %----------------------------------------------------------------------
    methods
        function initialize(algObj, ~)
            
            addpath('../..');
            % Store the name of the selected label definition. Use this
            % name to label the detected vehicles.
            algObj.SelectedLabelName = algObj.SelectedLabelDefinitions.Name;
            
            % Initialize the vehicle detector with a pre-trained model.
%             algObj.Detector = vehicleDetectorFasterRCNN(algObj.VehicleModelName);
            algObj.Detector = vehicleDetectorRefineDet();
            
            % Initialize parameters to compute vehicle distance
            if algObj.AutomateDistanceAttriibute
                initializeAttributeParams(algObj);
            end            
        end
        
        function settingsDialog(algObj)
            
            % Invoke dialog with options for choosing a pre-trained model,
            % overlap threshold and detection score threshold. Optionally,
            % input a calibrated monoCamera sensor to configure the
            % detector.
            algObj.settingsACF();            
        end
        
        function autoLabels = run(algObj, I)
            
            autoLabels = [];
            
            % Configure the detector.
%             if algObj.ConfigureDetector && ~isa(algObj.Detector,'acfObjectDetectorMonoCamera')
%                 vehicleSize = [algObj.VehicleWidth;algObj.VehicleLength];
%                 algObj.Detector = configureDetectorMonoCamera(algObj.Detector, algObj.SensorObj, vehicleSize);                
%             end
            
            % Detect vehicles using the initialized vehicle detector.
%             [bboxes, scores] = detect(algObj.Detector, I,...
%                 'SelectStrongest', false);
            bufferFilename = fullfile(tempdir, 'buffer.jpg');
            imwrite(I, bufferFilename);
            bboxesList = algObj.Detector.detect(py.str(bufferFilename));
            for i = 1 : length(bboxesList)
                x1 = double(bboxesList{i}{1});
                y1 = double(bboxesList{i}{2});
                x2 = double(bboxesList{i}{3});
                y2 = double(bboxesList{i}{4});
                bboxes(i, 1) = x1;
                bboxes(i, 2) = y1;
                bboxes(i, 3) = x2 - x1;
                bboxes(i, 4) = y2 - y1;
            end
            selectedBbox = bboxes;
            
%             [selectedBbox, selectedScore] = selectStrongestBbox(bboxes, scores, ...
%                 'RatioType', 'Min', 'OverlapThreshold', algObj.OverlapThreshold);
            
            % Reject detections with detection score lower than
            % ScoreThreshold.
%             detectionsToKeepIdx = (selectedScore > algObj.ScoreThreshold);
%             selectedBbox = selectedBbox(detectionsToKeepIdx,:);
            
            if ~isempty(selectedBbox)
                % Add automated labels at bounding box locations detected
                % by the vehicle detector, of type Rectangle having name of
                % the selected label.
                autoLabels.Name     = algObj.SelectedLabelName;
                autoLabels.Type     = labelType.Rectangle;
                autoLabels.Position = selectedBbox;
                
                if (algObj.AutomateDistanceAttriibute && algObj.HasValidDistanceAttribute)
                    attribName = algObj.DistanceAttributeName;
                    % Attribute value is of type 'Numeric Value'
                    autoLabels.Attributes = computeVehicleDistances(algObj, selectedBbox, attribName);
                end                  
            else
                autoLabels = [];
            end
        end
    end
    
    %----------------------------------------------------------------------
    % Private
    %----------------------------------------------------------------------
    
    methods (Access=private)
        
        function initializeAttributeParams(algObj)
            % Initialize properties relevant to attribute automation
            
            % The label must have an attribute with name Distance and type Numeric Value
            hasAttribute = isfield(algObj.ValidLabelDefinitions, 'Attributes') && ...
                           isstruct(algObj.ValidLabelDefinitions.Attributes);
            if hasAttribute           
               attributeNames = fieldnames(algObj.ValidLabelDefinitions.Attributes);
               idx = find(contains(attributeNames, algObj.SupportedDistanceAttribName));
               if ~isempty(idx)
                  algObj.DistanceAttributeName = attributeNames{idx};  
                  algObj.HasValidDistanceAttribute = validateDistanceType(algObj);
               end
            end  
        end  
        
        function tf = validateDistanceType(algObj)
            % Validate the attribute type 
            
            tf = isfield(algObj.ValidLabelDefinitions.Attributes, algObj.DistanceAttributeName) && ...
                 isfield(algObj.ValidLabelDefinitions.Attributes.(algObj.DistanceAttributeName), 'DefaultValue') && ...
                 isnumeric(algObj.ValidLabelDefinitions.Attributes.(algObj.DistanceAttributeName).DefaultValue);
        end
        

        function distances= computeDistances(algObj, bboxes)
            % Helper function to compute vehicle distance

            midPts = helperFindBottomMidpoint(bboxes);
            xy = algObj.SensorObj.imageToVehicle(midPts);
            distances  = sqrt(xy(:,1).^2 + xy(:,2).^2);

        end

        function attribS = computeVehicleDistances(algObj, bboxes, attribName)
            % Compute vehicle distance
            
            numCars = size(bboxes, 1);
            attribS = repmat(struct(attribName, 0), [numCars, 1]);

            for i=1:numCars       
                distanceVal = computeDistances(algObj, bboxes(i,:));
                attribS(i).(attribName) = distanceVal;
            end
        end

        function settingsACF(algObj)

            importSensorDlgCanceled = true; % no calibration variable selected by default
            
            % Assign default values
            modelName           = algObj.VehicleModelName;
            overlapThresh       = algObj.OverlapThreshold;
            scoreThresh         = algObj.ScoreThreshold;
            configureDetector   = algObj.ConfigureDetector;
            sensorObj           = algObj.SensorObj;
            sensorStr           = algObj.SensorStr;
            vehicleWidth        = algObj.VehicleWidth;
            vehicleLength       = algObj.VehicleLength;
            
            % Position the modal dialog in the center of the screen
            dlgSize = [600 400];
            monitorPos = get(0, 'MonitorPositions');
            monitorPos = monitorPos(1,:);
            center = monitorPos(1:2)+[monitorPos(3), monitorPos(4)]/2;
            dlgPos = round([center-dlgSize/2 dlgSize]);
            
            dlgName = sprintf('%s %s', algObj.Name, ...
                vision.getMessage('vision:labeler:Settings'));
            parentObj = dialog('Position',dlgPos,...
                'Name', dlgName);
            
            % Create panels to add uicontrols to the dialog
            panelX = 0.02;
            panelWidth = 0.57;
            panelWidthOffset = 0.05;           
            panelPos = [panelX 0.03 1 0.24];
            buttonPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX + panelWidth + panelWidthOffset 0.17 1 0.15 ];
            vehicleLengthEditPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX 0.16 panelWidth + panelWidthOffset 0.25 ];
            vehicleLengthTextPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX + panelWidth + panelWidthOffset 0.29 1 0.15 ];
            vehicleWidthEditPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX 0.28 panelWidth + panelWidthOffset 0.25 ];
            vehicleWidthTextPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');            
            
            panelPos = [panelX + panelWidth + panelWidthOffset 0.40 panelWidth+panelWidthOffset 0.2 ];
            importSensorTextPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX + panelWidthOffset 0.39 panelWidth + panelWidthOffset 0.2 ];
            importSensorButtonPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX 0.52 1 0.1 ];
            calibrateCheckBoxPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX + panelWidth 0.63 1 0.15 ];
            classifyThreshEditPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX 0.62 panelWidth 0.25 ];
            classifyThreshTextPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX + panelWidth 0.75 1 0.15 ];
            overlapThreshEditPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX 0.74 panelWidth 0.25 ];
            overlapThreshTextPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX + panelWidth 0.87 panelWidth 0.2 ];
            modelPopupPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            panelPos = [panelX 0.86 panelWidth 0.2 ];
            modelTextPanel = uipanel('Parent', parentObj, ...
                'Units', 'normalized',...
                'Position', panelPos,...
                'HandleVisibility','callback',...
                'BorderType', 'none');
            
            modelPromptStr  = vision.getMessage('vision:labeler:ACFModelName');
            modelPromptStrWidth = numel(modelPromptStr);
            textPos = [2 0 modelPromptStrWidth+4 2];
            % Model name prompt
            uicontrol('Parent',modelTextPanel,...
                'Style','text',...
                'HorizontalAlignment','left',...
                'Units','characters',...
                'Position',textPos,...
                'TooltipString', vision.getMessage('vision:labeler:ModelNameTooltip'),...
                'HandleVisibility','callback',...
                'String',modelPromptStr);
            
            % Model name popup
            popupTextPos = textPos;
            popupTextPos(3) = popupTextPos(3)-2;
            validModelNames = {'full-view';'front-rear-view'};
            modelNamePopup = uicontrol('Parent',modelPopupPanel,...
                'Style','popup',...
                'String',validModelNames,...
                'Units','characters',...
                'Position',popupTextPos,...
                'Callback',@modelPopupCallback,...
                'HandleVisibility','callback',...
                'Tag','modelName');
            
            % Set popupmenu value to previously selected or default model
            % name
            [~,indx] = ismember(validModelNames,modelName);
            modelNamePopup.Value = find(indx==1);            
                        
            function modelPopupCallback(~,~)
                % Enable vehicle length input only for full-view models
                idx = modelNamePopup.Value;
                popupItems = modelNamePopup.String;
                modelNameSelect = char(popupItems(idx,:));
                
                if strcmpi(modelNameSelect,'full-view') && ...
                        calibrateCheckBox.Value == 1
                    hVehicleLengthText.Enable = 'on';
                    hVehicleLengthEdit.Enable = 'on';
                else
                    hVehicleLengthText.Enable = 'off';
                    hVehicleLengthEdit.Enable = 'off';
                end
            end
            
            % Calibration check box
            strPosText = textPos;
            strPosText(3) = 100;
            calibrateCheckBox = uicontrol('Parent',calibrateCheckBoxPanel,...
                'Style','checkbox',...
                'HorizontalAlignment','left',...
                'Units','characters',...
                'Position',strPosText,...
                'Callback',@calibrationCheckBoxCallback,...
                'Value',configureDetector,...
                'TooltipString', vision.getMessage('vision:labeler:ConfigureDetectorTooltip'),...
                'HandleVisibility','callback',...
                'String',vision.getMessage('vision:labeler:ConfigureWithSensor'),...
                'Tag','checkBoxVal');            
 
            function calibrationCheckBoxCallback(~,~)
                % Enable calibration options only when checkbox is checked
                if calibrateCheckBox.Value == 1
                    hImportSensorButton.Enable = 'on';
                    hVehicleWidthText.Enable = 'on';
                    hVehicleWidthEdit.Enable = 'on';
                    hImportSensorText.Enable = 'on';
                    if ~isempty(strtrim(get(hImportSensorText,'String'))) && ...
                            ~isempty(strtrim(hVehicleWidthEdit.String))
                        hOkButton.Enable = 'on';
                    else
                        hOkButton.Enable = 'off';
                    end
                    
                    % Enable vehicle length input only for full-view models
                    idx = modelNamePopup.Value;
                    popupItems = modelNamePopup.String;
                    modelNameSelect = char(popupItems(idx,:));
                    
                    if strcmpi(modelNameSelect,'full-view')
                        hVehicleLengthText.Enable = 'on';
                        hVehicleLengthEdit.Enable = 'on';
                    else
                        hVehicleLengthText.Enable = 'off';
                        hVehicleLengthEdit.Enable = 'off';
                    end
                else
                    hImportSensorButton.Enable = 'off';
                    hVehicleWidthText.Enable = 'off';
                    hVehicleWidthEdit.Enable = 'off';
                    hVehicleLengthText.Enable = 'off';
                    hVehicleLengthEdit.Enable = 'off';
                    hImportSensorText.Enable = 'off';
                    hOkButton.Enable = 'on';
                end
            end
                 
            % Import from workspace push button
            hImportSensorButton = uicontrol('Parent', importSensorButtonPanel, ...
                'Style','pushbutton',...
                'Callback', @doImport,...
                'Units', 'normalized',...
                'Position', [0.08 0.1 0.70 0.4],...
                'HorizontalAlignment', 'left',...
                'TooltipString', vision.getMessage('vision:labeler:ImportMonoCameraTooltip'),...
                'String', vision.getMessage('vision:labeler:ImportSensorFromWS'),...
                'HandleVisibility','callback',...
                'Enable','off',...
                'Tag','ImportButton');
            
            function doImport(varargin)
                variableTypes = {'monoCamera'};
                variableDisp =  {'Monocular Camera Sensor'};
                [sensorObj,sensorObjStr,importSensorDlgCanceled] = vision.internal.uitools.getVariablesFromWS(variableTypes, variableDisp);
                if (~importSensorDlgCanceled)
                    set(hImportSensorText,'String',sensorObjStr);
                    if ~isempty(strtrim(hVehicleWidthEdit.String))
                        % Enable OK button only after all inputs are set.
                        hOkButton.Enable = 'on';
                    end
                end                
            end
            
            % Import variable name
            strPosText = textPos;
            strPosText(1) = strPosText(1)+4;
            strPosText(3) = 100;
            hImportSensorText = uicontrol('Parent',importSensorTextPanel,...
                'Style','text',...
                'HorizontalAlignment','left',...
                'Units','characters',...
                'Position',strPosText,...
                'FontWeight','bold',...
                'Enable','off',... 
                'HandleVisibility','callback',...
                'String',sensorStr,...
                'Tag','sensorText');
            
            % 'Set vehicle length range' text
            strPosText = textPos;
            strPosText(1) = strPosText(1)+5;
            strPosText(3) = 100;
            hVehicleLengthText = uicontrol('Parent',vehicleLengthTextPanel,...
                'Style','text',...
                'HorizontalAlignment','left',...
                'Units','characters',...
                'Position',strPosText,...
                'Enable','off',...
                'HandleVisibility','callback',...
                'TooltipString', vision.getMessage('vision:labeler:VehicleLengthRangeTooltip'),...                
                'String',vision.getMessage('vision:labeler:SensorVehicleLength'));
            
            % Set classification score threshold edit box
            textPosEdit = textPos;
            textPosEdit(1) = textPosEdit(1)+4;
            textPosEdit(3) = 15; 
            if ~isempty(vehicleLength)
                vehicleLengthStr = ['[' num2str(vehicleLength(1)) '   ' num2str(vehicleLength(2)) ']'];
            else
                vehicleLengthStr = '[ ]';
            end
            hVehicleLengthEdit = uicontrol('Parent',vehicleLengthEditPanel,...
                'Style','edit',...
                'Units','characters',...
                'Position',textPosEdit,...
                'String', vehicleLengthStr,...
                'Enable','off',...
                'HandleVisibility','callback',...
                'Tag','vehicleLengthVal');
            
            % 'Set vehicle width range' text
            strPosText = textPos;
            strPosText(1) = strPosText(1)+5;
            strPosText(3) = 100;
            hVehicleWidthText = uicontrol('Parent',vehicleWidthTextPanel,...
                'Style','text',...
                'HorizontalAlignment','left',...
                'Units','characters',...
                'Position',strPosText,...
                'Enable','off',...
                'HandleVisibility','callback',...
                'TooltipString', vision.getMessage('vision:labeler:VehicleWidthRangeTooltip'),...                
                'String',vision.getMessage('vision:labeler:SensorVehicleWidth'));
            
            % Set classification score threshold edit box
            textPosEdit = textPos;
            textPosEdit(1) = textPosEdit(1)+4;
            textPosEdit(3) = 15;            
            hVehicleWidthEdit = uicontrol('Parent',vehicleWidthEditPanel,...
                'Style','edit',...
                'Units','characters',...
                'Position',textPosEdit,...
                'String',['[' num2str(vehicleWidth(1)) '   ' num2str(vehicleWidth(2)) ']'] ,...
                'Enable','off',...
                'HandleVisibility','callback',...
                'Tag','vehicleWidthVal');
                        
            % 'Set overlap threshold' text
            uicontrol('Parent',overlapThreshTextPanel,...
                'Style','text',...
                'HorizontalAlignment','left',...
                'Units','characters',...
                'Position',textPos,...
                'HandleVisibility','callback',...
                'TooltipString', vision.getMessage('vision:labeler:OverlapThresholdTooltip'),...
                'String',vision.getMessage('vision:labeler:ACFOverlapThreshold'));
            
            % Set overlap threshold edit box
            textPosEdit = textPos;
            textPosEdit(3) = 10;
            uicontrol('Parent',overlapThreshEditPanel,...
                'Style','edit',...
                'Units','characters',...
                'Position',textPosEdit,...
                'String',overlapThresh,...
                'HandleVisibility','callback',...
                'Callback', @validateOverlap,...
                'Tag','thresholdVal');
            
            function validateOverlap(src, ~)
                
                overlapThreshold = str2num(src.String); %#ok<ST2NM>
                
                % Overwrite users overlap threshold if they gave a bad
                % value.
                if isempty(overlapThreshold) || ~isreal(overlapThreshold)
                    overlapThreshold = algObj.OverlapThreshold;
                end
                
                if ~isscalar(overlapThreshold)
                    overlapThreshold = overlapThreshold(1);
                end
                
                overlapThreshold = max(min(overlapThreshold,1),0);
                
                src.String = num2str(overlapThreshold);
            end
            
            % 'Set classification score threshold' text
            strPosText = textPos;
            strPosText(3) = 100;
            uicontrol('Parent',classifyThreshTextPanel,...
                'Style','text',...
                'HorizontalAlignment','left',...
                'Units','characters',...
                'Position',strPosText,...
                'HandleVisibility','callback',...
                'TooltipString', vision.getMessage('vision:labeler:ScoreThresholdTooltip'),...
                'String',vision.getMessage('vision:labeler:ACFClassifyScoreThreshold'));
            
            % Set classification score threshold edit box
            textPosEdit = textPos;
            textPosEdit(3) = 10;
            uicontrol('Parent',classifyThreshEditPanel,...
                'Style','edit',...
                'Units','characters',...
                'Position',textPosEdit,...
                'String',scoreThresh,...
                'HandleVisibility','callback',...
                'Callback', @validateClassificationScore,...
                'Tag','scoreThresholdVal');
            
            function validateClassificationScore(src,~)
                
                score = str2num(src.String); %#ok<ST2NM>
                
                % Overwrite users classification score if they gave a bad
                % value.
                if isempty(score) || ~isreal(score)
                    score = algObj.ScoreThreshold;
                end
                
                if ~isscalar(score)
                    score = algObj.ScoreThreshold(1);
                end
                
                src.String = num2str(score);
            end
            
            % Ok and cancel buttons
            btnText = vision.getMessage('vision:labeler:SettingsCancelButton');
            btnTextWidth = numel(btnText)+5;
            % OK
            okButtonPos = [25 0.6 btnTextWidth 2];
            hOkButton = uicontrol('Parent',buttonPanel,...
                'Units','characters',...
                'Position',okButtonPos,...
                'HandleVisibility','callback',...
                'String',vision.getMessage('vision:labeler:SettingsOKButton'),...
                'Callback',@okButtonCallback);
            
            function okButtonCallback(okBtn,~)
                % Set model name
                popup = findobj(ancestor(okBtn,'figure'),'Tag','modelName');
                idx = popup.Value;
                popupItems = popup.String;
                modelName = char(popupItems(idx,:));
                
                % Set confidence threshold
                threshEditBox = findobj(ancestor(okBtn,'figure'),'Tag','thresholdVal');
                overlapThresh = str2double(get(threshEditBox,'String'));
                                
                % Set score threshold
                scoreThreshEditBox = findobj(ancestor(okBtn,'figure'),'Tag','scoreThresholdVal');
                scoreThresh = str2double(get(scoreThreshEditBox,'String'));
                
                % Set vehicle width
                vehicleWidthEditBox = findobj(ancestor(okBtn,'figure'),'Tag','vehicleWidthVal');
                try
                    vehicleWidthStr = get(vehicleWidthEditBox,'String');
                    vehicleWidth = eval(vehicleWidthStr);
                    
                    validateattributes(vehicleWidth, {'single', 'double'}, ...
                        {'real', 'nonsparse', 'finite', 'vector', 'increasing', 'numel', 2}, mfilename);
                    
                catch ME
                    errordlg(ME.message,...
                        vision.getMessage('vision:labeler:InvalidVehicleWidthDlgTitle'),'modal')
                    return
                end
                
                % Set vehicle length
                vehicleLengthEditBox = findobj(ancestor(okBtn,'figure'),'Tag','vehicleLengthVal');
                try
                    vehicleLengthStr = get(vehicleLengthEditBox,'String');
                    vehicleLength = eval(vehicleLengthStr);
                    
                    if ~isempty(vehicleLength)
                        validateattributes(vehicleLength, {'single', 'double'}, ...
                            {'real', 'nonsparse', 'finite', 'vector', 'increasing', 'numel', 2}, mfilename);
                    end
                    
                catch ME
                    errordlg(ME.message,...
                        vision.getMessage('vision:labeler:InvalidVehicleLengthDlgTitle'),'modal')
                    return
                end                
                
                % Set calibration check box status
                calibCheckBox = findobj(ancestor(okBtn,'figure'),'Tag','checkBoxVal');
                configureDetector = (calibCheckBox.Value == 1);
                
                % Set sensor text
                sensorTextBox = findobj(ancestor(okBtn,'figure'),'Tag','sensorText');
                sensorStr = get(sensorTextBox,'String');
                
                % Save user settings to the object
                algObj.VehicleModelName = modelName;                
                algObj.OverlapThreshold = overlapThresh;
                algObj.ScoreThreshold = scoreThresh;
                algObj.VehicleWidth = vehicleWidth;
                algObj.VehicleLength = vehicleLength;
                algObj.ConfigureDetector = configureDetector;
                algObj.SensorObj = sensorObj;
                algObj.SensorStr = sensorStr;
                
                delete(gcf);
            end
            
            % Cancel
            cancelButtonPos = [55 0.6 btnTextWidth 2];
            uicontrol('Parent',buttonPanel,...
                'Units','characters',...
                'Position',cancelButtonPos,...
                'HandleVisibility','callback',...
                'String',vision.getMessage('vision:labeler:SettingsCancelButton'),...
                'Callback',@cancelButtonCallback);
            
            function cancelButtonCallback(~,~)
                delete(gcf);
            end
            
            % Enable/disable calibration based on stored value
            if configureDetector
                calibrationCheckBoxCallback();
            end
            
            % Wait for dialog to close before running to completion
            uiwait(parentObj);
        end
    end
end

function midPts = helperFindBottomMidpoint(bboxes)
% Find midpoint of bottom edge of the bounding box

xBL = bboxes(:,1);
yBL = bboxes(:,2);

xM = xBL + bboxes(:,3)/2;
yM = yBL + + bboxes(:,4)./2;
midPts = [xM yM];

end

