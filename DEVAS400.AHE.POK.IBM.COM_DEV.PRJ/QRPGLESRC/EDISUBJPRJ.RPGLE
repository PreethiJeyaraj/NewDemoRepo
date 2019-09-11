000100140407      ****************************************************************
000200150120      * Program name: EDISUBJ                                        *
000300140407      *                                                              *
000400140407      * Description:  This program is used to customize the subject  *
000500150120      *   line on the EDI error report                               *
000600140407      *                                                              *
000700150120      * Calling program:  PSFCFG EDIRPTOUT                           *
000800140407      *                                                              *
000900140407      * Called programs:  none                                       *
001000140407      *                                                              *
001100140407      * Files used:       none                                       *
001200140407      *                                                              *
001300140407      * Messages:         none                                       *
001400140407      *                                                              *
001500140407      * Special behavior: NONE                                       *
001600150120      *                                                              *
001700140407      * Change history:                                              *
001800140407      *                                                              *
001900140407      * Change  Reason      Date     Pgmr   Description              *
002000140407      * flag                                                         *
002100140407      * -----   ----------  ------   ----   ------------------------ *
002200150121      * @1333   GIP1150147  01/2015  SCH    Initial development      *
002300151109      * @1413   GIP1403117  11/2015  SCH    EDI monitor report       *
002400190125      * @1711   GIP1936806  01/2019  PRJ    EDI Alert report         *
002500140407      ****************************************************************
002600150120     FEDISUBJWK IF   E             DISK
002700141028     F                                     USROPN
002800141028      *
002900050315      * Define error logging data structure.
003000050315     DERRORDS          DS
003100050315     DMSGID                           7A
003200050315     DPGMNAME                        10A
003300050315     DFILENME                         8A
003400050315     DOPCODE                          6A
003500050315     DSTATS                           5S 0
003600050315     DEXTMSG                        100A
003700050315      *
003800050315      * Define data structure for program status.
003900050315     DPGMSTS          SDS
004000050315     DPROCNAME                 1     10A
004100050315     DJOBNAME                244    253A
004200050315     DUSERID1                254    263A
004300050315     DJOBNUM                 264    269  0
004400050315     DRUN_DATE               276    281S 0
004500050315     DRUN_TIME               282    287S 0
004600050315      *
004700050315      *
004800010522      *
004900050315     DINPUTDS          DS
005000050315     DJOBNAM                   1     26
005100050315     DSPLFID                  27     36
005200050315     DSPLFNO                  37     40B 0
005300050315     DMAILTAG                 41    290
005400050315     DPDFFILE                291    630
005500050315     DRES1                   631    632
005600050315     DPATHCCSID              633    636B 0
005700050315     DSENDER                 637    646
005800050315     DUSRDTA                 647    656
005900050315      *********************************************************************
006000050315     DOUTDS            DS
006100050315     DDISPOSTN                 1      1
006200050315     DCALLAGIN                 2      2
006300050315     DRES2                     3      4
006400050315     DMSGLEN                   5      8B 0
006500050315     DADDRLEN                  9     12B 0
006600050315     DMSGTXT                  13    267
006700050315     DRES3                   268    268
006800050315     DEXTOFF                 269    272B 0
006900050315     DCCSID                  273    276B 0
007000050315     DRES4                   277    287
007100050315     DADDRESS                288    543
007200050318      ** EXTENSION AREA *********************************
007300050318     DEXTLEN                 544    547B 0
007400050318     DSUBOFF                 548    551B 0
007500050318     DSUBLEN                 552    555B 0
007600050318     DRPLYOFF                556    559B 0
007700050318     DRPLYLEN                560    563B 0
007800050318     DCCOFF                  564    567B 0
007900050318     DCCLEN                  568    571B 0
008000050318     DBCCOFF                 572    575B 0
008100050318     DBCCLEN                 576    579B 0
008200050318     DBDYPTHOFF              580    583B 0
008300050318     DDIRPTHOFF              584    587B 0
008400050318     DDIRPTHLEN              588    591B 0
008500050318     DATTPTHOFF              592    595B 0
008600050318     DEXTSUBJ                596    635
008700050318     D*EXTRPLY                606    630
008800050318     D*EXTBCC                 631    655
008900050318     D*EXTCC                  656    680
009000050318     D*BDYLEN                 681    684B 0
009100050318     D*BDYNUMB                685    688B 0
009200050318     D*BDYX1                  689    692B 0
009300050318     D*BDYY1                  693    696B 0
009400050318     D*BDYOFF1                697    700B 0
009500050318     D*BDYPLEN1               701    704B 0
009600050318     D*BDYUSE1                705    705
009700050318     D*BDYRES1                706    708  0
009800050318     D*BDYPTH1                709    724
009900050318     D*BDYX2                  725    728B 0
010000050318     D*BDYY2                  729    732B 0
010100050318     D*BDYOFF2                733    736B 0
010200050318     D*BDYPLEN2               737    740B 0
010300050318     D*BDYUSE2                741    741
010400050318     D*BDYRES2                742    744  0
010500050318     D*BDYPTH2                745    760
010600050318     D*BDYX3                  761    764B 0
010700050318     D*BDYY3                  765    768B 0
010800050318     D*BDYOFF3                769    772B 0
010900050318     D*BDYPLEN3               773    776B 0
011000050318     D*BDYUSE3                777    777
011100050318     D*BDYRES3                778    780  0
011200050318     D*BDYPTH3                781    796
011300050318     D*DIRPTH                 797    811
011400050315      *
011500050315      *********************************************************************
011600050315     DINPUTLEN         S              9B 0
011700050315     DOUTPUTLEN        S              9B 0
011800050315     DOUTINFO          S              9B 0
011900050315      *
012000050318     DMESSAGE          S             50A
012100140404      *
012200140404     DSYSNAME          S              8A
012300050315      *********************************************************************
012400050315     C     *ENTRY        PLIST
012500050315     C                   PARM                    INPUTDS
012600050315     C                   PARM                    INPUTLEN
012700050315     C                   PARM                    OUTDS
012800050315     C                   PARM                    OUTPUTLEN
012900050315     C                   PARM                    OUTINFO
013000010522      *
013100010522      *
013200010910      *********************************************************************
013300030318      * MAINLINE PROCESSING
013400030318      *********************************************************************
013500030318      *
013600050318     C                   EVAL      MESSAGE = 'BEGIN'
013700050315      * Check to see if the output buffer is large enough.  OUTPUTLEN
013800050315      * contains the initial length of the output buffer.  If it is not
013900050315      * large enough, return with OUTINFO set to be the length required.
014000050315      * This program will be called right back with OUTPUTLEN = OUTINFO
014100050330      *
014200050315     C                   EVAL      OUTINFO = 542
014300050315     C     OUTINFO       IFGT      OUTPUTLEN
014400050315     C                   RETURN
014500050315     C                   ENDIF
014600050315      *
014700050315      * Check to see if being called for encryption.  The PDF filename
014800050315      * in the input structure will be blank, if called for encryption.
014900050315      * We don;t want to do any encryption, so just set the output buffer
015000050315      * to hexadecimal zeros and return.
015100050315     C     PDFFILE       IFEQ      *BLANKS
015200050315     C                   MOVE      *ALLx'00'     OUTDS
015300050315     C                   RETURN
015400050315     C                   ENDIF
015500050315      *
015600050315      * Set the message length and address length
015700050318     C                   EVAL      SUBLEN = 80
015800050318     C                   EVAL      MSGLEN = 255
015900050315     C                   EVAL      ADDRLEN = 255
016000050330     C                   EVAL      ADDRESS = '''' + MAILTAG + ''''
016100050315      *
016200050315      * Set reserved areas to hexadecimal zeros.  Otherwise, the program
016300050315      * may not work on release 5.2 or higher.
016400050318     C                   EVAL      RES2 = X'0000'
016500050318     C                   EVAL      RES3 = X'00'
016600050318     C                   EVAL      RES4 = X'0000000000000000000000'
016700050318     C                   EVAL      CCSID  = 0
016800050318     C                   EVAL      EXTOFF = 543
016900050318     C                   EVAL      SUBOFF = 595
017000050318     C                   EVAL      SUBLEN = 40
017100050318     C                   EVAL      EXTLEN = 52
017200050315      *
017300050322      * Call module to addlible if needed
017400150120     C                   CALLB     'EDISUBJC'
017500140404     C                   PARM                    SYSNAME
017600141028      * Open the file
017700150120     C                   OPEN      EDISUBJWK
017800050322      *
017900150120      * Retreive subject line from work file EDISUBJWK
018000150120     C                   Read      EDISUBJWKR                           7071
018100141028     C                   SELECT
018200151130      * @1413: Begin
018300151109     C                   WHEN      %SUBST(SPLFID:1:2) = 'EM'
018400151109     C                   If        SYSNAME = *BLANKS
018500151109     C                   EVAL      EXTSUBJ = 'EDI Monitor report'
018600151109     C                   Else
018700151109     C                   EVAL      EXTSUBJ = %trim(SYSNAME) +
018800151109     C                                       ':  EDI Monitor report'
018900151109     C                   EndIf
019000151130      * @1413: End
019100190129      * @1711: Begin
019200190129     C                   WHEN      %SUBST(SPLFID:1:3) = 'EDI'
019300190129     C                   If        SYSNAME = *BLANKS
019400190129     C                   EVAL      EXTSUBJ = 'EDIINVC1 Job Alert'
019500190129     C                   Else
019600190129     C                   EVAL      EXTSUBJ = %trim(SYSNAME) +
019700190129     C                                       ':  EDIINVC1 Job Alert'
019800190129     C                   EndIf
019900190129      * @1711: End
020000141028      * File error
020100141028     C                   WHEN      *IN70 or *IN71
020200140404     C                   If        SYSNAME = *BLANKS
020300150120     C                   EVAL      EXTSUBJ = 'EDI Error report'
020400140404     C                   Else
020500140407     C                   EVAL      EXTSUBJ = %trim(SYSNAME) +
020600150120     C                                       ':  EDI Error report'
020700140404     C                   EndIf
020800141028      *
020900141028     C                   Other
021000150120     C                   EVAL      EXTSUBJ = EDISUBJLIN
021100141028     C                   EndSl
021200050315      *
021300050322     C                   EVAL      MESSAGE = 'ADDRESS = ' + ADDRESS
021400050322     C     MESSAGE       DSPLY
021500050322     C                   EVAL      MESSAGE = 'EXTSUBJ = ' + EXTSUBJ
021600050322     C     MESSAGE       DSPLY
021700050322     C                   EVAL      MESSAGE = 'SPLFID = ' + SPLFID
021800050322     C     MESSAGE       DSPLY
021900050315      *
022000050315      * Mail the file
022100050315     C                   EVAL      DISPOSTN = '1'
022200030318      *
022300050315      * Don't call this pgm again for this file
022400050330     C                   EVAL      CALLAGIN = '0'
022500010523      *
022600030318     C                   EXSR      EXITSR
022700030318      *
022800030318      *
022900010910      *******************************************************
023000010906      * Exit the program
023100010906     C     EXITSR        BEGSR
023200010906     C                   SETON                                        LR
023300010906     C                   RETURN
023400010906     C                   ENDSR
023500010906      *
023600010525      *
023700030318      **********************************************************************
023800030318      * Subroutine to log IO errors.
023900030318      **********************************************************************
024000030318     C     ERRLOG        BEGSR
024100030318      *
024200030318      * Call service program to log error.
024300030318     C                   CALLB     'LOGIOERRS'
024400030318     C                   PARM                    ERRORDS
024500030318      *
024600030318     C                   ENDSR
024700030318      *
024800030318      *
