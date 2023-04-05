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

## Task 3 - Initial analysis
We are now going to do some analysis. Typically we are interested in captured timing, power, and area information about a design. We call this PPA, short for Power Performance Area. 

First, we will check whether the design is passing timing. The script defines a clock frequency of 1GHz, which is not very aggressive for this 7nm technology. In order to check whether our design is really taking a 1GHz clock into consideration, we issue the command `report_clocks`. The result looks like this:

![image](https://user-images.githubusercontent.com/50336652/230015772-d1033f4f-05bb-49a8-bed1-1565beb72cd1.png)

> How to read this image: There is a single clock name clk. It's period is 1000ps (1ns), which means a frequency of 1GHz. There is a single clock domain and a total of 1806 registers (flip-flops) are connected to this clock. The duty cycle is 50/50, meaning that the clock is assumed to be a perfect square wave.

Next, let's have a look at timing. The command we will be using is `report_timing`. The result looks like this:

![image](https://user-images.githubusercontent.com/50336652/229806406-71bacc2d-e75a-4855-8486-6b49684f7de8.png)

> How to read this image: The critical path does not meet the timing constraint. There is a negative slack of 73ps, which means the timed path takes 1073ps to settle, but we only have 1000ps. We can also see where the path starts (core_e_reg_reg[10], clock pin) and where it ends (core_a_reg_reg[17], data pin) -- this is a reg-to-reg path. The report also tells us that the end-point flip-flop has a 24ps setup requirement, meaning that data has to be stable for 24ps for the flip-flop to be able to reliably capture it. This is why in the timing calculation this appears with a negative sign, because we "lose" 24ps for latching. We can also see that the datapath itself takes 1049ps. The individual contribution of each cell that is part of the path is shown as a table. We can also see that most cells are X2, meaning that they are upsized. There are also some outliers that are X12 and X16. All of these are indicators that the synthesis engine worked really hard on this path.

Next, let's have a look at area. There are two commands for that, `report_area` and `report_gates`. You can think of the area report as a summary whereas the gates report is more complete. The result looks like this:

![image](https://user-images.githubusercontent.com/50336652/230019635-294e761f-57f4-489e-9544-1349e1c53a2f.png)
> How to read this image: The design has a top-level module named sha256. The design contains 8740 standard cells which occupy 21323 um^2. This is a precise number, obtained by adding the area of each individual cell. Routing all of these cells will incur more area, which Genus estimates at 7926 um^2. This number is not precise since we do not have a layout at this point. The total area is the sum of the two areas. IMPORTANT: in academic papers, both cell area and total are used and it is not always clear which one is which. It is always good to be clear about what you are reporting.

![image](https://user-images.githubusercontent.com/50336652/230020777-76fd8bcd-1234-403d-a7ad-34ec8122d553.png)

> How to read this image: The design uses cells from different libraries. This is not really relevant in this case because the library designers decided to separate their libraries into different files. In practical terms, there is only one standard cell library being used and it is for regular Vth (RVT). Next, we see how the area is distributed among different cell types. Not surprisingly, flip-flops account for 51% of the area, which is really typical. Also remember that flip-flops are large cells, often the largest cell in a whole library.

Finally, let's have a look at power. The command we are going to use is `report_power`. The command output looks like this:


![image](https://user-images.githubusercontent.com/50336652/230052569-6c86afaa-f2db-4d10-8478-92a5d90489da.png)

> How to read this image: Power consumptions has 3 components: Leakage (or static), Internal, and Switching. Internal and switching are dynamic in nature, meaning that this is power consumed when the circuit is actively computing. In other words, the power consumption here depends on the inputs of the circuit. Internal power is the power consumed by the standard cells themselves. Switching power is related to capacitance charge/discharge of the wires that connect the cells together. Power consumption can come from many components of the circuit, including memories, flip-flops, latches, logic, black boxes, clock distribution, pads, and pm. Because we are not doing physical synthesis, we only have a few of those.

Most of the time we will be interested in checking area, timing, power, so go ahead and remove the comments at the end of script. This way we will always get the values reported any time we run it.

Did you get the same values for area and power? If so, let's move on! Timing should not match because I created an artificial scenario to show negative timing slack. Your design should have a positive or zero slack. Is it right?

## Task 4 - Input/output delay
Now that we have a reference script and we know how to report on the characteristics of a circuit, let's try some more advanced commands and options. The first thing we are going to do is revise our clock specification. We have, so far, defined a clock:
`create_clock -name "clk" -period 1000 [get_ports clk]`

This is hardly sufficient. It works well for paths that are reg-to-reg since they are bound by clock on the arrival and destinations ends. But it does not say anything about input to reg paths and output to reg paths. By default, the tool cannot assume anything about these paths. In the same Genus session, we can verify that there is an issue with our inputs with the aid of `report_timing`. In the terminal, use the following command:
`report_timing -from cs`

Did it work? It should not have worked because the tool cannot find a constrained path that starts at the "cs" input. It should have said "Some unconstrained paths have not been displayed". There is a workaround to force the tool to time this path by issuing the command `report_timing -from cs -unconstrained`. The outcome should look like this:

![image](https://user-images.githubusercontent.com/50336652/230076564-efa482d7-97a6-454e-b98f-17dd20fedf86.png)

You, the designer, have to tell the tool the behavior that you want. In most cases, when doing synthesis of a block that is part of a larger chip, all inputs are synchronous to the clock. That means that whatever other logic there is that is generating inputs for your block, it also works on the same clock domain. In order to achieve this behavior, we are going to use the `set_input_delay` command like this:

`set_input_delay -clock clk delay_value [all_inputs]`
> How to interpret this command: we are telling Genus that all inputs of our design have a relationship with a clock named "clk" and that this relationship has to be respected. This means that every input becomes available (stable) delay_value time units after the clock edge. This amount is discounted from our timing windown when doing timing analysis.

There is also an analogous command for the outputs of our block. The command looks like this:
`set_output_delay -clock clk delay_value [all_outputs]`
> How to interpret this command: we are telling Genus that all outputs of our design have a relationship with a clock named "clk" and that this relationship has to be respected. This means that every output must become available (stable) delay_value time units before the next clock edge. This amount is discounted from our timing windown when doing timing analysis.

Go ahead and apply these commands to your design in the same Genus session. We are gonna use a value of 300ps for input and output delays. This number is a guess because we do not know the environment in which our block will be operating. 

`set_input_delay -clock clk 300 [all_inputs]`

`set_output_delay -clock clk 300 [all_outputs]`

When we have our setup right, we can now report timing again and see what we get... Notice that this time we do not need the unconstrained option because the path is now properly constrained.

![image](https://user-images.githubusercontent.com/50336652/230077524-01f61c76-5139-446f-b81c-915f00f6c3c0.png)

Did you find the same violation in your design? There should be a violating path that starts from "cs" and ends in "read_data". We are going to fix this in the next task!

# Task 5 - Run synthesis again
In order to fix our timing, we have to apply the input and output delays from the start. We are going to close Genus, edit our reference script such that it includes the input and output delay constraints, and start Genus again with the same script.

You can check timing now, there should be no violating paths. Correct?

Now, what happened to our area/power? Because the design is now more constrained, the expectation is that we will have to consume more power and more area to make sure all paths meet timing. Go ahead and check if that is true with the commands `report_area` and `report_power`.

Did the area increase? By how much? How about power?

Go ahead and write down the power values you obtained. We will need those for comparison later. We also want to collect cell count and area values for comparisons.

# Task 6 - Synthesis effort
Genus supports multiple efforts level in its synthesis, mapping, and optimizing engines (syn_gen, syn_map, and syn_opt). The idea is that you can ask the tool to work harder on the problem and this will incur a penalty in execution time. Since we are doing a relatively small design, having high effort is a no brainer. So go ahead and set the following variables to high in your script:

`set_db syn_generic_effort	high`

`set_db syn_map_effort	high`

`set_db syn_opt_effort	high`

Now run your synthesis script again. You have to close Genus and start from scratch, these settings do not work well if applied after the design has already been synthesized. 

Did the area increase? By how much? How about power? How about timing? Write down your results and compare against those from Task 5.




