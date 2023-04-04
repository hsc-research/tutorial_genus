# synthesis_basics
A short and on point tutorial on how to use an ASIC logic synthesis tool

# Preliminaries
The tutorial is built around Cadence Genus version 21. Most of the commands are identical in previous versions too. The tutorial will use a single design (sha256) and many optimizations options will be explored to generate different results. The tutorial is organized in tasks.

# Tasks
## Task 1 - Starting the tool
Make sure you can start Genus. If your setup is right, typing genus on a terminal will start the tool. To exit the tool, type exit or press CTRL+C twice. If the installation is correct, you will see something like this on the screen:
![image](https://user-images.githubusercontent.com/50336652/229764141-250d55b3-77b4-4d17-893f-3603f2c91a6b.png)

## Task 2 -- Our first synthesis run
Let's run a reference script. When using genus, although the tool provides an interactive shell, you will almost always prefer to use scripts. 
Genus produces a lot of log files, these are stored in the folder where you invoke genus from. For this reason, it is very common to have a /run folder in your setup. To launch genus and invoke a script at the same time, the syntax is *genus -files script.tcl*. Since you will invoke Genus from the /run folder and the reference script is called genus.tcl, you will have to call *genus -files ../scripts/genus.tcl*

## Task 2
Let's make sure you have access to the 

