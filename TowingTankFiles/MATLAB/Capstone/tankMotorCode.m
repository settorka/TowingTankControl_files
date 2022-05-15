%homing parameters
%should be able to change speeds
%t=linspace(0,10,N); %add N to generate that number of points

%effective tank length
Tank_width_2= 247.5; %cm
Tank_width_1 = 4.5;%cm
Tank_length=277;
Speed= 70; %in mm/min
t=Tank_width_1:0.25:Tank_width_2;
y= input('Enter function: ');
% allows the actuator to traverse 40cm, irrespective of the function
y = rescale(y,0,40); 

beyond=find(abs(y)<Tank_length);
new_y=y(beyond);
new_t=t(beyond);

plot(t,y)

title('Curve name: ');
%G90 G28 X0 Y0 homing parameters
fileID = fopen('new.gcode','w') ;%enter the name of the created file
fprintf(fileID,'%s\n','G21 G90 F90');%G21 for metric, G90 for absolute movement from datum,

%program
fprintf(fileID,'%s %c%.2f %c%.2f %s\n','G01','X',(Tank_width_2+Tank_width_1)/2,'Y',0, 'F10'); %Start program at this position, but slowly in a straight line
for i=1:length(beyond)
    fprintf(fileID,'%s %c%.2f %c%.2f\n','G01','X',new_t(i),'Y',new_y(i));
end
fprintf(fileID,'%s\n','G90 G28 F40');