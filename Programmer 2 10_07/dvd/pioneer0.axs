PROGRAM_NAME='PIONEER, CLD-V2400, RS-232, BASIC, 11-96, BA'
(*   DATE:05/20/99    TIME:16:19:05    *)
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
(*   TRANSPORTS (PL,ST,PS,SCAN,MULTI-SPEED,STILL-STEP)     *)
(***********************************************************)
(* NOTES-                                                  *)
(*   THIS DISC PLAYER CAN PLAY 4 TYPES OF DISCS: CAV LASER *)
(*   DISCS, CLV LASER DISCS, VIDEO COMPACT DISCS (CDV'S),  *)
(*   AND AUDIO COMPACT DISCS (CD'S). EVERY COMMAND IN THIS *)
(*   PROGRAM CONTAINS A COMMENT WHICH INCLUDES THE NAME OF *)
(*   THE COMMAND FOLLOWED BY THE TYPES OF DISCS ON WHICH   *)
(*   THAT COMMAND WILL WORK LISTED IN PARENTHESES. IF A    *)
(*   COMMAND IS USED WITH A DISC-TYPE WHICH IS NOT LISTED  *)
(*   WITH IT THEN THAT COMMAND WILL NOT FUNCTION.          *)
(*                                                         *)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

CLDP   = 1                             (* RS-232 DEVICE *)
PNL    = 128                           (* ANY AMX PANEL *)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

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


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


(*** TRANSPORT ***)
PUSH[PNL,11]                           (* PLAY (CAV/CLV/CD) *)
  SEND_STRING CLDP,"'PL',$0D"

PUSH[PNL,12]                           (* PAUSE (CAV/CLV/CD) *)
  SEND_STRING CLDP,"'PA',$0D"

PUSH[PNL,13]                           (* STILL (CAV) *)
  SEND_STRING CLDP,"'ST',$0D"

PUSH[PNL,14]                           (* SCAN FORWARD (CAV/CLV/CD) *)
  SEND_STRING CLDP,"'NF',$0D"

PUSH[PNL,15]                           (* SCAN REVERSE (CAV/CLV/CD) *)
  SEND_STRING CLDP,"'NR',$0D"

PUSH[PNL,16]                           (* MULTI-SPEED FORWARD (CAV) *)
  SEND_STRING CLDP,"'MF',$0D"

PUSH[PNL,17]                           (* MULTI-SPEED REVERSE (CAV) *)
  SEND_STRING CLDP,"'MR',$0D"

PUSH[PNL,18]                           (* STEP FORWARD (CAV) *)
  SEND_STRING CLDP,"'SF',$0D"

PUSH[PNL,19]                           (* STEP REVERSE (CAV) *)
  SEND_STRING CLDP,"'SR',$0D"


PUSH[PNL,21]                           (* START (CAV/CLV/CD) *)
  SEND_STRING CLDP,"'SA',$0D"

PUSH[PNL,22]                           (* REJECT (CAV/CLV/CD) *)
  SEND_STRING CLDP,"'RJ',$0D"

PUSH[PNL,23]                           (* OPEN DOOR (CAV/CLV/CD) *)
  SEND_STRING CLDP,"'OP',$0D"

PUSH[PNL,24]                           (* CLOSE DOOR (CAV/CLV/CD) *)
  SEND_STRING CLDP,"'CO',$0D"



(*** MULTI-SPEED SET ***)
PUSH[PNL,31]                           (* SET SPEED TO 3X (CAV) *)
  SEND_STRING CLDP,"'180SP',$0D"

PUSH[PNL,32]                           (* SET SPEED TO 2X (CAV) *)
  SEND_STRING CLDP,"'120SP',$0D"

PUSH[PNL,33]                           (* SET SPEED TO 1X (CAV) *)
  SEND_STRING CLDP,"'60SP',$0D"

PUSH[PNL,34]                           (* SET SPEED TO 1/2X (CAV) *)
  SEND_STRING CLDP,"'30SP',$0D"

PUSH[PNL,35]                           (* SET SPEED TO 1/4X (CAV) *)
  SEND_STRING CLDP,"'15SP',$0D"

PUSH[PNL,36]                           (* SET SPEED TO 1/8X (CAV) *)
  SEND_STRING CLDP,"'7SP',$0D"

PUSH[PNL,37]                           (* SET SPEED TO 1/16X (CAV) *)
  SEND_STRING CLDP,"'4SP',$0D"

PUSH[PNL,38]                           (* SET SPEED TO STEP1 (CAV) *)
  SEND_STRING CLDP,"'2SP',$0D"


(*** SET ADDRESS FLAG ***)
PUSH[PNL,41]                           (* SET TO FRAME MODE (CAV/CLV) *)
  SEND_STRING CLDP,"'FR',$0D"

PUSH[PNL,42]                           (* SET TO CHAPTER MODE (CAV/CLV) *)
  SEND_STRING CLDP,"'CH',$0D"

PUSH[PNL,43]                           (* SET TO TIME MODE (CLV/CD) *)
  SEND_STRING CLDP,"'TM',$0D"

PUSH[PNL,44]                           (* SET TO TRACK MODE (CD) *)
  SEND_STRING CLDP,"'TR',$0D"

PUSH[PNL,45]                           (* SET TO INDEX MODE (CD) *)
  SEND_STRING CLDP,"'IX',$0D"

PUSH[PNL,46]                           (* SET TO BLOCK MODE (CD) *)
  SEND_STRING CLDP,"'BK',$0D"


(*** SEARCH - EXAMPLES ***)
PUSH[PNL,51]                           (* SEARCH TO FRAME 12345 (CAV) *)
  SEND_STRING CLDP,"'FR12345SE',$0D"

PUSH[PNL,52]                           (* SEARCH TO 12:34 FRAME 15 (CLV) *)
  SEND_STRING CLDP,"'FR123415SE',$0D"

PUSH[PNL,53]                           (* SEARCH TO CHAPTER 12 (CAV/CLV) *)
  SEND_STRING CLDP,"'CH12SE',$0D"

PUSH[PNL,54]                           (* SEARCH TO TIME 1:23:45 (CLV/CD) *)
  SEND_STRING CLDP,"'TM12345SE',$0D"

PUSH[PNL,55]                           (* SEARCH TO TRACK 1 (CD) *)
  SEND_STRING CLDP,"'TR01SE',$0D"

PUSH[PNL,56]                           (* SEARCH TO TRACK 10 INDEX 2 (CD) *)
  SEND_STRING CLDP,"'IX1002SE',$0D"

PUSH[PNL,57]                           (* SEARCH TO 12:34 BLOCK 56 (CD) *)
  SEND_STRING CLDP,"'BK123456SE',$0D"



(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

