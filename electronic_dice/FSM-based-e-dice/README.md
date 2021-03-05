# FSM-based-e-dice

only need one file: ```fsm_edice.vhd```

We have four operating modes for this e-dice:
- No cheating ```M="00"```
- Predefined result ```M="10"```
- Forbidden result ```M="01"```
- 3x probability result ```M="11"```

The result selection tuple ```R(2:0)``` works in combination with the selected cheating mode (no effect if no cheating).

Push “run” to throw the e-dice, release it to stop.


M1  | M0  | R2  | R1  | R0  | Mode
----|-----|-----|-----|-----|----
0   |0    |x    |x    |x    | No cheating
0   |1    |0    |0    |0    | X - we decide
0   |1    |0    |0    |1    | Forbidden result: 1
... |...  |...  |...  |...  | ...
0   |1    |1    |1    |1    | X - we decide
1   |0    |0    |0    |0    | X
1   |0    |0    |0    |1    | Pre-defined result: 1
... |...  |...  |...  |...  | ...
1   |0    |1    |1    |1    | X - we decide
1   |1    |0    |0    |0    | X - we decide
1   |1    |0    |0    |1    | 3x probability for result: 1
... |...  |...  |...  |...  | ...
1   |1    |1    |1    |1    | X - we decide
