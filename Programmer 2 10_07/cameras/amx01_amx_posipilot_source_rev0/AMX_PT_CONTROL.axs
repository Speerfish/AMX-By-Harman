MODULE_NAME='AMX_PT_CONTROL' (DEV vdvPILOT_LIST[], DEV dvPT_LIST[])
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 08/21/2001 AT: 07:20:46               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/14/2003 AT: 10:58:45         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 1.01                                *)
(*  REVISION DATE: 04/14/2003                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*  -ZOOM_TELE,ZOOM_WIDE FB was reversed from level 9.     *)
(*  -Added position level commands to sync up to other     *)
(*   modules to this level.                                *)
(*     --'CxZOOM POS-y'                                    *)
(*     --'CxFOCUS POS-y'                                   *)
(*     --'CxIRIS POS-y'                                    *)
(***********************************************************)
(*!!FILE REVISION: Rev 1.00                                *)
(*  REVISION DATE: 02/23/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)
(* System Type : Netlinx                                   *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT


VER = '1.01'


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


(*** MISC POSIPILOT STUFF ***************************************************)
MAX_PILOT   = 5
MAX_CAMERA  = 18
MAX_PSET    = 128


(*** AMX CAMERA CHANNELS USED ***********************************************)
(* CAMERA (HIGH CURRENT) *)
PAN_LEFT       =  35      (* (AT CURRENT SPEED) *)
PAN_RIGHT      =  31      (* (AT CURRENT SPEED) *)
TILT_UP        =  36      (* (AT CURRENT SPEED) *)
TILT_DOWN      =  32      (* (AT CURRENT SPEED) *)

(* LENS (LOW CURRENT / POSITIONAL) *)
ZOOM_WIDE  =  3           (* +V (AT CURRENT SPEED) *)
ZOOM_TELE  =  7           (* -V (AT CURRENT SPEED) *)
FOCUS_FAR  =  4           (* +V (AT CURRENT SPEED) *)
FOCUS_NEAR =  8           (* -V (AT CURRENT SPEED) *)
IRIS_CLOSE =  1           (* +V (AT CURRENT SPEED) *)
IRIS_OPEN  =  5           (* -V (AT CURRENT SPEED) *)



(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE _sPT_HEAD
{
  INTEGER   PAN_LVL
  INTEGER   TILT_LVL
  INTEGER   ZOOM_LVL
  INTEGER   FOCUS_LVL
  INTEGER   IRIS_LVL
  INTEGER   ZOOM_POS_LVL
  INTEGER   FOCUS_POS_LVL
  INTEGER   IRIS_POS_LVL
  INTEGER   REVERSE_PAN
  INTEGER   REVERSE_TILT
  INTEGER   REVERSE_ZOOM
  INTEGER   REVERSE_FOCUS
  INTEGER   REVERSE_IRIS
  INTEGER   AUTO_IRIS
  INTEGER   LENS_IS_SPEED_MODE
}


STRUCTURE _sPT_PSET
{
  CHAR      PSET_STORED[MAX_PSET]
  INTEGER   ZOOM_POS_PSET[MAX_PSET]
  INTEGER   FOCUS_POS_PSET[MAX_PSET]
}


STRUCTURE _sPILOT
{
  INTEGER   PAN_LVL
  INTEGER   TILT_LVL
  INTEGER   ZOOM_AVG_LVL
  INTEGER   FOCUS_AVG_LVL
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE


(*** CAMERA LEVELS ***)
VOLATILE _sPT_HEAD sCAMERA[MAX_CAMERA]
VOLATILE INTEGER ZOOM_BUSY_IDX[MAX_CAMERA]
VOLATILE INTEGER FOCUS_BUSY_IDX[MAX_CAMERA]
VOLATILE INTEGER IRIS_BUSY_IDX[MAX_CAMERA]


(*** CAMERA COMMAND STACK ***)
VOLATILE CHAR CAM_INIT_STRING[MAX_CAMERA][500]
VOLATILE CHAR NEXT_CMD[64]


(*** PRESET STUFF ***)
_sPT_PSET sPSET[MAX_CAMERA]


(*** POSIPILOT STUFF ***)
VOLATILE _sPILOT sPILOT[MAX_PILOT]
VOLATILE INTEGER CAM_SELECT[MAX_PILOT]


(*** MISC ***)
VOLATILE PNL_IDX
VOLATILE CAM_IDX
VOLATILE LONG TL_TIMES[1]


(*** FLAG (vdvPILOT): CAMERA (1-18) IS SELECTED *************)
INTEGER ALL_CHN_CAM_SELECT[] =
{
   1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
}


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

(**********************)
(* GET_LAST_JS_DEVICE *)
(***********************************************************)
(* GET_LAST DOESN'T SEEM TO WORK WITH LEVEL EVENTS??       *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_LAST_JS_DEVICE(DEV DVC)
STACK_VAR
  LOOP
{
  FOR(LOOP=1; LOOP<=LENGTH_ARRAY(vdvPILOT_LIST); LOOP++)
  {
    IF(DVC = vdvPILOT_LIST[LOOP])
      RETURN (LOOP)
  }

  SEND_STRING 0,"'AMX_CCS_PT ERROR: PILOT NOT FOUND IN LIST!!'"
  RETURN (MAX_PILOT)
}

(************************)
(* GET_PILOT_CAM_SELECT *)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_PILOT_CAM_SELECT (PNL_PTR)
LOCAL_VAR
  LOOP
{
  FOR(LOOP=1; LOOP<=LENGTH_ARRAY(dvPT_LIST); LOOP++)
  {
    IF([vdvPILOT_LIST[PNL_PTR],LOOP])
    {
      RETURN (LOOP)
    }
  }
  RETURN(0)
}

(**************************)
(* NAME: GET_CAMERA_LEVEL *)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_CAMERA_LEVEL (INTEGER REVERSE_FLAG, INTEGER LVL)
{
  IF(REVERSE_FLAG)
  {
    LVL = (255 - LVL) + 1

    IF((LVL = 0) || (LVL = 256))
      LVL = 255
    ELSE IF(LVL = 1)
      LVL = 0

    RETURN (LVL)
  }
  ELSE
    RETURN (LVL)
}

(**************************)
(* LINK PILOTS CAM SELECT *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'LINK PILOTS CAM SELECT' (CAM_IDX)
STACK_VAR
  LOOP
{
  FOR(LOOP=1; LOOP<=LENGTH_ARRAY(vdvPILOT_LIST); LOOP++)
  {
    IF([vdvPILOT_LIST[LOOP],CAM_IDX])
      CAM_SELECT[LOOP] = 0
  }
}

(*****************************)
(* LINK PILOTS ZOOM POSITION *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'LINK PILOTS ZOOM POSITION' (PNL_IDX, CAM_IDX, LVL_VALUE)
STACK_VAR
  LOOP
{
  FOR(LOOP=1; LOOP<=LENGTH_ARRAY(vdvPILOT_LIST); LOOP++)
  {
    IF(PNL_IDX <> LOOP)
    {
      IF([vdvPILOT_LIST[LOOP],CAM_IDX])
//      IF([vdvPILOT_LIST[LOOP],CAM_IDX] && (![vdvPILOT_LIST[LOOP],PILOT_JS_ZOOM_BUSY]))
        SEND_LEVEL vdvPILOT_LIST[LOOP],3,LVL_VALUE
    }
  }
}

(******************************)
(* LINK PILOTS FOCUS POSITION *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'LINK PILOTS FOCUS POSITION' (PNL_IDX, CAM_IDX, LVL_VALUE)
STACK_VAR
  LOOP
{
  FOR(LOOP=1; LOOP<=LENGTH_ARRAY(vdvPILOT_LIST); LOOP++)
  {
    IF(PNL_IDX <> LOOP)
    {
      IF([vdvPILOT_LIST[LOOP],CAM_IDX])
//      IF([vdvPILOT_LIST[LOOP],CAM_IDX] && (![vdvPILOT_LIST[LOOP],PILOT_JS_FOCUS_BUSY]))
        SEND_LEVEL vdvPILOT_LIST[LOOP],4,LVL_VALUE
    }
  }
}

(*****************************)
(* LINK PILOTS IRIS POSITION *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'LINK PILOTS IRIS POSITION' (PNL_IDX, CAM_IDX, LVL_VALUE)
STACK_VAR
  LOOP
{
  FOR(LOOP=1; LOOP<=LENGTH_ARRAY(vdvPILOT_LIST); LOOP++)
  {
    IF(PNL_IDX <> LOOP)
    {
      IF([vdvPILOT_LIST[LOOP],CAM_IDX])
//      IF([vdvPILOT_LIST[LOOP],CAM_IDX] && (![vdvPILOT_LIST[LOOP],PILOT_JS_FOCUS_BUSY]))
        SEND_LEVEL vdvPILOT_LIST[LOOP],5,LVL_VALUE
    }
  }
}

(*************************)
(* PARSE MODULE COMMANDS *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'PARSE PILOT COMMANDS' (INTEGER PNL_PTR, CHAR CMD[])
LOCAL_VAR
  TRASH[100]
  LVL_PTR
  PSET
  VALUE
{
  SELECT
  {
(***************************)
(*** PRESET STORE/RECALL ***)
(***************************)
(*** CxRPySz ***)
    ACTIVE(FIND_STRING(CMD,"'RP'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        TRASH = REMOVE_STRING(CMD,"'RP'",1)
        PSET  = ATOI(CMD)
        IF(PSET && (PSET <= MAX_PSET))
        {
        (***  Pull out a SPEED value or default to 96 ***)
          VALUE = 0
          IF(FIND_STRING(CMD,"'S'",1))
          {
            TRASH = REMOVE_STRING(CMD,"'S'",1)
            VALUE = ATOI(CMD)
          }
          IF((VALUE = 0) || (VALUE > 127))
            VALUE = 96

          SEND_COMMAND dvPT_LIST[CAM_IDX],"'RP',ITOA(PSET),'S',ITOA(VALUE),'I-'"

        (*** NOTE: WITH POSITIONAL LENS, WE NEED TO RESET THE JOYSTICK POSITION LEVEL TO MATCH ***)
          IF(sPSET[CAM_IDX].PSET_STORED[PSET])
          {
            sCAMERA[CAM_IDX].ZOOM_POS_LVL  = sPSET[CAM_IDX].ZOOM_POS_PSET[PSET]
            sCAMERA[CAM_IDX].FOCUS_POS_LVL = sPSET[CAM_IDX].FOCUS_POS_PSET[PSET]

            CALL 'LINK PILOTS ZOOM POSITION'  (PNL_PTR, CAM_IDX, sCAMERA[CAM_IDX].ZOOM_POS_LVL)
            CALL 'LINK PILOTS FOCUS POSITION' (PNL_PTR, CAM_IDX, sCAMERA[CAM_IDX].FOCUS_POS_LVL)
          }
        }
      }
    }
(*** CxSPy ***)
    ACTIVE(FIND_STRING(CMD,"'SP'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        TRASH = REMOVE_STRING(CMD,"'SP'",1)
        PSET  = ATOI(CMD)
        IF(PSET && (PSET <= MAX_PSET))
        {
          SEND_COMMAND dvPT_LIST[CAM_IDX],"'SP',ITOA(PSET)"

        (*** NOTE: WITH POSITIONAL LENS, WE NEED TO STORE THE JOYSTICK POSITION LEVEL ***)
          sPSET[CAM_IDX].PSET_STORED[PSET] = 1
          sPSET[CAM_IDX].ZOOM_POS_PSET[PSET]  = sCAMERA[CAM_IDX].ZOOM_POS_LVL
          sPSET[CAM_IDX].FOCUS_POS_PSET[PSET] = sCAMERA[CAM_IDX].FOCUS_POS_LVL
        }
      }
    }
(***************************)
(*** P/T/Z/F/I REVERSALS ***)
(***************************)
(*** CxGy REV-<N,F,T> ***)
    ACTIVE(FIND_STRING(CMD,"'REV-N'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        TRASH = REMOVE_STRING(CMD,"'G'",1)
        LVL_PTR = ATOI(CMD)

        SWITCH(LVL_PTR)
        {
          CASE 0 :
          {
            sCAMERA[CAM_IDX].REVERSE_PAN   = 1
            sCAMERA[CAM_IDX].REVERSE_TILT  = 1
            sCAMERA[CAM_IDX].REVERSE_ZOOM  = 1
            sCAMERA[CAM_IDX].REVERSE_FOCUS = 1
            sCAMERA[CAM_IDX].REVERSE_IRIS  = 1
          }
          CASE 1 : sCAMERA[CAM_IDX].REVERSE_PAN   = 1
          CASE 2 : sCAMERA[CAM_IDX].REVERSE_TILT  = 1
          CASE 3 : sCAMERA[CAM_IDX].REVERSE_ZOOM  = 1
          CASE 4 : sCAMERA[CAM_IDX].REVERSE_FOCUS = 1
          CASE 5 : sCAMERA[CAM_IDX].REVERSE_IRIS  = 1
        }

        IF(sCAMERA[CAM_IDX].REVERSE_TILT)
          SEND_COMMAND dvPT_LIST[CAM_IDX],"'TILT CURVE=INVERT'"
        ELSE
          SEND_COMMAND dvPT_LIST[CAM_IDX],"'TILT CURVE=NORMAL'"

        CALL 'PT MODULE FB' (CAM_IDX)
      }
    }
(*** CxGy REV-<N,F,T> ***)
    ACTIVE(FIND_STRING(CMD,"'REV-F'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        TRASH = REMOVE_STRING(CMD,"'G'",1)
        LVL_PTR = ATOI(CMD)

        SWITCH(LVL_PTR)
        {
          CASE 0 :
          {
            sCAMERA[CAM_IDX].REVERSE_PAN   = 0
            sCAMERA[CAM_IDX].REVERSE_TILT  = 0
            sCAMERA[CAM_IDX].REVERSE_ZOOM  = 0
            sCAMERA[CAM_IDX].REVERSE_FOCUS = 0
            sCAMERA[CAM_IDX].REVERSE_IRIS  = 0
          }
          CASE 1 : sCAMERA[CAM_IDX].REVERSE_PAN   = 0
          CASE 2 : sCAMERA[CAM_IDX].REVERSE_TILT  = 0
          CASE 3 : sCAMERA[CAM_IDX].REVERSE_ZOOM  = 0
          CASE 4 : sCAMERA[CAM_IDX].REVERSE_FOCUS = 0
          CASE 5 : sCAMERA[CAM_IDX].REVERSE_IRIS  = 0
        }

        IF(sCAMERA[CAM_IDX].REVERSE_TILT)
          SEND_COMMAND dvPT_LIST[CAM_IDX],"'TILT CURVE=INVERT'"
        ELSE
          SEND_COMMAND dvPT_LIST[CAM_IDX],"'TILT CURVE=NORMAL'"

        CALL 'PT MODULE FB' (CAM_IDX)
      }
    }
(*** CxGy REV-<N,F,T> ***)
    ACTIVE(FIND_STRING(CMD,"'REV-T'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        TRASH = REMOVE_STRING(CMD,"'G'",1)
        LVL_PTR = ATOI(CMD)

        SWITCH(LVL_PTR)
        {
          CASE 0 :
          {
            sCAMERA[CAM_IDX].REVERSE_PAN   = !sCAMERA[CAM_IDX].REVERSE_PAN
            sCAMERA[CAM_IDX].REVERSE_TILT  = !sCAMERA[CAM_IDX].REVERSE_TILT
            sCAMERA[CAM_IDX].REVERSE_ZOOM  = !sCAMERA[CAM_IDX].REVERSE_ZOOM
            sCAMERA[CAM_IDX].REVERSE_FOCUS = !sCAMERA[CAM_IDX].REVERSE_FOCUS
            sCAMERA[CAM_IDX].REVERSE_IRIS  = !sCAMERA[CAM_IDX].REVERSE_IRIS
          }
          CASE 1 : sCAMERA[CAM_IDX].REVERSE_PAN   = !sCAMERA[CAM_IDX].REVERSE_PAN
          CASE 2 : sCAMERA[CAM_IDX].REVERSE_TILT  = !sCAMERA[CAM_IDX].REVERSE_TILT
          CASE 3 : sCAMERA[CAM_IDX].REVERSE_ZOOM  = !sCAMERA[CAM_IDX].REVERSE_ZOOM
          CASE 4 : sCAMERA[CAM_IDX].REVERSE_FOCUS = !sCAMERA[CAM_IDX].REVERSE_FOCUS
          CASE 5 : sCAMERA[CAM_IDX].REVERSE_IRIS  = !sCAMERA[CAM_IDX].REVERSE_IRIS
        }

        IF(sCAMERA[CAM_IDX].REVERSE_TILT)
          SEND_COMMAND dvPT_LIST[CAM_IDX],"'TILT CURVE=INVERT'"
        ELSE
          SEND_COMMAND dvPT_LIST[CAM_IDX],"'TILT CURVE=NORMAL'"

        CALL 'PT MODULE FB' (CAM_IDX)
      }
    }
(************************************)
(*** LENS MODE (POSITIONAL/SPEED) ***)
(************************************)
(*** CxLENS-<S or P> ***)
    ACTIVE(FIND_STRING(CMD,"'LENS-S'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE = 1
        SEND_COMMAND dvPT_LIST[CAM_IDX],"'LENS=STANDARD'"

        CALL 'PT MODULE FB' (CAM_IDX)
      }
    }
(*** CxLENS-<S or P> ***)
    ACTIVE(FIND_STRING(CMD,"'LENS-P'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE = 0
        SEND_COMMAND dvPT_LIST[CAM_IDX],"'LENS=SERVO'"

        CALL 'PT MODULE FB' (CAM_IDX)
      }
    }
(************************)
(*** AUTO/MANUAL IRIS ***)
(************************)
(*** Cx AUTO IRIS-<N,F,T> ***)
    ACTIVE(FIND_STRING(CMD,"'AUTO IRIS-N'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        sCAMERA[CAM_IDX].AUTO_IRIS = 1

        IF(DEVICE_ID(dvPT_LIST[CAM_IDX]) = $BE)   // AXB-CAM
          SEND_COMMAND dvPT_LIST[CAM_IDX],'P2L255T1'
        ELSE
          SEND_COMMAND dvPT_LIST[CAM_IDX],'IA'

        CALL 'PT MODULE FB' (CAM_IDX)
      }
    }
(*** Cx AUTO IRIS-<N,F,T> ***)
    ACTIVE(FIND_STRING(CMD,"'AUTO IRIS-F'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        sCAMERA[CAM_IDX].AUTO_IRIS = 0

        IF(DEVICE_ID(dvPT_LIST[CAM_IDX]) = $BE)   // AXB-CAM
          SEND_COMMAND dvPT_LIST[CAM_IDX],'P2L0T1'
        ELSE
          SEND_COMMAND dvPT_LIST[CAM_IDX],'IL'

        CALL 'PT MODULE FB' (CAM_IDX)
      }
    }
(*** Cx AUTO IRIS-<N,F,T> ***)
    ACTIVE(FIND_STRING(CMD,"'AUTO IRIS-T'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        sCAMERA[CAM_IDX].AUTO_IRIS = !sCAMERA[CAM_IDX].AUTO_IRIS
        IF(sCAMERA[CAM_IDX].AUTO_IRIS)
        {
          IF(DEVICE_ID(dvPT_LIST[CAM_IDX]) = $BE)   // AXB-CAM
            SEND_COMMAND dvPT_LIST[CAM_IDX],'P2L255T1'
          ELSE
            SEND_COMMAND dvPT_LIST[CAM_IDX],'IA'
        }
        ELSE
        {
          IF(DEVICE_ID(dvPT_LIST[CAM_IDX]) = $BE)   // AXB-CAM
            SEND_COMMAND dvPT_LIST[CAM_IDX],'P2L0T1'
          ELSE
            SEND_COMMAND dvPT_LIST[CAM_IDX],'IL'
        }

        CALL 'PT MODULE FB' (CAM_IDX)
      }
    }
(***************************)
(*** MANUAL IRIS CONTROL ***)
(***************************)
(*** Cx IRIS OPEN ***)
    ACTIVE(FIND_STRING(CMD,"'IRIS OPEN'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        IF(sCAMERA[CAM_IDX].REVERSE_IRIS)
        {
          OFF[dvPT_LIST[CAM_IDX],IRIS_OPEN]
          ON [dvPT_LIST[CAM_IDX],IRIS_CLOSE]
        }
        ELSE
        {
          ON [dvPT_LIST[CAM_IDX],IRIS_OPEN]
          OFF[dvPT_LIST[CAM_IDX],IRIS_CLOSE]
        }
      }
    }
(*** Cx IRIS CLOSE ***)
    ACTIVE(FIND_STRING(CMD,"'IRIS CLOSE'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        IF(sCAMERA[CAM_IDX].REVERSE_IRIS)
        {
          ON [dvPT_LIST[CAM_IDX],IRIS_OPEN]
          OFF[dvPT_LIST[CAM_IDX],IRIS_CLOSE]
        }
        ELSE
        {
          OFF[dvPT_LIST[CAM_IDX],IRIS_OPEN]
          ON [dvPT_LIST[CAM_IDX],IRIS_CLOSE]
        }
      }
    }
(*** Cx IRIS STOP ***)
    ACTIVE(FIND_STRING(CMD,"'IRIS STOP'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        OFF[dvPT_LIST[CAM_IDX],IRIS_OPEN]
        OFF[dvPT_LIST[CAM_IDX],IRIS_CLOSE]
      }
    }
(********************)
(*** CAMERA RESET ***)
(********************)
(*** CxRESET ***)
    ACTIVE(FIND_STRING(CMD,"'RESET'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        CALL 'PT INITIALIZE' (CAM_IDX)
      }
    }
(****************************)
(*** LINK POSITION LEVELS ***)
(****************************)
(*** CxZOOM POS-y ***)
    ACTIVE(FIND_STRING(CMD,"'ZOOM POS-'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        TRASH = REMOVE_STRING(CMD,'ZOOM POS-',1)
        sCAMERA[CAM_IDX].ZOOM_POS_LVL = ATOI(CMD)

        CALL 'LINK PILOTS ZOOM POSITION'  (0, CAM_IDX, sCAMERA[CAM_IDX].ZOOM_POS_LVL)
      }
    }
(*** CxFOCUS POS-y ***)
    ACTIVE(FIND_STRING(CMD,"'FOCUS POS-'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        TRASH = REMOVE_STRING(CMD,'FOCUS POS-',1)
        sCAMERA[CAM_IDX].FOCUS_POS_LVL = ATOI(CMD)

        CALL 'LINK PILOTS FOCUS POSITION'  (0, CAM_IDX, sCAMERA[CAM_IDX].FOCUS_POS_LVL)
      }
    }
(*** CxIRIS POS-y ***)
    ACTIVE(FIND_STRING(CMD,"'IRIS POS-'",1)) :
    {
      CAM_IDX = ATOI(CMD)

      IF(CAM_IDX && (CAM_IDX <= MAX_CAMERA))
      {
        TRASH = REMOVE_STRING(CMD,'IRIS POS-',1)
        sCAMERA[CAM_IDX].IRIS_POS_LVL = ATOI(CMD)

        CALL 'LINK PILOTS IRIS POSITION'  (0, CAM_IDX, sCAMERA[CAM_IDX].IRIS_POS_LVL)
      }
    }
(**********************)
(*** PILOT: VERSION ***)
(**********************)
    ACTIVE(FIND_STRING(CMD,"'VERSION'",1)) :
    {
      SEND_STRING 0,"'AMX_CCS_PT - VER',VER"
    }
  }
}

(****************)
(* PT MODULE FB *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'PT MODULE FB' (PT_PTR)
LOCAL_VAR
  LOOP
{
  IF(PT_PTR = 0)
  {
    FOR(LOOP=1; LOOP<=LENGTH_ARRAY(dvPT_LIST); LOOP++)
    {
      [dvPT_LIST[LOOP],PT_REV_PAN]   = sCAMERA[LOOP].REVERSE_PAN
      [dvPT_LIST[LOOP],PT_REV_TILT]  = sCAMERA[LOOP].REVERSE_TILT
      [dvPT_LIST[LOOP],PT_REV_ZOOM]  = sCAMERA[LOOP].REVERSE_ZOOM
      [dvPT_LIST[LOOP],PT_REV_FOCUS] = sCAMERA[LOOP].REVERSE_FOCUS
      [dvPT_LIST[LOOP],PT_REV_IRIS]  = sCAMERA[LOOP].REVERSE_IRIS

      [dvPT_LIST[LOOP],PT_LENS_IS_SPEED] = sCAMERA[LOOP].LENS_IS_SPEED_MODE

      [dvPT_LIST[LOOP],PT_IRIS_AUTO] = sCAMERA[LOOP].AUTO_IRIS
    }
  }
  ELSE
  {
      [dvPT_LIST[PT_PTR],PT_REV_PAN]   = sCAMERA[PT_PTR].REVERSE_PAN
      [dvPT_LIST[PT_PTR],PT_REV_TILT]  = sCAMERA[PT_PTR].REVERSE_TILT
      [dvPT_LIST[PT_PTR],PT_REV_ZOOM]  = sCAMERA[PT_PTR].REVERSE_ZOOM
      [dvPT_LIST[PT_PTR],PT_REV_FOCUS] = sCAMERA[PT_PTR].REVERSE_FOCUS
      [dvPT_LIST[PT_PTR],PT_REV_IRIS]  = sCAMERA[PT_PTR].REVERSE_IRIS

      [dvPT_LIST[PT_PTR],PT_LENS_IS_SPEED] = sCAMERA[PT_PTR].LENS_IS_SPEED_MODE

      [dvPT_LIST[PT_PTR],PT_IRIS_AUTO] = sCAMERA[PT_PTR].AUTO_IRIS
  }
}

(*****************)
(* PT INITIALIZE *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'PT INITIALIZE' (CAM_IDX)
{
(*** START A REPEATING TIMELINE TO FLUSH OUT OUR QUEUE ***)
  IF(!TIMELINE_ACTIVE(CAM_IDX+100))
  {
    TL_TIMES[1] = 100
    TIMELINE_CREATE(CAM_IDX+100,TL_TIMES,1,TIMELINE_ABSOLUTE,TIMELINE_REPEAT)
  }

(*** Reset the command queue ***)
  CAM_INIT_STRING[CAM_IDX] = ""

(*** Set ramp rates to maximum (zoom,focus,iris) ***)
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'P3R40',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'P4R40',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'P5R128',13"   (* MIDPOINT *)

(*** Set speed to maximum (pan,tilt,zoom,focus,iris) ***)
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G1S127',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G2S127',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G3S127',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G4S127',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G5S64',13"    (* MIDPOINT *)

(*** When pan and tilt are within 5 encoder    ***)
(*** counts of a destination, slow down to 25. ***)
(*** Position deviation = 0.                   ***)
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G1A5S25',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G2A5S25',13"

(*** Deviation ***)
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G1D0',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G2D0',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G3D0',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'G4D0',13"

(*** Pot range is 0 - 65535 for zoom and ***)
(*** focus signals from the camera pot.  ***)
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'AD MODE 3 10',13"
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'AD MODE 4 10',13"

(*** Lens mode ***)
  IF(sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE)
    CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'LENS=STANDARD',13"
  ELSE
    CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'LENS=SERVO',13"

(*** Lens mode ***)
  IF(sCAMERA[CAM_IDX].REVERSE_TILT)
    SEND_COMMAND dvPT_LIST[CAM_IDX],"'TILT CURVE=INVERT'"
  ELSE
    SEND_COMMAND dvPT_LIST[CAM_IDX],"'TILT CURVE=NORMAL'"

(*** Auto Iris ***)
  IF(sCAMERA[CAM_IDX].AUTO_IRIS)
    CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'IA',13"
  ELSE
    CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'IL',13"

(*** Acceleration  ***)
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'ACCEL CONTROL=ON',13"


(*** NOTE: Need this 'END' to kill the queue timeline!! ***)
  CAM_INIT_STRING[CAM_IDX] = "CAM_INIT_STRING[CAM_IDX],'END',13"
}

(************)
(* PT RESET *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'PT RESET' (CAM_IDX)
{
  sCAMERA[CAM_IDX].PAN_LVL   = 128
  sCAMERA[CAM_IDX].TILT_LVL  = 128
  SEND_LEVEL dvPT_LIST[CAM_IDX],1,sCAMERA[CAM_IDX].PAN_LVL
  SEND_LEVEL dvPT_LIST[CAM_IDX],2,sCAMERA[CAM_IDX].TILT_LVL

  IF(sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE)
  {
    sCAMERA[CAM_IDX].ZOOM_LVL  = 128
    sCAMERA[CAM_IDX].FOCUS_LVL = 128
    sCAMERA[CAM_IDX].IRIS_LVL  = 128
    SEND_LEVEL dvPT_LIST[CAM_IDX],3,sCAMERA[CAM_IDX].ZOOM_LVL
    SEND_LEVEL dvPT_LIST[CAM_IDX],4,sCAMERA[CAM_IDX].FOCUS_LVL
(*  SEND_LEVEL dvPT_LIST[CAM_IDX],5,sCAMERA[CAM_IDX].IRIS_LVL     *)
  }
  ELSE
  {
    OFF[dvPT_LIST[CAM_IDX],ZOOM_TELE]
    OFF[dvPT_LIST[CAM_IDX],ZOOM_WIDE]
    OFF[dvPT_LIST[CAM_IDX],FOCUS_NEAR]
    OFF[dvPT_LIST[CAM_IDX],FOCUS_FAR]
    OFF[dvPT_LIST[CAM_IDX],IRIS_CLOSE]
    OFF[dvPT_LIST[CAM_IDX],IRIS_OPEN]
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
(*       POSIPILOT LEVELS REPORTED BACK FROM MODULE        *)
(*---------------------------------------------------------*)
LEVEL_EVENT[vdvPILOT_LIST,1]      (*** PAN *********************)
{
  PNL_IDX = GET_LAST_JS_DEVICE(LEVEL.INPUT.DEVICE)
  sPILOT[PNL_IDX].PAN_LVL = LEVEL.VALUE

  CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

(*** ATTACH THIS LEVEL TO THE CAMERA SELECTED ***)
  IF(CAM_IDX)
  {
    sCAMERA[CAM_IDX].PAN_LVL = GET_CAMERA_LEVEL (sCAMERA[CAM_IDX].REVERSE_PAN, LEVEL.VALUE)
    SEND_LEVEL dvPT_LIST[CAM_IDX],1,sCAMERA[CAM_IDX].PAN_LVL
  }
}

LEVEL_EVENT[vdvPILOT_LIST,2]      (*** TILT ********************)
{
  PNL_IDX = GET_LAST_JS_DEVICE(LEVEL.INPUT.DEVICE)
  sPILOT[PNL_IDX].TILT_LVL = LEVEL.VALUE

  CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

(*** NOTE: Send command 'TILT CURVE=INVERT' will reverse this for us!! ***)

(*** ATTACH THIS LEVEL TO THE CAMERA SELECTED ***)
  IF(CAM_IDX)
  {
    sCAMERA[CAM_IDX].TILT_LVL = LEVEL.VALUE
    SEND_LEVEL dvPT_LIST[CAM_IDX],2,sCAMERA[CAM_IDX].TILT_LVL
  }
}

LEVEL_EVENT[vdvPILOT_LIST,3]      (*** ZOOM (POSITION) *********)
{
  PNL_IDX = GET_LAST_JS_DEVICE(LEVEL.INPUT.DEVICE)

  CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

  IF(CAM_IDX)
  {
    IF(ZOOM_BUSY_IDX[CAM_IDX] = PNL_IDX)
    {
      IF(sCAMERA[CAM_IDX].ZOOM_POS_LVL <> LEVEL.VALUE)
        CALL 'LINK PILOTS ZOOM POSITION' (PNL_IDX, CAM_IDX, LEVEL.VALUE)

      sCAMERA[CAM_IDX].ZOOM_POS_LVL = LEVEL.VALUE
    }
  }
}

LEVEL_EVENT[vdvPILOT_LIST,9]      (*** ZOOM (DIRECTION) ********)
{
  PNL_IDX = GET_LAST_JS_DEVICE(LEVEL.INPUT.DEVICE)
  sPILOT[PNL_IDX].ZOOM_AVG_LVL = LEVEL.VALUE

  CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

  IF(CAM_IDX)
  {
    sCAMERA[CAM_IDX].ZOOM_LVL = GET_CAMERA_LEVEL (sCAMERA[CAM_IDX].REVERSE_ZOOM, LEVEL.VALUE)

    IF(sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE)
    {
      SEND_LEVEL dvPT_LIST[CAM_IDX],3,sCAMERA[CAM_IDX].ZOOM_LVL
    }
    ELSE
    {
      [dvPT_LIST[CAM_IDX],ZOOM_TELE] = (sCAMERA[CAM_IDX].ZOOM_LVL > 128)
      [dvPT_LIST[CAM_IDX],ZOOM_WIDE] = (sCAMERA[CAM_IDX].ZOOM_LVL < 128)
    }
  }
}

LEVEL_EVENT[vdvPILOT_LIST,20]    (*** ZOOM (SPEED) *************)
{
  PNL_IDX = GET_LAST_JS_DEVICE(LEVEL.INPUT.DEVICE)

  CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

  IF(CAM_IDX)
  {
    IF(sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE)
    {
    }
    ELSE
    {
      SEND_COMMAND dvPT_LIST[CAM_IDX],"'P3R',ITOA((255-((LEVEL.VALUE*7)/8)))"
    }
  }
}

LEVEL_EVENT[vdvPILOT_LIST,4]      (*** FOCUS (POSITION) ********)
{
  PNL_IDX = GET_LAST_JS_DEVICE(LEVEL.INPUT.DEVICE)

  CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

  IF(CAM_IDX)
  {
    IF(FOCUS_BUSY_IDX[CAM_IDX] = PNL_IDX)
    {
      IF(sCAMERA[CAM_IDX].FOCUS_POS_LVL <> LEVEL.VALUE)
        CALL 'LINK PILOTS FOCUS POSITION' (PNL_IDX, CAM_IDX, LEVEL.VALUE)

      sCAMERA[CAM_IDX].FOCUS_POS_LVL = LEVEL.VALUE
    }
  }
}

LEVEL_EVENT[vdvPILOT_LIST,10]     (*** FOCUS (DIRECTION) *******)
{
  PNL_IDX = GET_LAST_JS_DEVICE(LEVEL.INPUT.DEVICE)
  sPILOT[PNL_IDX].FOCUS_AVG_LVL = LEVEL.VALUE

  CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

  IF(CAM_IDX)
  {
    sCAMERA[CAM_IDX].FOCUS_LVL = GET_CAMERA_LEVEL (sCAMERA[CAM_IDX].REVERSE_FOCUS, LEVEL.VALUE)

    IF(sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE)
    {
      SEND_LEVEL dvPT_LIST[CAM_IDX],4,sCAMERA[CAM_IDX].FOCUS_LVL
    }
    ELSE
    {
      [dvPT_LIST[CAM_IDX],FOCUS_NEAR] = (sCAMERA[CAM_IDX].FOCUS_LVL < 128)
      [dvPT_LIST[CAM_IDX],FOCUS_FAR]  = (sCAMERA[CAM_IDX].FOCUS_LVL > 128)
    }
  }
}

LEVEL_EVENT[vdvPILOT_LIST,21]     (*** FOCUS (SPEED) ***********)
{
  PNL_IDX = GET_LAST_JS_DEVICE(LEVEL.INPUT.DEVICE)

  CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

  IF(CAM_IDX)
  {
    IF(sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE)
    {
    }
    ELSE
    {
      SEND_COMMAND dvPT_LIST[CAM_IDX],"'P4R',ITOA((255-((LEVEL.VALUE*7)/8)))"
    }
  }
}

LEVEL_EVENT[vdvPILOT_LIST,5]      (*** IRIS  (POSITION) ********)
{
  PNL_IDX = GET_LAST_JS_DEVICE(LEVEL.INPUT.DEVICE)

  CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

  IF(CAM_IDX)
  {
    IF(IRIS_BUSY_IDX[CAM_IDX] = PNL_IDX)
    {
      IF(sCAMERA[CAM_IDX].IRIS_POS_LVL <> LEVEL.VALUE)
        CALL 'LINK PILOTS IRIS POSITION' (PNL_IDX, CAM_IDX, LEVEL.VALUE)

      sCAMERA[CAM_IDX].IRIS_POS_LVL = LEVEL.VALUE
    }
  }
}


(*---------------------------------------------------------*)
(*         COMMANDS SENT TO CONFIGURE THIS MODULE          *)
(*---------------------------------------------------------*)
DATA_EVENT[vdvPILOT_LIST]
{
  COMMAND :
  {
    CALL 'PARSE PILOT COMMANDS' (GET_LAST(vdvPILOT_LIST), UPPER_STRING(DATA.TEXT))
  }
}

(*---------------------------------------------------------*)
(* FB:Camera availability notification.                    *)
(*---------------------------------------------------------*)
CHANNEL_EVENT[dvPT_LIST,PT_AVAILABLE]
{
  ON :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

  (*** RESET LEVELS TO CENTER POSITION FOR THIS NEW CAMERA ***)
    CALL 'PT RESET' (CAM_IDX)
  }
  OFF :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

    CALL 'LINK PILOTS CAM SELECT' (CAM_IDX)
  }
}

(*---------------------------------------------------------*)
(* FB:Another pilot changed PT configurations.             *)
(*---------------------------------------------------------*)
CHANNEL_EVENT[dvPT_LIST,PT_REV_PAN]
CHANNEL_EVENT[dvPT_LIST,PT_REV_TILT]
CHANNEL_EVENT[dvPT_LIST,PT_REV_ZOOM]
CHANNEL_EVENT[dvPT_LIST,PT_REV_FOCUS]
CHANNEL_EVENT[dvPT_LIST,PT_REV_IRIS]
CHANNEL_EVENT[dvPT_LIST,PT_IRIS_AUTO]
CHANNEL_EVENT[dvPT_LIST,PT_LENS_IS_SPEED]
{
  ON :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

    SWITCH (CHANNEL.CHANNEL)
    {
      CASE PT_REV_PAN   : sCAMERA[CAM_IDX].REVERSE_PAN   = 1
      CASE PT_REV_TILT  : sCAMERA[CAM_IDX].REVERSE_TILT  = 1
      CASE PT_REV_ZOOM  : sCAMERA[CAM_IDX].REVERSE_ZOOM  = 1
      CASE PT_REV_FOCUS : sCAMERA[CAM_IDX].REVERSE_FOCUS = 1
      CASE PT_REV_IRIS  : sCAMERA[CAM_IDX].REVERSE_IRIS  = 1
      CASE PT_IRIS_AUTO : sCAMERA[CAM_IDX].AUTO_IRIS     = 1
      CASE PT_LENS_IS_SPEED : sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE = 1
    }
  }
  OFF :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

    SWITCH (CHANNEL.CHANNEL)
    {
      CASE PT_REV_PAN   : sCAMERA[CAM_IDX].REVERSE_PAN   = 0
      CASE PT_REV_TILT  : sCAMERA[CAM_IDX].REVERSE_TILT  = 0
      CASE PT_REV_ZOOM  : sCAMERA[CAM_IDX].REVERSE_ZOOM  = 0
      CASE PT_REV_FOCUS : sCAMERA[CAM_IDX].REVERSE_FOCUS = 0
      CASE PT_REV_IRIS  : sCAMERA[CAM_IDX].REVERSE_IRIS  = 0
      CASE PT_IRIS_AUTO : sCAMERA[CAM_IDX].AUTO_IRIS     = 0
      CASE PT_LENS_IS_SPEED : sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE = 0
    }
  }
}

(*---------------------------------------------------------*)
(* FB:UI has changed camera selection for this pilot.      *)
(*---------------------------------------------------------*)
CHANNEL_EVENT[vdvPILOT_LIST,ALL_CHN_CAM_SELECT]
{
  ON :
  {
    PNL_IDX = GET_LAST(vdvPILOT_LIST)

(**************************************)
(*** PREVIOUS CAMERA NEEDS TO RESET ***)
(**************************************)
    IF(CAM_SELECT[PNL_IDX])
    {
      CALL 'PT RESET' (CAM_SELECT[PNL_IDX])
    }


(*************************)
(*** NEW CAMERA SELECT ***)
(*************************)
    CAM_SELECT[PNL_IDX] = CHANNEL.CHANNEL
    CAM_IDX = CHANNEL.CHANNEL


(****************************************************)
(*** SET LEVELS OF NEW CAMERA TO OUR PILOT LEVELS ***)
(****************************************************)
    sCAMERA[CAM_IDX].PAN_LVL   = GET_CAMERA_LEVEL(sCAMERA[CAM_IDX].REVERSE_PAN,sPILOT[PNL_IDX].PAN_LVL)
    sCAMERA[CAM_IDX].TILT_LVL  = sPILOT[PNL_IDX].TILT_LVL
    SEND_LEVEL dvPT_LIST[CAM_IDX],1,sCAMERA[CAM_IDX].PAN_LVL
    SEND_LEVEL dvPT_LIST[CAM_IDX],2,sCAMERA[CAM_IDX].TILT_LVL

    IF(sCAMERA[CAM_IDX].LENS_IS_SPEED_MODE)
    {
      sCAMERA[CAM_IDX].ZOOM_LVL  = GET_CAMERA_LEVEL(sCAMERA[CAM_IDX].REVERSE_ZOOM,sPILOT[PNL_IDX].ZOOM_AVG_LVL)
      sCAMERA[CAM_IDX].FOCUS_LVL = GET_CAMERA_LEVEL(sCAMERA[CAM_IDX].REVERSE_FOCUS,sPILOT[PNL_IDX].FOCUS_AVG_LVL)
      SEND_LEVEL dvPT_LIST[CAM_IDX],3,sCAMERA[CAM_IDX].ZOOM_LVL
      SEND_LEVEL dvPT_LIST[CAM_IDX],4,sCAMERA[CAM_IDX].FOCUS_LVL
    }
    ELSE
    {
      sCAMERA[CAM_IDX].ZOOM_LVL  = GET_CAMERA_LEVEL(sCAMERA[CAM_IDX].REVERSE_ZOOM,sPILOT[PNL_IDX].ZOOM_AVG_LVL)
      sCAMERA[CAM_IDX].FOCUS_LVL = GET_CAMERA_LEVEL(sCAMERA[CAM_IDX].REVERSE_FOCUS,sPILOT[PNL_IDX].FOCUS_AVG_LVL)
      [dvPT_LIST[CAM_IDX],ZOOM_TELE] = (sCAMERA[CAM_IDX].ZOOM_LVL > 128)
      [dvPT_LIST[CAM_IDX],ZOOM_WIDE] = (sCAMERA[CAM_IDX].ZOOM_LVL < 128)
      [dvPT_LIST[CAM_IDX],FOCUS_NEAR] = (sCAMERA[CAM_IDX].FOCUS_LVL < 128)
      [dvPT_LIST[CAM_IDX],FOCUS_FAR]  = (sCAMERA[CAM_IDX].FOCUS_LVL > 128)
    }

(*****************************************************)
(*** RESET JOYSTICK POSITIONS TO MY POSITION LEVEL ***)
(*****************************************************)
    SEND_LEVEL vdvPILOT_LIST[PNL_IDX],3,sCAMERA[CAM_IDX].ZOOM_POS_LVL
    SEND_LEVEL vdvPILOT_LIST[PNL_IDX],4,sCAMERA[CAM_IDX].FOCUS_POS_LVL
  }
  OFF :
  {
    PNL_IDX = GET_LAST(vdvPILOT_LIST)

    CAM_IDX = CHANNEL.CHANNEL

    IF((CAM_SELECT[PNL_IDX] = CAM_IDX) && CAM_SELECT[PNL_IDX])
    {
    (*** RESET LEVELS TO CENTER POSITION FOR THIS PREVIOUS CAMERA ***)
      CALL 'PT RESET' (CAM_SELECT[PNL_IDX])

      CAM_SELECT[PNL_IDX] = 0
    }
  }
}

(*---------------------------------------------------------*)
(*         P/T ERRORS                                      *)
(*---------------------------------------------------------*)
CHANNEL_EVENT[dvPT_LIST,230]    // ERROR
CHANNEL_EVENT[dvPT_LIST,240]    // ERROR - PROBLEM WITH PAN ENCODER
CHANNEL_EVENT[dvPT_LIST,241]    // ERROR - PROBLEM WITH TILT ENCODER
CHANNEL_EVENT[dvPT_LIST,242]    // ERROR - PROBLEM WITH PAN OPTICAL READER
CHANNEL_EVENT[dvPT_LIST,243]    // ERROR - PROBLEM WITH TILT OPTICAL READER
CHANNEL_EVENT[dvPT_LIST,244]    // ERROR - PROBLEM WITH PAN WORM GEAR
CHANNEL_EVENT[dvPT_LIST,245]    // ERROR - PROBLEM WITH TILT WORM GEAR
CHANNEL_EVENT[dvPT_LIST,246]    // ERROR - PAN HAS STALLED
CHANNEL_EVENT[dvPT_LIST,247]    // ERROR - TILT HAS STALLED
CHANNEL_EVENT[dvPT_LIST,248]    // ERROR - UNIT IS FINDING HOME
CHANNEL_EVENT[dvPT_LIST,95]     // REACHED PAN LIMIT LEFT
CHANNEL_EVENT[dvPT_LIST,96]     // REACHED PAN LIMIT RIGHT
CHANNEL_EVENT[dvPT_LIST,97]     // REACHED TILT LIMIT UP
CHANNEL_EVENT[dvPT_LIST,98]     // REACHED TILT LIMIT DOWN
CHANNEL_EVENT[dvPT_LIST,29]     // UNIT IS PANNING
CHANNEL_EVENT[dvPT_LIST,30]     // UNIT IS TILTING
{
  ON :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

    IF([dvPT_LIST[CAM_IDX],PT_DEBUG])
    {
      SWITCH (CHANNEL.CHANNEL)
      {
        CASE 230 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E230(ON) -ERROR'"
        CASE 240 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E240(ON) -PROBLEM WITH PAN ENCODER'"
        CASE 241 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E241(ON) -PROBLEM WITH TILT ENCODER'"
        CASE 242 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E242(ON) -PROBLEM WITH PAN OPTICAL READER'"
        CASE 243 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E243(ON) -PROBLEM WITH TILT OPTICAL READER'"
        CASE 244 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E244(ON) -PROBLEM WITH PAN WORM GEAR'"
        CASE 245 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E245(ON) -PROBLEM WITH TILT WORM GEAR'"
        CASE 246 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E246(ON) -PAN HAS STALLED'"
        CASE 247 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E247(ON) -TILT HAS STALLED'"
        CASE 248 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E248(ON) -UNIT IS FINDING HOME'"
        CASE  95 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E95(ON) -REACHED PAN LIMIT LEFT'"
        CASE  96 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E96(ON) -REACHED PAN LIMIT RIGHT'"
        CASE  97 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E97(ON) -REACHED TILT LIMIT UP'"
        CASE  98 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E98(ON) -REACHED TILT LIMIT DOWN'"
        CASE  29 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E29(ON) -UNIT IS PANNING'"
        CASE  30 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E30(ON) -UNIT IS TILTING'"
      }
    }

  (*** WHEN UNIT IS FINDING HOME POSITION, IT IS NOT READY ***)
    IF(CHANNEL.CHANNEL = 248)
    {
      OFF[dvPT_LIST[CAM_IDX],PT_AVAILABLE]

      IF([dvPT_LIST[CAM_IDX],PT_DEBUG])
        SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') !!!! NOT AVAILABLE !!!!'"
    }
  }
  OFF :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

    IF([dvPT_LIST[CAM_IDX],PT_DEBUG])
    {
      SWITCH (CHANNEL.CHANNEL)
      {
        CASE 230 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E230(OFF)-ERROR'"
        CASE 240 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E240(OFF)-PROBLEM WITH PAN ENCODER'"
        CASE 241 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E241(OFF)-PROBLEM WITH TILT ENCODER'"
        CASE 242 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E242(OFF)-PROBLEM WITH PAN OPTICAL READER'"
        CASE 243 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E243(OFF)-PROBLEM WITH TILT OPTICAL READER'"
        CASE 244 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E244(OFF)-PROBLEM WITH PAN WORM GEAR'"
        CASE 245 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E245(OFF)-PROBLEM WITH TILT WORM GEAR'"
        CASE 246 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E246(OFF)-PAN HAS STALLED'"
        CASE 247 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E247(OFF)-TILT HAS STALLED'"
        CASE 248 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E248(OFF)-UNIT IS FINDING HOME'"
        CASE  95 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E95(OFF)-REACHED PAN LIMIT LEFT'"
        CASE  96 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E96(OFF)-REACHED PAN LIMIT RIGHT'"
        CASE  97 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E97(OFF)-REACHED TILT LIMIT UP'"
        CASE  98 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E98(OFF)-REACHED TILT LIMIT DOWN'"
        CASE  29 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E29(OFF)-UNIT IS PANNING'"
        CASE  30 : SEND_STRING 0,"'PT (',ITOA(CAM_IDX),')  E30(OFF)-UNIT IS TILTING'"
      }
    }
  }
}

(*---------------------------------------------------------*)
(*         P/T DONE HOMING (READY)                         *)
(*---------------------------------------------------------*)
CHANNEL_EVENT[dvPT_LIST,228]    // UNIT HAS FOUND HOME POSITION
{
  ON :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

    IF([dvPT_LIST[CAM_IDX],PT_DEBUG])
      SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E228-UNIT HAS FOUND HOME POSITION'"
  }
  OFF :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

    IF([dvPT_LIST[CAM_IDX],PT_DEBUG])
      SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') E228-UNIT HAS LOST HOME POSITION'"
  }
}

(*---------------------------------------------------------*)
(*         PILOT DONE MOVING ZOOM/FOCUS                    *)
(*---------------------------------------------------------*)
CHANNEL_EVENT[vdvPILOT_LIST,PILOT_JS_ZOOM_BUSY]
{
  ON :
  {
    PNL_IDX = GET_LAST(vdvPILOT_LIST)
    CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

    IF (CAM_IDX)
    {
      IF(ZOOM_BUSY_IDX[CAM_IDX] = 0)
        {ZOOM_BUSY_IDX[CAM_IDX] = PNL_IDX}
    }
  }
  OFF :
  {
    PNL_IDX = GET_LAST(vdvPILOT_LIST)
    CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

    IF (CAM_IDX)
    {
      IF(ZOOM_BUSY_IDX[CAM_IDX] = PNL_IDX)
        {ZOOM_BUSY_IDX[CAM_IDX] = 0}
    }
  }
}

CHANNEL_EVENT[vdvPILOT_LIST,PILOT_JS_FOCUS_BUSY]
{
  ON :
  {
    PNL_IDX = GET_LAST(vdvPILOT_LIST)
    CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

    IF (CAM_IDX)
    {
      IF(FOCUS_BUSY_IDX[CAM_IDX] = 0)
        {FOCUS_BUSY_IDX[CAM_IDX] = PNL_IDX}
    }
  }
  OFF :
  {
    PNL_IDX = GET_LAST(vdvPILOT_LIST)
    CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

    IF (CAM_IDX)
    {
      IF(FOCUS_BUSY_IDX[CAM_IDX] = PNL_IDX)
        {FOCUS_BUSY_IDX[CAM_IDX] = 0}
    }
  }
}

CHANNEL_EVENT[vdvPILOT_LIST,PILOT_JS_IRIS_BUSY]
{
  ON :
  {
    PNL_IDX = GET_LAST(vdvPILOT_LIST)
    CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

    IF (CAM_IDX)
    {
      IF(IRIS_BUSY_IDX[CAM_IDX] = 0)
        {IRIS_BUSY_IDX[CAM_IDX] = PNL_IDX}
    }
  }
  OFF :
  {
    PNL_IDX = GET_LAST(vdvPILOT_LIST)
    CAM_IDX = GET_PILOT_CAM_SELECT(PNL_IDX)

    IF (CAM_IDX)
    {
      IF(IRIS_BUSY_IDX[CAM_IDX] = PNL_IDX)
        {IRIS_BUSY_IDX[CAM_IDX] = 0}
    }
  }
}

(*---------------------------------------------------------*)
(*         P/T ONLINE/OFFLINE                              *)
(*---------------------------------------------------------*)
DATA_EVENT[dvPT_LIST]
{
  ONLINE :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

  (*** TIMELINES: CREATE DELAY BEFORE MAKING IT AVAILABLE ***)
    TL_TIMES[1] = 25000   (* 25 SECONDS *)
    TIMELINE_CREATE(CAM_IDX,TL_TIMES,1,TIMELINE_RELATIVE,TIMELINE_ONCE)
  }
  OFFLINE :
  {
    CAM_IDX = GET_LAST(dvPT_LIST)

  (*** TIMELINES: KILL ANY PREVIOUSLY PENDING ONLINE DELAY ***)
    IF(TIMELINE_ACTIVE(CAM_IDX))
    {
      TIMELINE_KILL(CAM_IDX)

      IF([dvPT_LIST[CAM_IDX],PT_DEBUG])
        SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') TIMELINE CANCELLED'"
    }

  (*** TIMELINES: KILL ANY PENDING PT COMMANDS ***)
    IF(TIMELINE_ACTIVE(CAM_IDX+100))
    {
      TIMELINE_KILL(CAM_IDX+100)
    }
  }
}

(*---------------------------------------------------------*)
(*         P/T ONLINE DELAY FOR AVAILABILITY               *)
(*---------------------------------------------------------*)
TIMELINE_EVENT[1]                 (* CAM  1 *)
TIMELINE_EVENT[2]                 (* CAM  2 *)
TIMELINE_EVENT[3]                 (* CAM  3 *)
TIMELINE_EVENT[4]                 (* CAM  4 *)
TIMELINE_EVENT[5]                 (* CAM  5 *)
TIMELINE_EVENT[6]                 (* CAM  6 *)
TIMELINE_EVENT[7]                 (* CAM  7 *)
TIMELINE_EVENT[8]                 (* CAM  8 *)
TIMELINE_EVENT[9]                 (* CAM  9 *)
TIMELINE_EVENT[10]                (* CAM  10*)
TIMELINE_EVENT[11]                (* CAM  11*)
TIMELINE_EVENT[12]                (* CAM  12*)
TIMELINE_EVENT[13]                (* CAM  13*)
TIMELINE_EVENT[14]                (* CAM  14*)
TIMELINE_EVENT[15]                (* CAM  15*)
TIMELINE_EVENT[16]                (* CAM  16*)
TIMELINE_EVENT[17]                (* CAM  17*)
TIMELINE_EVENT[18]                (* CAM  18*)
{
  CAM_IDX = TIMELINE.ID

(*** INITIALIZE CAMERA STARTUP COMMANDS (REPEAT UNTIL WE FIND 'END' IN STACK) ***)
  IF(CAM_IDX && (CAM_IDX <= 50))
  {
    CALL 'PT INITIALIZE' (CAM_IDX)

    IF([dvPT_LIST[CAM_IDX],PT_DEBUG])
    {
      SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') TIMELINE EVENT AT ',TIME"
      SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') .....STARTING PT INITIALIZATION.....'"
    }
  }
}

(*---------------------------------------------------------*)
(*         P/T STARTUP COMMAND STACKS                      *)
(*---------------------------------------------------------*)
TIMELINE_EVENT[101]               (* CAM  1 *)
TIMELINE_EVENT[102]               (* CAM  2 *)
TIMELINE_EVENT[103]               (* CAM  3 *)
TIMELINE_EVENT[104]               (* CAM  4 *)
TIMELINE_EVENT[105]               (* CAM  5 *)
TIMELINE_EVENT[106]               (* CAM  6 *)
TIMELINE_EVENT[107]               (* CAM  7 *)
TIMELINE_EVENT[108]               (* CAM  8 *)
TIMELINE_EVENT[109]               (* CAM  9 *)
TIMELINE_EVENT[110]               (* CAM  10*)
TIMELINE_EVENT[111]               (* CAM  11*)
TIMELINE_EVENT[112]               (* CAM  12*)
TIMELINE_EVENT[113]               (* CAM  13*)
TIMELINE_EVENT[114]               (* CAM  14*)
TIMELINE_EVENT[115]               (* CAM  15*)
TIMELINE_EVENT[116]               (* CAM  16*)
TIMELINE_EVENT[117]               (* CAM  17*)
TIMELINE_EVENT[118]               (* CAM  18*)
{
  CAM_IDX = TIMELINE.ID - 100

(*** SEND NEXT QUEUED COMMAND (REPEAT UNTIL WE FIND 'END' IN STACK) ***)
  IF(CAM_IDX && (CAM_IDX <= 50))
  {
    NEXT_CMD = REMOVE_STRING(CAM_INIT_STRING[CAM_IDX],"13",1)

    IF(LENGTH_STRING(NEXT_CMD))
    {
      SET_LENGTH_STRING(NEXT_CMD,LENGTH_STRING(NEXT_CMD)-1)
      IF(NEXT_CMD = "'END'")
      {
        TIMELINE_KILL(CAM_IDX+100)
        ON [dvPT_LIST[CAM_IDX],PT_AVAILABLE]

        IF([dvPT_LIST[CAM_IDX],PT_DEBUG])
          SEND_STRING 0,"'PT (',ITOA(CAM_IDX),') .....AVAILABLE (',TIME,').....'"
      }
      ELSE
      {
        SEND_COMMAND dvPT_LIST[CAM_IDX],"NEXT_CMD"
      }
    }
  }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM



(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

