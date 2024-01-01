PROGRAM_NAME='HITACHI, HVC10, RS-232, BASIC, 1-95, BA'
(*   DATE:05/20/99    TIME:15:39:22    *)
(***********************************************************)
(* The following code block is provided as a guide to      *)
(* programming the device(s) listed above. This is a       *)
(* sample only, and will most likely require modification  *)
(* to be integrated into a master program.                 *)
(*                                                         *)
(* Device-specific protocols should be obtained directly   *)
(* from the equipment manufacturer to ensure compliance    *)
(* with the most current versions. Within the limits       *)
(* imposed by any non-disclosure agreements, AMX will      *)
(* provide protocols upon request.                         *)
(*                                                         *)
(* If further programming assistance is required, please   *)
(* contact your AMX customer support team.                 *)
(*                                                         *)
(***********************************************************)
(* GENERAL FUNCTION LIST -                                 *)
(*   AUTO WHITE & BLACK, COLOR BARS, GAIN, GAMMA, H.PHASE, *)
(*   IRIS, MASTER BLACK, SHUTTER, WHITE BALANCE            *)
(*                                                         *)
(***********************************************************)
(* NOTES:                                                  *)
(*  -- WHITE BALANCE MUST BE SET TO "MEMORY" BEFORE AUTO   *)
(*     WHITE CAN BE TURNED ON;                             *)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

