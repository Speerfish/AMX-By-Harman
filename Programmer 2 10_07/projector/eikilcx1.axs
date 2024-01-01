PROGRAM_NAME='EIKI, LCX1, RS-232, BASIC, CWR'
(*   DATE:05/20/99    TIME:15:32:06    *)
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
(* POWER      -  ON/OFF                                    *)
(* VID MUTE   -  ON/OFF (!!USE MOMENTARY FB!!)             *)
(* INPUTS     -  VID1, VID2, RGB1, RGB2                    *)
(* ZOOM, FOCUS, LENS SHIFT, FREEZE                         *)
(* CURSOR CONTROL, MENU ON/OFF, ENTER                      *)
(* MISC: DISPLAY CLEAR, DEFAULT, NORMAL, AUTO IMAGE, P-TMR *)

(***********************************************************)
(* FIND.NOTES *)
(* NOTES:                                                  *)
(*   -  BE WARNED, THIS PROJECTOR INTERMITTENTLY STOPS     *)
(*      EXECUTING AND ACKNOWLEDGING COMMANDS.  THE ONLY    *)
(*      WAY FOUND TO RE-ESTABLISH COMMUNICATIONS IS BY     *)
(*      REMOVING THE POWER CHORD (OR THE LINE SWITCH).     *)
(*   -  THIS PROGRAM HAS NOT LOCKED UP THE PROJECTOR, BUT  *)
(*      A SURE WAY TO LOCK IT UP IS: ZOOM ('C80')          *)
(*      IMMEDIATELY FOLLOWED BY ZOOM IN OR ZOOM OUT ('C46')*)
(*      THIS IS NOT A CORRECT USAGE OF THE PROTOCOL!       *)
(*   -  SEARCH FOR FIND.NOTES FOR IMPORTANT PROGRAMMING    *)
(*      NOTES.                                             *)

