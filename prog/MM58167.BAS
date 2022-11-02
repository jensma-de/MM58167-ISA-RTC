REM MM58167
REM github.com/jensma-de/MM58167-ISA-RTC

ERR = 0
VERBOSE = 0
FORCE = 0
EXPOR = 1

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


REM process arguments
IF INSTR(UCASE$(COMMAND$), "GET") THEN mode$ = "GET"
IF INSTR(UCASE$(COMMAND$), "SET") THEN mode$ = "SET"
IF INSTR(UCASE$(COMMAND$), "VERBOSE") THEN VERBOSE = 1
IF INSTR(UCASE$(COMMAND$), "FORCE") THEN FORCE = 1
IF INSTR(UCASE$(COMMAND$), "NOEX") THEN EXPOR = 0

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

        sekunde$ = HEX$(INP(rtcd + 2))
        minute$ = HEX$(INP(rtcd + 3))
        stunde$ = HEX$(INP(rtcd + 4))
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

        REM Check if a year has passed
        IF EXPOR = 1 THEN

                OPEN "C:\MM581.RTC" FOR APPEND AS #1

                IF LOF(1) THEN
                        CLOSE #1
                        OPEN "C:\MM581.RTC" FOR INPUT AS #1
                        INPUT #1, yearfile$
                        INPUT #1, monthfile$
                        INPUT #1, dayfile$
                        CLOSE #1

                        IF (VAL(monthfile$) > VAL(monat$)) THEN
                                IF (VAL(dayfile$) > VAL(day$)) THEN
                                        IF VERBOSE = 1 THEN
                                                PRINT "A year has passed since the last time the RTC was read."
                                        END IF

                                        jahrdec% = VAL(jahr$)
                                        jahrdec% = jahrdec% + 1
                                        jahr$ = LTRIM$(STR$(jahrdec%))

                                        yearwrite% = VAL("&H" + jahr$)
                                        OUT rtcd + 9, (yearwrite%)

                                        KILL "C:\MM581.RTC"
                                    
                                        OPEN "C:\MM581.RTC" FOR APPEND AS #1
                                        PRINT #1, jahr$
                                        PRINT #1, monat$
                                        PRINT #1, tag$
                                        CLOSE #1

                                END IF
                        END IF

                ELSE
                        PRINT #1, jahr$
                        PRINT #1, monat$
                        PRINT #1, tag$
                CLOSE #1
                END IF
        END IF


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

        IF EXPOR = 1 THEN

                KILL "C:\MM581.RTC"

                OPEN "C:\MM581.RTC" FOR APPEND AS #1
                PRINT #1, jahr$
                PRINT #1, monat$
                PRINT #1, tag$
                CLOSE #1

        END IF
        
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
        PRINT "MM58167.EXE ADDRESSh SET|GET [VERBOSE] [FORCE] [NOEX]"
        PRINT ""
        PRINT "Adressh:   The address of the RTC, set by jumpers on the PCB, e.g. 240h"
        PRINT "SET|GET:   Sets the RTC to the system clock and vise versa."
        PRINT "[VERBOSE]: Outputs some information."
        PRINT "[FORCE]:   Skip detection of RTC."
        PRINT "[NOEX]:    Don't export the time to C:\MM581.RTC."
        PRINT "           The file is needed to update the year automatically."
        PRINT ""
        PRINT "Examples:"
        PRINT "To write the system time to the RTC, setup at 300h:"
        PRINT "MM58167.EXE 300h SET"
        PRINT ""
        PRINT "--------------------------------------------------------"
        PRINT "Credits to:"
        PRINT "github.com/mrehkopf/ & github.com/Sciurus68k/"
        PRINT ""
        PRINT "Project page:"
        PRINT "github.com/jensma-de/MM58167-ISA-RTC/"

