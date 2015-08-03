#!/bin/bash

#TODO verify file type, check for mkv

while getopts i:o:m:l: option; do
  case $option in
    i) input_dir=$OPTARG;;
    o) output_dir=$OPTARG;;
    m) move_source_dir=$OPTARG;;
    l) log_dir=$OPTARG;;
  esac
done

eval processes=( $(ps aux | grep -i "HandbrakeCLI -i" | awk '{print $11}') )
files=$(ls "$input_dir")
file=$(ls  "$input_dir" | sort -n | head -1)
short_file="${file%.*}"
should_start_new_encode=true


file_check() {
  if [ "$files" != "" ] ;then
    echo "Found file, encoding $file"
    start_encode
    move_original
  else 
    echo "No File Found"
  fi
}

start_encode(){
  HandBrakeCLI -i "$input_dir"/"$file" -o "$output_dir"/"$short_file".mp4 -m -4 -E fdk_aac -B 320 -e x264 -q 20 -x level=4.1:ref=4:b-adapt=2:direct=auto:deblock=-1,-1:me=umh:subme=8:psy-rd=1.00,0.15:vbv-bufsize=78125:vbv-maxrate=62500:rc-lookahead=50  -s 1 --subtitle-forced --subtitle-burn --native-language eng >> "$log_dir"/handbrake.log 2>&1
}

process_check(){
  for i in $processes; do
    if [ $i == "HandBrakeCLI" ] ;then
      should_start_new_encode=false
      echo "HandbrakeCLI is already running"
    fi 
  done
}

move_original(){
  mv "$input_dir"/"$file" "$move_source_dir"/"$file"
}

echo `date +"%Y-%m-%d-%T"`
process_check
if [ $should_start_new_encode == "true" ] ; then
  file_check
fi
echo

