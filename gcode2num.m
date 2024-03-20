function num = gcode2num(gcode)

% convert GCODE term to a numerical value.
% Ex:
%   input = X7.00
%   output = 7.00 

gcode = convertStringsToChars (gcode);
num = str2double(gcode(2:end));
  
end

