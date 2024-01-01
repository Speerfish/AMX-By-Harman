PROGRAM_NAME='AMX01,AMX_Posipilot,Example,SO#None,Rev 0,CWR'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 07/15/2001 AT: 09:06:49               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2002 AT: 11:58:34         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 07/15/2001                              *)
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

(***************)
(*** CAMERAS ***)
(***************)
dvCAM1      = 90:1:0    // PAN/TILT : AXB-PT10
                        // CAMERA   : SONY DXC-390
                        // LENS     : FUJINON BMD
dvCAM2      = 91:1:0    // PAN/TILT : AXB-PT10
                        // CAMERA   :
                        // LENS     :
dvCAM3      = 92:1:0    // PAN/TILT : AXB-PT10
                        // CAMERA   :
                        // LENS     :
dvCAM4      = 93:1:0    // PAN/TILT : AXB-PT10
                        // CAMERA   :
                        // LENS     :
dvCAM5      = 94:1:0    // PAN/TILT : AXB-PT10
                        // CAMERA   :
                        // LENS     :
dvCAM6      = 95:1:0    // PAN/TILT : AXB-PT10
                        // CAMERA   :
                        // LENS     :


(********************)
(*** POSIPILOT #1 ***)
(********************)
dvAI8_1     = 129:1:0
dvTP_1      = 131:1:0
vdvPILOT_1  = 33001:1:0


(********************)
(*** POSIPILOT #2 ***)
(********************)
dvAI8_2     = 128:1:0
dvTP_2      = 135:1:0
vdvPILOT_2  = 33002:1:0


(*---------------------------------------------------------*)
(*     POSIPILOT INCLUDE                                   *)
(*---------------------------------------------------------*)
INCLUDE 'AMX_PosiPilot.AXI'


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

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
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START


(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT


(*---------------------------------------------------------*)
(* If you have an external switcher, you would do the      *)
(* switching here!                                         *)
(*---------------------------------------------------------*)
CHANNEL_EVENT[vdvPILOT_1,1]       // CAM 1 SELECTED
CHANNEL_EVENT[vdvPILOT_1,2]       // CAM 2 SELECTED
CHANNEL_EVENT[vdvPILOT_1,3]       // CAM 3 SELECTED
CHANNEL_EVENT[vdvPILOT_1,4]       // CAM 4 SELECTED
CHANNEL_EVENT[vdvPILOT_1,5]       // CAM 5 SELECTED
CHANNEL_EVENT[vdvPILOT_1,6]       // CAM 6 SELECTED
{
  ON :
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 1 : SEND_STRING 0,"'PILOT 1, SELECT CAM 1 INPUT HERE!'"
      CASE 2 : SEND_STRING 0,"'PILOT 1, SELECT CAM 2 INPUT HERE!'"
      CASE 3 : SEND_STRING 0,"'PILOT 1, SELECT CAM 3 INPUT HERE!'"
      CASE 4 : SEND_STRING 0,"'PILOT 1, SELECT CAM 4 INPUT HERE!'"
      CASE 5 : SEND_STRING 0,"'PILOT 1, SELECT CAM 5 INPUT HERE!'"
      CASE 6 : SEND_STRING 0,"'PILOT 1, SELECT CAM 6 INPUT HERE!'"
    }
  }
  OFF :
  {
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

