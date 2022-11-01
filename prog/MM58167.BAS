REM MM58167
REM github.com/jensma-de/MM58167-ISA-RTC

ERR = 0
VERBOSE = 0
FORCE = 0
A = 0
rtcd = 0
P = 0



REM get address from arguments
rtcinput$ = UCASE$(MID$(COMMAND$, 1, 3))

FOR i = LEN(rtcinput$) TO 1 STEP -1
        A$ = MID$(rtcinput$, i, 1)
        IF A$ = "A" THEN A$ = "10"
        IF A$ = "B" THEN A$ = "11"
        IF A$ = "C" THEN A$ = "12"
        IF A$ = "D" THEN A$ = "13"
        IF A$ = "E" THEN A$ = "14"
        IF A$ = "F" THEN A$ = "15"
        A = VAL(A$) * 16 ^ P
        rtcd = rtcd + A
        P = P + 1
NEXT i


REM set or get
IF INSTR(UCASE$(COMMAND$), "GET") THEN mode$ = "GET"
IF INSTR(UCASE$(COMMAND$), "SET") THEN mode$ = "SET"
IF INSTR(UCASE$(COMMAND$), "VERBOSE") THEN VERBOSE = 1
IF INSTR(UCASE$(COMMAND$), "FORCE") THEN FORCE = 1

IF mode$ = "" THEN ERR = 1


IF ERR = 1 THEN GOTO usage




REM check if RTC is at given address

IF FORCE = 0 THEN
 checkstart% = VAL(HEX$(INP(rtcd + 1)))

 start# = TIMER
 DO
 LOOP UNTIL (TIMER - start#) >= .1

 checkend% = VAL(HEX$(INP(rtcd + 1)))

 IF checkend% < checkstart% THEN checkend% = checkend% + 100

 result% = checkend% - checkstart%

 IF result% = 0 OR result% > 50 THEN
        PRINT "No clock found at "; rtcinput$; "h"
        PRINT "To force this address, use FORCE argument"
        END
 END IF

END IF


IF mode$ = "GET" THEN

        REM PRINT HEX$(INP(rtcd)); "thousands"
        REM PRINT HEX$(INP(rtcd + 1)); "hundreds"
        sekunde$ = HEX$(INP(rtcd + 2))
        minute$ = HEX$(INP(rtcd + 3))
        stunde$ = HEX$(INP(rtcd + 4))
        REM PRINT HEX$(INP(rtcd + 5)); "day of week"
        tag$ = HEX$(INP(rtcd + 6))
        monat$ = HEX$(INP(rtcd + 7))
        jahr$ = HEX$(INP(rtcd + 9))

        IF LEN(tag$) = 1 THEN tag$ = "0" + tag$
        IF LEN(monat$) = 1 THEN monat$ = "0" + monat$
        IF LEN(jahr$) = 1 THEN jahr$ = "0" + jahr$
        IF LEN(stunde$) = 1 THEN stunde$ = "0" + stunde$
        IF LEN(minute$) = 1 THEN minute$ = "0" + minute$
        IF LEN(sekunde$) = 1 THEN sekunde$ = "0" + sekunde$

        readdate$ = monat$ + "-" + tag$ + "-" + jahr$
        readtime$ = stunde$ + ":" + minute$ + ":" + sekunde$

        IF VERBOSE = 1 THEN
                PRINT "System date and time were set to "; readdate$; " "; readtime$
        END IF


        DATE$ = readdate$
        TIME$ = readtime$

        END

END IF

IF mode$ = "SET" THEN

        REM Set time
        readdate$ = DATE$
        readtime$ = TIME$

        month$ = MID$(readdate$, 1, 2)
        day$ = MID$(readdate$, 4, 2)
        year$ = RIGHT$(MID$(readdate$, 7, 4), 2)

        hours$ = MID$(readtime$, 1, 2)
        minutes$ = MID$(readtime$, 4, 2)
        seconds$ = MID$(readtime$, 7, 2)


        monthwrite% = VAL("&H" + month$)
        daywrite% = VAL("&H" + day$)
        yearwrite% = VAL("&H" + year$)

        secondswrite% = VAL("&H" + seconds$)
        minuteswrite% = VAL("&H" + minutes$)
        hourswrite% = VAL("&H" + hours$)

        OUT rtcd + 2, (secondswrite%)
        OUT rtcd + 3, (minuteswrite%)
        OUT rtcd + 4, (hourswrite%)

        OUT rtcd + 6, (daywrite%)
        OUT rtcd + 7, (monthwrite%)
        OUT rtcd + 9, (yearwrite%)


        IF VERBOSE = 1 THEN
                PRINT "RTC date and time were set to "; readdate$; " "; readtime$
        END IF


        END

END IF




usage:
        PRINT "Usage:"
        PRINT "------"
        PRINT ""
        PRINT "MM58167.EXE ADDRESSh SET|GET [VERBOSE] [FORCE]"
        PRINT ""
        PRINT "Adressh:   The address of the RTC, set by jumpers on the PCB, e.g. 240h"
        PRINT "SET|GET:   Sets the RTC to the system clock and vise versa."
        PRINT "[VERBOSE]: Outputs some information."
        PRINT "[FORCE]:   Skip detection of RTC."
        PRINT ""
        PRINT "Examples:"
        PRINT "To write the system time to the RTC, setup at 300h:"
        PRINT "MM58167.EXE 300h SET"
        PRINT ""
        PRINT "Set the RTC's time to the system's clock:"
        PRINT "MM58167.EXE 300h GET"
        PRINT ""
        PRINT "--------------------------------------------------------"
        PRINT "Credits to:"
        PRINT "github.com/mrehkopf/"
        PRINT ""
        PRINT "Project page:"
        PRINT "github.com/jensma-de/MM58167-ISA-RTC/"

