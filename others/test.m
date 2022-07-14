delete whistle_files\*.wav
liste=dir('all_files/');
liste(1:2) = [];
calc=length(w_files);
for m=1:length(w_files)
    f=liste(w_files(1,m)).name;
    folder='all_files/';
    glue=strcat(folder,f);
    copyfile(glue,"whistle_files/")
end