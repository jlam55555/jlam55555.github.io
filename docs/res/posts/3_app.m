classdef line_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
	UIFigure      matlab.ui.Figure
	GridLayout    matlab.ui.container.GridLayout
	LeftPanel     matlab.ui.container.Panel
	bSlider       matlab.ui.control.Slider
	bSliderLabel  matlab.ui.control.Label
	mSlider       matlab.ui.control.Slider
	mSliderLabel  matlab.ui.control.Label
	RightPanel    matlab.ui.container.Panel
	UIAxes        matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
	onePanelWidth = 576;
    end


    properties (Access = private)
	m = 0;  % slope
	b = 0;  % y-intercept
    end

    methods (Access = private)

	function results = plotLine(app)
	    x = -10:10;
	    y = app.m*x + app.b;

	    plot(app.UIAxes, x, y);
	end
    end


    % Callbacks that handle component events
    methods (Access = private)

	% Code that executes after component creation
	function startupFcn(app)
	    app.plotLine();
	end

	% Value changing function: bSlider
	function bSliderValueChanging(app, event)
	    changingValue = event.Value;
	    app.b = changingValue;

	    app.plotLine();
	end

	% Value changing function: mSlider
	function mSliderValueChanging(app, event)
	    changingValue = event.Value;
	    app.m = changingValue;

	    app.plotLine();
	end

	% Changes arrangement of the app based on UIFigure width
	function updateAppLayout(app, event)
	    currentFigureWidth = app.UIFigure.Position(3);
	    if(currentFigureWidth <= app.onePanelWidth)
		% Change to a 2x1 grid
		app.GridLayout.RowHeight = {480, 480};
		app.GridLayout.ColumnWidth = {'1x'};
		app.RightPanel.Layout.Row = 2;
		app.RightPanel.Layout.Column = 1;
	    else
		% Change to a 1x2 grid
		app.GridLayout.RowHeight = {'1x'};
		app.GridLayout.ColumnWidth = {221, '1x'};
		app.RightPanel.Layout.Row = 1;
		app.RightPanel.Layout.Column = 2;
	    end
	end
    end

    % Component initialization
    methods (Access = private)

	% Create UIFigure and components
	function createComponents(app)

	    % Create UIFigure and hide until all components are created
	    app.UIFigure = uifigure('Visible', 'off');
	    app.UIFigure.AutoResizeChildren = 'off';
	    app.UIFigure.Position = [100 100 640 480];
	    app.UIFigure.Name = 'MATLAB App';
	    app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

	    % Create GridLayout
	    app.GridLayout = uigridlayout(app.UIFigure);
	    app.GridLayout.ColumnWidth = {221, '1x'};
	    app.GridLayout.RowHeight = {'1x'};
	    app.GridLayout.ColumnSpacing = 0;
	    app.GridLayout.RowSpacing = 0;
	    app.GridLayout.Padding = [0 0 0 0];
	    app.GridLayout.Scrollable = 'on';

	    % Create LeftPanel
	    app.LeftPanel = uipanel(app.GridLayout);
	    app.LeftPanel.Layout.Row = 1;
	    app.LeftPanel.Layout.Column = 1;

	    % Create mSliderLabel
	    app.mSliderLabel = uilabel(app.LeftPanel);
	    app.mSliderLabel.HorizontalAlignment = 'right';
	    app.mSliderLabel.Position = [11 457 25 22];
	    app.mSliderLabel.Text = 'm';

	    % Create mSlider
	    app.mSlider = uislider(app.LeftPanel);
	    app.mSlider.Limits = [-10 10];
	    app.mSlider.ValueChangingFcn = createCallbackFcn(app, @mSliderValueChanging, true);
	    app.mSlider.Position = [57 466 150 3];

	    % Create bSliderLabel
	    app.bSliderLabel = uilabel(app.LeftPanel);
	    app.bSliderLabel.HorizontalAlignment = 'right';
	    app.bSliderLabel.Position = [12 415 25 22];
	    app.bSliderLabel.Text = 'b';

	    % Create bSlider
	    app.bSlider = uislider(app.LeftPanel);
	    app.bSlider.Limits = [-10 10];
	    app.bSlider.ValueChangingFcn = createCallbackFcn(app, @bSliderValueChanging, true);
	    app.bSlider.Position = [58 424 150 3];

	    % Create RightPanel
	    app.RightPanel = uipanel(app.GridLayout);
	    app.RightPanel.Layout.Row = 1;
	    app.RightPanel.Layout.Column = 2;

	    % Create UIAxes
	    app.UIAxes = uiaxes(app.RightPanel);
	    title(app.UIAxes, 'y=mx+b')
	    xlabel(app.UIAxes, 'X')
	    ylabel(app.UIAxes, 'Y')
	    zlabel(app.UIAxes, 'Z')
	    app.UIAxes.XLim = [-10 10];
	    app.UIAxes.YLim = [-10 10];
	    app.UIAxes.XGrid = 'on';
	    app.UIAxes.YGrid = 'on';
	    app.UIAxes.Position = [3 4 413 473];

	    % Show the figure after all components are created
	    app.UIFigure.Visible = 'on';
	end
    end

    % App creation and deletion
    methods (Access = public)

	% Construct app
	function app = line_exported

	    % Create UIFigure and components
	    createComponents(app)

	    % Register the app with App Designer
	    registerApp(app, app.UIFigure)

	    % Execute the startup function
	    runStartupFcn(app, @startupFcn)

	    if nargout == 0
		clear app
	    end
	end

	% Code that executes before app deletion
	function delete(app)

	    % Delete UIFigure when app is deleted
	    delete(app.UIFigure)
	end
    end
end