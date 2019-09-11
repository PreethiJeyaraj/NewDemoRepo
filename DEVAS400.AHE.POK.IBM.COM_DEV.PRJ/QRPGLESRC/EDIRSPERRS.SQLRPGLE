000100151013      **********************************************************************
000200151013      * Program name: EDIMONR1                                             *
000300151013      *                                                                    *
000400190826      * Description:  This program prepares an EDI Error report for errors *
000500190826      *               in EDI Response Trigger Job EDIMQRSPC and            *
000600190826      *               emails to recipient(s)                               *
000700151013      *                                                                    *
000800151013      * Calling program:  None                                             *
000900151013      *                                                                    *
001000151013      * Called programs:  LOGIOERRS                                        *
001100151013      *                   QCMDEXC                                          *
001200151013      *                                                                    *
001300151013      * Files used:       ---------                                        *
001400151013      *                   ---------                                        *
001500151013      *                                                                    *
001600151013      * Messages:         Error messages sent to QSYSOPR for monitoring    *
001700151104      *                                                                    *
001800151013      *                                                                    *
001900151013      * Special behavior: NONE                                             *
002000151013      *                                                                    *
002100151013      * Change history:                                                    *
002200151013      *                                                                    *
002300151013      * Change  Reason      Date     Pgmr   Description                    *
002400151013      * flag                                                               *
002500151013      * -----   ----------  ------   ----   ------------------------       *
002600190826      * @1676   GIP1859663  06/2019  PRJ    Initial development            *
002700151013      **********************************************************************
002800190826     FEDIMONO   O    E             PRINTER INFDS(PRTDDS)
002900140402     F                                     OFLIND(*IN99)
003000140402      *
003100190826     D#PGM             C                   CONST('EDIRSPERRS')
003200961029     DRETCODE          S              3S 0
003300961029     DMSGACT           S              1A
003400961029     DMSGVAR           S            256A
003500961029     DMSGTYP           S              1A
003600140402      *
003700020122      *INPUT  PARM LIST:
003800151109     DEDIMBR           S             10A
003900151109      *
004000140402      *
004100140402     DPRTDDS           DS
004200140402     D FileRecord        *RECORD
004300140402     D CurLine               367    368I 0
004400140402     D CurPage               369    372I 0
004500080916      *
004600080715      ** ERROR handling informational data structure **
004700961029     DERRORDS          DS
004800961029     DMSGID                           7A
004900961029     DPGMNAME                        10A
005000961029     DFILENAME                        8A
005100961029     DOPCODE                          6A
005200961029     DSTATUS                          5S 0
005300961029     DEXTMSG                        100A
005400060418      *
005500140401      * Timestamp datastructure
005600961209     D                 DS
005700961209     DTIMSTP                   1     12  0
005800961209     DSYSTIME                  1      6S 0
005900140404     DHH                       1      2A
006000140404     DMM                       3      4A
006100140404     DSS                       5      6A
006200961209     DSYSDATE                  7     12S 0
006300140401      *
006400140401      * Define system date
006500140401     DSYS_DATE         S               D   INZ(*SYS)
006600140401     DTODAYISO         S               D   DATFMT(*ISO)
006700140401     DTODAYISO2        S             10A
006800151109     DHHMMSS           S              8A
006900140401      *
007000140404     DPurgeDayDS       DS
007100140404     DPurgeDays                1      3A
007200140401      *
007300140401      *Standalone variables:
007400140401     DMSG_Q            S             10A   INZ(*BLANKS)
007500140401     DMSG_ID           S              7A   INZ(*BLANKS)
007600140401     DMSG_DTA          S            256A   INZ(*BLANKS)
007700140401     DMSG_TYP          S              1A   INZ('I')
007800140401     DSNDERR           S              1A
007900140401     DSYSNAME          S              8A
008000140401     DCMDLENGTH        S             15P 5
008100140401     DCMDTEXT          S            256A
008200140401     DAllDone          S              1A
008300151210     DPart3_Done       S              1A
008400151210     DPart4_Done       S              1A
008500140401     DMore_Recs        S              1A
008600151109     DAll_Done         S              1A
008700140401     DRptCnt           S              4S 0
008800151014     DLoop_Cnt         S              4S 0
008900151109     DSEQ_Cnt          S              4S 0
009000151014     DNull_Cnt         S              5S 0
009100151014     DGCMS_Cnt         S              5S 0
009200151014     DS_Cnt            S              5S 0
009300151014     DW_Cnt            S              5S 0
009400161222     DD_Cnt            S              5S 0
009500161222     DD_CntC           S              5A
009600151014     DGCMS_CntC        S              5A
009700151014     DS_CntC           S              5A
009800151014     DW_CntC           S              5A
009900140404     DCHARDATE         S             10A
010000151109     DEDISEQ           S              9A
010100151014     DEDISEQ#          S              9P 0
010200140401     DAUTLLIB          S             10A
010300140401     DSelStmt          S            500A   INZ(*BLANKS)
010400140401     DRC1              S              2A
010500140404     DPrgDay#          S              3S 0
010600140404     DPrgDate          S               D   DATFMT(*ISO)
010700151013     DPRMFILE          S             10A
010800151013     DPRMLIB           S             10A
010900151014     DFile1            S             20A
011000151014     DFile2            S             20A
011100151014     DFile3            S             20A
011200151014     DFile4            S             20A
011300151207     DHld_Date         S             10A
011400151207     DHld_Time         S              8A
011500160303     DCtl_Done         S              1A
011600160303     DPart5_Done       S              1A
011700160303     DwSQL             S            500A   INZ(*Blanks)
011800160303     DInvDateISO       S               D   DATFMT(*ISO)
011900160303     DI_Cnt            S              5S 0
012000160303     DPrc_Cnt          S              5S 0
012100160303     DInv_Cnt          S              5S 0
012200160303     DInv_Cntc         S              5A
012300160303     DCty              S              2A
012400160303     DInvNum           S             15A
012500180104      *
012600180104     DM_Cnt            S              5S 0
012700180104     DM_CntC           S              5A
012800180307     DNull_CntC        S              5A
012900151014      *
013000151014      * SQL Cursor variables:
013100151014     Dcur5Mbr          S             10A
013200151014     Dcur5SndID        S             30A
013300151014     Dcur5RunDat       S               D   DATFMT(*ISO)
013400151014     Dcur5RunTim       S               T   TIMFMT(*ISO)
013500151014     Dcur5Cty          S              2A
013600151014     Dcur5Invno        S             22A
013700151014     Dcur5MsgID        S              7A
013800151014     Dcur5MsgVar       S            256A
013900151014      *
014000140401      *
014100151014      * Data structure used to parse the EDIPF5 data
014200151014     DEDIPF5LIN        DS
014300151014     DdetMBR                   1     10
014400151014     Ddetfill1                11     11    Inz(*Blanks)
014500151014     DdetSndID                12     41
014600151014     Ddetfill2                42     42    Inz(*Blanks)
014700151014     DdetRunDt                43     52
014800151014     Ddetfill3                53     53    Inz(*Blanks)
014900151014     DdetRUNTIM               54     63
015000151014     Ddetfill4                64     64    Inz(*Blanks)
015100151014     DdetCTY                  65     66
015200151014     Ddetfill5                67     67    Inz(*Blanks)
015300151014     DdetINVNO                68     89
015400151014     Ddetfill6                90     90    Inz(*Blanks)
015500151014     DdetMsgVar               91    200
015600151014     Ddetfill99              201    500    Inz(*Blanks)
015700140404      *
015800180426      *Data structure to hold CAAPS data area
015900180426     DHMSDS            DS
016000180426     DEDIHMSVAL                1      8A
016100140404      *
016200070420      *Input parameters:
016300970417     C     *ENTRY        PLIST
016400190826     C                   PARM                    ALERTFLG
016500190826     C                   PARM                    WAITC
016600190826     C                   PARM                    ENV
016700140401      *
016800140401      *
016900050324      ******************************************************************
017000050324      ** Main Program Loop                                            **
017100050324      ******************************************************************
017200050324     C                   EXSR      INITSR
017300151104      *
017400151014      **********************************************************
017500151014      * Part 1: write report Header
017600151014      **********************************************************
017700151014     C                   ExSr      WriteRptHdr1
017800151013      *
017900151014      **********************************************************
018000190826      * Part 2: retreive any EDIPF5 errors and write to report
018100151014      **********************************************************
018200151014     C                   ExSr      WriteRptHdr2
018300151014      *
018400151013     C                   EVAL      SelStmt = *Blanks
018500151013     C                   EVAL      SelStmt =
018600151013     C                             'SELECT E5MBRNAM, E5SNDIND,E5RUNDATE, ' +
018700151013     C                             'E5RUNTIME, E5COUNTRY, E5INVNO, ' +
018800151013     C                             'E5MSGID, E5MSGVAR '  +
018900151014     C                             'FROM ' + %TRIM(FILE2) + ' ' +
019000160303     C                             'and E5RUNDATE = ''' + Hld_Date + ''' ' +
019100180514     C                             'and E5RUNTIME >= ''' + Hld_Time + ''' '
019200160303      *
019300151013      * Prepare Run statement
019400151013     C/Exec Sql
019500151014     C+ PREPARE RUNSTMT2 from :SelStmt
019600151013     C/End-Exec
019700151013      *
019800151013      * Declare cursor
019900151013     C/Exec Sql
020000151014     C+ DECLARE EDICUR2 CURSOR FOR RUNSTMT2
020100151013     C/End-Exec
020200151013      *
020300151013      * Open EDICUR2
020400151013     C/Exec Sql
020500151013     C+ OPEN EDICUR2
020600151013     C/End-Exec
020700151013      *
020800151013     C                   Eval      AllDone = 'N'
020900151013     C                   Eval      RptCnt = 0
021000151013     C                   Dou       AllDone = 'Y'
021100151013      *
021200151013      * Fetch from EDICUR2
021300151013     C/Exec Sql
021400151014     C+ FETCH NEXT FROM EDICUR2 INTO
021500151014     C+     :cur5Mbr,
021600151014     C+     :cur5SndID,
021700151014     C+     :cur5RunDat,
021800151014     C+     :cur5RunTim,
021900151014     C+     :cur5Cty,
022000151014     C+     :cur5Invno,
022100151014     C+     :cur5MsgID,
022200151014     C+     :cur5MsgVar
022300151013     C/End-Exec
022400151013      *
022500151013     C                   IF        SQLCOD < 0
022600151109     C                   EVAL      EXTMSG = 'SQL fetch EDICUR2 failed'
022700151013     C                   EXSR      SQLERROR
022800151013     C                   ENDIF
022900151013      *
023000151013      * No more records
023100151013     C                   If        SQLCOD = 100
023200151013     C                   Eval      AllDone = 'Y'
023300151013     C                   Leave
023400151013     C                   EndIf
023500151013      *
023600151013      * If Record(s) found, write to report
023700151013     C                   If        SQLCOD = 0
023800151013     C                   EXSR      WriteEDIPF5
023900151013     C                   Eval      RptCnt = RptCnt + 1
024000151013     C                   EndIf
024100151013      *
024200151013     C                   EndDo
024300151013      *
024400151013      * Close EDUCUR2 cursor
024500151013     C/Exec Sql
024600151013     C+ CLOSE EDICUR2
024700151013     C/End-Exec
024800151013      *
024900151013      * No records found, write empty report
025000151013     C                   If        RptCnt = 0
025100151013     C                   EVAL      EDIMONLIN ='No EDIPF5 errors found ' +
025200190826     C                             'for EDI Response Processing'
025300151014     C                   WRITE     EDIMONOR
025400151013      *
025500151013     C                   EndIf
025600151014     C                   EXSR      CloseEDI
025700140404      *
025800140402      * Exit the program
025900970417     C                   SETON                                        LR
026000970417     C                   RETURN
026100050324      *
026200050324      *
026300050324      *
026400140401      * Option subroutines                                             *
026500140401      ******************************************************************
026600140401      * Initialize the variables                                      *
026700140401      ******************************************************************
026800970424     C     INITSR        BEGSR
026900050324      *
027000180426     C*                  TIME                    TIMSTP
027100180426     C*                  Eval      HHMMSS = HH+':'+MM+':'+SS
027200180426      * Retreive HHMMSS from data area
027300180426     C     *DTAARA       DEFINE    EDIHHMMSS     HMSDS
027400180426     C                   IN        HMSDS
027500180426     C                   Eval      HHMMSS = EDIHMSVAL
027600180427     C     HHMMSS        DSPLY
027700140404     C                   MOVE      SYS_DATE      CHARDATE
027800140401      *
027900140401     C                   CALL      'RTVSYSNME'
028000140401     C                   PARM                    SYSNAME
028100140401      *
028200140404     C/Exec Sql
028300140404     C+ CONNECT TO :SYSNAME
028400140404     C/End-Exec
028500140404      *
028600151014     C                   EVAL      PRMFILE = 'SUPLRTBLL5'
028700151014     C                   EVAL      PRMLIB  = *BLANKS
028800151014     C                   CALL      'RTVOBJDC'
028900151014     C                   PARM                    PRMFILE
029000151014     C                   PARM                    PRMLIB
029100151014      *
029200151014     C                   EVAL      File2 = %TRIM(PRMLIB) + '.EDIPF5'
029300151104      *
029400970424     C                   ENDSR
029500050324      *
029600050324      *
029700140401      ******************************************************************
029800140401      * Error encounterd - call ROBOT message pgm to snd msg to QSYSOPR*
029900140401      ******************************************************************
030000980918     C     SND_ROBOT     BEGSR
030100980918     C                   CALL      'SNDROBOT'
030200980918     C                   PARM                    MSG_Q
030300980918     C                   PARM                    MSG_ID
030400980918     C                   PARM                    MSG_DTA
030500980918     C                   PARM                    MSG_TYP
030600980918     C                   ENDSR
030700151013      *
030800151013      *
030900020122      ******************************************************************
031000151014      * Write the header lines for the EDI processed report            *
031100020122      ******************************************************************
031200151014     C     WriteRptHdr1  BegSr
031300020122      *
031400020218      * Write line 1
031500140401      *
031600151013     C                   EVAL      EDIMONLIN = '** ' + %trim(SYSNAME) +' **'
031700151013     C                   WRITE     EDIMONOR
031800140401      *
031900190826     C                   EVAL      EDIMONLIN = 'EDI Response Error' +
032000190826     C                             'Report '
032100151013     C                   WRITE     EDIMONOR
032200020218      * Blank line
032300151013     C                   EVAL      EDIMONLIN  = *BLANKS
032400151013     C                   WRITE     EDIMONOR
032500151014     C                   EVAL      EDIMONLIN  = *BLANKS
032600151014     C                   WRITE     EDIMONOR
032700140404      *
032800140404      *
032900140401     C                   EndSr
033000020702      *
033100140401      *
033200151014      ******************************************************************
033300151014      * Write the header lines for the EDIPF5 report section           *
033400151014      ******************************************************************
033500151014     C     WriteRptHdr2  BegSr
033600151014      *
033700151014      * Blank line
033800151014     C                   EVAL      EDIMONLIN  = *BLANKS
033900151014     C                   WRITE     EDIMONOR
034000151014     C                   EVAL      EDIMONLIN  = *BLANKS
034100151014     C                   WRITE     EDIMONOR
034200151014     C                   EVAL      EDIMONLIN  = 'from AS/400 EDIPF5:'
034300151014     C                   WRITE     EDIMONOR
034400151014      *
034500151014      * EDIPF5 Header
034600151014     C                   CLEAR                   EDIPF5LIN                  '
034700151014     C                   Eval      detMBR     = 'Member'
034800151014     C                   Eval      detSndID   = 'Sender Identifier'
034900151014     C                   Eval      detRUNDT   = 'Run Date'
035000151014     C                   Eval      detRUNTIM  = 'Run Time'
035100151014     C                   Eval      detCTY     = 'Ct'
035200151014     C                   Eval      detINVNO   = 'Invoice'
035300151014     C                   Eval      detMsgVar  = 'Error Message'
035400151014      *
035500151014     C                   EVAL      EDIMONLIN  = *BLANKS
035600151014     C                   Move      EDIPF5LIN     EDIMONLIN
035700151014     C                   WRITE     EDIMONOR
035800151014      *
035900151014      * Header line 2
036000151014     C                   EVAL      EDIMONLIN ='-----------------------------+
036100151014     C                             -----------------------------------------
036200151014     C                             -----------------------------------------
036300151014     C                             -----------------------------------------
036400151014     C                             ----'
036500151014     C                   WRITE     EDIMONOR
036600151014      *
036700151014      *
036800151014     C                   EndSr
036900151014      *
037000151014      *
037100151014      ******************************************************************
037200151014      * Write the EDIPF5 detail line                                   *
037300151014      ******************************************************************
037400151014     C     WriteEDIPF5   BegSr
037500151014     C                   CLEAR                   EDIPF5LIN                  '
037600151014      *
037700151014     C                   Eval      detMBR     = cur5Mbr
037800151014     C                   Eval      detSndID   = cur5SndID
037900151014     C                   Move      cur5RunDat    detRUNDT
038000151014     C                   Move      cur5RunTim    detRUNTIM
038100151014     C                   Eval      detCTY     = cur5Cty
038200151014     C                   Eval      detINVNO   = cur5Invno
038300151014     C                   Eval      detMsgVar  = cur5MsgVar
038400151014      *
038500151014     C                   EVAL      EDIMONLIN  = *BLANKS
038600151014     C                   Move      EDIPF5LIN     EDIMONLIN
038700151014     C                   WRITE     EDIMONOR
038800151014      *
038900151014     C                   EndSr
039000151014      *
039100151014      *
039200140401      ******************************************************************
039300140404      * Close the report for printing and emailing                     *
039400140401      ******************************************************************
039500151014     C     CloseEDI      BegSr
039600151013     C                   EVAL      EDIMONLIN  = '** End of Report **'
039700151013     C                   WRITE     EDIMONOR
039800140401      *
039900151014      * Close EDIMONO file
040000151014     C                   CLOSE     EDIMONO
040100020122      *
040200020122     C                   ENDSR
040300020122      *
040400140401      *
040500140401      *****************************************************************
040600140401      * Subroutine to log SQL errors
040700140401      *****************************************************************
040800140401     C     SQLERROR      BEGSR
040900140401      *
041000140401     C                   CLEAR                   ERRORDS
041100140401     C                   EVAL      MSGID = 'ICC6700'
041200140401     C                   EVAL      PGMNAME = #PGM
041300140401     C                   EVAL      STATUS = SQLCOD
041400140401     C                   CALLB     'LOGIOERRS'
041500140401     C                   PARM                    ERRORDS
041600140401      *
041700140401      * Exit program back to menu. Return code of 99 will handle sending
041800140401      * the 'seriuos sql' message back to the menu.
041900140401     C                   EXSR      EXITPGM
042000140401      *
042100140401     C                   ENDSR
042200140401      *
042300140401      *
042400140404      *****************************************************************
042500140404      * Subroutine to log SQL errors
042600140404      *****************************************************************
042700140404     C     ERRLOG        BEGSR
042800140404      *
042900140404     C                   CLEAR                   ERRORDS
043000140404     C                   EVAL      MSGID = 'ICC6700'
043100140404     C                   EVAL      PGMNAME = #PGM
043200140404     C                   CALLB     'LOGIOERRS'
043300140404     C                   PARM                    ERRORDS
043400140404      *
043500140404      * Exit program back to menu. Return code of 99 will handle sending
043600140404      * the 'seriuos sql' message back to the menu.
043700140404     C                   EXSR      EXITPGM
043800140404      *
043900140404     C                   ENDSR
044000140404      *
044100140404      *
044200140401      *****************************************************************
044300140401      * Subroutine to release connection and return to caller
044400140401      *****************************************************************
044500140401     C     EXITPGM       BEGSR
044600140401      *
044700140401      * Return to calling program
044800140401     C                   EVAL      *INLR = *ON
044900140401     C                   RETURN
045000140401      *
045100140401     C                   ENDSR
045200140401      *
