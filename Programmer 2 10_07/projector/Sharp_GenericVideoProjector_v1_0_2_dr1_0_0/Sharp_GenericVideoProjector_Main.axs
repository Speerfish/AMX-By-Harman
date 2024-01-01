PROGRAM_NAME='Sharp_GenericVideoProjector_Main'
(***********************************************************)
(*  FILE CREATED ON: 02/02/2006  AT: 07:39:30              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/19/2007  AT: 15:13:52        *)
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

//dvVProj   = 0:5:0
dvVProj   = 5001:1:0
vdvVProj  = 41001:1:0
vdvVProj2 = 41001:2:0

dvTP = 10001:45:0


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

integer NO_BTN = 9999

dev vdvVProjArray[] =
{
	vdvVProj
}

dev vdvLampArray[] =
{
	vdvVProj,vdvVProj2
}

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

define_module 'SharpDisplayComponent' mDispCmp1(vdvVProjArray,dvTP)
define_module 'SharpLampComponent' mLampCmp1(vdvLampArray, dvTP)
define_module 'SharpModuleComponent' mMdlCmp1(vdvVProj, dvTP)
define_module 'SharpSourceSelectComponent' mSrcSelCmp1(vdvVProjArray, dvTP)
define_module 'SharpVideoProjectorComponent' mVProjCmp1(vdvVProj, dvTP)
define_module 'SharpVolumeComponent' mVolCmp1(vdvVProjArray,dvTP)

define_module 'Sharp_GenericVideoProjector_Comm_dr1_0_0' mVProjDev1(vdvVProj, dvVProj)



(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

data_event[dvTP]
{
	ONLINE:
	{
		send_command dvTP, "'^TXT-1002,0,',''"
		send_command dvTP, "'^TXT-13,0,',''"
		send_command dvTP, "'^TXT-12,0,',''"
		send_command dvTP, "'^TXT-14,0,',''"
		send_command dvTP, "'^TXT-1510,0,',''"
		send_command dvTP, "'^TXT-1511,0,',''"
		send_command dvTP, "'^TXT-15,0,',''"
		send_command dvTP, "'^TXT-2020,0,',''"
		send_command dvTP, "'^TXT-1140,0,',''"
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

