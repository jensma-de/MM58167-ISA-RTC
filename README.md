# MM58167-ISA-RTC
![header](./info/rtc.jpg)

## What is this?
A 8bit real time clock for old computers. Keeps the time when the computer is shut down. Fully covered address bus to prevent conflicts.


## Why is this?
Yes, there are many more modern RTC's out there. I made this just for fun and with parts that were readily available back in the 80s. I like to keep things period correct 😉


## How to use it?
First set the jumpers for the RTC. You can choose between 200h, 240h, 300h and 340h.

![jumpers](./info/jumpers.png)

Plug the card into a free ISA slot, either 8bit or 16bit.

[Download the program to control,](./prog/MM58167.EXE) the RTC, or download [the source, modify it to your liking and compile it with QuickBasic 7.1](./prog/MM58167.BAS)

```
Usage:
------

MM58167.EXE ADDRESSh SET|GET [VERBOSE] [FORCE] [NOEX]

Adressh:   The address of the RTC, set by jumpers on the PCB, e.g. 240h
SET|GET:   Sets the RTC to the system clock and vise versa.
[VERBOSE]: Outputs some information.
[FORCE]:   Force given address without checking for plausible RTC data.
[NOEX]:    Don't export the time to C:\MM581.RTC.
           The file is needed to update the year automatically.

Example:
To write the system time to the RTC, setup at 300h:
MM58167.EXE 300h SET

--------------------------------------------------------
Credits to:
github.com/mrehkopf/ & github.com/Sciurus68k/

Project page:
github.com/jensma-de/MM58167-ISA-RTC/
```


Only if you're having problems with the interrupt output: cut the trace between the two pads of the jumper in the top left corner of the pcb. Then close the center and the right pad.

## Is this Y2K-compatible?
Yes. Just make sure your OS can handle dates after 1999!

## I've heard the MM58167 is terribly old and can't even increment years by it's own
That's right. In order increment the year automatically the MM58167.EXE offloads some information to C:\MM581.RTC.
If you don't want this for some reason you can disable it with the NOEX argument.

Downside to all of this is that you have to start your computer at least once in two years. But seriously - if you boot up your PC that rarely you might want to remove the time keeping battery anyways :)


## BOM

![header](./info/bom.PNG)


**Note for the battery holder**: The holder I used is just labeled "Rainpro". No idea about the exact model. Should be a very CR2032 battery holder, though. Here's a picture of the listing:

![header](./info/battery.png)

Alternatively you can download and check out the interactive BOM:
[iBOM](./info/ibom.html)

## Pictures and schematics
[Schematics](./info/schematics.pdf)

[Photo of assembled RTC](./info/assembled.jpg)

## Credit
[@mrehkopf](https://github.com/mrehkopf)
[@Sciurus68k](https://github.com/Sciurus68k)
