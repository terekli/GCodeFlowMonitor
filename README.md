# GCodeFlowMonitor
Calculates and graphs the volumetric flow rate for each printing step of a GCode file.

Helps to adjust the desired flow rate of your slicer profile.

## Background
3D printing via Direct-Ink-Writing requires precise control over the volumetric flow rate to ensure consistent filament geometry.

This script reads GCode file generated from any slicer software and computes line by line the volumetric flow rate.

The "flow" parameter in your slicing profile can then be adjusted to achieve the desired flow rate.

This can be implemented for infite-screw and piston based DIW printer.

For more information refer to this [review article](https://link.springer.com/article/10.1007/s40964-023-00424-9)

## Run the Code
In `calcQ.m` enter the path for your GCode.

Modify the value of `VperE` to the volume of extruded ink (μL) per unit of E step movement.

This value is dictated by your printer hardware configuraiton.

## Calculating `VperE`
For piston based printer:

> $VperE = \frac{1}{16}\pi ED^2$
> Where:
- $E$: E step movement
- $D$: diameter of your syringe (mm)
- $VperE$: extruded volume (µL)

For infinite-screw based printer please check your print nozzle manual on the extrusion volume per rotation, and correlate with your step rate configuration.

## Sample Output:
