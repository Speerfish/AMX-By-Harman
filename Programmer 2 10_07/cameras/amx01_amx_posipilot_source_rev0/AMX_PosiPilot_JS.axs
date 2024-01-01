MODULE_NAME='AMX_PosiPilot_JS' (DEV vdvPILOT, DEV dvAI8)
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 05/30/2001 AT: 14:46:13               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/08/2002 AT: 15:19:29         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 07/27/2001                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

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


(*** AMX MISC ***************************************************************)
JS_CENTER_TOLERANCE   = 2000  (* JOYSTICK     TOLERANCE VERSUS 16 BIT LEVEL *)
ZOOM_CENTER_TOLERANCE = 500   (* ZOOM KNOB    TOLERANCE VERSUS 16 BIT LEVEL (RANGE OF 24K) *)
FOCUS_CENTER_TOLERANCE= 500   (* FOCUS ROTARY TOLERANCE VERSUS 16 BIT LEVEL (RANGE OF 10K) *)


(*** CLOCK TIMELINE *********************************************************)
TL_ZOOM_POS   = 1
TL_FOCUS_SPEED= 2
TL_IRIS_SPEED = 3
TL_CALIBRATE  = 4


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE _sMDL_PILOT
{
(*** 16 BIT LEVELS TAKEN FROM AI8 ***)
  INTEGER   REAL_LVL_PAN      // LVL 1 - PAN
  INTEGER   REAL_LVL_TILT     // LVL 2 - TILT
  INTEGER   REAL_LVL_ZOOM     // LVL 3 - ZOOM
  INTEGER   REAL_LVL_FOCUS    // LVL 7 - FOCUS
  INTEGER   REAL_LVL_IRIS     // LVL 5 - IRIS
  INTEGER   REAL_LVL_SPEED    // LVL 4 - SPEED KNOB
(*** HISTORY OF LEVELS ***)
  INTEGER   REAL_LVL_FOCUS_PREV // PREVIOUS FOCUS LEVEL
  INTEGER   REAL_LVL_IRIS_PREV  // PREVIOUS IRIS  LEVEL
(*** 8 BIT LEVELS CONVERTED INTO SPEED TYPE LEVEL ***)
  INTEGER   PAN_SPD_LVL       // PAN    0-255, 128=CENTER
  INTEGER   TILT_SPD_LVL      // TILT   0-255, 128=CENTER
  INTEGER   ZOOM_SPD_LVL      // ZOOM   0-255, 128=CENTER
  INTEGER   FOCUS_SPD_LVL     // FOCUS  0-255, 128=CENTER
  INTEGER   IRIS_SPD_LVL      // IRIS   0-255, 128=CENTER
(*** 8 BIT LEVELS CONVERTED INTO POSITION TYPE LEVEL ***)
  INTEGER   ZOOM_POS_LVL      // ZOOM  (0-255)
  INTEGER   FOCUS_POS_LVL     // FOCUS "NEWER STYLE - POT"   (0-255)
  INTEGER   IRIS_POS_LVL      // IRIS  (0-255)
(*** 8 BIT LEVELS CALCULATED WITH SPEED KNOB ***)
  INTEGER   PAN_AVG_LVL       // PAN    (0-255) * (0-100%)
  INTEGER   TILT_AVG_LVL      // TILT
  INTEGER   ZOOM_AVG_LVL      // ZOOM
  INTEGER   FOCUS_AVG_LVL     // FOCUS
  INTEGER   IRIS_AVG_LVL      // IRIS
(*** 8 BIT LEVELS CALCULATED FOR SPEED ***)
  INTEGER   SPD_KNOB          // SPEED  (0-255)
  INTEGER   PAN_SPD           // PAN    (0-255)
  INTEGER   TILT_SPD          // TILT   (0-255)
  INTEGER   ZOOM_SPD          // ZOOM   (0-255)
  INTEGER   FOCUS_SPD         // FOCUS  (0-255)
  INTEGER   IRIS_SPD          // IRIS   (0-255)
(*** JOYSTICK CENTERS ***)
  INTEGER   JS_CENTER_PAN     // PAN   CENTER ( +/- 32786 )
  INTEGER   JS_CENTER_TILT    // TILT  CENTER ( +/- 32768 )
  INTEGER   JS_CENTER_ZOOM    // ZOOM  CENTER ( +/- 32768 )
  INTEGER   JS_CENTER_FOCUS   // FOCUS CENTER ( +/- 17344 ) ***Only with a "Pot" type focus wheel***
(*** MISC ***)
  INTEGER   ZOOM_POS_STEP     // STEP AMOUNT FOR ZOOM POSITIONAL LEVEL
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

(*** POSIPILOTS ****)
VOLATILE _sMDL_PILOT sMDL_PILOT

CALIBRATE_DELAY = 25
PILOT_IS_POT_TYPE = 0     // Default to "motor" stype (due to the lack of being able to turn OFF DELTA mode)


(*** MISC ***)
VOLATILE INTEGER nLOOP
VOLATILE LONG TL_TIMES[1]


(*** ROTARY FOCUS WHEEL ***)
VOLATILE INTEGER FOCUS_PTR            // Incremental pointer to history
VOLATILE INTEGER FOCUS_HISTORY[10]    // Keep history of levels
VOLATILE INTEGER FOCUS_AVG            // At each time sampling, average the history
VOLATILE INTEGER FOCUS_DIR            // Track wheel direction
VOLATILE INTEGER PREV_FOCUS_DIR       // Keep history of wheel direction
VOLATILE INTEGER TEMP_FOCUS_HISTORY   // 


(*** ROTARY IRIS WHEEL ***)
VOLATILE INTEGER IRIS_PTR            // Incremental pointer to history
VOLATILE INTEGER IRIS_HISTORY[10]    // Keep history of levels
VOLATILE INTEGER IRIS_AVG            // At each time sampling, average the history
VOLATILE INTEGER IRIS_DIR            // Track wheel direction
VOLATILE INTEGER PREV_IRIS_DIR       // Keep history of wheel direction
VOLATILE INTEGER TEMP_IRIS_HISTORY   // 


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
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)


