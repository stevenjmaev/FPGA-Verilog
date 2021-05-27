# Midterm 2  |  ECE 3300-02  |  April 19, 2021 
# Frequency Meter - Steven Jmaev


### Machine Architecture
The top level file is **frequency_meter.v**, and is comprised of the following modules:
* binary-to-bcd converter
* seven-segment display driver
* a module called `freq_memory`
* a module called `average_4vals`
Note that `freq_memory` and `average_4vals` are the newly created modules for this module. Descriptions of each of them (and their newly-created sub-modules) follow below.

###### Block Diagram:
![freq_meter_BlkDgm](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/frequency_meter_blockDiagram.svg)

---

#### freq_memory and its sub-modules

This module is comprised of 2 sub-modules:
* `freq_measurement`: a frequency measurement module which measures the frequency of the incoming waveform once every 500 ms
  * _This is the heart of the project._ A thorough discussion is given further below.
* `reg_file`: 4x36 memory module (4 registers of 36 bits each) which stores the measurements from the above module

The purpose of this module is simply to read the measured frequency from the module `freq_measurement` and store it in the file register, `reg_file` which is configured to have 4 registers each of which hold a 26-bit value (which is the same size of the measured frequency). Every time the `freq_measurement` outputs a _**done**_ signal, then the writing address, is incremented and the measurement is added. 

###### Block Diagram:
![freq_memory_BlkDgm](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/freq_memory_blockDiagram.svg)

Note that the `2-bit incrementing register (see code)` block is meant to represent the following code:
```verilog
reg [1:0] addr_w,
// increment the addr_w every time there is a new measurement
always @(posedge clk)
begin
    if (~reset_n)
        addr_w <= 2'b00;
    else if(writeEnable)
        addr_w <= addr_w + 1; 
end
```

##### freq_measurement:
This module is comprised of 4 sub-modules:
* `timer_parameter`: This counts 50,000,000 clock pulses and outputs a done signal. When the clock frequency equates to 100 MHz, this relates to a 500 ms timer.
* `edge_detector`: This monitors the incoming waveform (a squarewave) and outputs a single clock pulse whenever an edge is seen. In this frequency meter machine, we only look for the positive edges.
* `udl_counter`: This counts the number of positive edges that are seen on the incoming waveform, which is a squarewave. Its value is reset whenever reset_n is low, or when the FSM tells it to reset (done via the _**countReset**_ signal). 
* `freq_measurement_fsm`: This is the finite state machine (FSM) that controls the operation of this module. Its FSM diagram is shown below.

The purpose of this module is simply to read the frequency of a given waveform/squarewave and output its value along with a _**done**_ signal that tells when the value is ready for reading.

###### Block Diagram:
![freq_measurement_BlkDgm](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/freq_measurement_blockDiagram.svg)

###### FSM Diagram (freq_measurement_fsm):
![freq_measurement_FSM](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/freq_measurement_fsm.svg)

---
#### average_4vals and its sub-modules

This module envelopes 2 sub-modules:
* `accumulator`: This accumulates the values that is reads from the _**data_r**_ and it accesses using the _**addr_r**_ output. This output is incremented every clock pulse, so it constantly reads the next register in a 4x26 register file.
* `average_4_vals_fsm`: This is the FSM that controls when to reset the accumulator and when to update the output by dividing the accumulator's result and using a D Flip Flop.

The purpose of this module is simply to read four values from a 4x26 register file and output their average, updating every 5 clock cycles.

###### Block Diagram:
![average_4vals_BlkDgm](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/average_4vals_blockDiagram.svg)

Again, note that the `2-bit incrementing register (see code)` block is meant to represent the following code:
```verilog
output reg [1:0] addr_r,
// increment the addr_r every time there is a new measurement
always @(posedge clk)
begin
    if (~reset_n)
        addr_r <= 2'b00;
    else
        addr_r <= addr_r + 1; 
end
```

###### FSM Diagram (average_4vals_fsm):
![freq_measurement_FSM](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/average_4vals_fsm.svg)
***

###### Testbench Simulations:
######  freq_measurement_tb: 
In this simulation, we see that the frequency measurement is ready for reading when the done signal (magenta waveform) is asserted at 500 ms. Also, the input squarewave's period was set to **1300 ns** in this simulation, which relates to a frequency of **769,230.76 Hz**. The frequency measured in the simulation (orange waveform) is **769230 Hz**.
![freq_measurement](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/freq_measurement_tb_sim_period1300ns.png)

######  freq_memory_tb:
In this simulation, we can see that every 500 ms (the time scale is 1us:1ms), a the memory in reg_file is appended with a new frequency value.
![freq_memory](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/freq_memory_tb_sim_seeRegisterWrites.png)

######  frequency_meter_tb: 
In this simulation, we show that the averaging functionality of the `average_4vals` module works properly, as we can view the 4 values stored in memory and the average of them.
![frequency_meter](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/frequency_meter_tb_sim_averaging.png)

##### Video Demonstration:
Note that the machine uses a moving average to measure the frequency, so it takes a couple of seconds for the display to stabilize.
[![DemoVideo](https://github.com/aseddin-teaching/sp21-midterm-2-stevenjmaev/blob/main/Images/VidThumbnail.png)](https://youtu.be/0ByH15WfleE)