CAMERA = 1                   (* AXC-232: HITACHI HV-C10 *)
PANEL  = 128

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(* BYTE #1 *)
IRIS_AUTO   = $80
IRIS_REMOTE = $C0
IRIS_MANUAL = $40
W_BAL_PRE   = $30
W_BAL_AUTO  = $20
W_BAL_MEM   = $10
BARS_OFF    = $04
BARS_ON     = $00
GAIN_0_DB   = $02
GAIN_9_DB   = $03
GAIN_18_DB  = $01

(* BYTE #2 *)
TEST_ON     = $40
TEST_OFF    = $00
GAMMA_ON    = $00
GAMMA_OFF   = $20
DETAIL_HIGH = $0C
DETAIL_NORM = $00
DETAIL_LOW  = $04
DETAIL_OFF  = $08

SC_0        = $00
SC_90       = $03
SC_180      = $01
SC_270      = $02

(* BYTE #3 *)
CHECK_ON    = $08
SHUTTER_ON  = $04
AUTO_WHITE  = $02
AUTO_BLACK  = $01
ALL_OFF     = $00

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

CAMERA_STATUS[15]
LEVEL_MODE
LEVEL_BUTTON

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*           SUBROUTINE DEFINITIONS GO BELOW               *)
(***********************************************************)

(*                                                         *)
(* BYTE/BITS  FUNCTION        DEFAULT VALUE                *)
(*   1 / 1-2  LENS IRIS MODE    10XX XXXX                  *)
(*       3-4  WHITE BALANCE     XX10 XXXX                  *)
(*       5    RESERVED          XXXX 0XXX                  *)
(*       6    BAR/CAMERA        XXXX X1XX                  *)
(*       7-8  GAIN              XXXX XX10                  *)
(*   2 / 1    RESERVED          0XXX XXXX                  *)
(*       2    TEST ON/OFF       X0XX XXXX                  *)
(*       3    GAMMA OFF/ON      XX1X XXXX                  *)
(*       4    RESERVED          XXX0 XXXX                  *)
(*       5-6  DTL               XXXX 11XX                  *)
(*       7-8  SC COARSE         XXXX XX00                  *)
(*   3 / 1-4  RESERVED          0000 XXXX                  *)
(*       5    CHECK             XXXX 0XXX                  *)
(*       6    SHUTTER           XXXX X0XX                  *)
(*       7    AUTO WHITE        XXXX XX0X                  *)
(*       8    AUTO BLACK        XXXX XXX0                  *)
(*   4        FUTURE USE        0000 0000 ($00)            *)
(*   5        R BLACK LEVEL     0000 0000 ($00)            *)
(*   6        B BLACK LEVEL     0000 0000 ($00)            *)
(*   7        M BLACK LEVEL     0000 0000 ($00)            *)
(*   8        R GAIN LEVEL      0000 0000 ($00)            *)
(*   9        B GAIN LEVEL      0000 0000 ($00)            *)
(*  10        SC PHASE LEVEL    1000 0000 ($80)            *)
(*  11        H PHASE LEVEL     1000 0000 ($80)            *)
(*  12        IRIS LEVEL        1000 0000 ($80)            *)
(* 13-15      FUTURE USE        0000 0000 ($00)            *)
(*  16        PARITY                                       *)
(*                                                         *)
DEFINE_CALL 'SEND HITACHI' (CARD,CMD[15])
LOCAL_VAR CHKSUM
{
  CHKSUM = (CMD[1]  ^ CMD[2]  ^ CMD[3]  ^ CMD[4]  ^ CMD[5] ^
            CMD[6]  ^ CMD[7]  ^ CMD[8]  ^ CMD[9]  ^ CMD[10] ^
            CMD[11] ^ CMD[12] ^ CMD[13] ^ CMD[14] ^ CMD[15])
  SEND_STRING CARD,"CMD,CHKSUM"
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(* FOR INITIAL (DEFAULT) VALUES, SEE ABOVE. *)
CAMERA_STATUS = "$A6,$2C,$00,$00,$00,$00,$00,$00,
                 $00,$80,$80,$80,$00,$00,$00"

LEVEL_MODE = 0

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(*********************** COLOR BARS ************************)
PUSH[PANEL,01]                         (* BARS *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $FB) BOR BARS_ON
[PANEL,01] = (CAMERA_STATUS[1] BAND $04) = BARS_ON

PUSH[PANEL,02]                         (* CAMERA *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $FB) BOR BARS_OFF
[PANEL,02] = (CAMERA_STATUS[1] BAND $04) = BARS_OFF

(************************ TEST MODE ************************)
PUSH[PANEL,03]                         (* ON *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $BF) BOR TEST_ON
[PANEL,03] = (CAMERA_STATUS[2] BAND $40) = TEST_ON

PUSH[PANEL,04]                         (* OFF *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $BF) BOR TEST_OFF
[PANEL,04] = (CAMERA_STATUS[2] BAND $40) = TEST_OFF

(************************** GAMMA **************************)
PUSH[PANEL,05]                         (* ON *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $DF) BOR GAMMA_ON
[PANEL,05] = (CAMERA_STATUS[2] BAND $20) = GAMMA_ON

PUSH[PANEL,06]                         (* OFF *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $DF) BOR GAMMA_OFF
[PANEL,06] = (CAMERA_STATUS[2] BAND $20) = GAMMA_OFF

(************************** IRIS ***************************)
PUSH[PANEL,11]                         (* AUTO *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $3F) BOR IRIS_AUTO
[PANEL,11] = (CAMERA_STATUS[1] BAND $C0) = IRIS_AUTO

PUSH[PANEL,12]                         (* REMOTE *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $3F) BOR IRIS_REMOTE
[PANEL,12] = (CAMERA_STATUS[1] BAND $C0) = IRIS_REMOTE

PUSH[PANEL,13]                         (* MANUAL *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $3F) BOR IRIS_MANUAL
[PANEL,13] = (CAMERA_STATUS[1] BAND $C0) = IRIS_MANUAL

(************************* DETAIL **************************)
PUSH[PANEL,16]                         (* HIGH *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $F3) BOR DETAIL_HIGH
[PANEL,16] = (CAMERA_STATUS[2] BAND $0C) = DETAIL_HIGH

PUSH[PANEL,17]                         (* LOW *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $F3) BOR DETAIL_LOW
[PANEL,17] = (CAMERA_STATUS[2] BAND $0C) = DETAIL_LOW

PUSH[PANEL,18]                         (* NORMAL *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $F3) BOR DETAIL_NORM
[PANEL,18] = (CAMERA_STATUS[2] BAND $0C) = DETAIL_NORM

PUSH[PANEL,19]                         (* OFF *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $F3) BOR DETAIL_OFF
[PANEL,19] = (CAMERA_STATUS[2] BAND $0C) = DETAIL_OFF

(************************** GAIN ***************************)
PUSH[PANEL,21]                         (* +0 dB *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $FC) BOR GAIN_0_DB
[PANEL,21] = (CAMERA_STATUS[1] BAND $03) = GAIN_0_DB

PUSH[PANEL,22]                         (* +9 dB *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $FC) BOR GAIN_9_DB
[PANEL,22] = (CAMERA_STATUS[1] BAND $03) = GAIN_9_DB

PUSH[PANEL,23]                         (* +18 dB *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $FC) BOR GAIN_18_DB
[PANEL,23] = (CAMERA_STATUS[1] BAND $03) = GAIN_18_DB

(************************ SC COARSE ************************)
PUSH[PANEL,26]                         (* 0 *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $FC) BOR SC_0
[PANEL,26] = (CAMERA_STATUS[2] BAND $03) = SC_0

PUSH[PANEL,27]                         (* 90 *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $FC) BOR SC_90
[PANEL,27] = (CAMERA_STATUS[2] BAND $03) = SC_90

PUSH[PANEL,28]                         (* 180 *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $FC) BOR SC_180
[PANEL,28] = (CAMERA_STATUS[2] BAND $03) = SC_180

PUSH[PANEL,29]                         (* 270 *)
  CAMERA_STATUS[2] = (CAMERA_STATUS[2] BAND $FC) BOR SC_270
[PANEL,29] = (CAMERA_STATUS[2] BAND $03) = SC_270

(********************** WHITE BALANCE **********************)
PUSH[PANEL,31]                         (* PRESET *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $CF) BOR W_BAL_PRE
[PANEL,31] = (CAMERA_STATUS[1] BAND $30) = W_BAL_PRE

PUSH[PANEL,32]                         (* AUTO *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $CF) BOR W_BAL_AUTO
[PANEL,32] = (CAMERA_STATUS[1] BAND $30) = W_BAL_AUTO

PUSH[PANEL,33]                         (* MEMORY *)
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $CF) BOR W_BAL_MEM
[PANEL,33] = (CAMERA_STATUS[1] BAND $30) = W_BAL_MEM

(*********************** AUTO WHITE ************************)
PUSH[PANEL,36]                         (* AUTO WHITE *)
{
  CAMERA_STATUS[1] = (CAMERA_STATUS[1] BAND $CF) BOR W_BAL_MEM
  CAMERA_STATUS[3] = (CAMERA_STATUS[3] BAND $FD) BOR AUTO_WHITE
}
RELEASE[PANEL,36]
  CAMERA_STATUS[3] = (CAMERA_STATUS[3] BAND $FD) BOR ALL_OFF
[PANEL,36] = (CAMERA_STATUS[3] BAND $02) = AUTO_WHITE

(*********************** AUTO BLACK ************************)
PUSH[PANEL,37]                         (* AUTO BLACK *)
  CAMERA_STATUS[3] = (CAMERA_STATUS[3] BAND $FE) BOR AUTO_BLACK
RELEASE[PANEL,37]
  CAMERA_STATUS[3] = (CAMERA_STATUS[3] BAND $FE) BOR ALL_OFF
[PANEL,37] = (CAMERA_STATUS[3] BAND $01) = AUTO_BLACK

(************************* SHUTTER *************************)
PUSH[PANEL,38]                         (* SHUTTER *)
  CAMERA_STATUS[3] = (CAMERA_STATUS[3] BAND $FB) BOR SHUTTER_ON
RELEASE[PANEL,38]
  CAMERA_STATUS[3] = (CAMERA_STATUS[3] BAND $FB) BOR ALL_OFF
[PANEL,38] = (CAMERA_STATUS[3] BAND $04) = SHUTTER_ON

(************************** CHECK **************************)
PUSH[PANEL,39]                         (* CHECK *)
  CAMERA_STATUS[3] = (CAMERA_STATUS[3] BAND $F7) BOR CHECK_ON
RELEASE[PANEL,39]
  CAMERA_STATUS[3] = (CAMERA_STATUS[3] BAND $F7) BOR ALL_OFF
[PANEL,39] = (CAMERA_STATUS[3] BAND $08) = CHECK_ON

(************************* LEVELS **************************)

PUSH[PANEL,41]                         (* R BLACK *)
PUSH[PANEL,42]                         (* B BLACK *)
PUSH[PANEL,43]                         (* M BLACK *)
PUSH[PANEL,44]                         (* B GAIN *)
PUSH[PANEL,45]                         (* R GAIN *)
PUSH[PANEL,46]                         (* SC PHASE *)
PUSH[PANEL,47]                         (* H PHASE *)
PUSH[PANEL,48]                         (* IRIS *)
{
  IF (LEVEL_MODE = PUSH_CHANNEL - 36)
  {
    LEVEL_MODE = 0
    SEND_LEVEL PANEL,1,0
  }
  ELSE
    LEVEL_MODE = PUSH_CHANNEL - 36
}
[PANEL,41] = (LEVEL_MODE = 5)
[PANEL,42] = (LEVEL_MODE = 6)
[PANEL,43] = (LEVEL_MODE = 7)
[PANEL,44] = (LEVEL_MODE = 8)
[PANEL,45] = (LEVEL_MODE = 9)
[PANEL,46] = (LEVEL_MODE = 10)
[PANEL,47] = (LEVEL_MODE = 11)
[PANEL,48] = (LEVEL_MODE = 12)

IF (LEVEL_MODE)
{
  PUSH[PANEL,49]                       (* UP *)
  PUSH[PANEL,50]                       (* DOWN *)
    LEVEL_BUTTON = PUSH_CHANNEL - 48
  RELEASE[PANEL,49]
  RELEASE[PANEL,50]
    LEVEL_BUTTON = 0

  IF (LEVEL_BUTTON = 1)                (* UP BUTTON STILL PUSHED *)
  {
    IF (LEVEL_MODE <= 9)
    {
      IF (CAMERA_STATUS[LEVEL_MODE] >= 254)
        CAMERA_STATUS[LEVEL_MODE] = 0
      ELSE IF (CAMERA_STATUS[LEVEL_MODE] <> 126)
        CAMERA_STATUS[LEVEL_MODE] = CAMERA_STATUS[LEVEL_MODE] + 2
    }
    ELSE IF (CAMERA_STATUS[LEVEL_MODE] <= 126)
      CAMERA_STATUS[LEVEL_MODE] = CAMERA_STATUS[LEVEL_MODE] + 1
  }
  ELSE IF (LEVEL_BUTTON = 2)           (* DOWN BUTTON STILL PUSHED *)
  {
    IF (LEVEL_MODE <= 9)
    {
      IF (CAMERA_STATUS[LEVEL_MODE] = 0)
        CAMERA_STATUS[LEVEL_MODE] = 254
      ELSE IF (CAMERA_STATUS[LEVEL_MODE] <> 128)
        CAMERA_STATUS[LEVEL_MODE] = CAMERA_STATUS[LEVEL_MODE] - 2
    }
    ELSE IF (CAMERA_STATUS[LEVEL_MODE] > 0)
      CAMERA_STATUS[LEVEL_MODE] = CAMERA_STATUS[LEVEL_MODE] - 1
  }

  IF (LEVEL_MODE <= 9)
    SEND_LEVEL PANEL,1,(CAMERA_STATUS[LEVEL_MODE]+128)
  ELSE IF (CAMERA_STATUS[LEVEL_MODE] = 128)
    SEND_LEVEL PANEL,1,255
  ELSE
    SEND_LEVEL PANEL,1,(CAMERA_STATUS[LEVEL_MODE]*2)
}

(***********************************************************)

WAIT 4 'HITACHI'
  CALL 'SEND HITACHI' (CAMERA,CAMERA_STATUS)

IF (PUSH_DEVICE = PANEL)
{
  CANCEL_WAIT 'HITACHI'
  CALL 'SEND HITACHI' (CAMERA,CAMERA_STATUS)
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

