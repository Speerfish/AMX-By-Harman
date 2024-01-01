PROGRAM_NAME='CANON, VCC1, RS-232, BASIC, 10-96, WA'
(*   DATE:05/20/99    TIME:16:38:49    *)
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

(***********************************************************)
(***********************************************************)
(* NOTES -                                                 *)
(* THERE ARE THREE SETS OF COMMAND TYPES:  CAMERA CONTROL, *)
(* PEDESTAL CONTROL AND UNIVERSAL CONTROL COMMANDS.        *)
(*                                                         *)
(* FOR PROPER USE OF THE PEDESTAL COMMANDS, AFTER THE VC-C1*)
(* IS TURNED ON, THE CAMERA SHOULD BE INITIALIZED TO LEARN *)
(* THE ABSOLUTE PAN/TILT POSITION.  AFTER INITIALIZATION,  *)
(* THE CAMERA IS ABLE TO ACCEPT THE SET/GET ANGLE COMMANDS.*)
(*                                                         *)
(* LENGTHENED THE WAIT TIME TO RECALL ABSOLUTE PAN/TILT/   *)
(* ZOOM POSITIONS TO 1.5 SECONDS.                          *)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

CAMERA  = 2                  (* RS232: CANON VC-C1  9600,8,N,2 *)
PANEL   = 128                (* AMX PANEL *)
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

