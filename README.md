# synthesis_basics
A short and on point tutorial on how to use an ASIC logic synthesis tool

# Preliminaries
The tutorial is built around Cadence Genus version 21. Most of the commands are identical in previous versions too. The tutorial will use a single design (sha256) and many optimizations options will be explored to generate different results. The standard cell library considered in this tutorial is from the ASAP7 PDK. No external downloads are necessary, all design files and library files are already included in this repository. The tutorial is organized in tasks that should be completed in order. Let's get started!

# Tasks
## Task 1 - Starting the tool
Make sure you can start Genus. If your setup is right, typing `genus` on a terminal will start the tool. To exit the tool, type exit or press `CTRL+C` twice. If the installation is correct, you will see something like this on the screen:
![image](https://user-images.githubusercontent.com/50336652/229764141-250d55b3-77b4-4d17-893f-3603f2c91a6b.png)

It is also important to make sure you have access to genus documentation. Inside the genus terminal, type `cdnshelp &. If your setup is properly installed, a new window will open with Cadence's help navigation system. It looks like this: 

![image](https://user-images.githubusercontent.com/50336652/229774697-710f598b-7d57-4f48-9c0d-6020b84b9d8e.png)

On the top of the image there is a search box. You can use it to find specific commands or terms. For instance, try searching for the word "clock". It will give you thousands of hits. You can search for the command "report_clocks" and then the search results will be much narrower.

Can you find the report_clocks documentation page?


## Task 2 - Our first synthesis run
Let's run a reference synthesis script. When using Genus, although the tool provides an interactive shell, you will almost always prefer to use scripts. 
Genus produces a lot of log files, by default these are stored in the folder where you invoke Genus from. For this reason, it is very common to have a /run folder in your setup. To launch genus and invoke a script at the same time, the syntax is `genus -files myfile.tcl`. Since you will invoke Genus from the /run folder and the reference script is called genus.tcl, you will have to call `genus -files ../scripts/genus.tcl`.

This is what the folder structure looks like:

![image](https://user-images.githubusercontent.com/50336652/229774072-f75e9bed-9db7-40cb-95dd-443b0389aa7f.png)

Did the script start executing? The tool will take about 4 minutes to complete the synthesis run. Do not close the tool just yet, we will collect some results from it in the next task.

## Task 3
We are now going to do some analysis. First, we will check whether the design is passing timing. The script defines a clock frequency of 1GHz, which is not very aggressive for this 7nm technology. In order to check timing, we issue the command `report_timing`. 

![image](https://user-images.githubusercontent.com/50336652/229806406-71bacc2d-e75a-4855-8486-6b49684f7de8.png)


Most of the time we will be interested in checking area, timing, power, so go ahead and remove the comments at the end of script. This way we will always get the values reported any time we run it.

