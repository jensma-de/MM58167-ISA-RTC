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

Configure the RTC with these programs:
   #(c) Copyright 1989-91   David Mutimer,   All rights reserved# - Great for


<table id="verticalalign">
    <caption>vertical-align</caption>
    <thead>
        <tr>
            <th>Name</th>
            <th>Copyright</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="left" valign="top"><a href="./prog/CLOCK.COM">CLOCK.COM</a></td>
            <td align="left" valign="top">1989-91   David Mutimer</td>
            <td align="left" valign="top">Very useful tool, usable with addresses 240h, 300h and 340h.</td>
        </tr>
        <tr>
            <td align="left" valign="top">GETCLOCK.COM & SETCLOCK.COM <br/><a href="./prog/hi/">HI</a> & <a href="./prog/low/">LOW</a></td>
            <td align="left" valign="top">DIAMOND FLOWER ELECTRONIC CO. (C)COPY RIGHT 1984, 1985, 1986</td>
            <td align="left" valign="top">GETCLOCK.COM:<br>Set system time to time from RTC.<br><br>SETCLOCK.COM:<br>Set RTC time to system time.<br><br><b>Available as HI (300h & 340h) and LOW (200h & 240h)</b></td>
        </tr>
    </tbody>
</table>


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

