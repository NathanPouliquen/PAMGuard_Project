path_directory='/Users/nathanpouliquen/Desktop/Intern/Project/PAMBinary/20220524'; 
original_files=dir([path_directory '/Click_Detector_Click_Detector_Clicks*.pgdf']);

stream=length(original_files);
lstfiles=(1:stream);

count_SD_overall=0;count_SD_high_conf=0;count_SD_med_conf=0;count_SD_low_conf=0;
count_SW_overall=0;count_SW_high_conf=0;count_SW_med_conf=0;count_SW_low_conf=0;
count_BOTH=0;

no_detection=0;
no_classification=0;

lstratio=[];

lstSWl1=[];lstSWl2=[];lstSWl3=[];lstSWl4=[];
lstSDl1=[];lstSDl2=[];lstSDl3=[];

for k=1:stream
    filename=[path_directory '/' original_files(k).name];
    pgdata=loadPamguardBinaryFile(filename);
    
    unclassified=0;
    SD_score_ratio=0;
    SW_score_ratio=0;
    SD_strong_label=0;
    SW_strong_label=0;

    SWl1=0;SWl2=0;SWl3=0;SWl4=0;SDl1=0;SDl2=0;SDl3=0;

    for l=1:length(pgdata)
        labels=pgdata(l).type;
        switch labels
            case 0
                unclassified=unclassified+1; 
            case 1
                SW_score_ratio=SW_score_ratio+25;
                %SWl1=SWl1+1;
            case 2
                SW_score_ratio=SW_score_ratio+50;
                SW_strong_label=SD_strong_label+1;
                %SWl2=SWl2+1;
            case 3
                SW_score_ratio=SW_score_ratio+50;
                %SWl3=SWl3+1;
            case 4
                SW_score_ratio=SW_score_ratio+25;
                %SWl4=SWl4+1;               
            case 5
                SD_score_ratio=SD_score_ratio+100;
                %SDl1=SDl1+1;
            case 6
                SD_score_ratio=SD_score_ratio+100;
                SD_strong_label=SD_strong_label+1;
                %SDl2=SDl2+1;
            case 7
                SD_score_ratio=SD_score_ratio+100;
                %SDl3=SDl3+1;
        end
    end

    ratio=(SW_score_ratio-SD_score_ratio);
    lstratio=[lstratio;ratio];
    %lstSWl1=[lstSWl1;SWl1];
    %lstSWl2=[lstSWl2;SWl2];
    %lstSWl3=[lstSWl3;SWl3];
    %lstSWl4=[lstSWl4;SWl4];
    %lstSDl1=[lstSDl1;SDl1];
    %lstSDl2=[lstSDl2;SWl2];
    %lstSDl3=[lstSDl3;SWl3];

    if isempty(pgdata)
        k;
        result='No Detection';
        no_detection=no_detection+1;
        
    elseif length(pgdata)==unclassified
        k;
        result='No Classification';
        no_classification=no_classification+1;

    elseif length(pgdata) > 10

        if SD_strong_label > 5 && SW_strong_label > 5
            count_BOTH=count_BOTH+1;

        elseif SD_strong_label > 5 && SW_strong_label <= 5
            count_SD_high_conf=count_SD_high_conf+1;

        elseif SW_strong_label > 5 && SD_strong_label <= 5 
            count_SW_high_conf=count_SW_high_conf+1;

        elseif ratio > 51
            count_SW_med_conf=count_SW_med_conf+1;

        elseif ratio < 51
            count_SD_med_conf=count_SD_med_conf+1;  

        else
            count_BOTH=count_BOTH+1;

        end

    else
        
        if SD_strong_label >= 5 && SW_strong_label >= 5
            count_BOTH=count_BOTH+1;

        elseif SD_strong_label > 5 && SW_strong_label <= 5
            count_SD_med_conf=count_SD_med_conf+1;

        elseif SW_strong_label > 5 && SD_strong_label <= 5 
            count_SW_med_conf=count_SW_med_conf+1;

        elseif ratio > 51
            count_SW_low_conf=count_SW_low_conf+1;

        elseif ratio < 51
            count_SD_low_conf=count_SD_low_conf+1;  

        else
            count_BOTH=count_BOTH+1;

        end   
    end

    if k==347
        disp('Score Stripped Dolphin files')
        SD_count_SD_overall=count_SD_high_conf+count_SD_med_conf+count_SD_low_conf
        count_SD_high_conf
        count_SD_med_conf
        count_SD_low_conf
        SD_count_SW_overall=count_SW_high_conf+count_SW_med_conf+count_SW_low_conf
        count_SW_high_conf
        count_SW_med_conf
        count_SW_low_conf
        SD_count_BOTH=count_BOTH
        SD_no_detection=no_detection
        SD_no_classification=no_classification

        count_SD_overall=0;count_SD_high_conf=0;count_SD_med_conf=0;count_SD_low_conf=0;
        count_SW_overall=0;count_SW_high_conf=0;count_SW_med_conf=0;count_SW_low_conf=0;
        count_BOTH=0;no_detection=0;no_classification=0;
    end 
end


disp('Score Stripped Dolphin files')
SW_count_SD_overall=count_SD_high_conf+count_SD_med_conf+count_SD_low_conf
count_SD_high_conf
count_SD_med_conf
count_SD_low_conf
SW_count_SW_overall=count_SW_high_conf+count_SW_med_conf+count_SW_low_conf
count_SW_high_conf
count_SW_med_conf
count_SW_low_conf
SW_count_BOTH=count_BOTH
SW_no_detection=no_detection
SW_no_classification=no_classification


disp('Score Overall')
Total_countSD=SD_count_SD_overall+SW_count_SD_overall
Total_countSW=SW_count_SW_overall+SD_count_SW_overall
Total_count_BOTH=SD_count_BOTH+SW_count_BOTH
Total_no_detection=SD_no_detection+SW_no_detection
Total_no_classification=SD_no_classification+SW_no_classification


disp('Stats')
disp('Classification')
True_Positive=(SD_count_SD_overall+SW_count_SW_overall)/(SD_count_SD_overall+SD_count_SW_overall+SW_count_SW_overall+SW_count_SD_overall)*100
False_Positive=(SD_count_SW_overall+SW_count_SD_overall)/(SD_count_SD_overall+SD_count_SW_overall+SW_count_SW_overall+SW_count_SD_overall)*100

disp('Detection AND Classification')
True_Positive_ALL=(SD_count_SD_overall+SW_count_SW_overall)/(SD_count_SD_overall+SD_count_SW_overall+SW_count_SW_overall+SW_count_SD_overall+Total_count_BOTH+Total_no_detection+Total_no_classification)*100
False_Positive_ALL=(SD_count_SW_overall+SW_count_SD_overall)/(SD_count_SD_overall+SD_count_SW_overall+SW_count_SW_overall+SW_count_SD_overall+Total_count_BOTH+Total_no_detection+Total_no_classification)*100

%plot(lstfiles,lstSWl1,Color='blue')
%hold on
%plot(lstfiles,lstSWl2,Color='green')
%hold on
%plot(lstfiles,lstSWl3,Color='red')
%hold on
%plot(lstfiles,lstSWl4,Color='cyan')
%hold on
%plot(lstfiles,lstSDl1,Color='#EDB120')
%hold on
%plot(lstfiles,lstSDl2,Color='#FF00FF')
%hold on
%plot(lstfiles,lstSDl3,Color='magenta')