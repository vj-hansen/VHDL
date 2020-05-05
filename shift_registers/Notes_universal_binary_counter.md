## Universal binary counter

Consider an 8-bit universal binary counter supporting an asynchronous reset input plus four synchronous inputs to clear the outputs, to enable the operation of the counter, to load an 8-bit initial count value (c_in(7:0)), and to define the counting direction (up / down).


#### 1. Use the template below to create a function table describing the operation of this circuit.

clk    | reset |clear  | enable | load   | direction | c_in(7:0)       | c_out(7:0)
------ |------ |------ | ------ | ------ | ------    | --------------- | ------ 
x      |**1**  |x      | x      | x      | x         | x               | Clear to 0
↑      |0      |**1**  | x      | x      | x         | x               | Clear to 0
↑      |0      |0      |**1**   | x      |**1**      | x               | Count up
↑      |0      |0      |**1**   | x      | 0         | x               | Count down
↑      |0      |0      |**1**   |**1**   |**1**      | load input      | Count up c_in



↑ = rising edge, x = don't care


clk    | reset |ctrl   | c_in(7:0) | c_out(7:0)
------ |------ |------ | ------    | --------
x      |1      |x      |x          |Clear to 0
↑      |0      |000    |x          |0
↑      |0      |001    |x          |Count up
↑      |0      |010    |x          |Count down
↑      |0      |011    |load input |c_in ± 1
↑      |0      |1--    |x          |Clear to 0
