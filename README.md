# Counter-based e-dice 
CCW1: A counter-based e-dice (due 13 Sep 2019)

The result selection tuple ```R(2:0)``` specifies which of the 6 possible results have triple probability, except:
* When the cheat input is ‘0’ (i.e. no cheating), in which case all results have equal probability.
* Tuples (000) and (111 = 7), in which case all results have equal probability.
Push “run” to throw the e-dice, release it to stop.

What we need:
* binary up counter to implement the e-dice. 

Since the state transition diagram is predefined and just moves through the 8 possible output combinations, what we can do is to decode the appropriate output patterns for the leds and the 7-segment digit, considering that state 0 will output result 1, state 1 result 2, and so on until state 5 outputs result

You also need the combinational decoding logic to drive the leds and the 7-segment digit. And you need of course the additional logic gates that will take the cheat input and the counter outputs, and drive the synchronous clear input of the counter.
