(*********************************************************************)
(*  AMX Corporation                                                  *)
(*  Copyright (c) 2004-2006 AMX Corporation. All rights reserved.    *)
(*********************************************************************)
(* Copyright Notice :                                                *)
(* Copyright, AMX, Inc., 2004-2007                                   *)
(*    Private, proprietary information, the sole property of AMX.    *)
(*    The contents, ideas, and concepts expressed herein are not to  *)
(*    be disclosed except within the confines of a confidential      *)
(*    relationship and only then on a need to know basis.            *)
(*********************************************************************)
PROGRAM_NAME = 'Key_Digital_MSW8x4Pro_Main' 
(***********************************************************)
(* System Type : NetLinx                                   *)
(* Creation Date: 3/27/2007 3:04:49 PM                    *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvTPMain = 10001:1:0 // This should be the touch panel's main port

vdvSwitcher  = 41001:1:0  // The COMM module should use this as its duet device, Output 1
vdvSwitcher2 = 41001:2:0  // Output 2
vdvSwitcher3 = 41001:3:0  // Output 3
vdvSwitcher4 = 41001:4:0  // Output 4

dvSwitcher   = 5001:1:0 // This device should be used as the physical device by the COMM module
dvSwitcherTp = 10001:38:0 // This port should match the assigned touch panel device port

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

DEV vdvDev[] = {vdvSwitcher,vdvSwitcher2,vdvSwitcher3,vdvSwitcher4}

// ----------------------------------------------------------
// CURRENT DEVICE NUMBER ON TP NAVIGATION BAR
INTEGER nSwitcher = 1

// ----------------------------------------------------------
// DEFINE THE PAGES THAT YOUR COMPONENTS ARE USING IN THE 
// SUB NAVIGATION BAR HERE. See MainInclude.axi file nSubNavBtns... 
INTEGER nGainPages[] = { 3 }// not used in this project
INTEGER nModulePages[] = { 5 }
INTEGER nSwitcherPages[] = { 1 }
INTEGER nVolumePages[] = { 6 }


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START


// ----------------------------------------------------------
// DEVICE MODULE GROUPS SHOULD ALL HAVE THE SAME DEVICE NUMBER
DEFINE_MODULE 'ModuleComponent' module(vdvDev, dvSwitcherTp, dvTPMain, nSwitcher, nModulePages)
DEFINE_MODULE 'SwitcherComponent' switcher(vdvDev, dvSwitcherTp, dvTPMain, nSwitcher, nSwitcherPages)
DEFINE_MODULE 'VolumeComponent' volume(vdvDev, dvSwitcherTp, dvTPMain, nSwitcher, nVolumePages)

// Define your communications module here like so:
DEFINE_MODULE 'KeyDigital_MSW_Comm_dr1_0_0' comm(vdvSwitcher, dvSwitcher)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