(********************)
(* GET_JOYSTICK_LVL *)
(***********************************************************)
(* CONVERT THE 16 BIT PAN & TILT LEVELS TO 8 BITS AND      *)
(* RETURN AS JOYSTICK POSITION OF 0-255, 128=CENTER.       *)
(*                                                         *)
(* ALL CONVERT TO THIS:                                    *)
(*                           (255)                         *)
(*                            MAX                          *)
(*                             |                           *)
(*                           (128)                         *)
(*                  MIN------CENTER------MAX               *)
(*                  (0)        |        (255)              *)
(*                             |                           *)
(*                            MIN                          *)
(*                            (0)                          *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_JOYSTICK_LVL (INTEGER LVL, INTEGER CENTER)
LOCAL_VAR
  POS_LVL
{
  SELECT
  {
  (* PROVIDE A CENTER TOLERANCE TO ACCOUNT FOR JOYSTICKS *)
  (* THAT DON'T CENTER  CONSISTENTLY.                    *)
    ACTIVE ((LVL >= CENTER-JS_CENTER_TOLERANCE) &&
            (LVL <= CENTER+JS_CENTER_TOLERANCE))     :
    {
      POS_LVL = 128
    }
    ACTIVE(1) :
    {
      POS_LVL = (LVL * 255) / 65535
    }
  }

  RETURN (POS_LVL)
}

(********************)
(* GET_JOYSTICK_AVG *)
(***********************************************************)
(* USE SPEED TO CREATE A 0-100% MULTIPLIER AND USE IT      *)
(* AGAINST THE 8 BIT LEVEL TO RETURN AN AVERAGE OF ACTUAL  *)
(* LEVEL VERSUS SPEED PERCENTAGE.                          *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_JOYSTICK_AVG (INTEGER LVL, INTEGER SPEED)
LOCAL_VAR
  AVG_LVL
{
  IF(LVL > 128)
    AVG_LVL = 128 + (((LVL - 128) * SPEED) / 255)
  ELSE IF(LVL < 128)
    AVG_LVL = 128 - (((128 - LVL) * SPEED) / 255)
  ELSE
    AVG_LVL = 128

  RETURN (AVG_LVL)
}

(********************)
(* GET_JOYSTICK_SPD *)
(***********************************************************)
(* PROVIDE A SPEED (0-255) THAT VARIES AS THE JOYSTICK     *)
(* ROTATES OFF CENTER.                                     *)
(*               MAX       CENTER       MAX                *)
(*               255---------0----------255                *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_JOYSTICK_SPD (INTEGER AVG_LVL)
LOCAL_VAR
  SPD_LVL
{
  IF(AVG_LVL > 128)
    SPD_LVL = ((AVG_LVL - 128) * 2) + 1
  ELSE IF(AVG_LVL < 128)
    SPD_LVL = ((128 - AVG_LVL) * 2) + 1
  ELSE
    SPD_LVL = 0

  RETURN (SPD_LVL)
}

(********************)
(* GET_ZOOM_POS_LVL *)
(***********************************************************)
(* PROVIDES A POSITIONAL LEVEL.                            *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_ZOOM_POS_LVL (INTEGER CUR_POS, INTEGER CUR_SPD_LVL, INTEGER STEP)
{
  SELECT
  {
    ACTIVE (CUR_SPD_LVL = 128) :
    {
    }
    ACTIVE(CUR_SPD_LVL > 128) :
    {
      CUR_POS = CUR_POS + STEP
      IF(CUR_POS > 255)
        CUR_POS = 255
    }
    ACTIVE(CUR_SPD_LVL < 128) :
    {
      CUR_POS = CUR_POS - STEP
      IF(CUR_POS > 255)
        CUR_POS = 0
    }
  }

  RETURN(CUR_POS)
}

(*********************)
(* GET_ZOOM_POS_STEP *)
(***********************************************************)
(* PROVIDES A POSITIONAL LEVEL STEP VALUE.                 *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_ZOOM_POS_STEP (INTEGER CUR_SPD_LVL, INTEGER STEP)
{
  STEP = (CUR_SPD_LVL * 10) / 255

  IF(STEP = 0)
    STEP = 1

  RETURN(STEP)
}

(********************)
(* GET_ZOOM_SPD_LVL *)
(***********************************************************)
(* PROVIDES A SPEED TYPE LEVEL AS THE ZOOM KNOB IS HELD OFF*)
(* OF CENTER.  THIS POSITION IS DEVIATED UP OR DOWN UNTIL  *)
(* THE OUTER LIMITS ARE REACHED.                           *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_ZOOM_SPD_LVL (INTEGER LVL, INTEGER CENTER)
LOCAL_VAR
  CUR_POS
{
  SELECT
  {
    ACTIVE ((LVL >= CENTER-ZOOM_CENTER_TOLERANCE) &&
            (LVL <= CENTER+ZOOM_CENTER_TOLERANCE))     :
    {
      CUR_POS = 128
    }
    ACTIVE(LVL > CENTER) :
    {
      CUR_POS = 128 + (((LVL - CENTER) * 127) / 11000)
      IF(CUR_POS > 255)
        CUR_POS = 255
    }
    ACTIVE(LVL < CENTER) :
    {
      CUR_POS = 128 - (((CENTER - LVL) * 128) / 11000)
      IF(CUR_POS > 255)
        CUR_POS = 0
    }
  }

  RETURN(CUR_POS)
}


(****************)
(* GET_ZOOM_SPD *)
(***********************************************************)
(* PROVIDE A SPEED (0-255) THAT VARIES AS THE ZOOM KNOB    *)
(* ROTATES OFF CENTER.                                     *)
(*               MAX       CENTER       MAX                *)
(*               255---------0----------255                *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_ZOOM_SPD (INTEGER LVL, INTEGER CENTER)
LOCAL_VAR
  SPD_LVL
{
  SELECT
  {
  (* PROVIDE A CENTER TOLERANCE TO ACCOUNT FOR KNOBS     *)
  (* THAT DON'T CENTER  CONSISTENTLY.                    *)
    ACTIVE ((LVL >= CENTER-ZOOM_CENTER_TOLERANCE) &&
            (LVL <= CENTER+ZOOM_CENTER_TOLERANCE))     :
    {
      SPD_LVL = 0
    }
    ACTIVE(LVL = CENTER) :
    {
      SPD_LVL = 0
    }
    ACTIVE(LVL > CENTER) :
    {
      SPD_LVL = (LVL - CENTER) / 40
      IF(SPD_LVL > 255)
        SPD_LVL = 255
    }
    ACTIVE(LVL < CENTER) :
    {
      SPD_LVL = (CENTER - LVL) / 40
      IF(SPD_LVL > 255)
        SPD_LVL = 255
    }
  }

  RETURN (SPD_LVL)
}

(*****************)
(* GET_FOCUS_AVG *)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_FOCUS_AVG(INTEGER PTR)
STACK_VAR
  LONG AVG
{
  IF(PTR)
  {
    FOR(nLOOP=1; nLOOP<=PTR; nLOOP++)
    {
      AVG = AVG + FOCUS_HISTORY[nLOOP]
      FOCUS_HISTORY[nLOOP] = 0
    }

    AVG = AVG / PTR
    PTR = 0
  }

  RETURN (TYPE_CAST(AVG))
}

(*************************)
(* GET_FOCUS_DIR_FOR_POT *)
(***********************************************************)
(* PROVIDES A SPEED TYPE LEVEL AS THE FOCUS IS HELD OFF    *)
(* OF CENTER.  THIS POSITION IS DEVIATED UP OR DOWN UNTIL  *)
(* THE OUTER LIMITS ARE REACHED.                           *)
(*                                                         *)
(* NOTE: "POT" TYPE FOCUS WHEELS WILL INC/DEC FROM THE PREV*)
(*       LEVEL, THEN WRAP AROUND.  IT WILL NOT PROVIDE A   *)
(*       CENTER VALUE!                                     *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_FOCUS_DIR_FOR_POT (INTEGER LVL, INTEGER PREV_LVL)
LOCAL_VAR
  DIR
{
  SELECT
  {
  (*** These didn't wrap ***)
    ACTIVE((LVL > PREV_LVL) && ((LVL - PREV_LVL) < 30000)) :
    {
      DIR = 1
    }
    ACTIVE((LVL < PREV_LVL) && ((PREV_LVL - LVL) < 30000)) :
    {
      DIR = 2
    }
  (*** These did wrap ***)
    ACTIVE(LVL > PREV_LVL) :
    {
      DIR = 2
    }
    ACTIVE(LVL < PREV_LVL) :
    {
      DIR = 1
    }
  }

  RETURN(DIR)
}

(***************************)
(* GET_FOCUS_DIR_FOR_MOTOR *)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_FOCUS_DIR_FOR_MOTOR (INTEGER LVL, INTEGER CENTER)
LOCAL_VAR
  DIR
{
  IF(LVL < (CENTER - FOCUS_CENTER_TOLERANCE))
    DIR = 1
  ELSE IF(LVL > (CENTER + FOCUS_CENTER_TOLERANCE))
    DIR = 2
  ELSE
    DIR = 0

  RETURN (DIR)
}

(**************************)
(* GET_FOCUS_DIFF_FOR_POT *)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_FOCUS_DIFF_FOR_POT (INTEGER LVL, INTEGER PREV_LVL)
LOCAL_VAR
  DIFF
{
  SELECT
  {
  (*** These didn't wrap ***)
    ACTIVE((LVL > PREV_LVL) && ((LVL - PREV_LVL) < 30000)) :
    {
      DIFF = LVL - PREV_LVL
    }
    ACTIVE((LVL < PREV_LVL) && ((PREV_LVL - LVL) < 30000)) :
    {
      DIFF = PREV_LVL - LVL
    }
  (*** These did wrap ***)
    ACTIVE(LVL > PREV_LVL) :
    {
      DIFF = PREV_LVL - LVL
    }
    ACTIVE(LVL < PREV_LVL) :
    {
      DIFF = LVL - PREV_LVL
    }
  }

  RETURN (DIFF)
}

(*****************************)
(* GET_FOCUS_SPD_LVL_FOR_POT *)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_FOCUS_SPD_LVL_FOR_POT (INTEGER LVL_DIFF, INTEGER DIR)
LOCAL_VAR
  SPD_LVL
  MAX_RANGE
  STEP
{
(*** THIS IS AN ATTEMPT TO SCALE SMALLER CHANGES DOWN FOR BETTER RESOLUTION AT SLOW SPEEDS ***)
  SELECT
  {
    ACTIVE(LVL_DIFF <= 256) : MAX_RANGE = 1280
    ACTIVE(LVL_DIFF <= 512) : MAX_RANGE = 1020
    ACTIVE(1)               : MAX_RANGE = 800
  }

  IF(DIR = 1)
  {
    IF(LVL_DIFF < MAX_RANGE)     STEP = (LVL_DIFF * 127) / MAX_RANGE
    ELSE                         STEP = 127

    SPD_LVL = 128 + STEP
  }
  ELSE IF(DIR = 2)
  {
    IF(LVL_DIFF < MAX_RANGE)     STEP = (LVL_DIFF * 128) / MAX_RANGE
    ELSE                         STEP = 128

    SPD_LVL = 128 - STEP
  }

  RETURN(SPD_LVL)
}

(*******************************)
(* GET_FOCUS_SPD_LVL_FOR_MOTOR *)
(***********************************************************)
(* PROVIDES A SPEED TYPE LEVEL AS THE FOCUS IS HELD OFF    *)
(* OF CENTER.  THIS POSITION IS DEVIATED UP OR DOWN UNTIL  *)
(* THE OUTER LIMITS ARE REACHED.                           *)
(*                                                         *)
(* NOTE: "MOTOR" TYPE FOCUS WHEELS WILL INC/DEC FROM A     *)
(*       CENTERED LEVEL (WHEN AT REST).                    *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_FOCUS_SPD_LVL_FOR_MOTOR (INTEGER LVL, INTEGER CENTER)
LOCAL_VAR
  SPD_LVL
{
  SELECT
  {
    ACTIVE ((LVL >= CENTER-FOCUS_CENTER_TOLERANCE) &&
            (LVL <= CENTER+FOCUS_CENTER_TOLERANCE))     :
    {
      SPD_LVL = 128
    }
    ACTIVE(LVL > CENTER) :
    {
      SPD_LVL = 128 + (((LVL - CENTER) * 127) / 8000)
      IF(SPD_LVL > 255)
        SPD_LVL = 255
    }
    ACTIVE(LVL < CENTER) :
    {
      SPD_LVL = 128 - (((CENTER - LVL) * 128) / 8000)
      IF(SPD_LVL > 255)
        SPD_LVL = 0
    }
  }

  RETURN(SPD_LVL)
}

(*****************)
(* GET_FOCUS_SPD *)
(***********************************************************)
(* PROVIDE A SPEED (0-255) THAT VARIES AS THE FOCUS WHEEL  *)
(* ROTATES AND CONTINUES MOVEMENT.                         *)
(*               MAX        STOP        MAX                *)
(*               255---------0----------255                *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_FOCUS_SPD (INTEGER LVL)
LOCAL_VAR
  SPD_LVL
{
  SELECT
  {
    ACTIVE (LVL = 128) :
    {
      SPD_LVL = 0
    }
    ACTIVE(LVL > 128) :
    {
      SPD_LVL = (LVL - 128) * 2
      IF(SPD_LVL > 255)
        SPD_LVL = 255
    }
    ACTIVE(LVL < 128) :
    {
      SPD_LVL = (128 - LVL) * 2
      IF((SPD_LVL = 0) || (SPD_LVL > 255))
        SPD_LVL = 255
    }
  }

  RETURN (SPD_LVL)
}

(****************)
(* GET_IRIS_AVG *)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_IRIS_AVG(INTEGER PTR)
STACK_VAR
  LONG AVG
{
  IF(PTR)
  {
    FOR(nLOOP=1; nLOOP<=PTR; nLOOP++)
    {
      AVG = AVG + IRIS_HISTORY[nLOOP]
      IRIS_HISTORY[nLOOP] = 0
    }

    AVG = AVG / PTR
    PTR = 0
  }

  RETURN (TYPE_CAST(AVG))
}

(************************)
(* GET_IRIS_DIR_FOR_POT *)
(***********************************************************)
(* PROVIDES A SPEED TYPE LEVEL AS THE FOCUS IS HELD OFF    *)
(* OF CENTER.  THIS POSITION IS DEVIATED UP OR DOWN UNTIL  *)
(* THE OUTER LIMITS ARE REACHED.                           *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_IRIS_DIR_FOR_POT (INTEGER LVL, INTEGER PREV_LVL)
LOCAL_VAR
  DIR
{
  SELECT
  {
  (*** These didn't wrap ***)
    ACTIVE((LVL > PREV_LVL) && ((LVL - PREV_LVL) < 30000)) :
    {
      DIR = 1
    }
    ACTIVE((LVL < PREV_LVL) && ((PREV_LVL - LVL) < 30000)) :
    {
      DIR = 2
    }
  (*** These did wrap ***)
    ACTIVE(LVL > PREV_LVL) :
    {
      DIR = 2
    }
    ACTIVE(LVL < PREV_LVL) :
    {
      DIR = 1
    }
  }

  RETURN(DIR)
}

(*************************)
(* GET_IRIS_DIFF_FOR_POT *)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_IRIS_DIFF_FOR_POT (INTEGER LVL, INTEGER PREV_LVL)
LOCAL_VAR
  DIFF
{
  SELECT
  {
  (*** These didn't wrap ***)
    ACTIVE((LVL > PREV_LVL) && ((LVL - PREV_LVL) < 30000)) :
    {
      DIFF = LVL - PREV_LVL
    }
    ACTIVE((LVL < PREV_LVL) && ((PREV_LVL - LVL) < 30000)) :
    {
      DIFF = PREV_LVL - LVL
    }
  (*** These did wrap ***)
    ACTIVE(LVL > PREV_LVL) :
    {
      DIFF = PREV_LVL - LVL
    }
    ACTIVE(LVL < PREV_LVL) :
    {
      DIFF = LVL - PREV_LVL
    }
  }

  RETURN (DIFF)
}

(****************************)
(* GET_IRIS_SPD_LVL_FOR_POT *)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_IRIS_SPD_LVL_FOR_POT (INTEGER LVL_DIFF, INTEGER DIR)
LOCAL_VAR
  SPD_LVL
  MAX_RANGE
  STEP
{
(*** THIS IS AN ATTEMPT TO SCALE SMALLER CHANGES DOWN FOR BETTER RESOLUTION AT SLOW SPEEDS ***)
  SELECT
  {
    ACTIVE(LVL_DIFF <= 256) : MAX_RANGE = 1280
    ACTIVE(LVL_DIFF <= 512) : MAX_RANGE = 1020
    ACTIVE(1)               : MAX_RANGE = 800
  }

  IF(DIR = 1)
  {
    IF(LVL_DIFF < MAX_RANGE)     STEP = (LVL_DIFF * 127) / MAX_RANGE
    ELSE                         STEP = 127

    SPD_LVL = 128 + STEP
  }
  ELSE IF(DIR = 2)
  {
    IF(LVL_DIFF < MAX_RANGE)     STEP = (LVL_DIFF * 128) / MAX_RANGE
    ELSE                         STEP = 128

    SPD_LVL = 128 - STEP
  }

  RETURN(SPD_LVL)
}

(****************)
(* GET_IRIS_SPD *)
(***********************************************************)
(* PROVIDE A SPEED (0-255) THAT VARIES AS THE IRIS WHEEL   *)
(* ROTATES AND CONTINUES MOVEMENT.                         *)
(*               MAX        STOP        MAX                *)
(*               255---------0----------255                *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_IRIS_SPD (INTEGER LVL)
LOCAL_VAR
  SPD_LVL
{
  SELECT
  {
    ACTIVE (LVL = 128) :
    {
      SPD_LVL = 0
    }
    ACTIVE(LVL > 128) :
    {
      SPD_LVL = (LVL - 128) * 2
      IF(SPD_LVL > 255)
        SPD_LVL = 255
    }
    ACTIVE(LVL < 128) :
    {
      SPD_LVL = (128 - LVL) * 2
      IF((SPD_LVL = 0) || (SPD_LVL > 255))
        SPD_LVL = 255
    }
  }

  RETURN (SPD_LVL)
}

(************************)
(* GET_ROTARY_DEVIATION *)
(***********************************************************)
(* WITH FOCUS & IRIS ROTARY KNOBS, CHECK DEVIATION AMOUNT  *)
(* AND DIRECTION AND STEP UP OR DOWN FROM THE PREVIOUS     *)
(* LEVEL.  THIS LEVEL WILL BE A POSITIONAL TYPE LEVEL OF   *)
(* 0-255.                                                  *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_ROTARY_DEVIATION (INTEGER CUR_POS, INTEGER LVL, INTEGER PREV_LVL)
LOCAL_VAR
  STEP
{
  SELECT
  {
    ACTIVE((LVL > PREV_LVL) && ((LVL - PREV_LVL) < 30000)) :
    {
      STEP = (LVL - PREV_LVL) / 128
      CUR_POS = CUR_POS + STEP
      IF(CUR_POS > 255)
        CUR_POS = 255
    }
    ACTIVE((LVL < PREV_LVL) && ((PREV_LVL - LVL) < 30000)) :
    {
      STEP = (PREV_LVL - LVL) / 128
      CUR_POS = CUR_POS - STEP
      IF(CUR_POS > 255)
        CUR_POS = 0
    }
  }

  RETURN(CUR_POS)
}


(******************************)
(* GET_ROTARY_DEVIATION_MOTOR *)
(***********************************************************)
(* WITH OLDER STYLE MOTOR FOCUS KNOBS, CHECK DEVIATION     *)
(* AMOUNT AND DIRECTION AND STEP UP OR DOWN FROM THE       *)
(* PREVIOUS LEVEL.  THIS LEVEL WILL BE A POSITIONAL TYPE   *)
(* LEVEL OF 0-255.                                         *)
(***********************************************************)
DEFINE_FUNCTION INTEGER GET_ROTARY_DEVIATION_MOTOR (INTEGER CUR_POS, INTEGER LVL, INTEGER CENTER)
LOCAL_VAR
  STEP
{
  SELECT
  {
    ACTIVE(LVL > (CENTER + 25)) :   (* 25 = DEAD ZONE *)
    {
      STEP = (LVL - CENTER) / 500

      IF((CUR_POS + STEP) < 255)
        CUR_POS = CUR_POS + STEP
      ELSE
        CUR_POS = 255
    }
    ACTIVE(LVL < (CENTER - 25)) :
    {
      STEP = (CENTER - LVL) / 500

      IF((CUR_POS - STEP) > 60000)
        CUR_POS = 0
      ELSE
        CUR_POS = CUR_POS - STEP
    }
  }

  RETURN(CUR_POS)
}

(************************)
(* PARSE PILOT COMMANDS *)
(***********************************************************)
(***********************************************************)
DEFINE_CALL 'PARSE PILOT COMMANDS' (CHAR CMD[])
LOCAL_VAR
  TRASH[100]
{
  SELECT
  {
(*
(*** PILOT: RESET ZOOM POSITION LEVEL ***)
    ACTIVE(FIND_STRING(CMD,"'P3L'",1)) :
    {
      TRASH = REMOVE_STRING(CMD,"'P3L'",1)

      sMDL_PILOT.ZOOM_POS_LVL = ATOI(CMD)
    }
(*** PILOT: RESET FOCUS POSITION LEVEL ***)
    ACTIVE(FIND_STRING(CMD,"'P4L'",1)) :
    {
      TRASH = REMOVE_STRING(CMD,"'P4L'",1)

      sMDL_PILOT.FOCUS_POS_LVL = ATOI(CMD)
      sMDL_PILOT.REAL_LVL_FOCUS_PREV = sMDL_PILOT.REAL_LVL_FOCUS
    }
(*** PILOT: RESET IRIS POSITION LEVEL ***)
    ACTIVE(FIND_STRING(CMD,"'P5L'",1)) :
    {
      TRASH = REMOVE_STRING(CMD,"'P5L'",1)

      sMDL_PILOT.IRIS_POS_LVL = ATOI(CMD)
      sMDL_PILOT.REAL_LVL_IRIS_PREV = sMDL_PILOT.REAL_LVL_IRIS
    }
*)
(*** PILOT: REFRESH ***)
    ACTIVE(FIND_STRING(CMD,"'REFRESH'",1)) :
    {
    (*** PAN ***)
      SEND_LEVEL vdvPILOT,18,(sMDL_PILOT.PAN_SPD%255) + 1
      SEND_LEVEL vdvPILOT,13,(sMDL_PILOT.PAN_SPD_LVL%255) + 1
      SEND_LEVEL vdvPILOT, 7,(sMDL_PILOT.PAN_AVG_LVL%255) + 1
      SEND_LEVEL vdvPILOT, 1,(sMDL_PILOT.PAN_AVG_LVL%255) + 1

      SEND_LEVEL vdvPILOT,18,sMDL_PILOT.PAN_SPD
      SEND_LEVEL vdvPILOT,13,sMDL_PILOT.PAN_SPD_LVL
      SEND_LEVEL vdvPILOT, 7,sMDL_PILOT.PAN_AVG_LVL
      SEND_LEVEL vdvPILOT, 1,sMDL_PILOT.PAN_AVG_LVL

    (*** TILT ***)
      SEND_LEVEL vdvPILOT,19,(sMDL_PILOT.TILT_SPD%255) + 1
      SEND_LEVEL vdvPILOT,14,(sMDL_PILOT.TILT_SPD_LVL%255) + 1
      SEND_LEVEL vdvPILOT, 8,(sMDL_PILOT.TILT_AVG_LVL%255) + 1
      SEND_LEVEL vdvPILOT, 2,(sMDL_PILOT.TILT_AVG_LVL%255) + 1

      SEND_LEVEL vdvPILOT,19,sMDL_PILOT.TILT_SPD
      SEND_LEVEL vdvPILOT,14,sMDL_PILOT.TILT_SPD_LVL
      SEND_LEVEL vdvPILOT, 8,sMDL_PILOT.TILT_AVG_LVL
      SEND_LEVEL vdvPILOT, 2,sMDL_PILOT.TILT_AVG_LVL

    (*** ZOOM ***)
      SEND_LEVEL vdvPILOT,20,(sMDL_PILOT.ZOOM_SPD%255) + 1
      SEND_LEVEL vdvPILOT,15,(sMDL_PILOT.ZOOM_SPD_LVL%255) + 1
      SEND_LEVEL vdvPILOT, 9,(sMDL_PILOT.ZOOM_AVG_LVL%255) + 1
      SEND_LEVEL vdvPILOT, 3,(sMDL_PILOT.ZOOM_POS_LVL%255) + 1

      SEND_LEVEL vdvPILOT,20,sMDL_PILOT.ZOOM_SPD
      SEND_LEVEL vdvPILOT,15,sMDL_PILOT.ZOOM_SPD_LVL
      SEND_LEVEL vdvPILOT, 9,sMDL_PILOT.ZOOM_AVG_LVL
      SEND_LEVEL vdvPILOT, 3,sMDL_PILOT.ZOOM_POS_LVL

    (*** FOCUS ***)
      SEND_LEVEL vdvPILOT,21,(sMDL_PILOT.FOCUS_SPD%255) + 1
      SEND_LEVEL vdvPILOT,16,(sMDL_PILOT.FOCUS_SPD_LVL%255) + 1
      SEND_LEVEL vdvPILOT,10,(sMDL_PILOT.FOCUS_AVG_LVL%255) + 1
      SEND_LEVEL vdvPILOT, 4,(sMDL_PILOT.FOCUS_POS_LVL%255) + 1

      SEND_LEVEL vdvPILOT,21,sMDL_PILOT.FOCUS_SPD
      SEND_LEVEL vdvPILOT,16,sMDL_PILOT.FOCUS_SPD_LVL
      SEND_LEVEL vdvPILOT,10,sMDL_PILOT.FOCUS_AVG_LVL
      SEND_LEVEL vdvPILOT, 4,sMDL_PILOT.FOCUS_POS_LVL

    (*** IRIS ***)
      SEND_LEVEL vdvPILOT, 5,(sMDL_PILOT.IRIS_POS_LVL%255) + 1

      SEND_LEVEL vdvPILOT, 5,sMDL_PILOT.IRIS_POS_LVL

    (*** SPEED ***)
      SEND_LEVEL vdvPILOT, 6,(sMDL_PILOT.SPD_KNOB%255) + 1

      SEND_LEVEL vdvPILOT, 6,sMDL_PILOT.SPD_KNOB
    }
(*** PILOT: CALIBRATE ***)
    ACTIVE(FIND_STRING(CMD,"'CALIBRATE'",1)) :
    {
      ON[vdvPILOT,PILOT_CALIBRATED]

    (*** Take snapshot of current levels ***)
      sMDL_PILOT.JS_CENTER_PAN  = 32768
      sMDL_PILOT.JS_CENTER_TILT = 32768
      sMDL_PILOT.JS_CENTER_ZOOM = 32768
      sMDL_PILOT.JS_CENTER_FOCUS= 17344

      IF(TIMELINE_ACTIVE(TL_CALIBRATE))
        TIMELINE_KILL(TL_CALIBRATE)

    (*** DEBUG ***)
      IF([vdvPILOT,PILOT_DEBUG])
      {
        SEND_STRING 0,"'PAN   CENTER=',ITOA(sMDL_PILOT.JS_CENTER_PAN)"
        SEND_STRING 0,"'TILT  CENTER=',ITOA(sMDL_PILOT.JS_CENTER_TILT)"
        SEND_STRING 0,"'ZOOM  CENTER=',ITOA(sMDL_PILOT.JS_CENTER_ZOOM)"
        SEND_STRING 0,"'FOCUS CENTER=',ITOA(sMDL_PILOT.JS_CENTER_FOCUS)"
      }
    }
(*** PILOT: FOCUS TYPE ***)
    ACTIVE(FIND_STRING(CMD,"'FOCUS=MOTOR'",1)) :
    {
      PILOT_IS_POT_TYPE = 0
      SEND_STRING 0,"'WARNING: PosiPilot has been set to "FOCUS=MOTOR" mode!'"
      SEND_STRING 0,"'         You may need to cycle power to the AI8.'"
    }
    ACTIVE(FIND_STRING(CMD,"'FOCUS=POT'",1)) :
    {
      PILOT_IS_POT_TYPE = 1
      SEND_COMMAND dvAI8,"'DELTA7'"
      SEND_STRING 0,"'WARNING: PosiPilot has been set to "FOCUS=POT" mode!'"
      SEND_STRING 0,"'         DELTA7 command sent to the AI8.'"
    }
(*** PILOT: VERSION ***)
    ACTIVE(FIND_STRING(CMD,"'VERSION'",1)) :
    {
      SEND_STRING 0,"'AMX_PosiPilot_JS - VER',VER"
    }
  }
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START


(*** THIS VIRTUAL PILOT NEEDS TO SUPPORT MORE LEVELS ***)
SET_VIRTUAL_LEVEL_COUNT(vdvPILOT,22)



(*** ASSUME CALIBRATED CENTERS ***)
sMDL_PILOT.JS_CENTER_PAN  = 32768
sMDL_PILOT.JS_CENTER_TILT = 32768
sMDL_PILOT.JS_CENTER_ZOOM = 32768
sMDL_PILOT.JS_CENTER_FOCUS= 17344    // NOTE: NEEDED FOR OLDER "MOTOR" SYLE FOCUS KNOBS




(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT


(**********************************)
(*** VIRTUAL POSIPILOT COMMANDS ***)
(**********************************)
DATA_EVENT[vdvPILOT]          (*** COMMANDS FROM MAIN ******)
{
  COMMAND :
  {
    CALL 'PARSE PILOT COMMANDS' (UPPER_STRING(DATA.TEXT))
  }
}


(*****************)
(*** JOYSTICKS ***)
(*****************)
DATA_EVENT[dvAI8]
{
  ONLINE :
  {
    SEND_COMMAND DATA.DEVICE,"'DELTA5'"    // IRIS  LVL IS CONTINUOUS ROTATING POT

    IF(PILOT_IS_POT_TYPE)
      SEND_COMMAND DATA.DEVICE,"'DELTA7'"  // FOCUS LVL IS CONTINUOUS ROTATING POT

    IF(TIMELINE_ACTIVE(TL_CALIBRATE))
      TIMELINE_KILL(TL_CALIBRATE)

    TL_TIMES[1] = CALIBRATE_DELAY * 1000
    TIMELINE_CREATE(TL_CALIBRATE,TL_TIMES,1,TIMELINE_RELATIVE,TIMELINE_ONCE)

    IF([vdvPILOT,PILOT_DEBUG])
      SEND_STRING 0,"'AI8 ONLINE, DELAY FOR CALIBRATION AT ',TIME"
  }
  OFFLINE :
  {
    OFF[vdvPILOT,PILOT_CALIBRATED]

    IF(TIMELINE_ACTIVE(TL_CALIBRATE))
      TIMELINE_KILL(TL_CALIBRATE)
  }
}


(*******************************************)
(*** READ POSIPILOT LEVELS (FROM PT MDL) ***)
(*******************************************)
LEVEL_EVENT[vdvPILOT,3]   (*** ZOOM *****************)
{
  sMDL_PILOT.ZOOM_POS_LVL = LEVEL.VALUE
}

LEVEL_EVENT[vdvPILOT,4]   (*** FOCUS ****************)
{
  sMDL_PILOT.FOCUS_POS_LVL = LEVEL.VALUE
}

LEVEL_EVENT[vdvPILOT,5]   (*** IRIS *****************)
{
  sMDL_PILOT.IRIS_POS_LVL = LEVEL.VALUE
}


(************************)
(*** POSIPILOT LEVELS ***)
(************************)
LEVEL_EVENT[dvAI8,1]      (*** PAN **********************)
{
  sMDL_PILOT.REAL_LVL_PAN = LEVEL.VALUE
  sMDL_PILOT.PAN_SPD_LVL  = GET_JOYSTICK_LVL (LEVEL.VALUE,sMDL_PILOT.JS_CENTER_PAN)
  sMDL_PILOT.PAN_AVG_LVL  = GET_JOYSTICK_AVG (sMDL_PILOT.PAN_SPD_LVL, sMDL_PILOT.SPD_KNOB)
  sMDL_PILOT.PAN_SPD      = GET_JOYSTICK_SPD (sMDL_PILOT.PAN_AVG_LVL)


  SEND_LEVEL vdvPILOT,18,sMDL_PILOT.PAN_SPD
  SEND_LEVEL vdvPILOT,13,sMDL_PILOT.PAN_SPD_LVL
  SEND_LEVEL vdvPILOT, 7,sMDL_PILOT.PAN_AVG_LVL
  SEND_LEVEL vdvPILOT, 1,sMDL_PILOT.PAN_AVG_LVL

(*** CREATE A PAN BUSY FLAG ***)
  [vdvPILOT,PILOT_JS_PAN_BUSY] = (sMDL_PILOT.PAN_SPD_LVL<>128)
}

LEVEL_EVENT[dvAI8,2]      (*** TILT *********************)
{
  sMDL_PILOT.REAL_LVL_TILT = LEVEL.VALUE
  sMDL_PILOT.TILT_SPD_LVL  = GET_JOYSTICK_LVL (LEVEL.VALUE,sMDL_PILOT.JS_CENTER_TILT)
(* !!REV1..
.....CNN Thinks this makes it work backwards...
  IF(sMDL_PILOT.TILT_SPD_LVL <> 128)
    sMDL_PILOT.TILT_SPD_LVL = 255 - sMDL_PILOT.TILT_SPD_LVL
..*)
  sMDL_PILOT.TILT_AVG_LVL  = GET_JOYSTICK_AVG (sMDL_PILOT.TILT_SPD_LVL, sMDL_PILOT.SPD_KNOB)
  sMDL_PILOT.TILT_SPD      = GET_JOYSTICK_SPD (sMDL_PILOT.TILT_AVG_LVL)


  SEND_LEVEL vdvPILOT,19,sMDL_PILOT.TILT_SPD
  SEND_LEVEL vdvPILOT,14,sMDL_PILOT.TILT_SPD_LVL
  SEND_LEVEL vdvPILOT, 8,sMDL_PILOT.TILT_AVG_LVL
  SEND_LEVEL vdvPILOT, 2,sMDL_PILOT.TILT_AVG_LVL

(*** CREATE A TILT BUSY FLAG ***)
  [vdvPILOT,PILOT_JS_TILT_BUSY] = (sMDL_PILOT.TILT_SPD_LVL<>128)
}

LEVEL_EVENT[dvAI8,3]      (*** ZOOM KNOB *****************)
{
  sMDL_PILOT.REAL_LVL_ZOOM  = LEVEL.VALUE
  sMDL_PILOT.ZOOM_SPD_LVL   = GET_ZOOM_SPD_LVL (sMDL_PILOT.REAL_LVL_ZOOM, sMDL_PILOT.JS_CENTER_ZOOM)
  sMDL_PILOT.ZOOM_AVG_LVL   = GET_JOYSTICK_AVG (sMDL_PILOT.ZOOM_SPD_LVL, sMDL_PILOT.SPD_KNOB)
  sMDL_PILOT.ZOOM_SPD       = GET_ZOOM_SPD (sMDL_PILOT.REAL_LVL_ZOOM, sMDL_PILOT.JS_CENTER_ZOOM)
  sMDL_PILOT.ZOOM_POS_STEP  = GET_ZOOM_POS_STEP (sMDL_PILOT.ZOOM_SPD, sMDL_PILOT.ZOOM_POS_STEP)

(*** ZOOM PREVIOUSLY NOT BUSY - START POSITIONAL CLOCK ***)
  IF(![vdvPILOT,PILOT_JS_ZOOM_BUSY])
  {
    sMDL_PILOT.ZOOM_POS_LVL   = GET_ZOOM_POS_LVL (sMDL_PILOT.ZOOM_POS_LVL,sMDL_PILOT.ZOOM_SPD_LVL,sMDL_PILOT.ZOOM_POS_STEP)

    TL_TIMES[1] = 75
    TIMELINE_CREATE(TL_ZOOM_POS,TL_TIMES,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
  }

(*** CREATE A ZOOM BUSY FLAG ***)
  [vdvPILOT,PILOT_JS_ZOOM_BUSY] = (sMDL_PILOT.ZOOM_SPD_LVL<>128)

(*** ZOOM STOPPED RAMPING - STOP POSITIONAL CLOCK ***)
  IF(![vdvPILOT,PILOT_JS_ZOOM_BUSY])
  {
  (*** STOP THE CLOCK ***)
    TIMELINE_KILL(TL_ZOOM_POS)
  }

  SEND_LEVEL vdvPILOT,20,sMDL_PILOT.ZOOM_SPD
  SEND_LEVEL vdvPILOT,15,sMDL_PILOT.ZOOM_SPD_LVL
  SEND_LEVEL vdvPILOT, 9,sMDL_PILOT.ZOOM_AVG_LVL
  SEND_LEVEL vdvPILOT, 3,sMDL_PILOT.ZOOM_POS_LVL
}

LEVEL_EVENT[dvAI8,7]      (*** FOCUS ROTARY **************)
{
  sMDL_PILOT.REAL_LVL_FOCUS = LEVEL.VALUE

(*********************************************************************)
(*** GET FOCUS VALUE FOR "POT" FOCUS WHEELS (NEWER POSIPILOTS)     ***)
(*** NOTE: This does NOT work well when the wheel is turned slowly!***)
(*********************************************************************)
  IF(PILOT_IS_POT_TYPE)
  {
    sMDL_PILOT.FOCUS_POS_LVL  = GET_ROTARY_DEVIATION (sMDL_PILOT.FOCUS_POS_LVL,sMDL_PILOT.REAL_LVL_FOCUS,sMDL_PILOT.REAL_LVL_FOCUS_PREV)

  (*** GET THE DEFLECTION OF THE WHEEL ***)
    TEMP_FOCUS_HISTORY = GET_FOCUS_DIFF_FOR_POT(sMDL_PILOT.REAL_LVL_FOCUS, sMDL_PILOT.REAL_LVL_FOCUS_PREV)
    
  (*** NOT PREVIOUSLY BUSY, WHEEL HAS STARTED MOVING ***)
    IF(![vdvPILOT,PILOT_JS_FOCUS_BUSY])
    {
      FOR(nLOOP=1; nLOOP<=10; nLOOP++)
      {
        FOCUS_HISTORY[nLOOP] = TEMP_FOCUS_HISTORY
      }
      FOCUS_PTR = 9
    }
    
  (*** CREATE A FOCUS BUSY FLAG (TURNED OFF WITH TIMELINE) ***)
    ON[vdvPILOT,PILOT_JS_FOCUS_BUSY]

  (*** TRACK THE DIRECTION OF FOCUS ***)
    FOCUS_DIR = GET_FOCUS_DIR_FOR_POT(sMDL_PILOT.REAL_LVL_FOCUS, sMDL_PILOT.REAL_LVL_FOCUS_PREV)

  (*** KEEP HISTORY OF LEVEL DIFFERENCES (TRYING TO SMOOTH IT OUT) ***)
    FOCUS_PTR++
    FOCUS_HISTORY[FOCUS_PTR] = GET_FOCUS_DIFF_FOR_POT(sMDL_PILOT.REAL_LVL_FOCUS, sMDL_PILOT.REAL_LVL_FOCUS_PREV)

  (*** EVERY 10 LEVEL HITS, AVERAGE AND CALCULATE ***)
    IF(FOCUS_PTR >= 10)
    {
      FOCUS_AVG = GET_FOCUS_AVG(FOCUS_PTR)

    (*** CALCULATE THE SPEED LEVELS ***)
      sMDL_PILOT.FOCUS_SPD_LVL = GET_FOCUS_SPD_LVL_FOR_POT (FOCUS_AVG, FOCUS_DIR)
      sMDL_PILOT.FOCUS_AVG_LVL = GET_JOYSTICK_AVG  (sMDL_PILOT.FOCUS_SPD_LVL, sMDL_PILOT.SPD_KNOB)
      sMDL_PILOT.FOCUS_SPD     = GET_FOCUS_SPD     (sMDL_PILOT.FOCUS_SPD_LVL)
    }

  (*** START/RESTART SPEED CLOCK (TO SET BUSY OFF) ***)
    IF(TIMELINE_ACTIVE(TL_FOCUS_SPEED))
      TIMELINE_KILL(TL_FOCUS_SPEED)

    SELECT
    {
      ACTIVE(TEMP_FOCUS_HISTORY <= 256) : TL_TIMES[1] = 250
      ACTIVE(TEMP_FOCUS_HISTORY <= 512) : TL_TIMES[1] = 200
      ACTIVE(TEMP_FOCUS_HISTORY <= 768) : TL_TIMES[1] = 175
      ACTIVE(1) :                         TL_TIMES[1] = 150
    }
    TIMELINE_CREATE(TL_FOCUS_SPEED,TL_TIMES,1,TIMELINE_ABSOLUTE,TIMELINE_REPEAT)

  (*** RESET HISTORY ****)
    sMDL_PILOT.REAL_LVL_FOCUS_PREV = sMDL_PILOT.REAL_LVL_FOCUS
  }
(*******************************************************************)
(*** GET FOCUS VALUE FOR "MOTOR" FOCUS WHEELS (OLDER POSIPILOTS) ***)
(*******************************************************************)
  ELSE
  {
    sMDL_PILOT.FOCUS_POS_LVL = GET_ROTARY_DEVIATION_MOTOR (sMDL_PILOT.FOCUS_POS_LVL,sMDL_PILOT.REAL_LVL_FOCUS,sMDL_PILOT.JS_CENTER_FOCUS)

  (*** CREATE A FOCUS BUSY FLAG ***)
    [vdvPILOT,PILOT_JS_FOCUS_BUSY] = (sMDL_PILOT.REAL_LVL_FOCUS < (sMDL_PILOT.JS_CENTER_FOCUS - FOCUS_CENTER_TOLERANCE)) ||
                                     (sMDL_PILOT.REAL_LVL_FOCUS > (sMDL_PILOT.JS_CENTER_FOCUS + FOCUS_CENTER_TOLERANCE))

  (*** TRACK THE DIRECTION OF FOCUS ***)
    FOCUS_DIR = GET_FOCUS_DIR_FOR_MOTOR(sMDL_PILOT.REAL_LVL_FOCUS, sMDL_PILOT.JS_CENTER_FOCUS)

  (*** WHEN DIRECTION CHANGES, RESET OUR HISTORY ***)
    IF(PREV_FOCUS_DIR <> FOCUS_DIR)
    {
      PREV_FOCUS_DIR = FOCUS_DIR

      FOR(nLOOP=1; nLOOP<=10; nLOOP++)
      {
        FOCUS_HISTORY[nLOOP] = 0
      }
      FOCUS_PTR = 0
    }

  (*** KEEP HISTORY OF LEVELS (FOR AVERAGING ON THE TIME SAMPLING CLOCK) ***)
    IF(FOCUS_PTR < 10)
    {
      FOCUS_PTR++
      FOCUS_HISTORY[FOCUS_PTR] = LEVEL.VALUE
    }

  (*** FOCUS BUSY - START/STOP SPEED CLOCK (TIME SAMPLING CLOCK) ***)
    IF([vdvPILOT,PILOT_JS_FOCUS_BUSY] && (!TIMELINE_ACTIVE(TL_FOCUS_SPEED)))
    {
      sMDL_PILOT.FOCUS_SPD_LVL = GET_FOCUS_SPD_LVL_FOR_MOTOR (sMDL_PILOT.REAL_LVL_FOCUS, sMDL_PILOT.JS_CENTER_FOCUS)
      sMDL_PILOT.FOCUS_AVG_LVL = GET_JOYSTICK_AVG  (sMDL_PILOT.FOCUS_SPD_LVL, sMDL_PILOT.SPD_KNOB)
      sMDL_PILOT.FOCUS_SPD     = GET_FOCUS_SPD     (sMDL_PILOT.FOCUS_SPD_LVL)

      TL_TIMES[1] = 250
      TIMELINE_CREATE(TL_FOCUS_SPEED,TL_TIMES,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
    }
    ELSE IF((![vdvPILOT,PILOT_JS_FOCUS_BUSY]) && TIMELINE_ACTIVE(TL_FOCUS_SPEED))
    {
      TIMELINE_KILL(TL_FOCUS_SPEED)

      sMDL_PILOT.FOCUS_SPD_LVL = 128
      sMDL_PILOT.FOCUS_AVG_LVL = 128
      sMDL_PILOT.FOCUS_SPD     = 0
    }
  }

  SEND_LEVEL vdvPILOT,21,sMDL_PILOT.FOCUS_SPD
  SEND_LEVEL vdvPILOT,16,sMDL_PILOT.FOCUS_SPD_LVL
  SEND_LEVEL vdvPILOT,10,sMDL_PILOT.FOCUS_AVG_LVL
  SEND_LEVEL vdvPILOT, 4,sMDL_PILOT.FOCUS_POS_LVL
}

LEVEL_EVENT[dvAI8,5]      (*** IRIS ROTARY ***************)
{
  sMDL_PILOT.REAL_LVL_IRIS = LEVEL.VALUE

  sMDL_PILOT.IRIS_POS_LVL  = GET_ROTARY_DEVIATION (sMDL_PILOT.IRIS_POS_LVL,sMDL_PILOT.REAL_LVL_IRIS,sMDL_PILOT.REAL_LVL_IRIS_PREV)

(*** GET THE DEFLECTION OF THE WHEEL ***)
  TEMP_IRIS_HISTORY = GET_IRIS_DIFF_FOR_POT(sMDL_PILOT.REAL_LVL_IRIS, sMDL_PILOT.REAL_LVL_IRIS_PREV)
  
(*** NOT PREVIOUSLY BUSY, WHEEL HAS STARTED MOVING ***)
  IF(![vdvPILOT,PILOT_JS_IRIS_BUSY])
  {
    FOR(nLOOP=1; nLOOP<=10; nLOOP++)
    {
      IRIS_HISTORY[nLOOP] = TEMP_IRIS_HISTORY
    }
    IRIS_PTR = 9
  }
  
(*** CREATE A IRIS BUSY FLAG (TURNED OFF WITH TIMELINE) ***)
  ON[vdvPILOT,PILOT_JS_IRIS_BUSY]

(*** TRACK THE DIRECTION OF IRIS ***)
  IRIS_DIR = GET_IRIS_DIR_FOR_POT(sMDL_PILOT.REAL_LVL_IRIS, sMDL_PILOT.REAL_LVL_IRIS_PREV)

(*** KEEP HISTORY OF LEVEL DIFFERENCES (TRYING TO SMOOTH IT OUT) ***)
  IRIS_PTR++
  IRIS_HISTORY[IRIS_PTR] = GET_IRIS_DIFF_FOR_POT(sMDL_PILOT.REAL_LVL_IRIS, sMDL_PILOT.REAL_LVL_IRIS_PREV)

(*** EVERY 10 LEVEL HITS, AVERAGE AND CALCULATE ***)
  IF(IRIS_PTR >= 10)
  {
    IRIS_AVG = GET_IRIS_AVG(IRIS_PTR)

  (*** CALCULATE THE SPEED LEVELS ***)
    sMDL_PILOT.IRIS_SPD_LVL = GET_IRIS_SPD_LVL_FOR_POT (IRIS_AVG, IRIS_DIR)
    sMDL_PILOT.IRIS_AVG_LVL = GET_JOYSTICK_AVG  (sMDL_PILOT.IRIS_SPD_LVL, sMDL_PILOT.SPD_KNOB)
    sMDL_PILOT.IRIS_SPD     = GET_IRIS_SPD     (sMDL_PILOT.IRIS_SPD_LVL)
  }

(*** START/RESTART SPEED CLOCK (TO SET BUSY OFF) ***)
  IF(TIMELINE_ACTIVE(TL_IRIS_SPEED))
    TIMELINE_KILL(TL_IRIS_SPEED)

  SELECT
  {
    ACTIVE(TEMP_IRIS_HISTORY <= 256) : TL_TIMES[1] = 250
    ACTIVE(TEMP_IRIS_HISTORY <= 512) : TL_TIMES[1] = 200
    ACTIVE(TEMP_IRIS_HISTORY <= 768) : TL_TIMES[1] = 175
    ACTIVE(1) :                        TL_TIMES[1] = 150
  }
  TIMELINE_CREATE(TL_IRIS_SPEED,TL_TIMES,1,TIMELINE_ABSOLUTE,TIMELINE_REPEAT)

(*** RESET HISTORY ****)
  sMDL_PILOT.REAL_LVL_IRIS_PREV = sMDL_PILOT.REAL_LVL_IRIS

  SEND_LEVEL vdvPILOT,22,sMDL_PILOT.IRIS_SPD
  SEND_LEVEL vdvPILOT,17,sMDL_PILOT.IRIS_SPD_LVL
  SEND_LEVEL vdvPILOT,11,sMDL_PILOT.IRIS_AVG_LVL
  SEND_LEVEL vdvPILOT, 5,sMDL_PILOT.IRIS_POS_LVL
}

LEVEL_EVENT[dvAI8,4]      (*** SPEED KNOB ***************)
{
  sMDL_PILOT.REAL_LVL_SPEED = LEVEL.VALUE
  sMDL_PILOT.SPD_KNOB       = (LEVEL.VALUE * 255) / 65535
  IF(sMDL_PILOT.SPD_KNOB <= 20)
    sMDL_PILOT.SPD_KNOB = 20

  SEND_LEVEL vdvPILOT, 6,sMDL_PILOT.SPD_KNOB


  sMDL_PILOT.PAN_AVG_LVL  = GET_JOYSTICK_AVG (sMDL_PILOT.PAN_SPD_LVL, sMDL_PILOT.SPD_KNOB)
  sMDL_PILOT.PAN_SPD      = GET_JOYSTICK_SPD (sMDL_PILOT.PAN_AVG_LVL)
  SEND_LEVEL vdvPILOT,18,sMDL_PILOT.PAN_SPD
  SEND_LEVEL vdvPILOT, 7,sMDL_PILOT.PAN_AVG_LVL
  SEND_LEVEL vdvPILOT, 1,sMDL_PILOT.PAN_AVG_LVL


  sMDL_PILOT.TILT_AVG_LVL = GET_JOYSTICK_AVG (sMDL_PILOT.TILT_SPD_LVL, sMDL_PILOT.SPD_KNOB)
  sMDL_PILOT.TILT_SPD     = GET_JOYSTICK_SPD (sMDL_PILOT.TILT_AVG_LVL)
  SEND_LEVEL vdvPILOT,19,sMDL_PILOT.TILT_SPD
  SEND_LEVEL vdvPILOT, 8,sMDL_PILOT.TILT_AVG_LVL
  SEND_LEVEL vdvPILOT, 2,sMDL_PILOT.TILT_AVG_LVL


  sMDL_PILOT.ZOOM_AVG_LVL = GET_JOYSTICK_AVG (sMDL_PILOT.ZOOM_SPD_LVL, sMDL_PILOT.SPD_KNOB)
  SEND_LEVEL vdvPILOT, 9,sMDL_PILOT.ZOOM_AVG_LVL
}


(********************************************************)
(*** POSITIONAL LEVEL CLOCK (FIRES EVERY 75mS)        ***)
(********************************************************)
TIMELINE_EVENT[TL_ZOOM_POS]
{
(*** ZOOM IS BUSY - STEP POSITIONAL LEVEL ***)
  IF([vdvPILOT,PILOT_JS_ZOOM_BUSY])
  {
    sMDL_PILOT.ZOOM_POS_LVL   = GET_ZOOM_POS_LVL (sMDL_PILOT.ZOOM_POS_LVL,sMDL_PILOT.ZOOM_SPD_LVL,sMDL_PILOT.ZOOM_POS_STEP)
    SEND_LEVEL vdvPILOT, 3,sMDL_PILOT.ZOOM_POS_LVL
  }
}


(********************************************************)
(*** FOCUS SPEED CLOCK                                ***)
(********************************************************)
TIMELINE_EVENT[TL_FOCUS_SPEED]
{
(************************************************************)
(*** "POT" FOCUS WHEELS (NEWER POSIPILOTS) - SET BUSY OFF ***)
(************************************************************)
  IF(PILOT_IS_POT_TYPE)
  {
    OFF[vdvPILOT,PILOT_JS_FOCUS_BUSY]
    sMDL_PILOT.REAL_LVL_FOCUS_PREV = sMDL_PILOT.REAL_LVL_FOCUS

    IF(TIMELINE_ACTIVE(TL_FOCUS_SPEED))
      TIMELINE_KILL(TL_FOCUS_SPEED)

    FOR(nLOOP=1; nLOOP<=10; nLOOP++)
    {
      FOCUS_HISTORY[nLOOP] = 0
    }
    FOCUS_PTR = 0

    PREV_FOCUS_DIR = 0
    FOCUS_DIR = 0
    sMDL_PILOT.FOCUS_SPD_LVL = 128
    sMDL_PILOT.FOCUS_AVG_LVL = 128
    sMDL_PILOT.FOCUS_SPD     = 0
  }
(*******************************************************************)
(*** GET FOCUS VALUE FOR "MOTOR" FOCUS WHEELS (OLDER POSIPILOTS) ***)
(*******************************************************************)
  ELSE
  {
    IF([vdvPILOT,PILOT_JS_FOCUS_BUSY])
    {
    (*** USE THE HISTORY TO CALCULATE AN AVERAGE OF THE LAST ***)
    (*** <n> LEVEL CHANGES SINCE THE LAST TIME SAMPLING      ***)
      IF(FOCUS_PTR > 0)
      {
        FOCUS_AVG = GET_FOCUS_AVG(FOCUS_PTR)

        sMDL_PILOT.FOCUS_SPD_LVL = GET_FOCUS_SPD_LVL_FOR_MOTOR (FOCUS_AVG, sMDL_PILOT.JS_CENTER_FOCUS)
        sMDL_PILOT.FOCUS_AVG_LVL = GET_JOYSTICK_AVG  (sMDL_PILOT.FOCUS_SPD_LVL, sMDL_PILOT.SPD_KNOB)
        sMDL_PILOT.FOCUS_SPD     = GET_FOCUS_SPD     (sMDL_PILOT.FOCUS_SPD_LVL)
      }
    }
    ELSE
    {
      IF(TIMELINE_ACTIVE(TL_FOCUS_SPEED))
        TIMELINE_KILL(TL_FOCUS_SPEED)

      FOR(nLOOP=1; nLOOP<=10; nLOOP++)
      {
        FOCUS_HISTORY[nLOOP] = 0
      }
      FOCUS_PTR = 0
    }
  }


  SEND_LEVEL vdvPILOT,21,sMDL_PILOT.FOCUS_SPD
  SEND_LEVEL vdvPILOT,16,sMDL_PILOT.FOCUS_SPD_LVL
  SEND_LEVEL vdvPILOT,10,sMDL_PILOT.FOCUS_AVG_LVL
}


(********************************************************)
(*** IRIS SPEED CLOCK                                 ***)
(********************************************************)
TIMELINE_EVENT[TL_IRIS_SPEED]
{
  OFF[vdvPILOT,PILOT_JS_IRIS_BUSY]
  sMDL_PILOT.REAL_LVL_IRIS_PREV = sMDL_PILOT.REAL_LVL_IRIS

  IF(TIMELINE_ACTIVE(TL_IRIS_SPEED))
    TIMELINE_KILL(TL_IRIS_SPEED)

  FOR(nLOOP=1; nLOOP<=10; nLOOP++)
  {
    IRIS_HISTORY[nLOOP] = 0
  }
  IRIS_PTR = 0

  PREV_IRIS_DIR = 0
  IRIS_DIR = 0
  sMDL_PILOT.IRIS_SPD_LVL = 128
  sMDL_PILOT.IRIS_AVG_LVL = 128
  sMDL_PILOT.IRIS_SPD     = 0


  SEND_LEVEL vdvPILOT,22,sMDL_PILOT.FOCUS_SPD
  SEND_LEVEL vdvPILOT,17,sMDL_PILOT.FOCUS_SPD_LVL
  SEND_LEVEL vdvPILOT,11,sMDL_PILOT.FOCUS_AVG_LVL
}


(**************************)
(*** ONLINE CALIBRATION ***)
(**************************)
TIMELINE_EVENT[TL_CALIBRATE]
{
  ON[vdvPILOT,PILOT_CALIBRATED]

(*** Take snapshot of current levels ***)
  sMDL_PILOT.JS_CENTER_PAN  = 32768
  sMDL_PILOT.JS_CENTER_TILT = 32768
  sMDL_PILOT.JS_CENTER_ZOOM = 32768
  sMDL_PILOT.JS_CENTER_FOCUS= 17344

(*** These levels don't seem to report with ONLINE ***)
  sMDL_PILOT.FOCUS_SPD_LVL = 128
  sMDL_PILOT.FOCUS_AVG_LVL = 128
  SEND_LEVEL vdvPILOT,16,sMDL_PILOT.FOCUS_SPD_LVL
  SEND_LEVEL vdvPILOT,10,sMDL_PILOT.FOCUS_AVG_LVL

  sMDL_PILOT.IRIS_SPD_LVL  = 128
  sMDL_PILOT.IRIS_AVG_LVL  = 128
  SEND_LEVEL vdvPILOT,17,sMDL_PILOT.IRIS_SPD_LVL
  SEND_LEVEL vdvPILOT,11,sMDL_PILOT.IRIS_AVG_LVL


  IF([vdvPILOT,PILOT_DEBUG])
    SEND_STRING 0,"13,10,'JOYSTICK HAS BEEN CALIBRATED AT ',TIME"
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


(*** IRIS (THIS WILL MAKE THE UI MODULE DO THE WORK) *******)
[vdvPILOT,PILOT_IRIS_OPEN]  = (sMDL_PILOT.IRIS_AVG_LVL > 128) && [vdvPILOT,PILOT_JS_IRIS_BUSY]
[vdvPILOT,PILOT_IRIS_CLOSE] = (sMDL_PILOT.IRIS_AVG_LVL < 128) && [vdvPILOT,PILOT_JS_IRIS_BUSY]



(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