(***********************************************************)
(* System Type :  AXB-EM232 v4.020                         *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(* AXB-EM232 (v4.020) *)
VPROJ   =  1     (* EIKI LC-X1 (LCD PROJECTOR)                   192/8/N/1 *)

TP      =  128   (* AXT-EL+ *)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(*** EIKI LC-X1 (CHANNELS USED) ***)
VP_PWR        =  9     (* POWER STATE                                     *)
VP_ON_DELAY   = 10     (* DELAY AFTER THE 'ON' CMD IS ISSUED              *)
VP_OFF_DELAY  = 11     (* DELAY AFTER THE 'OFF' CMD IS ISSUED             *)

VP_VID_MUTE   =  20    (* VIDEO MUTE FLAG                                 *)

VP_VOL_UP     =  24    (* VOLUME                                          *)
VP_VOL_DN     =  25
VP_VOL_MUTE   =  26

VP_VID1       =  51    (* INPUTS SELECTED                                 *)
VP_VID2       =  52
VP_RGB1       =  53
VP_RGB2       =  54

VP_ZOOM_IN    =  61    (* ZOOM                                            *)
VP_ZOOM_OUT   =  62

VP_FOCUS_NEAR =  63    (* FOCUS                                           *)
VP_FOCUS_FAR  =  64

VP_LENS_UP    =  65    (* LENS SHIFT                                      *)
VP_LENS_DN    =  66

VP_MENU       =  67
VP_FREEZE     =  68

VP_CUR_UP     =  71    (* CURSOR CONTROL                                  *)
VP_CUR_DN     =  72
VP_CUR_LT     =  73
VP_CUR_RT     =  74

VP_ON      =  27       (* FUNCTIONS *)
VP_OFF     =  28

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

FLASH

(*** EIKI LC-X1 ***)
DEBUG_VPROJ         (* FLAG TO SEND RESPONSES TO TERMINAL                 *)
VPROJ_BUFF[100]     (* RESPONSES                                          *)
RESPONSE[30]

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

(****************)
(* EIKI LCX1 FN *)
(***********************************************************)
(* FUNCTIONS: PWR ON/OFF, VIDEO MUTE, AUDIO MUTE, INPUT    *)
(*  SELECTS (VID1,VID2,RGB1,RGB2), ZOOM, FOCUS, LENS SHIFT *)
(***********************************************************)
DEFINE_CALL 'EIKI LCX1 FN' (FN)
{
  SELECT
  {
    ACTIVE (FN = VP_ON) :          (* POWER ON ******************************)
    {
      SEND_STRING VPROJ,"'C00',13"
                                   (* FIND.NOTES *)
      IF(![VPROJ,VP_PWR])          (* NOTE: THE FIRST 'ON' CMD ISSUED WILL  *)
      {                            (* TURN THE PROJECTOR ON WITH THE 'EIKI' *)
        ON [VPROJ,VP_ON_DELAY]     (* LOGO DISPLAYED WITH A COUNTDOWN TIMER.*)
        WAIT 300 'VP ON DELAY'
          OFF[VPROJ,VP_ON_DELAY]
      }
      ELSE                         (* ELSE, THE SECOND 'ON' CMD ISSUED WILL *)
      {                            (* STOP THE EIKI POWER ON COUNTDOWN TIMER*)
        CANCEL_WAIT 'VP ON DELAY'  (* AND REMOVE THE 'EIKI' LOGO FROM THE   *)
        OFF[VPROJ,VP_ON_DELAY]     (* DISPLAY!!  MOST OTHER CMDS WILL ALSO  *)
      }                            (* CANCEL THIS ON TIMER!!                *)
      ON [VPROJ,VP_PWR]
      OFF[VPROJ,VP_VID_MUTE]
    }
    ACTIVE (FN = VP_OFF) :         (* POWER OFF *****************************)
    {
      SEND_STRING VPROJ,"'C01',13"
                                   (* FIND.NOTES *)
      IF([VPROJ,VP_PWR])           (* NOTE: ONCE THE 'OFF' CMD IS ISSUED,   *)
      {                            (* THE EIKI IS LOCKED INTO IT'S 60 SECOND*)
        CANCEL_WAIT 'VP ON DELAY'  (* TIMER FOR FAN EXHAUST WITH LAMP OFF.  *)
        OFF[VPROJ,VP_ON_DELAY]     (* ONCE HERE, YOU MUST WAIT TO TURN IT   *)
                                   (* BACK ON!                              *)
        ON [VPROJ,VP_OFF_DELAY]
        WAIT 600 'VP OFF DELAY'
          OFF[VPROJ,VP_OFF_DELAY]
      }
      OFF[VPROJ,VP_PWR]
      OFF[VPROJ,VP_VID_MUTE]
    }
    ACTIVE (FN = VP_VID1) :        (* INPUT = VID1 **************************)
    {
      SEND_STRING VPROJ,"'C07',13"
    (* INPUT SELECT *)
      ON [VPROJ,VP_VID1]
      OFF[VPROJ,VP_VID2]
      OFF[VPROJ,VP_RGB1]
      OFF[VPROJ,VP_RGB2]
      OFF[VPROJ,VP_VID_MUTE]
    }
    ACTIVE (FN = VP_VID2) :        (* INPUT = VID2 **************************)
    {
      SEND_STRING VPROJ,"'C08',13"
    (* INPUT SELECT *)
      OFF[VPROJ,VP_VID1]
      ON [VPROJ,VP_VID2]
      OFF[VPROJ,VP_RGB1]
      OFF[VPROJ,VP_RGB2]
      OFF[VPROJ,VP_VID_MUTE]
    }
    ACTIVE (FN = VP_RGB1) :        (* INPUT = RGB1 **************************)
    {
      SEND_STRING VPROJ,"'C05',13"
    (* INPUT SELECT *)
      OFF[VPROJ,VP_VID1]
      OFF[VPROJ,VP_VID2]
      ON [VPROJ,VP_RGB1]
      OFF[VPROJ,VP_RGB2]
      OFF[VPROJ,VP_VID_MUTE]
    }
    ACTIVE (FN = VP_RGB2) :        (* INPUT = RGB2 **************************)
    {
      SEND_STRING VPROJ,"'C06',13"
    (* INPUT SELECT *)
      OFF[VPROJ,VP_VID1]
      OFF[VPROJ,VP_VID2]
      OFF[VPROJ,VP_RGB1]
      ON [VPROJ,VP_RGB2]
      OFF[VPROJ,VP_VID_MUTE]
    }
    ACTIVE (FN = VP_VID_MUTE) :    (* VIDEO MUTE ON *************************)
    {
      SEND_STRING VPROJ,"'C0D',13"
      ON [VPROJ,VP_VID_MUTE]
    }
    ACTIVE (FN = (VP_VID_MUTE | $100)) : (* VIDEO MUTE OFF ******************)
    {
      SEND_STRING VPROJ,"'C0E',13"
      OFF[VPROJ,VP_VID_MUTE]
    }
    ACTIVE (FN = VP_VOL_MUTE) :    (* AUDIO MUTE ON *************************)
    {
      SEND_STRING VPROJ,"'C0B',13"
      ON [VPROJ,VP_VOL_MUTE]
    }
    ACTIVE (FN = (VP_VOL_MUTE | $100)) : (* AUDIO MUTE OFF ******************)
    {
      SEND_STRING VPROJ,"'C0C',13"
      OFF[VPROJ,VP_VOL_MUTE]
    }
    ACTIVE (FN = VP_ZOOM_IN) :     (* ZOOM TELE *****************************)
    {
      OFF[VPROJ,VP_VID_MUTE]
      OFF[VPROJ,VP_ZOOM_OUT]
      ON [VPROJ,VP_ZOOM_IN]
      SEND_STRING VPROJ,"'C46',13"
    }
    ACTIVE (FN = VP_ZOOM_OUT) :    (* ZOOM WIDE *****************************)
    {
      OFF[VPROJ,VP_VID_MUTE]
      ON [VPROJ,VP_ZOOM_OUT]
      OFF[VPROJ,VP_ZOOM_IN]
      SEND_STRING VPROJ,"'C47',13"
    }
    ACTIVE ((FN = (VP_ZOOM_IN  | $100)) ||
            (FN = (VP_ZOOM_OUT | $100))) :  (* ZOOM STOP ********************)
    {
      OFF[VPROJ,VP_VID_MUTE]
      OFF[VPROJ,VP_ZOOM_OUT]
      OFF[VPROJ,VP_ZOOM_IN]
    }
    ACTIVE (FN = VP_FOCUS_NEAR) :  (* FOCUS NEAR ****************************)
    {
      OFF[VPROJ,VP_VID_MUTE]
      OFF[VPROJ,VP_FOCUS_FAR]
      ON [VPROJ,VP_FOCUS_NEAR]
      SEND_STRING VPROJ,"'C4A',13"
    }
    ACTIVE (FN = VP_FOCUS_FAR) :   (* FOCUS FAR *****************************)
    {
      OFF[VPROJ,VP_VID_MUTE]
      ON [VPROJ,VP_FOCUS_FAR]
      OFF[VPROJ,VP_FOCUS_NEAR]
      SEND_STRING VPROJ,"'C4B',13"
    }
    ACTIVE ((FN = (VP_FOCUS_FAR  | $100)) ||
            (FN = (VP_FOCUS_NEAR | $100))) :(* FOCUS STOP *******************)
    {
      OFF[VPROJ,VP_VID_MUTE]
      OFF[VPROJ,VP_FOCUS_FAR]
      OFF[VPROJ,VP_FOCUS_NEAR]
    }
    ACTIVE (FN = VP_LENS_UP) :     (* LENS SHIFT UP *************************)
    {
      OFF[VPROJ,VP_VID_MUTE]
      OFF[VPROJ,VP_LENS_DN]
      ON [VPROJ,VP_LENS_UP]
      SEND_STRING VPROJ,"'C5D',13"
    }
    ACTIVE (FN = VP_LENS_DN) :     (* LENS SHIFT DOWN ***********************)
    {
      OFF[VPROJ,VP_VID_MUTE]
      ON [VPROJ,VP_LENS_DN]
      OFF[VPROJ,VP_LENS_UP]
      SEND_STRING VPROJ,"'C5E',13"
    }
    ACTIVE ((FN = (VP_LENS_UP | $100)) ||
            (FN = (VP_LENS_DN | $100))) :   (* LENS SHIFT STOP **************)
    {
      OFF[VPROJ,VP_VID_MUTE]
      OFF[VPROJ,VP_LENS_UP]
      OFF[VPROJ,VP_LENS_DN]
    }
  }
}


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(*** EIKI LC-X1 ***)
DEBUG_VPROJ = 1
CREATE_BUFFER VPROJ,VPROJ_BUFF
VPROJ_BUFF = ""

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

WAIT 5 'FLASH'
  FLASH = !FLASH

                                   (************************)
                                   (* POWER                *)
                                   (************************)
(* FIND.NOTES *)
(* NOTE: - ONCE THE POWER OFF CMD IS ISSUED, YOU MUST DELAY BEFORE TURNING  *)
(*         THE UNIT BACK ON!  THE PROJECTOR WILL NOT TURN BACK ON UNTIL     *)
(*         IT HAS FINISHED IT'S COOL DOWN PROCESS (1 MINUTE).               *)
(*       - WHEN THE POWER ON CMD IS ISSUED, THE EIKI LOGO IS DISPLAYED WITH *)
(*         A COUNTDOWN TIMER (30 SECONDS).  IF ANOTHER ON CMD OR AN INPUT   *)
(*         SELECT CMD IS ISSUED, THE LOGO DISAPPEARS AND THE INPUT IS       *)
(*         DISPLAYED.  THIS PROGRAM PROVIDES A VP_ON_DELAY CHANNEL FOR FB   *)
(*         BUT IT SHOULD BE CONSIDERED FB ONLY AND NOT A FLAG TO ISSUE      *)
(*         OTHER COMMANDS ON A TIMED BASIS!                                 *)
PUSH[TP,1]                         (* POWER ON ******************************)
{
  IF([VPROJ,VP_OFF_DELAY])
    SEND_COMMAND TP,'ADBEEP'
  ELSE
    CALL 'EIKI LCX1 FN' (VP_ON)
}
[TP,1] = [VPROJ,VP_PWR]

PUSH[TP,2]                         (* POWER OFF *****************************)
{
  CALL 'EIKI LCX1 FN' (VP_OFF)
}
[TP,2] = (![VPROJ,VP_PWR])

[TP,3] = [VPROJ,VP_ON_DELAY] && FLASH
[TP,4] = [VPROJ,VP_OFF_DELAY] && FLASH

                                   (************************)
                                   (* INPUT SELECT         *)
                                   (************************)
(* FIND.NOTES *)
(* NOTE:-THIS PROJECTOR WILL ALLOW YOU TO SELECT AN INPUT WHILE THE PROJECOR*)
(*       IS OFF.  WHEN POWER IS TURNED BACK ON, THE LAST SELECTED INPUT WILL*)
(*       BECOME THE NEW SOURCE!!                                            *)
(*      -INPUT SELECTS WILL TURN OFF VIDEO MUTE.                            *)
(*      -INPUT SELECTS WILL NOT TURN PROJECTOR ON.                          *)
PUSH[TP,5]                         (* INPUT = VID1 **************************)
{
  CALL 'EIKI LCX1 FN' (VP_VID1)
}
[TP,5] = [VPROJ,VP_VID1] && [VPROJ,VP_PWR]

PUSH[TP,6]                         (* INPUT = VID2 **************************)
{
  CALL 'EIKI LCX1 FN' (VP_VID2)
}
[TP,6] = [VPROJ,VP_VID2] && [VPROJ,VP_PWR]

PUSH[TP,7]                         (* INPUT = RGB1 **************************)
{
  CALL 'EIKI LCX1 FN' (VP_RGB1)
}
[TP,7] = [VPROJ,VP_RGB1] && [VPROJ,VP_PWR]

PUSH[TP,8]                         (* INPUT = RGB2 **************************)
{
  CALL 'EIKI LCX1 FN' (VP_RGB2)
}
[TP,8] = [VPROJ,VP_RGB2] && [VPROJ,VP_PWR]


PUSH[TP,9]                         (* VIDEO MUTE ****************************)
{
  TO [TP,9]
  IF(![VPROJ,VP_VID_MUTE])
    CALL 'EIKI LCX1 FN' (VP_VID_MUTE)          (* MUTE ON *)
  ELSE
    CALL 'EIKI LCX1 FN' (VP_VID_MUTE | $100)   (* MUTE OFF *)
}
(* MOMENTARY FB RECOMMENDED WITH VIDEO MUTE BUTTON. THE MUTE ON/OFF WORKS
   DISCRETELY, BUT THE PROJECTOR WILL PUT THE PROJECTOR VIDEO MUTE ON/OFF
   SPORADICALLY WITH OTHER FUNCTIONS SUCH AS ZOOM, FOCUS, LENS SHIFT...
[TP,9] = [VPROJ,VP_VID_MUTE] && [VPROJ,VP_PWR]
*)

                                   (************************)
                                   (* AUDIO                *)
                                   (************************)
PUSH[TP,10]                        (* VOL UP ********************************)
{
  ON [VPROJ,VP_VOL_UP]
  OFF[VPROJ,VP_VOL_DN]
  OFF[VPROJ,VP_VOL_MUTE]
  SEND_STRING VPROJ,"'C09',13"
}
[TP,10] = [VPROJ,VP_VOL_UP]

PUSH[TP,11]                        (* VOL DOWN ******************************)
{
  ON [VPROJ,VP_VOL_DN]
  OFF[VPROJ,VP_VOL_UP]
  OFF[VPROJ,VP_VOL_MUTE]
  SEND_STRING VPROJ,"'C0A',13"
}
[TP,11] = [VPROJ,VP_VOL_DN]

RELEASE[TP,10]
RELEASE[TP,11]
{
  OFF[VPROJ,VP_VOL_DN]
  OFF[VPROJ,VP_VOL_UP]
  CANCEL_WAIT 'VP VOL RAMP'
}

IF([VPROJ,VP_VOL_UP] || [VPROJ,VP_VOL_DN])  (* VOL RAMPING ******************)
{
  WAIT 3 'VP VOL RAMP'
  {
    SELECT
    {
      ACTIVE ([VPROJ,VP_VOL_UP]) : SEND_STRING VPROJ,"'C09',13"
      ACTIVE ([VPROJ,VP_VOL_DN]) : SEND_STRING VPROJ,"'C0A',13"
    }
  }
}

PUSH[TP,12]                        (* VOL MUTE ******************************)
{
  IF(![VPROJ,VP_VOL_MUTE])
    CALL 'EIKI LCX1 FN' (VP_VOL_MUTE)          (* MUTE ON *)
  ELSE
    CALL 'EIKI LCX1 FN' (VP_VOL_MUTE | $100)   (* MUTE OFF *)
}
[TP,12] = [VPROJ,VP_VOL_MUTE] && [VPROJ,VP_PWR]


                                   (************************)
                                   (* ZOOM                 *)
                                   (************************)
PUSH[TP,13]                        (* ZOOM IN *******************************)
{
  CALL 'EIKI LCX1 FN' (VP_ZOOM_IN)
}
[TP,13] = [VPROJ,VP_ZOOM_IN]

PUSH[TP,14]                        (* ZOOM OUT ******************************)
{
  CALL 'EIKI LCX1 FN' (VP_ZOOM_OUT)
}
[TP,14] = [VPROJ,VP_ZOOM_OUT]

RELEASE[TP,13]
RELEASE[TP,14]
{
  CALL 'EIKI LCX1 FN' (VP_ZOOM_IN | $100)
  CANCEL_WAIT 'VP ZOOM RAMP'
}

IF([VPROJ,VP_ZOOM_IN] || [VPROJ,VP_ZOOM_OUT])     (* ZOOM RAMPING ***********)
{
  WAIT 3 'VP ZOOM RAMP'
  {
    SELECT
    {
      ACTIVE ([VPROJ,VP_ZOOM_IN])  : CALL 'EIKI LCX1 FN' (VP_ZOOM_IN)
      ACTIVE ([VPROJ,VP_ZOOM_OUT]) : CALL 'EIKI LCX1 FN' (VP_ZOOM_OUT)
    }
  }
}

                                   (************************)
                                   (* FOCUS                *)
                                   (************************)
PUSH[TP,16]                        (* FOCUS NEAR ****************************)
{
  CALL 'EIKI LCX1 FN' (VP_FOCUS_NEAR)
}
[TP,16] = [VPROJ,VP_FOCUS_NEAR]

PUSH[TP,17]                        (* FOCUS FAR *****************************)
{
  CALL 'EIKI LCX1 FN' (VP_FOCUS_FAR)
}
[TP,17] = [VPROJ,VP_FOCUS_FAR]

RELEASE[TP,16]
RELEASE[TP,17]
{
  CALL 'EIKI LCX1 FN' (VP_FOCUS_NEAR | $100)
  CANCEL_WAIT 'VP FOCUS RAMP'
}

IF([VPROJ,VP_FOCUS_NEAR] || [VPROJ,VP_FOCUS_FAR]) (* FOCUS RAMPING **********)
{
  WAIT 3 'VP FOCUS RAMP'
  {
    SELECT
    {
      ACTIVE ([VPROJ,VP_FOCUS_NEAR]) : CALL 'EIKI LCX1 FN' (VP_FOCUS_NEAR)
      ACTIVE ([VPROJ,VP_FOCUS_FAR])  : CALL 'EIKI LCX1 FN' (VP_FOCUS_FAR)
    }
  }
}


                                   (************************)
                                   (* LENS SHIFT           *)
                                   (************************)
PUSH[TP,19]                        (* LENS UP *******************************)
{
  CALL 'EIKI LCX1 FN' (VP_LENS_UP)
}
[TP,19] = [VPROJ,VP_LENS_UP]

PUSH[TP,20]                        (* LENS DOWN *****************************)
{
  CALL 'EIKI LCX1 FN' (VP_LENS_DN)
}
[TP,20] = [VPROJ,VP_LENS_DN]

RELEASE[TP,19]
RELEASE[TP,20]
{
  CALL 'EIKI LCX1 FN' (VP_LENS_UP | $100)
  CANCEL_WAIT 'VP LENS SHIFT RAMP'
}

IF([VPROJ,VP_LENS_UP] || [VPROJ,VP_LENS_DN])      (* LENS SHIFT RAMPING *****)
{
  WAIT 3 'VP LENS SHIFT RAMP'
  {
    SELECT
    {
      ACTIVE ([VPROJ,VP_LENS_UP]) : CALL 'EIKI LCX1 FN' (VP_LENS_UP)
      ACTIVE ([VPROJ,VP_LENS_DN]) : CALL 'EIKI LCX1 FN' (VP_LENS_DN)
    }
  }
}


                                   (************************)
                                   (* Z/F/L                *)
                                   (************************)
(* FIND.NOTES *)
(* NOTE: THESE COMMANDS ARE USED WITH THE CURSOR UP/DN BUTTONS TO OFFER     *)
(*       SIMILAR CONTROL AS PROVIDED BY THE HAND CONTROL.  THE IDEA IS TO   *)
(*       SELECT ZOOM, FOCUS, LENS SHIFT (MUTUALLY EXCLUSIVE) AND THEN       *)
(*       CURSOR UP/DOWN.                                                    *)
(* !!WARNING: DO NOT USE THIS COMMAND WITH THE DISCRETE ZOOM IN/OUT,        *)
(*            FOCUS NEAR/FAR, LENS SHIFT UP/DOWN.  IT WILL LOCK UP THE      *)
(*            PROJECTOR WHERE ONLY POWER CYCLE WILL BRING IT BACK!!         *)
PUSH[TP,15]                        (* ZOOM **********************************)
  SEND_STRING VPROJ,"'C80',13"

PUSH[TP,18]                        (* FOCUS *********************************)
  SEND_STRING VPROJ,"'C87',13"

PUSH[TP,21]                        (* LENS SHIFT ****************************)
  SEND_STRING VPROJ,"'C88',13"


                                   (************************)
                                   (* CURSOR               *)
                                   (************************)
PUSH[TP,22]                        (* CURSOR UP *****************************)
{
  ON [VPROJ,VP_CUR_UP]
  OFF[VPROJ,VP_CUR_DN]
  OFF[VPROJ,VP_CUR_LT]
  OFF[VPROJ,VP_CUR_RT]
  SEND_STRING VPROJ,"'C3C',13"
}

PUSH[TP,23]                        (* CURSOR DOWN ***************************)
{
  OFF[VPROJ,VP_CUR_UP]
  ON [VPROJ,VP_CUR_DN]
  OFF[VPROJ,VP_CUR_LT]
  OFF[VPROJ,VP_CUR_RT]
  SEND_STRING VPROJ,"'C3D',13"
}

PUSH[TP,24]                        (* CURSOR LEFT ***************************)
{
  OFF[VPROJ,VP_CUR_UP]
  OFF[VPROJ,VP_CUR_DN]
  ON [VPROJ,VP_CUR_LT]
  OFF[VPROJ,VP_CUR_RT]
  SEND_STRING VPROJ,"'C3B',13"
}

PUSH[TP,25]                        (* CURSOR RIGHT **************************)
{
  OFF[VPROJ,VP_CUR_UP]
  OFF[VPROJ,VP_CUR_DN]
  OFF[VPROJ,VP_CUR_LT]
  ON [VPROJ,VP_CUR_RT]
  SEND_STRING VPROJ,"'C3A',13"
}

RELEASE[TP,22]
RELEASE[TP,23]
RELEASE[TP,24]
RELEASE[TP,25]
{
  OFF[VPROJ,VP_CUR_UP]
  OFF[VPROJ,VP_CUR_DN]
  OFF[VPROJ,VP_CUR_LT]
  OFF[VPROJ,VP_CUR_RT]
  CANCEL_WAIT 'VP CURSOR RAMP'
}
[TP,22] = [VPROJ,VP_CUR_UP]
[TP,23] = [VPROJ,VP_CUR_DN]
[TP,24] = [VPROJ,VP_CUR_LT]
[TP,25] = [VPROJ,VP_CUR_RT]

IF([VPROJ,VP_CUR_UP] || [VPROJ,VP_CUR_DN] ||      (* CURSOR RAMPING *********)
   [VPROJ,VP_CUR_LT] || [VPROJ,VP_CUR_RT])
{
  WAIT 3 'VP CURSOR RAMP'
  {
    SELECT
    {
      ACTIVE ([VPROJ,VP_CUR_UP]) : SEND_STRING VPROJ,"'C3C',13"
      ACTIVE ([VPROJ,VP_CUR_DN]) : SEND_STRING VPROJ,"'C3D',13"
      ACTIVE ([VPROJ,VP_CUR_LT]) : SEND_STRING VPROJ,"'C3B',13"
      ACTIVE ([VPROJ,VP_CUR_RT]) : SEND_STRING VPROJ,"'C3A',13"
    }
  }
}

PUSH[TP,26]                        (* ENTER *********************************)
  SEND_STRING VPROJ,"'C3F',13"

PUSH[TP,27]                        (* MENU ON *******************************)
{
  TO [TP,27]
  ON [VPROJ,VP_MENU]
  SEND_STRING VPROJ,"'C1C',13"
}

PUSH[TP,35]                        (* MENU OFF ******************************)
{
  TO [TP,35]
  OFF[VPROJ,VP_MENU]
  SEND_STRING VPROJ,"'C1D',13"
}

                                   (************************)
                                   (* MISC FUNCTIONS       *)
                                   (************************)
PUSH[TP,30]                        (* FREEZE ON *****************************)
{
  TO [TP,30]
  ON [VPROJ,VP_FREEZE]
  SEND_STRING VPROJ,"'C43',13"
}

PUSH[TP,34]                        (* FREEZE OFF ****************************)
{
  TO [TP,34]
  OFF[VPROJ,VP_FREEZE]
  SEND_STRING VPROJ,"'C44',13"
}

PUSH[TP,28]                        (* DISPLAY CLEAR *************************)
  SEND_STRING VPROJ,"'C1E',13"

PUSH[TP,29]                        (* NORMAL ********************************)
  SEND_STRING VPROJ,"'C1F',13"

PUSH[TP,31]                        (* P-TIMER *******************************)
  SEND_STRING VPROJ,"'C8A',13"

                                   (* FIND.NOTES *)
PUSH[TP,32]                        (* AUTO IMAGE ****************************)
  SEND_STRING VPROJ,"'C89',13"     (* NOTE: PULLS DOWN AUTO IMAGE FROM MENU *)

PUSH[TP,33]                        (* DEFAULT *******************************)
  SEND_STRING VPROJ,"'C92',13"




                                   (************************)
                                   (* BUFFER PARSING       *)
                                   (************************)
(* FIND.NOTES *)
(* NOTE: - PROJECTOR SENDS "'2',6,13,10" FOR ANY CORRECTLY FORMATTED CMD.   *)
(*       - NO STATUS IS AVAILABLE.                                          *)
(*       - BUFFER PROCESSING IS ONLY GOOD WHEN DETERMINING WHETHER THE      *)
(*         PROJECTOR HAS STOPPED RESPONDING TO CMDS (LOCKED UP).            *)
RESPONSE = REMOVE_STRING(VPROJ_BUFF,"13,10",1)

IF(LENGTH_STRING(RESPONSE))
{
(*** DEBUG ***)
IF(DEBUG_VPROJ)
  SEND_STRING 0,"RESPONSE"

}

                                   (************************)
                                   (* MACROS               *)
                                   (************************)
(* FIND.NOTES *)
(* NOTE: - USE A 1/2 SECOND DELAY BETWEEN ON/INPUT CMDS AND INPUT/ON CMDS.  *)
PUSH[TP,250]                       (* MACRO = ON, VID1 SELECT *)
{
  CALL 'EIKI LCX1 FN' (VP_ON)
  WAIT 5 'MACRO DELAY INPUT'
    CALL 'EIKI LCX1 FN' (VP_VID1)
}


PUSH[TP,251]                       (* MACRO = RGB2 SELECT, ON *)
{
  CALL 'EIKI LCX1 FN' (VP_RGB2)
  WAIT 5 'MACRO DELAY ON'
    CALL 'EIKI LCX1 FN' (VP_ON)
}




(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

