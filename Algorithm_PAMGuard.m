path_directory='C:\Users\underwater\Desktop\PAMBinary\20220524'; 
original_files=dir([path_directory '\Click_Detector_Click_Detector_Clicks*.pgdf']);

countSW=0;
countSD=0;

TIE=0;

NO_DETECTION=0;
UNCLASSIFIED=0;
NO_IDENTIFICATION=0;

lstratio=[];

for k=1:length(original_files)
    filename=[path_directory '\' original_files(k).name];
    pgdata=loadPamguardBinaryFile(filename);
    
    SD=0;
    SW=0;
    ratio=0;
    
    for l=1:length(pgdata)
        Labels=pgdata(l).type;
        switch Labels
            case 0
                UNCLASSIFIED=UNCLASSIFIED+1; 
            case 1
                SW=SW+25;
            case 2
                SW=SW+50;
            case 3
                SW=SW+50;
            case 4
                SD=SD+100;
            case 5
                SD=SD+100;
            case 6
                SW=SW+25;
            case 7
                SD=SD+100;
        end
    end
    
    if isempty(pgdata)
        k;
        result='No Detection';
        NO_DETECTION=NO_DETECTION+1;
        
    elseif length(pgdata)==UNCLASSIFIED
        k;
        result='No Identification';
        NO_IDENTIFICATION=NO_IDENTIFICATION+1;
        
    else    
        ratio=(SW-SD);
        lstratio=[lstratio;ratio];
    end
    
    if (ratio>51)
            k;
            result='Sperm Whale';
            countSW=countSW+1;
            
    elseif (ratio<51)
            k;
            result='Stripped Dolphin';
            countSD=countSD+1;
            
    elseif (ratio==51)
            k;
            result='Tie';
            TIE=TIE+1;
    end

    if k==347
        disp('Score Stripped Dolphin files')
        SD_countSW=countSW
        SD_countSD=countSD
        SD_TIE=TIE
        SD_NO_DETECTION=NO_DETECTION
        SD_NO_IDENTIFICATION=NO_IDENTIFICATION
        countSW=0,countSD=0,TIE=0,NO_DETECTION=0,NO_IDENTIFICATION=0;
    end 
end


disp('Score Sperm Whale files')
SW_countSW=countSW
SW_countSD=countSD
SW_TIE=TIE
SW_NO_DETECTION=NO_DETECTION
SW_NO_IDENTIFICATION=NO_IDENTIFICATION


disp('Score Overall')
Total_countSW=SD_countSW+SW_countSW
Total_countSD=SD_countSD+SW_countSD
Total_TIE=SD_TIE+SW_TIE
Total_NO_DETECTION=SD_NO_DETECTION+SW_NO_DETECTION
Total_NO_IDENTIFICATION=SD_NO_IDENTIFICATION+SW_NO_IDENTIFICATION


disp('Stats')
disp('Classification')
True_Positive=(SD_countSD+SW_countSW)/(SD_countSD+SD_countSW+SW_countSW+SW_countSD)*100
False_Positive=(SD_countSW+SW_countSD)/(SD_countSD+SD_countSW+SW_countSW+SW_countSD)*100

disp('Detection AND Classification')
True_Positive_ALL=(SD_countSD+SW_countSW)/(SD_countSD+SD_countSW+SW_countSW+SW_countSD+Total_TIE)*100
False_Positive_ALL=(SD_countSW+SW_countSD)/(SD_countSD+SD_countSW+SW_countSW+SW_countSD+Total_TIE)*100
