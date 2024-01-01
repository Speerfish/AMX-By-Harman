PROGRAM_NAME='EXTRON, MATRIX 200, RS-232, BASIC, 1-94, SKH'
(*   DATE:05/20/99    TIME:15:34:46    *)
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
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

SWITCH = 1                             (* AXC-232,,EXTRON MATRIX 200 *)

TP = 128                               (* TOUCH PANEL *)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(* SWITCHER CONSTANTS **************************************)

PL_RGBS = $8F                          (* RGBS PLANE *)
PL_VID = $90                           (* COMPOSITE PLANE *)
PL_AUD = $A0                           (* AUDIO PLANE *)
(* NOTE:
PL_AUD = $E0 also works for AUDIO PLANE
*)


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

BUFFER[30]                             (* RESPONSE BUFFER *)
INPUT                                  (* HOLDS CURRENT INPUT SELECTION *)
MATRIX[4]                              (* HOLDS SWITCH INFORMATION *)
SWT_PWR                                (* TRACKS POWER *)

CHECKSUM1                              (* STORAGE FOR CHECKSUM BYTE 1 *)
CHECKSUM2                              (* STORAGE FOR CHECKSUM BYTE 2 *)

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

DEFINE_CALL 'CALC CHECKSUM' (DAT1,DAT2,DAT3,DAT4,COMM,CKS1,CKS2)
(* FUNCTION:  TO CALCULATE THE TWO BYTE CHECKSUM FOR THE   *)
(*            EXTRON 200 MATRIX SWITCHER.                  *)
(* DAT1 - FIRST DATA BYTE                                  *)
(* DAT2 - SECOND DATA BYTE                                 *)
(* DAT3 - THIRD DATA BYTE                                  *)
(* DAT4 - FOURTH DATA BYTE                                 *)
(* COMM - COMMAND BYTE                                     *)
(* CKS1 - FIRST CHECKSUM BYTE                              *)
(* CKS2 - SECOND CHECKSUM BYTE                             *)
LOCAL_VAR
   CKS                                 (* TEMP CHECKSUM STORAGE *)
{
   CKS=COMM+DAT1+DAT2+DAT3+DAT4        (* ADD ALL BYTES *)
   CKS=CKS BAND $3FFF                  (* ZERO BITS 14 AND 15 *)
   CKS=CKS*2                           (* SHIFT TO THE LEFT (1 POSITION) *)
   CKS2=CKS%256
   CKS2=CKS2/2                         (* SHIFT TO THE RIGHT *)
   CKS2=CKS2+$80
   CKS1=CKS/256
   CKS1=CKS1+$80
}

DEFINE_CALL 'SWITCH EXTRON' (INP,OUT,PLANE)
(* FUNCTION:  TO SWITCH THE EXTRON 200 MATRIX SWITCHER     *)
(*            GIVEN THE DESIRED INPUT, OUTPUT AND 'PLANE'. *)
(* INP - DESIRED INPUT                                     *)
(* OUT - DESIRED OUTPUT                                    *)
(* PLANE - SWITCHING PLANE (DETERMINES WHICH BOARDS ARE TO *)
(*         BE SWITCHED)                                    *)
LOCAL_VAR
  C1                                   (* FIRST CHECKSUM BYTE *)
  C2                                   (* SECOND CHECKSUM BYTE *)
{
   CALL 'CALC CHECKSUM' (INP+$80,OUT+$80,PLANE,$80,$35,C1,C2)
   SEND_STRING SWITCH,"$35,$80,PLANE,OUT+$80,INP+$80,C1,C2,$04"
   MATRIX[OUT]=INP                     (* UPDATE MATRIX *)
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

CREATE_BUFFER SWITCH,BUFFER            (* CREATE BUFFER *)

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

IF (LENGTH_STRING(BUFFER))             (* IF ANYTHING IN BUFFER *)
{
  SEND_STRING 0,BUFFER                 (* DISPLAY *)
  CLEAR_BUFFER BUFFER                  (* CLEAR THE BUFFER *)
}

IF (SWT_PWR)                           (* IF SWITCHER IS ON *)
{
  PUSH[TP,1]                           (* INPUT 1 *)
  PUSH[TP,2]                           (* INPUT 2 *)
  PUSH[TP,3]                           (* INPUT 3 *)
  PUSH[TP,4]                           (* INPUT 4 *)
  PUSH[TP,5]                           (* INPUT 5 *)
  PUSH[TP,6]                           (* INPUT 6 *)
  PUSH[TP,7]                           (* INPUT 7 *)
  PUSH[TP,8]                           (* INPUT 8 *)
     INPUT=PUSH_CHANNEL

  PUSH[TP,9]                           (* OUTPUT 1 *)
  PUSH[TP,10]                          (* OUTPUT 2 *)
  PUSH[TP,11]                          (* OUTPUT 3 *)
  PUSH[TP,12]                          (* OUTPUT 4 *)
     IF (INPUT)                        (* IF AN INPUT IS SELECTED *)
        CALL 'SWITCH EXTRON' (INPUT,PUSH_CHANNEL-8,PL_RGBS)
}

[TP,1] = INPUT=1 && SWT_PWR            (* INPUT 1 FB *)
[TP,2] = INPUT=2 && SWT_PWR            (* INPUT 2 FB *)
[TP,3] = INPUT=3 && SWT_PWR            (* INPUT 3 FB *)
[TP,4] = INPUT=4 && SWT_PWR            (* INPUT 4 FB *)
[TP,5] = INPUT=5 && SWT_PWR            (* INPUT 5 FB *)
[TP,6] = INPUT=6 && SWT_PWR            (* INPUT 6 FB *)
[TP,7] = INPUT=7 && SWT_PWR            (* INPUT 7 FB *)
[TP,8] = INPUT=8 && SWT_PWR            (* INPUT 8 FB *)

[TP,9] =  MATRIX[1]=INPUT && INPUT && SWT_PWR  (* OUTPUT 1 FB *)
[TP,10] = MATRIX[2]=INPUT && INPUT && SWT_PWR  (* OUTPUT 2 FB *)
[TP,11] = MATRIX[3]=INPUT && INPUT && SWT_PWR  (* OUTPUT 3 FB *)
[TP,12] = MATRIX[4]=INPUT && INPUT && SWT_PWR  (* OUTPUT 4 FB *)

PUSH[TP,13]                            (* POWER ON *)
{
  CALL 'CALC CHECKSUM' (0,0,0,0,$32,CHECKSUM1,CHECKSUM2)
  SEND_STRING SWITCH,"$32,CHECKSUM1,CHECKSUM2,$04"
  SWT_PWR=1
}
[TP,13] = SWT_PWR                      (* FB *)

PUSH[TP,14]                            (* POWER OFF *)
{
  CALL 'CALC CHECKSUM' (0,0,0,0,$33,CHECKSUM1,CHECKSUM2)
  SEND_STRING SWITCH,"$33,CHECKSUM1,CHECKSUM2,$04"
  SWT_PWR=0
}
[TP,14] = !SWT_PWR                     (* FB *)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
