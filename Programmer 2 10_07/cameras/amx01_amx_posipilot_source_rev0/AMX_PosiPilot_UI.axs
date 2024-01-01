MODULE_NAME='AMX_PosiPilot_UI' (DEV vdvPILOT, DEV dvPNL, INTEGER ALL_BTNS[], DEV dvPT_LIST[])
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 09/07/2001 AT: 13:37:55               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/04/2002 AT: 08:49:32         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 09/07/2001                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

(***********************************************************)
(* System Type : Netlinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT


VER = '1.00'


(*** vdvPILOT CHANNELS USED ***)
PILOT_IRIS_OPEN     = 221
PILOT_IRIS_CLOSE    = 222
PILOT_SETUP_MODE    = 240
PILOT_MUX_CAMERAS   = 241
PILOT_DEBUG         = 249
PILOT_CALIBRATED    = 250
PILOT_JS_PAN_BUSY   = 251
PILOT_JS_TILT_BUSY  = 252
PILOT_JS_ZOOM_BUSY  = 253
PILOT_JS_FOCUS_BUSY = 254
PILOT_JS_IRIS_BUSY  = 255


(*** AXB-PT10 CHANNELS USED ***)
PT_AVAILABLE        = 60
PT_REV_PAN          = 61
PT_REV_TILT         = 62
PT_REV_ZOOM         = 63
PT_REV_FOCUS        = 64
PT_REV_IRIS         = 65
PT_LENS_IS_SPEED    = 66
PT_DEBUG            = 69
PT_IRIS_AUTO        = 70
PT_IRIS_OPEN        = 71
PT_IRIS_CLOSE       = 72


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE


(*** CAMERA SELECTION ***)
VOLATILE INTEGER CAM_SELECT


(*** CAMERA PRESET SELECT ***)
VOLATILE INTEGER NEW_SHOT
VOLATILE INTEGER TEMP_SHOT


(*** MODE A,B,C ***)
INTEGER CAM_MULTIPLIER = 1
INTEGER PST_MULTIPLIER = 1


(*** MISC ***)
VOLATILE CAM_IDX
VOLATILE BTN_IDX


(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)


(*************************)
(* PARSE MODULE COMMANDS *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'PARSE PILOT COMMANDS' (CHAR CMD[])
{
  SELECT
  {
(**********************)
(*** PILOT: VERSION ***)
(**********************)
    ACTIVE(FIND_STRING(CMD,"'VERSION'",1)) :
    {
      SEND_STRING 0,"'AMX_PosiPilot_UI - VER',VER"
    }
  }
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START


(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT


(*---------------------------------------------------------*)
(*---------------------------------------------------------*)
DATA_EVENT[vdvPILOT]
{
  ONLINE :
  {
    [vdvPILOT,PILOT_MUX_CAMERAS] = (LENGTH_ARRAY(dvPT_LIST) > 6)
  }
  COMMAND :
  {
    CALL 'PARSE PILOT COMMANDS' (UPPER_STRING(DATA.TEXT))
  }
}


(*---------------------------------------------------------*)
(*---------------------------------------------------------*)
DATA_EVENT[dvPNL]
{
  ONLINE :
  {
  (*** KILL SETUP MODE ***)
    OFF[vdvPILOT,PILOT_SETUP_MODE]

  (*** SHOW/HIDE THE CONFIG BUTTON ***)
    IF(ALL_BTNS[36])
    {
      IF(CAM_SELECT)  SEND_COMMAND dvPNL,"'@SHO',ALL_BTNS[36],1"
      ELSE            SEND_COMMAND dvPNL,"'@SHO',ALL_BTNS[36],0"
    }

  (*** SHOW/HIDE THE MORE-CAMERAS BUTTON ***)
    IF(ALL_BTNS[15])
    {
      IF([vdvPILOT,PILOT_MUX_CAMERAS])   SEND_COMMAND dvPNL,"'@SHO',ALL_BTNS[15],1"
      ELSE                               SEND_COMMAND dvPNL,"'@SHO',ALL_BTNS[15],0"
    }

(*** CAMERA NUMBERS ***)
    IF(ALL_BTNS[9])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[9] ,ITOA(((CAM_MULTIPLIER-1)*6)+1)"
    IF(ALL_BTNS[10]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[10],ITOA(((CAM_MULTIPLIER-1)*6)+2)"
    IF(ALL_BTNS[11]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[11],ITOA(((CAM_MULTIPLIER-1)*6)+3)"
    IF(ALL_BTNS[12]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[12],ITOA(((CAM_MULTIPLIER-1)*6)+4)"
    IF(ALL_BTNS[13]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[13],ITOA(((CAM_MULTIPLIER-1)*6)+5)"
    IF(ALL_BTNS[14]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[14],ITOA(((CAM_MULTIPLIER-1)*6)+6)"

(*** PRESET NUMBERS ***)
    IF(ALL_BTNS[3])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[3],ITOA(((PST_MULTIPLIER-1)*6)+1)"
    IF(ALL_BTNS[4])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[4],ITOA(((PST_MULTIPLIER-1)*6)+2)"
    IF(ALL_BTNS[5])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[5],ITOA(((PST_MULTIPLIER-1)*6)+3)"
    IF(ALL_BTNS[6])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[6],ITOA(((PST_MULTIPLIER-1)*6)+4)"
    IF(ALL_BTNS[7])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[7],ITOA(((PST_MULTIPLIER-1)*6)+5)"
    IF(ALL_BTNS[8])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[8],ITOA(((PST_MULTIPLIER-1)*6)+6)"
  }
  OFFLINE :
  {
    OFF[vdvPILOT,PILOT_SETUP_MODE]
    CAM_SELECT = 0
  }
}


(*---------------------------------------------------------*)
(* Multiple camera button.                                 *)
(*---------------------------------------------------------*)
CHANNEL_EVENT[vdvPILOT,PILOT_MUX_CAMERAS]      // MULTIPLE CAMERA MODE
{
  ON :
  {
    IF(ALL_BTNS[15])
      SEND_COMMAND dvPNL,"'@SHO',ALL_BTNS[15],1"
  }
  OFF :
  {
    IF(ALL_BTNS[15])
      SEND_COMMAND dvPNL,"'@SHO',ALL_BTNS[15],0"

    CAM_MULTIPLIER = 1

(*** CAMERA NUMBERS ***)
    IF(ALL_BTNS[9])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[9] ,ITOA(((CAM_MULTIPLIER-1)*6)+1)"
    IF(ALL_BTNS[10]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[10],ITOA(((CAM_MULTIPLIER-1)*6)+2)"
    IF(ALL_BTNS[11]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[11],ITOA(((CAM_MULTIPLIER-1)*6)+3)"
    IF(ALL_BTNS[12]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[12],ITOA(((CAM_MULTIPLIER-1)*6)+4)"
    IF(ALL_BTNS[13]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[13],ITOA(((CAM_MULTIPLIER-1)*6)+5)"
    IF(ALL_BTNS[14]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[14],ITOA(((CAM_MULTIPLIER-1)*6)+6)"
  }
}


(*---------------------------------------------------------*)
(*---------------------------------------------------------*)
BUTTON_EVENT[dvPNL,ALL_BTNS]
{
  PUSH :
  {
(***  GET BUTTON INDEX ***)
    BTN_IDX = GET_LAST(ALL_BTNS)

    SWITCH (BTN_IDX)
    {
(***************************)
(*** PRESET STORE/RECALL ***)
(***************************)
      CASE 1 :                    //    PRESET RECALL
      {
        IF(NEW_SHOT && CAM_SELECT)
        {
          TO[dvPNL,ALL_BTNS[1]]
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'RP',ITOA(NEW_SHOT)"
          NEW_SHOT = 0
        }
      }
      CASE 2 :                    //    PRESET STORE
      {
        IF(CAM_SELECT && NEW_SHOT)
        {
          TO[dvPNL,ALL_BTNS[2]]
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'SP',ITOA(NEW_SHOT)"
          NEW_SHOT = 0
        }
      }
(*********************)
(*** PRESET SELECT ***)
(*********************)
      CASE 3 :                    //    PRESET 1
      CASE 4 :                    //    PRESET 2
      CASE 5 :                    //    PRESET 3
      CASE 6 :                    //    PRESET 4
      CASE 7 :                    //    PRESET 5
      CASE 8 :                    //    PRESET 6
      {
        IF(CAM_SELECT)
        {
          TEMP_SHOT = (BTN_IDX-2) + ((PST_MULTIPLIER-1) * 6)  (* 1-24 *)

          IF(TEMP_SHOT = NEW_SHOT)
            NEW_SHOT = 0
          ELSE
            NEW_SHOT = TEMP_SHOT
        }
      }
(**********************)
(*** CAMERA SELECTS ***)
(**********************)
      CASE  9 :                    //    CAM 1
      CASE 10 :                    //    CAM 2
      CASE 11 :                    //    CAM 3
      CASE 12 :                    //    CAM 4
      CASE 13 :                    //    CAM 5
      CASE 14 :                    //    CAM 6
      {
        CAM_IDX = (BTN_IDX-8) + ((CAM_MULTIPLIER-1) * 6)  (* 1-18 *)

        IF(CAM_IDX = CAM_SELECT)      // DESELECT
        {
          CAM_SELECT = 0
          NEW_SHOT = 0

        (*** HIDE THE CONFIG BUTTON ***)
          IF(ALL_BTNS[36])
            SEND_COMMAND dvPNL,"'@SHO',ALL_BTNS[36],0"
        }
        ELSE                          // SELECT
        {
        (*** IF AVAILABLE ***)
          IF([dvPT_LIST[CAM_IDX],PT_AVAILABLE])
          {
            CAM_SELECT = CAM_IDX

          (*** SHOW THE CONFIG BUTTON ***)
            IF(ALL_BTNS[36])
              SEND_COMMAND dvPNL,"'@SHO',ALL_BTNS[36],1"
          }
          ELSE
          {
            SEND_COMMAND dvPNL,"'ADBEEP'"
            SEND_COMMAND dvPNL,"'PAGE-PROMPT_CAMERA_OFFLINE'"
          }
        }
      }
(**************************)
(*** PILOT MODE SELECTS ***)
(**************************)
      CASE 15 :                   //    MORE - CAMERAS
      {
        IF([vdvPILOT,PILOT_MUX_CAMERAS])
        {
          TO[dvPNL,ALL_BTNS[15]]
          CAM_MULTIPLIER = (CAM_MULTIPLIER % 3) + 1
        }

        IF(ALL_BTNS[9])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[9] ,ITOA(((CAM_MULTIPLIER-1)*6)+1)"
        IF(ALL_BTNS[10]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[10],ITOA(((CAM_MULTIPLIER-1)*6)+2)"
        IF(ALL_BTNS[11]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[11],ITOA(((CAM_MULTIPLIER-1)*6)+3)"
        IF(ALL_BTNS[12]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[12],ITOA(((CAM_MULTIPLIER-1)*6)+4)"
        IF(ALL_BTNS[13]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[13],ITOA(((CAM_MULTIPLIER-1)*6)+5)"
        IF(ALL_BTNS[14]) SEND_COMMAND dvPNL,"'!T',ALL_BTNS[14],ITOA(((CAM_MULTIPLIER-1)*6)+6)"
      }
      CASE 16 :                   //    MORE - PRESETS
      {
        TO[dvPNL,ALL_BTNS[16]]

        PST_MULTIPLIER = (PST_MULTIPLIER % 4) + 1

        IF(ALL_BTNS[3])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[3],ITOA(((PST_MULTIPLIER-1)*6)+1)"
        IF(ALL_BTNS[4])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[4],ITOA(((PST_MULTIPLIER-1)*6)+2)"
        IF(ALL_BTNS[5])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[5],ITOA(((PST_MULTIPLIER-1)*6)+3)"
        IF(ALL_BTNS[6])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[6],ITOA(((PST_MULTIPLIER-1)*6)+4)"
        IF(ALL_BTNS[7])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[7],ITOA(((PST_MULTIPLIER-1)*6)+5)"
        IF(ALL_BTNS[8])  SEND_COMMAND dvPNL,"'!T',ALL_BTNS[8],ITOA(((PST_MULTIPLIER-1)*6)+6)"
      }
(************)
(*** IRIS ***)
(************)
      CASE 17 :                   //    IRIS AUTO/MANUAL
      {
        IF(CAM_SELECT)
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'AUTO IRIS-T'"
      }
(***************)
(*** SETUP 1 ***)
(***************)
      CASE 18 :                   // SETUP - REVERSE PAN
      {
        IF(CAM_SELECT)
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'G1 REV-T'"
      }
      CASE 19 :                   // SETUP - REVERSE TILT
      {
        IF(CAM_SELECT)
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'G2 REV-T'"
      }
      CASE 20 :                   // SETUP - REVERSE ZOOM
      {
        IF(CAM_SELECT)
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'G3 REV-T'"
      }
      CASE 21 :                   // SETUP - REVERSE FOCUS
      {
        IF(CAM_SELECT)
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'G4 REV-T'"
      }
      CASE 22 :                   // SETUP - REVERSE IRIS
      {
        IF(CAM_SELECT)
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'G5 REV-T'"
      }
      CASE 23 :                   // SETUP - LENS=SPEED
      {
        IF(CAM_SELECT)
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'LENS-S'"
      }
      CASE 24 :                   // SETUP - LENS=POSITIONAL
      {
        IF(CAM_SELECT)
          SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'LENS-P'"
      }
      CASE 25 :                   // SETUP - RESET CAMERA
      {
        TO[dvPNL,ALL_BTNS[25]]
        SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'RESET'"
      }
      CASE 26 :                   // SETUP - CALIBRATE
      {
        TO[dvPNL,ALL_BTNS[26]]
        SEND_COMMAND vdvPILOT,"'CALIBRATE'"
      }
(***************)
(*** SETUP 2 ***)
(***************)
      CASE 27 :                   // SETUP - CLEAR UP
      {
        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'CLEAR LIMIT UP'"
      }
      CASE 28 :                   // SETUP - CLEAR DOWN
      {
        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'CLEAR LIMIT DOWN'"
      }
      CASE 29 :                   // SETUP - CLEAR LEFT
      {
        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'CLEAR LIMIT LEFT'"
      }
      CASE 30 :                   // SETUP - CLEAR RIGHT
      {
        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'CLEAR LIMIT RIGHT'"
      }
      CASE 31 :                   // SETUP - SET UP
      {
        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'SET LIMIT UP'"
      }
      CASE 32 :                   // SETUP - SET DOWN
      {
        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'SET LIMIT DOWN'"
      }
      CASE 33 :                   // SETUP - SET LEFT
      {
        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'SET LIMIT LEFT'"
      }
      CASE 34 :                   // SETUP - SET RIGHT
      {
        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'SET LIMIT RIGHT'"
      }
      CASE 35 :                   // SETUP - SET/GOTO HOME
      {
      }
      CASE 36 :                   // CONFIG (ENTER SETUP)
      { // NOTE: PASSWORD PAGEFLIP, SET THIS ON RELEASE (AFTER CORRECT PASSWORD ENTERED)
      }
      CASE 37 :                   // CONFIG (EXIT  SETUP)
      {
        OFF[vdvPILOT,PILOT_SETUP_MODE]
      }
      CASE 38 :                   // FB ONLY (JS ARE INITIALIZING)
      {
      }
    }
  }
  RELEASE :
  {
(***  GET BUTTON INDEX ***)
    BTN_IDX = GET_LAST(ALL_BTNS)

    SWITCH (BTN_IDX)
    {
(***************)
(*** SETUP 2 ***)
(***************)
      CASE 35 :                   // SETUP - SET/GOTO HOME
      {
        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'HOME'"
      }
      CASE 36 :                   // CONFIG (ENTER SETUP)
      {
        ON [vdvPILOT,PILOT_SETUP_MODE]
      }
    }
  }
  HOLD[20] :
  {
(***  GET BUTTON INDEX ***)
    BTN_IDX = GET_LAST(ALL_BTNS)

    SWITCH (BTN_IDX)
    {
(***************)
(*** SETUP 2 ***)
(***************)
      CASE 35 :                   // SETUP - SET/GOTO HOME
      {
        SEND_COMMAND dvPNL,'ADBEEP'

        IF(CAM_SELECT)
          SEND_COMMAND dvPT_LIST[CAM_SELECT],"'SET HOME'"
      }
    }
  }
}


(*---------------------------------------------------------*)
(*---------------------------------------------------------*)
CHANNEL_EVENT[dvPT_LIST,PT_AVAILABLE]
{
  OFF :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

  (*** IF MY SELECTED CAMERA IS NO LONGER AVAILABLE ***)
    IF(CAM_SELECT = CAM_IDX)
    {
      CAM_SELECT = 0

    (*** HIDE THE CONFIG BUTTON ***)
      IF(ALL_BTNS[36])
        SEND_COMMAND dvPNL,"'@SHO',ALL_BTNS[36],0"
    }
  }
}


(*---------------------------------------------------------*)
(*---------------------------------------------------------*)
CHANNEL_EVENT[vdvPILOT,PILOT_IRIS_OPEN]
CHANNEL_EVENT[vdvPILOT,PILOT_IRIS_CLOSE]
{
  ON :
  {
    IF(CAM_SELECT = 0) 
    {
    }
    ELSE IF(CHANNEL.CHANNEL = PILOT_IRIS_OPEN)
    {
      ON [dvPT_LIST[CAM_SELECT],PT_IRIS_OPEN] 
      OFF[dvPT_LIST[CAM_SELECT],PT_IRIS_CLOSE]   // THIS FB SO ALL PILOTS HAVE IRIS FB FOR THIS CAMERA
      SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'IRIS OPEN'"
    }
    ELSE
    {
      ON [dvPT_LIST[CAM_SELECT],PT_IRIS_CLOSE]
      OFF[dvPT_LIST[CAM_SELECT],PT_IRIS_OPEN]    // THIS FB SO ALL PILOTS HAVE IRIS FB FOR THIS CAMERA
      SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'IRIS CLOSE'"
    }
  }
  OFF :
  {
    IF(CAM_SELECT = 0) 
    {
    }
    ELSE
    {
      OFF[dvPT_LIST[CAM_SELECT],PT_IRIS_CLOSE]
      OFF[dvPT_LIST[CAM_SELECT],PT_IRIS_OPEN]    // THIS FB SO ALL PILOTS HAVE IRIS FB FOR THIS CAMERA
      SEND_COMMAND vdvPILOT,"'C',ITOA(CAM_SELECT),'IRIS STOP'"
    }
  }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


(*---------------------------------------------------------*)
(*** PANEL FEEDBACK ***                                    *)
(*---------------------------------------------------------*)

(*** PILOT INITIALIZING ************************************)
[dvPNL,ALL_BTNS[38]] = (![vdvPILOT,PILOT_CALIBRATED])


(*** CAMERA SELECTS ****************************************)
SELECT
{
  ACTIVE(CAM_MULTIPLIER = 1) :
  {
    [dvPNL,ALL_BTNS[9]]  = (CAM_SELECT = 1)
    [dvPNL,ALL_BTNS[10]] = (CAM_SELECT = 2)
    [dvPNL,ALL_BTNS[11]] = (CAM_SELECT = 3)
    [dvPNL,ALL_BTNS[12]] = (CAM_SELECT = 4)
    [dvPNL,ALL_BTNS[13]] = (CAM_SELECT = 5)
    [dvPNL,ALL_BTNS[14]] = (CAM_SELECT = 6)
  }
  ACTIVE(CAM_MULTIPLIER = 2) :
  {
    [dvPNL,ALL_BTNS[9]]  = (CAM_SELECT = 7)
    [dvPNL,ALL_BTNS[10]] = (CAM_SELECT = 8)
    [dvPNL,ALL_BTNS[11]] = (CAM_SELECT = 9)
    [dvPNL,ALL_BTNS[12]] = (CAM_SELECT = 10)
    [dvPNL,ALL_BTNS[13]] = (CAM_SELECT = 11)
    [dvPNL,ALL_BTNS[14]] = (CAM_SELECT = 12)
  }
  ACTIVE(CAM_MULTIPLIER = 3) :
  {
    [dvPNL,ALL_BTNS[9]]  = (CAM_SELECT = 13)
    [dvPNL,ALL_BTNS[10]] = (CAM_SELECT = 14)
    [dvPNL,ALL_BTNS[11]] = (CAM_SELECT = 15)
    [dvPNL,ALL_BTNS[12]] = (CAM_SELECT = 16)
    [dvPNL,ALL_BTNS[13]] = (CAM_SELECT = 17)
    [dvPNL,ALL_BTNS[14]] = (CAM_SELECT = 18)
  }
  ACTIVE(1) :
  {
    [dvPNL,ALL_BTNS[9]]  = (0)
    [dvPNL,ALL_BTNS[10]] = (0)
    [dvPNL,ALL_BTNS[11]] = (0)
    [dvPNL,ALL_BTNS[12]] = (0)
    [dvPNL,ALL_BTNS[13]] = (0)
    [dvPNL,ALL_BTNS[14]] = (0)
  }
}



(*** PRESET SELECTS ****************************************)
SELECT
{
  ACTIVE(PST_MULTIPLIER = 1) :
  {
    [dvPNL,ALL_BTNS[3]] = (NEW_SHOT=1)
    [dvPNL,ALL_BTNS[4]] = (NEW_SHOT=2)
    [dvPNL,ALL_BTNS[5]] = (NEW_SHOT=3)
    [dvPNL,ALL_BTNS[6]] = (NEW_SHOT=4)
    [dvPNL,ALL_BTNS[7]] = (NEW_SHOT=5)
    [dvPNL,ALL_BTNS[8]] = (NEW_SHOT=6)
  }
  ACTIVE(PST_MULTIPLIER = 2) :
  {
    [dvPNL,ALL_BTNS[3]] = (NEW_SHOT=7)
    [dvPNL,ALL_BTNS[4]] = (NEW_SHOT=8)
    [dvPNL,ALL_BTNS[5]] = (NEW_SHOT=9)
    [dvPNL,ALL_BTNS[6]] = (NEW_SHOT=10)
    [dvPNL,ALL_BTNS[7]] = (NEW_SHOT=11)
    [dvPNL,ALL_BTNS[8]] = (NEW_SHOT=12)
  }
  ACTIVE(PST_MULTIPLIER = 3) :
  {
    [dvPNL,ALL_BTNS[3]] = (NEW_SHOT=13)
    [dvPNL,ALL_BTNS[4]] = (NEW_SHOT=14)
    [dvPNL,ALL_BTNS[5]] = (NEW_SHOT=15)
    [dvPNL,ALL_BTNS[6]] = (NEW_SHOT=16)
    [dvPNL,ALL_BTNS[7]] = (NEW_SHOT=17)
    [dvPNL,ALL_BTNS[8]] = (NEW_SHOT=18)
  }
  ACTIVE(PST_MULTIPLIER = 4) :
  {
    [dvPNL,ALL_BTNS[3]] = (NEW_SHOT=19)
    [dvPNL,ALL_BTNS[4]] = (NEW_SHOT=20)
    [dvPNL,ALL_BTNS[5]] = (NEW_SHOT=21)
    [dvPNL,ALL_BTNS[6]] = (NEW_SHOT=22)
    [dvPNL,ALL_BTNS[7]] = (NEW_SHOT=23)
    [dvPNL,ALL_BTNS[8]] = (NEW_SHOT=24)
  }
  ACTIVE(1) :
  {
    [dvPNL,ALL_BTNS[3]] = (0)
    [dvPNL,ALL_BTNS[4]] = (0)
    [dvPNL,ALL_BTNS[5]] = (0)
    [dvPNL,ALL_BTNS[6]] = (0)
    [dvPNL,ALL_BTNS[7]] = (0)
    [dvPNL,ALL_BTNS[8]] = (0)
  }
}


(*** CAMERA CONFIGURATIONS *********************************)
IF(CAM_SELECT)
{
  [dvPNL,ALL_BTNS[18]] = [dvPT_LIST[CAM_SELECT],PT_REV_PAN]         // REVERSE PAN
  [dvPNL,ALL_BTNS[19]] = [dvPT_LIST[CAM_SELECT],PT_REV_TILT]        // REVERSE TILT
  [dvPNL,ALL_BTNS[20]] = [dvPT_LIST[CAM_SELECT],PT_REV_ZOOM]        // REVERSE ZOOM
  [dvPNL,ALL_BTNS[21]] = [dvPT_LIST[CAM_SELECT],PT_REV_FOCUS]       // REVERSE FOCUS
  [dvPNL,ALL_BTNS[22]] = [dvPT_LIST[CAM_SELECT],PT_REV_IRIS]        // REVERSE IRIS
  [dvPNL,ALL_BTNS[23]] =  [dvPT_LIST[CAM_SELECT],PT_LENS_IS_SPEED]  // LENS = SPEED
  [dvPNL,ALL_BTNS[24]] =(![dvPT_LIST[CAM_SELECT],PT_LENS_IS_SPEED]) // LENS = POSITIONAL
}
ELSE
{
  [dvPNL,ALL_BTNS[18]] = (0)
  [dvPNL,ALL_BTNS[19]] = (0)
  [dvPNL,ALL_BTNS[20]] = (0)
  [dvPNL,ALL_BTNS[21]] = (0)
  [dvPNL,ALL_BTNS[22]] = (0)
  [dvPNL,ALL_BTNS[23]] = (0)
  [dvPNL,ALL_BTNS[24]] = (0)
}


(*** IRIS **************************************************)
IF(CAM_SELECT)
{
  [dvPNL,ALL_BTNS[17]] = (![dvPT_LIST[CAM_SELECT],PT_IRIS_AUTO])   // IRIS MANUAL
}
ELSE
{
  [dvPNL,ALL_BTNS[17]] = (0)
}


(*---------------------------------------------------------*)
(*** MODULE FEEDBACK ***                                   *)
(*---------------------------------------------------------*)
(*** CAMERA SELECT *****************************************)
[vdvPILOT,1]  = (CAM_SELECT =  1)
[vdvPILOT,2]  = (CAM_SELECT =  2)
[vdvPILOT,3]  = (CAM_SELECT =  3)
[vdvPILOT,4]  = (CAM_SELECT =  4)
[vdvPILOT,5]  = (CAM_SELECT =  5)
[vdvPILOT,6]  = (CAM_SELECT =  6)
[vdvPILOT,7]  = (CAM_SELECT =  7)
[vdvPILOT,8]  = (CAM_SELECT =  8)
[vdvPILOT,9]  = (CAM_SELECT =  9)
[vdvPILOT,10] = (CAM_SELECT = 10)
[vdvPILOT,11] = (CAM_SELECT = 11)
[vdvPILOT,12] = (CAM_SELECT = 12)
[vdvPILOT,13] = (CAM_SELECT = 13)
[vdvPILOT,14] = (CAM_SELECT = 14)
[vdvPILOT,15] = (CAM_SELECT = 15)
[vdvPILOT,16] = (CAM_SELECT = 16)
[vdvPILOT,17] = (CAM_SELECT = 17)
[vdvPILOT,18] = (CAM_SELECT = 18)



(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

