PROGRAM_NAME='PANASONIC, WVCS604A (PRESETS), RS-485, BASIC, 1-98, BA'
(*   DATE:05/20/99    TIME:16:16:29    *)
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
(*   STORE AND RECALL PRESETS                              *)
(***********************************************************)
(* NOTES -                                                 *)
(*   This file contains only the codes for Storing and     *)
(*   Recalling Presets. For other commands (pan/tilt,      *)
(*   zoom/focus, etc.) use the 'PANASONIC WV-CS404' file.  *)
(*                                                         *)
(*   The WV-CS604A is a ceiling-mount camera unit that is  *)
(*   controlled by the WV-RM70 camera controller. The AMX  *)
(*   system sends commands to the WV-RM70 via RS485 (9600  *)
(*   baud, 8 data, No parity, 1 stop) which then passes    *)
(*   the commands on to the WV-CS604A. After a command is  *)
(*   sent to the RM70, it will return an ACK (06) when it  *)
(*   has received a good command, and then it will send a  *)
(*   response message when the CS604a notifies it that the *)
(*   CS604a has successfully received the command.         *)
(*                                                         *)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

CAMERA = 1                             (* PANASONIC WV-CS604A/RM70 *)
PANEL  = 128                           (* AMX CONTROL PANEL *)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

CAMERA_BUFFER[100] (* BUFFER FOR DATA FROM THE CS604A *)
CURRENT_PRESET     (* CURRENTLY SELECTED PRESET *)
PRESET_RESPONSE    (* COUNTER FOR NUMBER OF RESPONSE MESSAGES *)
RESPONSE[100]      (* LAST COMPLETE RESPONSE MESSAGE *)
CHAR               (* TEMPORARY VARIABLE *)

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

DEFINE_CALL 'CS604A STORE PRESET' (DEV,PST)
{
  IF ((PST >= 1) AND (PST <= 64))
  {
    PRESET_RESPONSE = 1
    SEND_STRING DEV,"$02,'GC(:0021902:0022EC8:0022011:0021912:0022010'"
    SEND_STRING DEV,"':0021902:0022228:0022051:0021912:0022',
                        ITOHEX(PST/$10),ITOHEX(PST%$10),'0',$03"
  }
}

DEFINE_CALL 'CS604A RECALL PRESET' (DEV,PST)
{
  IF ((PST >= 1) AND (PST <= 64))
    SEND_STRING DEV,"$02,'GCF:2021400:2022',
                     ITOHEX((PST-1)/$10),ITOHEX((PST-1)%$10),'0',$03"
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

CREATE_BUFFER CAMERA,CAMERA_BUFFER

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


(*** STORING PRESETS ***)
PUSH[PANEL,41]                         (* STORE PRESET #1 *)
PUSH[PANEL,42]                         (* STORE PRESET #2 *)
PUSH[PANEL,43]                         (* STORE PRESET #3 *)
PUSH[PANEL,44]                         (* STORE PRESET #4 *)
PUSH[PANEL,45]                         (* STORE PRESET #5 *)
PUSH[PANEL,46]                         (* STORE PRESET #6 *)
PUSH[PANEL,47]                         (* STORE PRESET #7 *)
PUSH[PANEL,48]                         (* STORE PRESET #8 *)
PUSH[PANEL,49]                         (* STORE PRESET #9 *)
PUSH[PANEL,50]                         (* STORE PRESET #10 *)
{
  CURRENT_PRESET = PUSH_CHANNEL - 40
  CALL 'CS604A STORE PRESET' (CAMERA,CURRENT_PRESET)
}


(*** RECALLING PRESET ***)
PUSH[PANEL,51]                         (* RECALL PRESET #1 *)
PUSH[PANEL,52]                         (* RECALL PRESET #2 *)
PUSH[PANEL,53]                         (* RECALL PRESET #3 *)
PUSH[PANEL,54]                         (* RECALL PRESET #4 *)
PUSH[PANEL,55]                         (* RECALL PRESET #5 *)
PUSH[PANEL,56]                         (* RECALL PRESET #6 *)
PUSH[PANEL,57]                         (* RECALL PRESET #7 *)
PUSH[PANEL,58]                         (* RECALL PRESET #8 *)
PUSH[PANEL,59]                         (* RECALL PRESET #9 *)
PUSH[PANEL,60]                         (* RECALL PRESET #10 *)
{
  CURRENT_PRESET = PUSH_CHANNEL - 50
  CALL 'CS604A RECALL PRESET' (CAMERA,CURRENT_PRESET)
}


(*** BUFFER PROCESSING ***)
IF (LENGTH_STRING(CAMERA_BUFFER))
{
  IF (LEFT_STRING(CAMERA_BUFFER,1) = "6")        (* ACK *)
  {
    CHAR = GET_BUFFER_CHAR(CAMERA_BUFFER)
  }
  ELSE IF (FIND_STRING(CAMERA_BUFFER,"2",1))     (* RESPONSE *)
  {
    IF (FIND_STRING(CAMERA_BUFFER,"3",1))
    {
      RESPONSE = REMOVE_STRING(CAMERA_BUFFER,"3",1)

      (* WAIT UNTIL 10 RESPONSES HAVE BEEN RECEIVED. *)
      IF (PRESET_RESPONSE < 10)
        PRESET_RESPONSE = PRESET_RESPONSE + 1
      ELSE IF (PRESET_RESPONSE = 10)
      {
        PRESET_RESPONSE = 0
        (* SEND THE "COMMAND END" COMMAND *)
        SEND_STRING CAMERA,"$02,'GCF:2021542:2021543',$03"
      }
    }
  }

}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

