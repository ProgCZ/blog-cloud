ts=`date +"%s"`; dt_y=`date +"%Y"`; dt_m=`date +"%m"`; dt_d=`date +"%d"`;
src_path=scaffolds/create.md; dst_folder=source/_posts/$dt_y/$dt_m; dst_path=$dst_folder/$dt_d-$ts.md;
mkdir -p $dst_folder; cp $src_path $dst_path;