CAM_BUFFER[30]               (* CAMERA BUFFER *)
PAN_ANGLE[8][3]              (* ABSOLUTE PAN ANGLE FOR PRESETS 7-15 *)
TILT_ANGLE[8][3]             (* ABSOLUTE TILT ANGLE FRO PRESETS 7-15 *)
ZOOM_POSITION[8][3]          (* GET ZOOM POSITION FOR PRESETS 7-15 *)
LOWEST_PAN_MOTOR_SPEED[3]    (* PAN MOTER SPEED LOWEST VALUE *)
MAX_PAN_ANGLE_VALUE[3]       (* PAN MAXIMUM ANGLE VALUE *)
(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*              TOGGLING DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_TOGGLING

(***********************************************************)
(*           SUBROUTINE DEFINITIONS GO BELOW               *)
(***********************************************************)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

SEND_COMMAND CAMERA,'HSON'         (* ENABLE HARDWARE HANDSHAKING *)

CREATE_BUFFER CAMERA,CAM_BUFFER    (* CREATE CAMERA BUFFER *)
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

               (***************************)
               (* CAMERA CONTROL COMMANDS *)
               (***************************)

PUSH[PANEL,10]               (* OPERATE ON *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A0,$31,$EF"

PUSH[PANEL,11]               (* OPERATE OFF *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A0,$30,$EF"

PUSH[PANEL,12]               (* FOCUS FAR *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A1,$33,$EF"

PUSH[PANEL,13]               (* FOCUS NEAR *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A1,$32,$EF"

RELEASE[PANEL,12]            (* FOCUS FAR *)
RELEASE[PANEL,13]            (* FOCUS NEAR *)
  (*
   *    NOTE:  USE MANUAL MODE STRING TO STOP LENS.
  *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A1,$31,$EF"

PUSH[PANEL,14]               (* AUTO FOCUS *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A1,$30,$EF"

PUSH[PANEL,15]               (* MANUAL FOCUS *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A1,$31,$EF"

PUSH[PANEL,16]               (* LOW SPEED TELE ZOOMING/ZOOM IN *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A2,$32,$EF"

PUSH[PANEL,17]               (* HIGH SPEED TELE ZOOMING/ZOOM IN *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A2,$34,$EF"

PUSH[PANEL,18]              (* LOW SPEED WIDE ZOOMING/ZOOM OUT *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A2,$31,$EF"

PUSH[PANEL,19]              (* HIGH SPEED WIDE ZOOMING/ZOOM OUT *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A2,$33,$EF"

RELEASE[PANEL,16]                         (* STOP ZOOMING *)
RELEASE[PANEL,17]
RELEASE[PANEL,18]
RELEASE[PANEL,19]
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A2,$30,$EF"

PUSH[PANEL,22]              (* BACK LIGHT COMP. OFF *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A5,$30,$EF"

PUSH[PANEL,23]              (* BACK LIGHT COMP. ON *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A5,$31,$EF"

PUSH[PANEL,24]              (* AUTO WHITE BALANCE: NORMAL *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A7,$30,$EF"

PUSH[PANEL,25]              (* AUTO WHITE BALANCE: LOCK *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A7,$31,$EF"

PUSH[PANEL,26]               (* NORMAL FADE *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A9,$30,$EF"

PUSH[PANEL,27]               (* WHITE FADE *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A9,$31,$EF"

PUSH[PANEL,28]               (* HI-SPEED WHITE FADE *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A9,$32,$EF"

PUSH[PANEL,29]               (* HI-SPEED BLACK FADE *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$A9,$33,$EF"

              (*****************************)
              (* PEDESTAL CONTROL COMMANDS *)
              (*****************************)

PUSH[PANEL,30]               (* PEDESTAL INITIALIZE:  GOTO HOME POSITION *)
{                            (* AND MOTOR SPEED DEFAULT *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$58,$30,$EF"
}

PUSH[PANEL,31]               (* PEDESTAL INITIALIZE:  GOTO ORIGINAL *)
{                            (* POSITION AND MOTOR SPEED DEFAULT *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$58,$31,$EF"
}

PUSH[PANEL,32]               (* PAN LEFT *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$53,$32,$EF"

PUSH[PANEL,33]               (* PAN RIGHT *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$53,$31,$EF"

PUSH[PANEL,34]               (* TILT UP *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$53,$33,$EF"

PUSH[PANEL,35]               (* TILT DOWN *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$53,$34,$EF"

RELEASE[PANEL,32]            (* PAN LEFT *)
RELEASE[PANEL,33]            (* PAN RIGHT *)
RELEASE[PANEL,34]            (* TILT UP *)
RELEASE[PANEL,35]            (* TILT DOWN *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$53,$30,$EF"

PUSH[PANEL,36]               (* GOTO HOME POSITION *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$57,$EF"

PUSH[PANEL,37]               (* GET PAN MOTOR SPEED LOWEST VALUE *)
{
  CLEAR_BUFFER CAM_BUFFER
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$59,$30,$EF"
  WAIT_UNTIL (LENGTH_STRING(CAM_BUFFER) AND FIND_STRING(CAM_BUFFER,"$FE",1))
    LOWEST_PAN_MOTOR_SPEED = MID_STRING(CAM_BUFFER,6,3)
}

PUSH[PANEL,53]               (* GET PAN MAXIMUM ANGLE VALUE *)
{
  CLEAR_BUFFER CAM_BUFFER
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$5A,$31,$EF"
  WAIT_UNTIL (LENGTH_STRING(CAM_BUFFER) AND FIND_STRING(CAM_BUFFER,"$FE",1))
    MAX_PAN_ANGLE_VALUE = MID_STRING(CAM_BUFFER,6,3)
}

            (******************************)
            (* UNIVERSAL CONTROL COMMANDS *)
            (******************************)

PUSH[PANEL,38]               (* STORE PRESET 1 *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$89,$31,$EF"

PUSH[PANEL,39]               (* STORE PRESET 3 *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$89,$33,$EF"

PUSH[PANEL,40]               (* STORE PRESET 5 *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$89,$35,$EF"

PUSH[PANEL,41]               (* RECALL PRESET 1 *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$8A,$31,$EF"

PUSH[PANEL,42]               (* RECALL PRESET 3 *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$8A,$33,$EF"

PUSH[PANEL,43]               (* RECALL PRESET 5 *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$8A,$35,$EF"

PUSH[PANEL,44]               (* STORE PRESET 7 *)
{
  CLEAR_BUFFER CAM_BUFFER    (* GET ABSOLUTE PAN ANGLE *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$56,$30,$EF"
  WAIT_UNTIL (LENGTH_STRING(CAM_BUFFER) AND FIND_STRING(CAM_BUFFER,"$FE",1))
  {
     PAN_ANGLE[1] = MID_STRING(CAM_BUFFER,6,3)
     CLEAR_BUFFER CAM_BUFFER (* GET ABSOLUTE TILT ANGLE *)
     SEND_STRING CAMERA,"$FF,$30,$30,$00,$56,$31,$EF"
     WAIT_UNTIL (LENGTH_STRING(CAM_BUFFER) AND FIND_STRING(CAM_BUFFER,"$FE",1))
     {
        TILT_ANGLE[1] = MID_STRING(CAM_BUFFER,6,3)
        CLEAR_BUFFER CAM_BUFFER(* GET ZOOM POSITION *)
        SEND_STRING CAMERA,"$FF,$30,$30,$00,$A4,$EF"
        WAIT_UNTIL (LENGTH_STRING(CAM_BUFFER) AND FIND_STRING(CAM_BUFFER,"$FE",1))
          ZOOM_POSITION[1] = MID_STRING(CAM_BUFFER,6,2)
     }
  }
}

PUSH[PANEL,45]               (* RECALL RECALL PRESET 7 *)
{
  CLEAR_BUFFER CAM_BUFFER    (* ACCESS ABSOLUTE PAN ANGLE *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$55,TILT_ANGLE[1],$EF"
  WAIT 15                    (* ACCESS ABSOLUTE TILT ANGLE *)
  {
    SEND_STRING CAMERA,"$FF,$30,$30,$00,$54,PAN_ANGLE[1],$EF"
    WAIT 15                  (* ZOOM POSITON *)
      SEND_STRING CAMERA,"$FF,$30,$30,$00,$A3,ZOOM_POSITION[1],$EF"
  }
}

PUSH[PANEL,70]               (* CAMERA RESET *)
  SEND_STRING CAMERA,"$FF,$30,$30,$00,$AA,$EF"
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
