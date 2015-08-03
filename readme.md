# HandBrake Watch Folder

My goal with this project was to be able to drop video files into a watched folder and have HandBrakeCLI automatically encode them.

The process is pretty simple. I drop the file to encode into the watched folder. A cron task runs the shell script every 15 minutes. The shell script assess whether a HandBrake process is already running, and if not then checks for whether there are any files in the watched folder. If so, shell script begins encoding that file. When the encode is done, the shell script moves it to a separate folder. If there are still more files, the shell script will begin encoding again on the next run.

## Setup

I am using Ubuntu 14.04 with HandBrakeCLI

### Installing HandBrakeCLI 

It is not difficult, but the apt-get repository is not what you want. I've had better success with the stebbins PPA.
```
  $ sudo add-apt-repository ppa:stebbins/handbrake-releases
  $ sudo apt-get update
  $ sudo apt-get install handbrake-cli
```

### The cron command

You will need to know where five directories are:

1. this repository

2. -i the watched folder, where the input files will be

3. -o the output folder, where you want the encoded files to end up, should be different than the watched folder

4. -m where you want the original files to be moved after the encode is complete. Again, it should be different than the watched folder

5. -l where you want the HandBrake log file stored. You will probably want two separate log files. One for HandBrake (the -l flag) and then another for the script, the file specified at the end of the cron command.

Example, cron would run this every 15 minutes
```
0,15,30,45 * * * * /bin/bash /path/to/repo/encode.sh -i /path/to/watched/folder -o /path/to/output/folder -m /path/to/move/originals -l /path/to/log/directory/ >> /path/to/script.log 2>&1
```

You can add this with ``` $ crontab -e ```

### Encode Setting

You could certainly edit the HandBrakeCLI command in encode.sh, but this the included default (which I use for almost everything)

Container: mp4  
Video codec: x264, VBR, RF20  
Audio codec: AAC, with DLII mixdown  
x264 settings:  
  Preset: Slow  
  Tune: Film  
  Profile: High  
  Level: 4.1  

This is my first foray into Shell scripting. Feel free to share any comments! 
