%% ------ Add style to figure ----- %%
clear legend
warning('off') % disabled warning messages from importing .fig created by simulink scope
%% -- Data -- %%
% Change this array to the values you want to plot ie. voltage to plot
% out.voltage
% Input should be a timeseries from simulink with Data and Time values. 
input_data = [out.I_A, out.I_rog]; 

%% -- Settings -- %%
% Set index of store_at such that:
% store_at = 'current folder': store in current folder (same folder as this script)
% store_at = 'above folder': store in one folder above current folder
% store_at = 'prefix folder': store in new folder under folder where this script is
store_at = 'above folder';
% File settings
filename = 'rog_vs_ideal'; % filename of output in output_type format
output_type = '.png';

% Formatting
figure_title = 'Rogowski Coil And Ideal Measurements during Three Phase Fault'; % String for title
x_label = 'Time [t]';
y_label = 'Current [A]';
label_font_size = 18; % text size for labels, ticks, legend
title_font_size = 24; % text size for title above plot
line_width = 1; % thichkness of lines in plot
% Situational
prefix = 'images/'; % The folder where the figure is stored if store_at=3

%% -- Initial setup -- %
if strcmp(store_at, 'current folder')
    prefix = '';
elseif strcmp(store_at, 'above folder')
    directory = cd;
    folders = strfind(directory,'/');
    prefix = append(directory(1:folders(end)-1), '/');
elseif ~strcmp(store_at, 'prefix folder')
    disp('store_at setting is not correct')
end

output_file = append(prefix, filename, output_type);

% Open filename
disp(append('Styling figure: ', input_file))
fig = gcf;
hold on
for i = 1:length(input_data)
    plot(input_data(i).Time, input_data(i).Data, 'DisplayName', input_data(i).Name)
end

% for importing figure
% input_type = '.fig';
% input_file = append(prefix, filename, input_type);
% fig = openfig(input_file, 'invisible');
axes = gca;

%% Set basic data
fig.Name = filename; % name of window 
axes.XLim = [0, input_data(1).Time(end)]
%% -- Set labels -- %%
xlabel(x_label);
ylabel(y_label);

%% -- Set plot colors -- %%
%fig.Children.Children.Children.BackgroundColor = 'white'; % Color for area outside plot
%fig.Children.BackgroundColor = 'white'; % Color for shadow of plot window
axes.Color = 'white'; % Color for plot area
fig.Color = 'white'; % Color for rest of figure (outside plot area)
grid on % add grid lines to plot
axes.GridColor = [0.15, 0.15, 0.15]; % Paint grid gray

%% -- Set grid properties -- %%
axes.XColor = 'black';
axes.YColor = 'black';
axes.FontSize = label_font_size;

%% -- Set title -- %%
axes.Title.FontSize = title_font_size;
if length(figure_title) >= 40
    spaces = strfind(figure_title, ' ');
    index = spaces(ceil(length(spaces)/1.9));
    first_sub = extractBefore(figure_title, index);
    second_sub = extractAfter(figure_title, index);
    axes.Title.String = append(first_sub, newline, second_sub);
else
    axes.Title.String = figure_title;
end
axes.Title.Color = 'black';

%% -- Set legends -- %%
for i = 1:length(input_data)
    legendCell{i} = input_data(i).Name;
end
legend(legendCell)
axes.Legend.FontSize = label_font_size;
axes.Legend.Color = 'white';
axes.Legend.TextColor = 'black';
axes.Legend.EdgeColor = 'black';
axes.Legend.Location = 'northeast';

%% -- Line properties -- %%
lines = findobj(fig, 'Type', 'Line')
for i = i:length(lines)
    lines(i).LineWidth = line_width;
    lines(i).LineStyle = ':'
end

%% -- Finalizing -- %%
disp('Styling finished sucessfully!')
fig.Visible = 'On'; % show changed figure
set(fig, 'PaperPositionMode', 'auto') % Supress resizing
set(fig, 'InvertHardCopy', 'off'); % setting 'grid color reset' off
saveas(fig, output_file) % save to file
disp(append('Figure saved as: ', cd, output_file))
