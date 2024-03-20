clear; clc

raw = importfile('/Users/terekli/Desktop/calculate flow rate/test.gcode');

%% setup

% volume (uL) per E step movement, modify this number based on you hardware
VperE = 10;

% declare
Q = nan(size(raw,1),1); % flow rate (mm^3/s)
% F = nan(size(raw,1),1); % gantry travel speed (mm/s)
% E = nan(size(raw,1),1); % extrusion axis
% X = nan(size(raw,1),1); % X coordinate
% Y = nan(size(raw,1),1); % Y coordinate

% initial information (F, X, Y etc) has not been acquired;
initial_condition = 0; 

%% loop through each line of GCODE

iX = 1;
iY = 1;
iE = 1;
iF = 1;

for iline = 1:size(raw,1)
    
    X_exist = 0; % reset
    Y_exist = 0; % reset
    
    % this is the current line
    current_line = raw(iline,:);
    
    % next line if current line starts with ;
    % corresponds to comment line
    if sum(contains(current_line, ';'))
        continue
    end
    
    % if X value exist 
    temp = gcode2num(current_line(contains(current_line,'X')));
    if ~isempty(temp) 
        X(iX) = temp;
        iX = iX + 1;
        X_exist = 1;
    end
    
     % if Y value exist 
    temp = gcode2num(current_line(contains(current_line,'Y')));
    if ~isempty(temp)
        Y(iY) = temp;
        iY = iY + 1;
        Y_exist = 1;
    end
    
    % if F value exist
    temp = gcode2num(current_line(contains(current_line,'F')));
    if ~isempty(temp)
        F(iF) = temp;
        iF = iF + 1;
    end
    
    % if E value exist
    temp = gcode2num(current_line(contains(current_line,'E')));
    if ~isempty(temp)
        E(iE) = temp;
        iE = iE + 1;
    end
    
    % continue onto next line if not G1 (extrusion)
    if isempty(current_line(contains(current_line,'G1')))
        continue
    end
    
    % continue onto next line if no X or Y value (most likely retraction?)
    if X_exist == 0 && Y_exist == 0
        continue
    end
    
    % determine if any material is extruded in the current line   
    if isempty(temp) % if E command is not used
        continue; % nothing extruded, jump to next line
    else % if E command is used
        if temp == 0
            continue % if E0 is written then jump to next line
        end
    end
    % continue if is retraction
    if E(end) <= E(end-1)
        continue
    end
    
    
    %% calculate
    
    % calculate distance travelled (mm)
    d = ((X(end) - X(end-1))^2 + (Y(end) - Y(end-1))^2)^0.5;
    
    % calculate time traveled (s)
    t = d/(F(end)/60); % convert F from mm/min to mm/s 
    
    % volume of ink extruded
    V = (E(end) - E(end-1))*VperE; % uL

    % volumetric flow rate (uL/min)
    Q(iline-1) = V/t*60;
    
end % loop through each line of GCODE

% remove nan terms of Q
Q = Q(~isnan(Q));

% remove retraction
Q = Q(Q>0);

%% plot

markerSize = 4;
markerShape = '-o';
dashLine = '-.';
lineWidth = 2;
fontSize = 15;

plot(1:1:length(Q), Q, 's', 'LineWidth', lineWidth, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', markerSize)

set(gca,'FontName', 'Helvetica', 'fontweight','bold','fontsize',fontSize);
set(gca,'linewidth',2)
set(gca,'TickDir','out')
xlabel('Printing Steps')
ylabel('Volumetric Flow Rate (μL/min)')