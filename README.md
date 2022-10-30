# MM58167-ISA-RTC
![header](./info/rtc.jpg)

## What is this?
A 8bit real time clock for old computers. Keeps the time when the computer is shut down.

## Why is this?
Yes, there are many more modern RTC's out there. I made this just for fun and with parts that were readily available back in the 80s. I like to keep things period correct 😉

## How to use it?
First set the jumpers for the RTC. You can choose between 200h, 240h, 300h and 340h.
![jumpers](./info/jumpers.png)

*RTC configured at 340h*

Plug in the card, battery must face towards back of the PC. See silkscreen of the card, if unsure.

[[[[[hier programm zum ändern der clock einfüchen]]]]

Only if you're having problems with the interrupt output: cut the trace between the two pads of the jumper in the top left corner of the pcb. Then close the center and the right pad.

## Is this Y2K-compatible?
lol kA

## BOM
![header](./info/bom.PNG)
**Note for the battery holder**: The holder I used is just labeled "Rainpro". No idea about the exact model. Should be a very common part, though. Here's a picture of the listing:
![header](./info/battery.png)

Alternatively you can download and check out the interactive BOM:
[iBOM](./info/ibom.html)

## Pictures and schematics
[Schematics](./info/schematics.pdf)

[Photo of assembled RTC](./info/assembled.jpg)

