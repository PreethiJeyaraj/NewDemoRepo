000100180703     H
000200180703      ******************************************************************
000300180703      * Program name: EDIMQRSPR1                                       *
000400180702      *                                                                *
000500180703      * Module name:  EDIMQRSPR1                                       *
000600180702      *                                                                *
000700180702      * Description: Program to process EDI Response from MQ           *
000800180702      *                                                                *
000900180703      * Calling program: EDIMQRSPC1                                    *
001000180702      *                                                                *
001100180702      * Called programs: 1. LOGIOERRS - Std IGF error logging program  *
001200180702      * procedure/module                                               *
001300180702      *                  2. WSCFEIMPR - Generate xml for AddNotelog    *
001400180702      *                  3. WSCLIENT  - Invoke CFE webservice for      *
001500180702      * AddNotelog                                                     *
001600180702      *                                                                *
001700180702      *                                                                *
001800180702      * Files used: EDIPF5   - DETAIL ERROR FILE                       *
001900180702      *             EDIPF14  - MQ SERIES INFORMATION FILE              *
002000180702      *          INVOI00001  - INVOICE CONTROL FILE                    *
002100180705      *                                                                *
002200180702      * Special behevior:                                              *
002300180702      *                   Calls MQ to get MQ Message from GCMS         *
002400180702      *                                                                *
002500180702      * Compile as:  CRTRPGMOD MODULE(EDIMQRESPR)                      *
002600180702      *              SRCFILE(*CURLIB/QRPGLESRC)                        *
002700180702      *              BNDDIR(LIBHTTP/HTTPAPI)                           *
002800180702      *              COMMIT(*NONE)                                     *
002900180702      *              RPGPPOPT(*LVL1)                                   *
003000180702      *                                                                *
003100180702      * Messages: None                                                 *
003200180702      *                                                                *
003300180702      * Parameters: 1. PrmLibName - Library name  (Incoming)           *
003400180702      *                                                                *
003500180702      * Change history:                                                *
003600180702      *                                                                *
003700180702      * Change  Reason      Date     Pgmr   Description                *
003800180702      * flag                                                           *
003900180702      * -----   ----------  ------   ----   ------------------------   *
004000180702      * 1676    GIP1859663  07/2018  PXJ    Initial development      *
004100000000      ****************************************************************
004200000000      *                                                              *
004300000000      ****************************************************************
004400180703     H*DFTACTGRP(*NO) ACTGRP(*NEW)
004500180703      *
004600180711      * Log MQ Error  in EDIINVR11
004700180705     FMQOUTHP   UF A E             DISK    INFDS(MQHSDS)
004800180705
004900180711      * Info - EDI MQ Connection to GCMS , CTS Call
005000180705     FEDIPF14   IF   E           K DISK    INFDS(PF14DS)
005100180705
005200180713     FEDIPF5    UF A E             DISK
005300180713
005400180711      * Connection handle
005500180703     D HConn           S             10I 0
005600180703
005700180711      * Options
005800180703     D Options         S             10I 0
005900180703
006000180711      * Object handle
006100180703     D HObj            S             10I 0
006200180703
006300180711      * Completion codes
006400180703     D OpenCode        S             10I 0
006500180703     D CompletionCode  S             10I 0
006600180703
006700180711      * Reasons
006800180703     D Reason          S             10I 0
006900180703     D ConnReason      S             10I 0
007000180703
007100180711      * Buffer
007200180711     D Buffer          S          99999A   Inz('Initial')
007300180703
007400180711      * Buffer length
007500180703     D BufferLength    S             10I 0 Inz(%LEN(Buffer))
007600000000
007700180711      * Actual Message length received
007800180703     D MessageLength   S             10I 0
007900000000
008000180711      * XML-INTO Options
008100180703     D $Options        S            200A   varying
008200180703
008300180711      * Current Date
008400180713     D WWDATE          S               D   INZ(*SYS)
008500180703
008600180711      * Current Time
008700180713     D WWTIME          S               T   Inz(*SYS)
008800180703
008900180711      * Current TimeStamp
009000180713     D WWTIMESTAMP     S               Z   Inz(*SYS)
009100180703
009200180711      * Country Code
009300180704     D Country         S              2A
009400180704
009500180711      * Invoice Number
009600180704     D Id              S             22A
009700180704
009800180711      * Invoice Date
009900180710     D Invoice_Date    S               D   DATFMT(*MDY)
010000180704
010100180711      * Object ID
010200180705     D ObjId           S             16A
010300180705
010400180711      * Index of Object Description
010500180705     D n               S              3I 0
010600180705
010700180711      * Response from GCMS
010800180706     DRESPONSE_GCMS    S              1A
010900180706
011000180711      * WSCFEIMPR parm declaration
011100180704     DwAPPLID          S              5A
011200180704     DWSOPER           S             50A
011300180704     DErrNote          S            256A
011400180704     DRetCode          S              2A
011500180704     DWRETCODE         S              2A
011600180704     DWErrNote         S            256A
011700180705
011800180711      * Queue Manager
011900180705     D Qmgr            S             48A   Inz
012000180705
012100180711      * Queue Name
012200180705     D Queue           S             48A   Inz
012300180705
012400180711      * Program Library
012500180718     DPgmLib           S             10A   Inz
012600180706
012700180711      * IFS path Name
012800180705     D $New_File       S            100A   Inz
012900180705     D $File_Path      S            100A   Inz
013000180705     D $Arc_Dir        S            100A   Inz
013100180705     D fd              S             10I 0
013200180705
013300180711      * Correlation ID
013400180705     D GetCorID        S             80A   Inz
013500180705
013600180711      * Completion Code
013700180705     DCMPCOD           S             10I 0
013800180704
013900180711      * System Name
014000180706     DSYSNAME          S              8A
014100180706
014200180711      * Reason Code
014300180706     DREASONCODE       S             10A
014400180706
014500180711      * Reason Code
014600180706     DREASONCMP        S             10A   Inz('0000000000')
014700180711
014800180711      * Input Member Name
014900180711     DMBRNAME          S             10A
015000180711
015100180711      * Sender Identifier
015200180711     DSNDIND           S             30A
015300180711
015400180713      * Sequence Number
015500180713     DSEQNUM           S             10I 0
015600180706
015700180713      * Control Number
015800180713     DCTRNUM           S             10A
015900180713
016000180711      * MESSAGE VARIABLE
016100180711     DMSGVAR           S            256A
016200180711
016300180711      * Error Details to LOGIOERRS
016400180711     DERROR            S            136A
016500180711
016600180718      * Command parameter to QCMDEXC
016700180718     Dcmd              S            200A
016800180718
016900180718      * MQ Retry Count
017000180718     DMQCNT            S              3I 0
017100180718
017200180711      * Declare MQI structures needed
017300180711      * MQI named constants
017400180703     D/COPY CMQG
017500000000
017600180709      * Define ROBOT work fields
017700180709     DMSG_Q            S             10A   INZ(*BLANKS)
017800180709     DMSG_ID           S              7A   INZ(*BLANKS)
017900180709     DMSG_DTA          S            256A   INZ(*BLANKS)
018000180709     DMSG_TYP          S              1A   INZ('I')
018100180709
018200180711      * Object Descriptor
018300180703     D MQOD            DS                  Qualified
018400000000     D/COPY CMQODG
018500000000
018600180711      * Message Descriptor
018700180703     D MQMD            DS                  Qualified
018800000000     D/COPY CMQMDG
018900000000
019000180711      * Get message options
019100180703     D MQGMO           DS                  Qualified
019200000000     I/COPY CMQGMOG
019300000000
019400180622     D/copy *libl/qrpglesrc,IFSIO_H
019500180622
019600180711      * Get Correlation ID from XML Response
019700180703     D GetCorID_DS     DS                  Inz
019800180703     D Cor_Prefix                     4A
019900180703     D Buffer_CorID                  80A
020000180703
020100180711      * Get Status ID and Error details from XML Response
020200180703     D ApplicationStatus...
020300180703     D                 DS                  Qualified
020400180703     D StatusId                      10A
020500180703     D ErrorCode                     50A
020600180703     D ErrorDescription...
020700180703     D                               50A   Dim(50)
020800180703     D ErrorDataname                 50A
020900180711
021000180711      * Get Invoice Date from XML Response
021100180711     DDocumentDateTime...
021200180711     D                 S             10A
021300180703
021400180711      * Program Status Data Structure
021500180703     DPSDS            SDS
021600180705     DPGMNAME                  1     10A
021700180709     DPGMSTS                  11     15S 0
021800180709     DPGMMSGID                40     46A
021900180709     DPGMERRDTA               91    170A
022000180703     DPGMUSER                254    263A
022100180705
022200180705      * ERROR LOG data structure
022300180705     DERRORDS          DS                  INZ
022400180705     DMSGID                           7A
022500180705     DPROGRAMNAME                    10A
022600180705     DFILENAME                        8A
022700180705     DOPCODE                          6A
022800180705     DSTATUS                          5S 0
022900180705     DEXTMSG                        100A
023000180705
023100180705      * File data structure for file: EDIPF14
023200180705     DPF14DS           DS
023300180705     DPF14FIL            *FILE
023400180705     DPF14OPN                  9      9
023500180705     DPF14INP            *INP
023600180705     DPF14MOD            *MODE
023700180705     DPF14OUT            *OUT
023800180705     DPF14OPC            *OPCODE
023900180705     DPF14SIZ            *SIZE
024000180705     DPF14FST            *STATUS
024100180705     DPF14RCD            *RECORD
024200180705     DPF14RTN            *ROUTINE
024300180706
024400180706      * File data structure for file: MQOUTHP
024500180706     DMQHSDS           DS
024600180706     DMQHSFIL            *FILE
024700180706     DMQHSOPN                  9      9
024800180706     DMQHSINP            *INP
024900180706     DMQHSMOD            *MODE
025000180706     DMQHSOUT            *OUT
025100180706     DMQHSOPC            *OPCODE
025200180706     DMQHSSIZ            *SIZE
025300180706     DMQHSFST            *STATUS
025400180706     DMQHSRCD            *RECORD
025500180706     DMQHSRTN            *ROUTINE
025600180706
025700180711      * Prototype for WSCLIENT
025800180709     DWSCLIENT         PR                  ExtPgm('WSCLIENT')
025900180706     DwAPPLID                         5A
026000180706     DId                             22A
026100180718     DPgmLib                         10A
026200180706     DSYSNAME                         8A
026300180706     DWRETCODE                        2A
026400180706
026500180711      * Prototype for WSCFEIMPR
026600180709     DWSCFEIMPR        PR                  ExtPgm('WSCFEIMPR')
026700180706     DwAPPLID                         5A
026800180706     DWSOPER                         50A
026900180706     DId                             22A
027000180706     DObjId                          16A
027100180718     DPgmLib                         10A
027200180706     DSYSNAME                         8A
027300180706     DErrNote                       256A
027400180706     DRETCODE                         2A
027500180706
027600180711      * Prototype for SNDROBOT
027700180710     DSNDROBOT         PR                  ExtPgm('SNDROBOT')
027800180709     DMSG_Q                          10A
027900180709     DMSG_ID                          7A
028000180709     DMSG_DTA                       256A
028100180709     DMSG_TYP                         1A
028200180709
028300180713      * Prototype for GETSYSNAME
028400180713     DGETSYSNAME       PR                  ExtPgm('GETSYSNAME')
028500180713     DSYSNAME                         8A
028600180713
028700180711      * Prototype for LOGIOERRS
028800180711     DIOERRS           PR                  ExtProc('LOGIOERRS')
028900180713     DERROR                         136A
029000180705
029100180718      * Prototype for QCMDEXC
029200180718     DQCMDEXC          PR                  ExtPgm('QCMDEXC')
029300180718     Dcommand                     32702a   const options(*varsize)
029400180718     Dlen                            15p 5 const
029500180718     Digc                             3a   const options(*nopass)
029600180718
029700180711      * Prototype for EDIMQRSPR1
029800180709     DMain             PR                  ExtPgm('EDIMQRSPR1')
029900180718     DPrmPgmLib                      10A
030000000000
030100180711      * Prototype Interface for EDIMQRSPR1
030200180709     DMain             PI
030300180718     DPrmPgmLib                      10A
030400180622
030500000000      /Free
030600000000
030700180706       //***************************************************************
030800180706       //   Mainline Processing                                        *
030900180702       //***************************************************************
031000180706
031100180713       GETSYSNAME(SYSNAME);
031200180713
031300180711       //   Get queue manager and Queue from EDIPF14                   *
031400180711       PgmLib = PrmPgmLib;
031500180713       CHAIN (SYSNAME: PgmLib: 'MQMANAGER') EDIPF14;
031600180711       IF %FOUND(EDIPF14);
031700180711          Qmgr = EDIXMLDATA;
031800180711       ENDIF;
031900180711
032000180702       //***************************************************************
032100180702       //   Connect to the queue manager                               *
032200180702       //***************************************************************
032300180718       MQCNT = 1;
032400180718       CompletionCode = CCFAIL;
032500180718       DOW CompletionCode = CCFAIL and MQCNT <= 5;
032600180718           MQCONN(Qmgr : HConn : CompletionCode : ConnReason);
032700180718           If CompletionCode = CCFAIL;
032800180718              MQCNT = MQCNT + 1;
032900180718              CMD = *BLANKS;
033000180718              cmd = 'DLYJOB DLY(300)';
033100180718              QCMDEXC(cmd: %len(cmd));
033200180718           EndIf;
033300180718       ENDDO;
033400180718
033500000000       // report reason and stop if it failed
033600000000       If CompletionCode = CCFAIL;
033700180712          Clear ErrorDS;
033800180712          PROGRAMNAME = PGMNAME;
033900180712          MSGID       = 'ICC6900';
034000180712          FILENAME    = *Blanks;
034100180712          OPCODE      = 'MQCONN';
034200180712          STATUS      = ConnReason;
034300180712          EXTMSG      = 'GCMS EDI RESPONSE ERROR: ' +
034400180712                        'Unable to connect to to Queue Manager. ' +
034500180712                        'ReasonCode' + %Char(ConnReason);
034600180712          ERROR       = ERRORDS;
034700180712          IOERRS(ERROR);
034800180712          MSG_ID      = 'RBT8015';
034900180712          MSG_DTA     = 'EDIMQRSPR1: Unable to connect to Queue Manager. ' +
035000180712                        'ReasonCode' + %Char(ConnReason);
035100180712          EXSR SND_ROBOT;
035200180702
035300180702          *INLR = *ON;
035400180702          RETURN;
035500000000       EndIf;
035600000000
035700000000       //***************************************************************
035800000000       //   Open the named message queue for input (and fail if MQM    *
035900000000       //   is quiescing); exclusive or shared use of the queue is     *
036000000000       //   controlled by the queue definition here                    *
036100000000       //                                                              *
036200000000       //   Resulting queue handle is HObj                             *
036300000000       //***************************************************************
036400000000
036500180713       CHAIN (SYSNAME: PgmLib: 'MQINNAME') EDIPF14;
036600180703       IF %FOUND(EDIPF14);
036700180703          Queue = EDIXMLDATA;
036800180703       ENDIF;
036900180703
037000000000       //***************************************************************
037100000000       //   Create object descriptor for source queue                  *
037200000000       //***************************************************************
037300000000       MQOD.ODON = Queue;
037400000000
037500000000       // options are input-as-queue-def and fail-if-quiescing
037600000000       Options = OOINPQ + OOFIQ;
037700000000
037800180718       MQCNT = 1;
037900180718       OpenCode = CCFAIL;
038000180718       DOW OpenCode = CCFAIL and MQCNT <= 5;
038100180718           MQOPEN(HConn : MQOD : Options : HObj : OpenCode : Reason);
038200000000
038300180718           If OpenCode = CCFAIL;
038400180718              MQCNT = MQCNT + 1;
038500180718              CMD = *BLANKS;
038600180718              CMD = 'DLYJOB DLY(300)';
038700180718              QCMDEXC(cmd: %len(cmd));
038800180718           EndIf;
038900180718       ENDDO;
039000000000       // report reason, if any; stop if failed
039100000000
039200000000       If OpenCode = CCFAIL;
039300180712          Clear ErrorDS;
039400180712          PROGRAMNAME = PGMNAME;
039500180712          MSGID       = 'ICC6900';
039600180712          FILENAME    = *Blanks;
039700180712          OPCODE      = 'MQOPEN';
039800180712          STATUS      = Reason;
039900180712          EXTMSG      = 'GCMS EDI RESPONSE ERROR: ' +
040000180712                        'Unable to open queue for get operation. ' +
040100180712                        'ReasonCode' + %Char(Reason);
040200180712          ERROR       = ERRORDS;
040300180712          IOERRS(ERROR);
040400180712          MSG_ID      = 'RBT8015';
040500180712          MSG_DTA     = 'EDIMQRSPR1: Unable to open queue for get operation ' +
040600180712                        'ReasonCode' + %Char(Reason);
040700180712          EXSR SND_ROBOT;
040800180702
040900180702          *INLR = *ON;
041000180702          RETURN;
041100000000       EndIf;
041200000000
041300180712       //***************************************************************
041400180702       //   Get IFS Path from EDIPF14 to save MQ XML response          *
041500180702       //***************************************************************
041600180713       CHAIN (SYSNAME: PgmLib: 'EDIIFSOUT') EDIPF14;
041700180702       IF %FOUND(EDIPF14);
041800180703          $File_Path = EDIXMLDATA;
041900180702       ENDIF;
042000180702
042100180709
042200180709       //   Get IFS Path from EDIPF14 to save MQ XML response
042300180713         CHAIN (SYSNAME: PgmLib: 'EDIIFSDIR') EDIPF14;
042400180709         IF %FOUND(EDIPF14);
042500180709            $Arc_Dir = EDIXMLDATA;
042600180709         ENDIF;
042700180709
042800000000       // initial loop condition is based on result of MQOPEN
042900000000       CompletionCode = OpenCode;
043000180622
043100180702       // option is to wait up to 15 seconds for next message
043200180702       MQGMO.GMOPT = GMWT;
043300180702       MQGMO.GMWI = 15000;
043400180702
043500180702       MQGMO.GMOPT += GMCONV;
043600180702
043700180703       // initial loop condition is based on result of MQOPEN
043800180703       CompletionCode = OpenCode;
043900180703
044000000000       // start of loop to read all the messages
044100180711       DoW CompletionCode <> CCFAIL and Buffer <> *BLANKS;
044200000000
044300000000         // MsgId and CorrelId are selectors that must be cleared
044400000000         // to get messages in sequence, and they are set each MQGET
044500000000         MQMD.MDMID = MINONE;
044600000000         MQMD.MDCID = CINONE;
044700000000
044800000000         // clear buffer because MQGET only fills to length of message
044900000000         Buffer = *BLANKS;
045000180702
045100180702       //***************************************************************
045200180702       //   Get messages from message queue                            *
045300180702       //***************************************************************
045400000000
045500000000         MQGET(HConn : HObj : MQMD : MQGMO :  BufferLength : %ADDR(Buffer) :
045600000000               MessageLength : CompletionCode : Reason);
045700000000
045800000000         // report reason, if any
045900000000         Select;
046000000000           When Reason = RCNONE;
046100000000
046200000000           When Reason = RC2033;
046300000000
046400000000           Other;
046500180712              Clear ErrorDS;
046600180712              PROGRAMNAME = PGMNAME;
046700180712              MSGID       = 'ICC6900';
046800180712              FILENAME    = *Blanks;
046900180712              OPCODE      = 'MQOPEN';
047000180712              STATUS      = Reason;
047100180712              EXTMSG      = 'GCMS EDI RESPONSE ERROR: ' +
047200180712                            'Unable to perform MQGET operation. ' +
047300180712                            'ReasonCode' + %Char(Reason);
047400180712              ERROR       = ERRORDS;
047500180712              IOERRS(ERROR);
047600180712              MSG_ID      = 'RBT8015';
047700180712              MSG_DTA     = 'EDIMQRSPR1: Unable to perform MQGET operation. ' +
047800180712                            'ReasonCode' + %Char(Reason);
047900180712              EXSR SND_ROBOT;
048000180703
048100180621             *INLR = *ON;
048200180621             RETURN;
048300000000         EndSl;
048400180622
048500180703         If CompletionCode <> CCFAIL;
048600180622
048700180703            EXSR MovTmpEDI;
048800180703
048900180703            $Options  = 'case=any +
049000180703                      allowextra=yes +
049100180703                      allowmissing=yes +
049200180703                      ns=remove +
049300180703                      nsprefix=ns_ +
049400180703                      path=Envelope/Body/AcknowledgeInvoice/ApplicationArea/' +
049500180703                      'Application/ApplicationStatus';
049600180703            XML-INTO ApplicationStatus %XML(Buffer : $Options);
049700180703
049800180703            $Options  = 'case=any +
049900180703                         allowextra=yes +
050000180703                         allowmissing=yes +
050100180703                         ns=remove +
050200180703                         nsprefix=ns_ +
050300180703                         path=Envelope/Header/RelatesTo';
050400180703            XML-INTO GetCorID %XML(Buffer : $Options);
050500180703
050600180703            GetCorID_DS = GetCorID;
050700180703
050800180712            $Options  = 'case=any +
050900180712                         allowextra=yes +
051000180712                         allowmissing=yes +
051100180712                         ns=remove +
051200180712                         nsprefix=ns_ +
051300180712                         path=Envelope/Body/AcknowledgeInvoice/' +
051400180712                         'DataArea/Invoice/Header/Parties/SupplierParty' +
051500180712                         '/Addresses/PrimaryAddress/Country';
051600180712            XML-INTO Country %XML(Buffer : $Options);
051700180712
051800180712            $Options  = 'case=any +
051900180712                         allowextra=yes +
052000180712                         allowmissing=yes +
052100180712                         ns=remove +
052200180712                         nsprefix=ns_ +
052300180712                         path=Envelope/Body/AcknowledgeInvoice/' +
052400180712                         'DataArea/Invoice/Header/DocumentIds/' +
052500180712                         'SupplierDocumentId/Id';
052600180712            XML-INTO Id %XML(Buffer : $Options);
052700180712
052800180712            $Options  = 'case=any +
052900180712                         allowextra=yes +
053000180712                         allowmissing=yes +
053100180712                         ns=remove +
053200180712                         nsprefix=ns_ +
053300180712                         path=Envelope/Body/AcknowledgeInvoice/' +
053400180712                         'DataArea/Invoice/Header/DocumentDateTime';
053500180712            XML-INTO DocumentDateTime %XML(Buffer : $Options);
053600180712
053700180712            Invoice_Date = %Date(DocumentDateTime: *iso);
053800180712
053900180704            Select;
054000180704            When ApplicationStatus.StatusId = 'SUCCESS';
054100180704
054200180703            exec sql
054300180703               update invoice_control
054400180704               set mq_res_timestamp = :WWTIMESTAMP,
054500180704               gcms_response = 'S',
054600180704               last_update_id = :PGMUSER ,
054700180704               last_update_timestamp = :WWTIMESTAMP
054800180704               where mq_msg_id = :Buffer_CorID and
054900180704               country_code = :Country         and
055000180705               invoice_num = :Id               and
055100180705               invoice_date = :Invoice_Date    and
055200180704               mq_res_timestamp is null;
055300180709
055400180709            If SqlCode <> 0 and SqlCode <> 100;
055500180710               Clear ErrorDS;
055600180709               PROGRAMNAME = PGMNAME;
055700180709               MSGID       = 'ICC6700';
055800180709               FILENAME = 'INVOI00001';
055900180709               OPCODE   = 'Update';
056000180709               STATUS   = SQLCODE;
056100180709               EXTMSG='UPDATE- Error occurred for: '
056200180709                      +%trim(Id) + ' ' + %CHAR(Invoice_Date);
056300180711               ERROR = ERRORDS;
056400180711               IOERRS(ERROR);
056500180712               MSG_ID = 'RBT8015';
056600180712               MSG_DTA = 'EDIMQRSPR1: Error occurred while writing/updating' +
056700180712                         'BATCH_CONTROL file for invoice: ' +
056800180712                         %TRIM(Id) + ' ' + %CHAR(Invoice_Date);
056900180709               EXSR SND_ROBOT;
057000180709            EndIf;
057100180704
057200180706            Other;
057300180704                 n = 1;
057400180705                 DoU ApplicationStatus.ErrorDescription(n) = *Blanks;
057500180704                     If %Scan('Duplicate Invoice'
057600180705                              :ApplicationStatus.ErrorDescription(n)) <> 0;
057700180705                        Response_GCMS = 'D';
057800180705                     Else;
057900180705                        Response_GCMS = 'E';
058000180704                     EndIf;
058100180704
058200180705                     WErrNote = %Trim(WErrNote) +
058300180705                                ApplicationStatus.ErrorDescription(n);
058400180704                     n= n+1;
058500180704                 EndDo;
058600180704
058700180704                 exec sql
058800180704                 update invoice_control
058900180704                 set mq_res_timestamp = :WWTIMESTAMP ,
059000180704                 gcms_response = :Response_GCMS ,
059100180704                 last_update_id = :PGMUSER ,
059200180704                 last_update_timestamp = :WWTIMESTAMP
059300180704                 where mq_msg_id = :Buffer_CorID;
059400180709
059500180709                 If SqlCode <> 0 and SqlCode <> 100;
059600180710                    Clear ErrorDS;
059700180709                    PROGRAMNAME = PGMNAME;
059800180709                    MSGID       = 'ICC6700';
059900180709                    FILENAME = 'INVOI00001';
060000180709                    OPCODE   = 'Update';
060100180709                    STATUS   = SQLCODE;
060200180709                    EXTMSG='UPDATE- Error occurred for: '
060300180709                           +%trim(Id) + ' ' + %CHAR(Invoice_Date);
060400180711                    ERROR = ERRORDS;
060500180710                    IOERRS(ERRORDS);
060600180709                    MSG_ID = 'RBT8006';
060700180712                    MSG_DTA = 'EDIMQRSPR1: Error occurred while writing' +
060800180712                         '/updating BATCH_CONTROL file for invoice: ' +
060900180712                         %TRIM(Id) + ' ' + %CHAR(Invoice_Date);
061000180709                    EXSR SND_ROBOT;
061100180709                 EndIf;
061200180717
061300180717                 EXSR CrtCFEXML;
061400180706            EndSl;
061500180706
061600000000         // end DO-while loop; MQI failure causes loop to end
061700180706         EndIf;
061800180706       EndDo;
061900180704
062000180706       *INLR = *ON;
062100180706
062200000000       //***************************************************************
062300000000       //                                                              *
062400000000       //   Close the source queue (if it was opened)                  *
062500000000       //                                                              *
062600000000       //***************************************************************
062700180706        If OpenCode <> CCFAIL;
062800180703          Options = CONONE;
062900180703          MQCLOSE(HConn : HObj : Options :  CompletionCode : Reason);
063000000000
063100180703         // report reason, if any, resulting from this call
063200180703          If Reason <> RCNONE;
063300180703
063400180712             Clear ErrorDS;
063500180712             PROGRAMNAME = PGMNAME;
063600180712             MSGID       = 'ICC6900';
063700180712             FILENAME = *Blanks;
063800180712             OPCODE   = 'MQCLOSE';
063900180712             STATUS   = Reason;
064000180712             EXTMSG='GCMS EDI RESPONSE ERROR: ' +
064100180712                    'Unable to close the Queue. ' +
064200180712                    'ReasonCode' + %Char(Reason);
064300180712             ERROR = ERRORDS;
064400180712             IOERRS(ERRORDS);
064500180712             MSG_ID = 'RBT8015';
064600180712             MSG_DTA     = 'EDIMQRSPR1: Unable to close the Queue. ' +
064700180712                           'ReasonCode' + %Char(Reason);
064800180712             EXSR SND_ROBOT;
064900180703          EndIf;
065000000000
065100000000         // end if (OpenCode not CCFAIL)
065200180706        EndIf;
065300000000
065400000000       //***************************************************************
065500000000       //                                                              *
065600000000       //  Disconnect from queue manager (if not previously connected) *
065700000000       //                                                              *
065800000000       //***************************************************************
065900180706        If ConnReason <> RC2002;
066000180703          MQDISC(HConn : CompletionCode : Reason);
066100000000
066200180703       // report reason and stop if it failed
066300180709          If CompletionCode = CCFAIL;
066400180712             Clear ErrorDS;
066500180712             PROGRAMNAME = PGMNAME;
066600180712             MSGID       = 'ICC6900';
066700180712             FILENAME = *Blanks;
066800180712             OPCODE   = 'MQDISC';
066900180712             STATUS   = Reason;
067000180712             EXTMSG='GCMS EDI RESPONSE ERROR: Unable to disconnect MQ. ' +
067100180712                    'ReasonCode' + %Char(Reason);
067200180712             ERROR = ERRORDS;
067300180712             IOERRS(ERRORDS);
067400180712             MSG_ID = 'RBT8015';
067500180712             MSG_DTA  = 'EDIMQRSPR1: Unable to disconnect MQ. ' +
067600180712                        'ReasonCode' + %Char(Reason);
067700180712             EXSR SND_ROBOT;
067800180709          EndIf;
067900180706        EndIf;
068000180703
068100180704       //***************************************************************
068200180704       //   Subroutine to write XML Response to IFS file               *
068300180704       //***************************************************************
068400180703       Begsr MovTmpEDI;
068500180709         fd  = open(%trim($file_path)
068600180709                  : O_WRONLY+O_CREAT+O_TRUNC
068700180709                  : S_IRGRP + S_IWGRP + S_IXGRP +
068800180709                    S_IRUSR + S_IWUSR + S_IXUSR+S_IROTH+S_IXOTH);
068900180709
069000180709         callp close(fd);
069100180709
069200180703         fd = open(%trim($file_path)
069300180703                  :O_WRONLY+O_TEXTDATA);
069400180703
069500180703       // Write xml buffer into IFS
069600180703         callp write(fd:%addr(Buffer): %len(%trim(Buffer)));
069700180703         callp close(fd);
069800180703
069900180703         $New_File = %trim($Arc_Dir) + 'EDIXMLRSP'+ %char(WWDATE) +
070000180703                           %char(WWTIME);
070100180703
070200180703       // Clear old XML log history
070300180703         fd  = open(%trim($New_File)
070400180703                   : O_WRONLY+O_CREAT+O_TRUNC
070500180703                   : S_IRGRP + S_IWGRP + S_IXGRP +
070600180706                   S_IRUSR + S_IWUSR + S_IXUSR + S_IROTH+ S_IXOTH
070700180703                   : 819);
070800180703         callp close(fd);
070900180703
071000180703       // Create EDI xml history
071100180703         fd = open(%trim($New_File)
071200180703                   :O_WRONLY+O_TEXTDATA);
071300180703       // Write EDIXML buffer into IFS archive
071400180703         callp(e) write(fd:%addr(Buffer): %len(%trim(Buffer)));
071500180703         callp close(fd);
071600180703
071700180703       Endsr;
071800180704
071900180704       //***************************************************************
072000180704       //   Subroutine to write CM Error Worklist and Content Manager  *
072100180704       //***************************************************************
072200180704       Begsr CrtCFEXML;
072300180712
072400180712       //   Get Object ID & Control Num from Invoice Control File
072500180712       exec sql
072600180712          select CM_OBJECT_ID, CONTROL_NUM
072700180713          into :ObjId, :SEQNUM
072800180712          from Invoice_Control
072900180712          where mq_msg_id = :Buffer_CorID;
073000180712
073100180712
073200180712          If SqlCode <> 0 and SqlCode <> 100;
073300180712             Clear ErrorDS;
073400180712             PROGRAMNAME = PGMNAME;
073500180712             MSGID       = 'ICC6700';
073600180713             FILENAME = 'INVOI00001';
073700180713             OPCODE   = 'Select';
073800180712             STATUS   = SQLCODE;
073900180712             EXTMSG='INSERT- Error occurred for: '
074000180712                    +%trim(Id) + ' ' + %CHAR(Invoice_Date);
074100180712             ERROR = ERRORDS;
074200180712             IOERRS(ERRORDS);
074300180712             MSG_ID = 'RBT8006';
074400180712             MSG_DTA = 'EDIMQRSPR1: Error occurred while inserting ' +
074500180712                       'Error record into EDIPF5 for Invoice: ' +
074600180712                       %TRIM(Id) + ' ' + %CHAR(Invoice_Date);
074700180712             EXSR SND_ROBOT;
074800180712          EndIf;
074900180712
075000180704      * PART1 -------------------------------------
075100180704          wAPPLID = 'CFE';
075200180710          If Country = 'US' and Response_GCMS = 'D';
075300180704          Else;
075400180704          // Put Object ID in CM Error Worklist
075500180704             WSOPER  = 'StartWorkflow';
075600180716             ErrNote = *Blanks;
075700180718          // ErrNote = WErrNote;
075800180704             RETCODE = '00';
075900180711      // Generate xml for StartWorkflow
076000180706             WSCFEIMPR(wAPPLID: WSOPER: Id: ObjId:
076100180710                       PgmLib: SYSNAME: ErrNote: RETCODE);
076200180704
076300180704             If RETCODE='00';
076400180704                WRETCODE = '00';
076500180710                WSCLIENT(wAPPLID: Id: PgmLib: SYSNAME:
076600180706                         WRETCODE);
076700180711                If WRETCODE = '98';
076800180711                   MSGVAR = 'Error  : ' +
076900180711                            'Adding to worklist for ' +
077000180711                            'invoice number/Objectid: '  +
077100180711                             %TRIMR(Id)+' / '+ %TRIM(OBJID);
077200180711                   EXSR WRITEPF5;
077300180711                EndIf;
077400180704             Endif;
077500180704          Endif;
077600180704
077700180718          CMD = *BLANKS;
077800180718          cmd = 'DLYJOB DLY(2)';
077900180718          QCMDEXC(cmd: %len(cmd));
078000180718
078100180710      * PART2 -------------------------------------
078200180710          WSOPER  = 'AddNotelog';
078300180710          RETCODE = '00';
078400180710
078500180710      * Generate xml for AddNotelog
078600180710          WSCFEIMPR(wAPPLID: WSOPER: Id: ObjId:
078700180710                    PgmLib: SYSNAME: ErrNote: RETCODE);
078800180710
078900180710          If RETCODE='00';
079000180710             WRETCODE = '00';
079100180710             WSCLIENT(wAPPLID: Id: PgmLib: SYSNAME:
079200180710                      WRETCODE);
079300180711             If WRETCODE = '98';
079400180711                MSGVAR = 'Error  : ' +
079500180711                         'Adding to Notelog for ' +
079600180711                         'invoice number/Objectid: '  +
079700180711                         %TRIMR(Id)+' / '+ %TRIM(ObjId);
079800180711                EXSR WRITEPF5;
079900180711             EndIf;
080000180710          EndIf;
080100180704       ENDSR;
080200180704
080300180709      **********************************************************************
080400180709      * Subroutine to send ROBOT error messages
080500180709      **********************************************************************
080600180709       Begsr SND_ROBOT;
080700180709          SNDROBOT(MSG_Q: MSG_ID: MSG_DTA: MSG_TYP);
080800180709       Endsr;
080900180711
081000180711      ***********************************************************************
081100180711      * Write error messages
081200180711      ***********************************************************************
081300180711       Begsr WRITEPF5;
081400180711       //   Get Member Name and Sender Identifier from EDIPF6
081500180711          exec sql
081600180713             select E6MBRNAM, E6SNDIND, E6CTRNUM
081700180713             into :MBRNAME, :SNDIND, :CTRNUM
081800180711             from EDIPF6
081900180713             where E6SEQNUM = :SEQNUM;
082000180711
082100180712          If SqlCode <> 0 and SqlCode <> 100;
082200180712             Clear ErrorDS;
082300180712             PROGRAMNAME = PGMNAME;
082400180712             MSGID       = 'ICC6700';
082500180712             FILENAME = 'EDIPF6';
082600180712             OPCODE   = 'Select';
082700180712             STATUS   = SQLCODE;
082800180712             EXTMSG='SELECT- Error occurred for: '
082900180712                    +%trim(Id) + ' ' + %CHAR(Invoice_Date);
083000180712             ERROR = ERRORDS;
083100180712             IOERRS(ERRORDS);
083200180712             MSG_ID = 'RBT8006';
083300180712             MSG_DTA = 'EDIMQRSPR1: Error occurred while fetching ' +
083400180712                       'Member Name and Sender Identifier for Invoice: ' +
083500180712                       %TRIM(Id) + ' ' + %CHAR(Invoice_Date);
083600180712             EXSR SND_ROBOT;
083700180712          EndIf;
083800180712
083900180713             E5MBRNAM  =  MBRNAME;
084000180713             E5SNDIND  =  SNDIND ;
084100180713             E5CTRNUM  =  CTRNUM ;
084200180713             E5RUNDATE =  WWDATE ;
084300180713             E5RUNTIME =  WWTIME ;
084400180713             E5COUNTRY =  Country;
084500180713             E5INVNO   =  Id     ;
084600180713             E5INVTYP  =  *Blanks;
084700180713             E5MSGID   =  *Blanks;
084800180713             E5MSGVAR  =  MSGVAR ;
084900180713             WRITE     EDIPF5R   ;
085000180711       Endsr;
085100180711
085200180711      /End-Free
