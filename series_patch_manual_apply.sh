#!/bin/bash
repo="/local/vbolla/fresh/dpm_ubuntu/emulate_bsp"
patches_cnt=13
exec_dir=$PWD

rm -rf filenames subjects

cd $repo
git format-patch HEAD~$patches_cnt
patches_path=$PWD

for i in `ls 00*.patch`; do head -n 4 $i | tail -n 1 | awk '{for(i=4;i<=NF;++i)printf $i""FS}' >> subjects; echo "" >> subjects ; done

ls -l 00*.patch | awk '{print $9}' >> filenames

cd $exec_dir
for ((i=1; i<=patches_cnt; i++)); do
	sub=$(sed "${i}q;d" $patches_path/subjects)
	file=$(sed "${i}q;d" $patches_path/filenames)
	echo "$file :: $sub"

	patch -p1 < $patches_path/$file
	git add .
	git commit -s -m "$sub"
	sleep .2
	
done
