%intialization

%%% 
% dialog box for user input
prompt = {'Enter waveform desired [eg. (3*t.^2)./(cos(t)), t*sin(t.^2)]:',
    'Enter numeric value of motor speed (mm/min):'};
dlgtitle = 'Experiment variables';
dims = [1 50];
definput = {'3*t.^2','70'}; % default values
answer = inputdlg(prompt,dlgtitle,dims,definput)
y = str2sym(char(answer(1)));
Speed = str2double(answer(2));

% %% Desired waveform
% y = input('Enter waveform desired(eg. 3*t.^2, sin(x)): ');
% %% Carriage speed control
% Speed = input('Enter numeric value of motor speed (mm/min): '); will affect Arduino code

%%
StartExp(y,Speed)

function StartExp(y,Speed)
    %t=linspace(0,10,N);
    %add N to generate that number of points
    Tank_width_2=100; %cm
    Tank_width_1=10;%cm
    Tank_length=277;
    %Speed= 70; %in mm/min
    t=Tank_width_1:0.2:Tank_width_2;
    %y= (sin(t.^2-t.^3)).^4;
    
    beyond=find(abs(y)<Tank_length);
    new_y=y(beyond);
    new_t=t(beyond);

    plot(t,y,'r.')
    title({date})
    
    %GCODE conversion
    %G90 G28 X0 Y0 homing parameters
    fileID = fopen('tank_waveform.gcode','w') ;%enter the name of the created file
    fprintf(fileID,'%s\n','G21 G90 F90');%G21 for metric, G90 for absolute movement from datum,
    
    %program
    fprintf(fileID,'%s %c%.2f %c%.2f %s\n','G01','X',(Tank_width_2+Tank_width_1)/2,'Y',0, 'F10'); %Start program at this position, but slowly in a straight line
    for i=1:length(beyond)
        fprintf(fileID,'%s %c%.2f %c%.2f\n','G01','X',new_t(i),'Y',new_y(i));
    end
    fprintf(fileID,'%s\n','G90 G28 F40');
% 
%     %Spreadsheet conversion
%     waveTable = [new_t(i);new_y(i)];
%     excelData = array2table(waveTable,"Trajectory",{'X','Y'});
%     filename = 'trajectoryData.csv';
%     writetable(excelData,filename,'Sheet',date)
end
