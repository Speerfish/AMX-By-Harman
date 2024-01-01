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
MODULE_NAME = 'VolumeComponent' (dev vdvDev[], dev dvTP, dev dvTPMain, INTEGER nDevice, INTEGER nPages[])
(***********************************************************)
(* System Type : NetLinx                                   *)
(* Creation Date: 3/30/2007 4:42:22 PM                    *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

#include 'MainInclude.axi'

#include 'SNAPI.axi'
#include 'G4API.axi'

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// Channels
BTN_GET_VOL_PRESET              = 2295  // Button: getVolumePreset
BTN_VOL_LVL_RELEASE             = 2775  // Button: setVolume Lvl Release Btn

#IF_NOT_DEFINED BTN_VOL_PRESET_LIST
INTEGER BTN_VOL_PRESET_LIST[]   =       // Button: Volume Preset
{
 2275, 2276, 2277, 2278, 2279,
 2280, 2281, 2282, 2283, 2284,
 2285, 2286, 2287, 2288, 2289,
 2290, 2291, 2292, 2293, 2294
}
INTEGER BTN_OUTPUT[]   =       // Button: Outputs
{
  901, // Zone 1
  902, // Zone 2
	903, // Zone 3
	904, // Zone 4
	905, // Zone 5
	906, // Zone 6
	907, // Zone 7
	908, // Zone 8
	909, // Zone 9
	910, // Zone 10
	911, // Zone 11
	912, // Zone 12
	913, // Zone 13
	914, // Zone 14
	915, // Zone 15
	916, // Zone 16
	917, // Zone 17
	918, // Zone 18
	919, // Zone 19
	920  // Zone 20
}
#END_IF // BTN_VOL_PRESET_LIST


// Levels

// Variable Text Addresses

/* G4 CHANNELS
BTN_VOL_MUTE                    = 26    // Button: Mute
BTN_VOL_PRESET_SAVE             = 376   // Button: Save Volume Preset
BTN_VOL_DN                      = 25    // Button: Volume Down
BTN_VOL_UP                      = 24    // Button: Volume Up
*/

/* G4 LEVELS
LVL_VOL                         = 1     // Level: Volume
*/

/* SNAPI CHANNELS
VOL_PRESET                      = 138   // Button: cycleVolumePreset
VOL_MUTE_ON                     = 199   // Button: setVolumeMuteOn
*/

/* SNAPI LEVELS
VOL_LVL                         = 1     // Level: setVolume
*/

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT


(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

integer nVOL_LVL[MAX_ZONE] // Stores level values for VOL_LVL
integer i      // simple counter used on the DEFINE_PROGRAM section
char sVOLPRESET[MAX_ZONE][20] = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }
integer nZone = 1
VOLATILE INTEGER bBTN_VOL_PRESET_SAVE = 0


//---------------------------------------------------------------------------------
//
// FUNCTION NAME:    OnDeviceChanged
//
// PURPOSE:          This function is used by the device selection BUTTON_EVENT
//                   to notify the module that a device change has occurred
//                   allowing updates to the touch panel user interface.
//
//---------------------------------------------------------------------------------
DEFINE_FUNCTION OnDeviceChanged()
{
    println ("'OnDeviceChanged'")

}

//---------------------------------------------------------------------------------
//
// FUNCTION NAME:    OnPageChanged
//
// PURPOSE:          This function is used by the page selection BUTTON_EVENT
//                   to notify the module that a component change may have occurred
//                   allowing updates to the touch panel user interface.
//
//---------------------------------------------------------------------------------
DEFINE_FUNCTION OnPageChanged()
{
    println ("'OnPageChanged'")

}

//---------------------------------------------------------------------------------
//
// FUNCTION NAME:    OnZoneChange
//
// PURPOSE:          This function is used by the zone selection BUTTON_EVENT
//                   to notify the module that a zone change has occurred
//                   allowing updates to the touch panel user interface.
//
//---------------------------------------------------------------------------------
DEFINE_FUNCTION OnZoneChange()
{
    println ("'OnZoneChange'")

}

DEFINE_MUTUALLY_EXCLUSIVE
([dvTp,BTN_VOL_PRESET_LIST[1]]..[dvTp,BTN_VOL_PRESET_LIST[LENGTH_ARRAY(BTN_VOL_PRESET_LIST)]])


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

strCompName = 'VolumeComponent'



(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT


(***********************************************************)
(*             TOUCHPANEL EVENTS GO BELOW                  *)
(***********************************************************)
DATA_EVENT [dvTP]
{

    ONLINE:
    {
        bActiveComponent = FALSE
        nActiveDevice = 1
        nActivePage = 0
        nActiveDeviceID = nNavigationBtns[1]
        nActivePageID = 0
        nZone = 1
        bNoLevelReset = 0

    }
    OFFLINE:
    {
        bNoLevelReset = 1
    }

}


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       DATA_EVENT for vdvDev
//                   VolumeComponent: data event 
//
// PURPOSE:          This data event is used to listen for SNAPI component
//                   commands and track feedback for the VolumeComponent.
//
// LOCAL VARIABLES:  cHeader     :  SNAPI command header
//                   cParameter  :  SNAPI command parameter
//                   nParameter  :  SNAPI command parameter value
//                   cCmd        :  received SNAPI command
//
//---------------------------------------------------------------------------------
DATA_EVENT[vdvDev]
{
    COMMAND :
    {
        // local variables
        STACK_VAR CHAR    cCmd[DUET_MAX_CMD_LEN]
        STACK_VAR CHAR    cHeader[DUET_MAX_HDR_LEN]
        STACK_VAR CHAR    cParameter[DUET_MAX_PARAM_LEN]
        STACK_VAR INTEGER nParameter
        STACK_VAR CHAR    cTrash[20]
        STACK_VAR INTEGER nZone
        
        nZone = getFeedbackZone(data.device)
        
        // get received SNAPI command
        cCmd = DATA.TEXT
        
        // parse command header
        cHeader = DuetParseCmdHeader(cCmd)
        SWITCH (cHeader)
        {
            // SNAPI::VOLPRESET-<preset>
            CASE 'VOLPRESET' :
            {
                sVOLPRESET[nZone] = DuetParseCmdParam(cCmd)
                // get parameter value from SNAPI command and set feeback on user interface
                nParameter = ATOI(sVOLPRESET[nZone])
                off[dvTP,BTN_VOL_PRESET_LIST]
                if (nParameter)
                    on[dvTP,BTN_VOL_PRESET_LIST[nParameter]]

            }
            // SNAPI::DEBUG-<state>
            CASE 'DEBUG' :
            {
                // This will toggle debug printing
                nDbg = ATOI(DuetParseCmdParam(cCmd))
            }

        }
    }
}


//----------------------------------------------------------
// CHANNEL_EVENTs For VolumeComponent
//
// The following channel events are used in conjunction
// with the VolumeComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   VolumeComponent: channel button - ramping channel
//                   on BTN_VOL_UP
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the VolumeComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_VOL_UP]
{
    push:
    {
        if (bActiveComponent)
        {
            on[vdvDev[nZone], VOL_UP]
            println (" 'on[',dpstoa(vdvDev[nZone]),', ',itoa(VOL_UP),']'")
        }
    }
    release:
    {
        if (bActiveComponent)
        {
            off[vdvDev[nZone], VOL_UP]
            println (" 'off[',dpstoa(vdvDev[nZone]),', ',itoa(VOL_UP),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   VolumeComponent: channel button - ramping channel
//                   on BTN_VOL_DN
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the VolumeComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_VOL_DN]
{
    push:
    {
        if (bActiveComponent)
        {
            on[vdvDev[nZone], VOL_DN]
            println (" 'on[',dpstoa(vdvDev[nZone]),', ',itoa(VOL_DN),']'")
        }
    }
    release:
    {
        if (bActiveComponent)
        {
            off[vdvDev[nZone], VOL_DN]
            println (" 'off[',dpstoa(vdvDev[nZone]),', ',itoa(VOL_DN),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   VolumeComponent: channel button - discrete channel
//                   on VOL_MUTE_ON
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the VolumeComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, VOL_MUTE_ON]
{
    push:
    {
        if (bActiveComponent)
        {
            [vdvDev[nZone],VOL_MUTE_ON] = ![vdvDev[nZone],VOL_MUTE_ON]
            println (" '[',dpstoa(vdvDev[nZone]),', ',itoa(VOL_MUTE_ON),'] = ![',dpstoa(vdvDev[nZone]),', ',itoa(VOL_MUTE_ON),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   VolumeComponent: channel button - command
//                   on BTN_GET_VOL_PRESET
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the VolumeComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_GET_VOL_PRESET]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[nZone], '?VOLPRESET'
            println ("'send_command ',dpstoa(vdvDev[nZone]),', ',39,'?VOLPRESET',39")
        }
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   SwitcherComponent: channel button - command
//                   on BTN_GET_OUTPUT
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the SwitcherComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_OUTPUT]
{
    push:
    {
			if (bActiveComponent)
      {
				nZone = get_last(BTN_OUTPUT)
				send_level dvTP, LVL_VOL, nVOL_LVL[nZone]
			}
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   VolumeComponent: momentary button - momentary channel
//                   on VOL_PRESET
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the VolumeComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, VOL_PRESET]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nZone], VOL_PRESET]
            println (" 'pulse[',dpstoa(vdvDev[nZone]),', ',itoa(VOL_PRESET),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   VolumeComponent: momentary button - momentary channel
//                   on BTN_VOL_MUTE
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the VolumeComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_VOL_MUTE]
{
    push:
    {
        if (bActiveComponent)
        {
            pulse[vdvDev[nZone], VOL_MUTE]
            println (" 'pulse[',dpstoa(vdvDev[nZone]),', ',itoa(VOL_MUTE),']'")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   VolumeComponent: channel button - level
//                   on BTN_VOL_LVL_RELEASE
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the VolumeComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_VOL_LVL_RELEASE]
{
    release:
    {
        if (bActiveComponent)
        {
            if (!bNoLevelReset)
            {
                send_level vdvDev[nZone], VOL_LVL, nVOL_LVL[nZone]
                println (" 'send_level ',dpstoa(vdvDev[nZone]),', ',itoa(VOL_LVL),', ',itoa(nVOL_LVL[nZone])")
            }
        }
    }
}


//----------------------------------------------------------
// LEVEL_EVENTs For VolumeComponent
//
// The following level events are used in conjunction
// with the VolumeComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       LEVEL_EVENT for dvTP
//                   VolumeComponent: level event for dvTP
//
// PURPOSE:          This level event is used to listen for touch panel changes 
//                   and update the VolumeComponent
//                   interface feedback.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
LEVEL_EVENT[dvTP, VOL_LVL]
{
    if (bActiveComponent)
    {
        if (!bNoLevelReset)
        {
            nVOL_LVL[nZone] = Level.value
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       LEVEL_EVENT for vdvDev
//                   VolumeComponent: level event for VolumeComponent
//
// PURPOSE:          This level event is used to listen for SNAPI VolumeComponent changes
//                   on the VolumeComponent and update the touch panel user
//                   interface feedback.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
LEVEL_EVENT[vdvDev, VOL_LVL]
{
    if (!bNoLevelReset)
    {
        stack_var integer zone
        zone = getFeedbackZone(Level.input.device)
        
        nVOL_LVL[zone] = level.value
        if (zone == nZone)
        {
            send_level dvTP, LVL_VOL, nVOL_LVL[nZone]
            println (" 'send_level ',dpstoa(dvTP),', ',itoa(LVL_VOL),', ',itoa(nVOL_LVL[nZone])")
        }
    }
}



//----------------------------------------------------------
// EXTENDED EVENTS For VolumeComponent
//
// The following events are used in conjunction
// with the VolumeComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   VolumeComponent: channel range button - command
//                   on BTN_VOL_PRESET_LIST
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the .
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_VOL_PRESET_LIST]
{
    push:
    {
        if (bActiveComponent)
		{
			stack_var integer btn
			btn = get_last(BTN_VOL_PRESET_LIST)
			
			IF (bBTN_VOL_PRESET_SAVE = TRUE)
			{
				send_command vdvDev[nZone], "'VOLPRESETSAVE-',itoa(btn)"
				println("'send_command ',dpstoa(vdvDev[nZone]),', ',39,'VOLPRESETSAVE-',itoa(btn),39")
				
				// reset the button state
				bBTN_VOL_PRESET_SAVE = FALSE
				[dvTP, BTN_VOL_PRESET_SAVE] = bBTN_VOL_PRESET_SAVE
			}
			ELSE
			{
				send_command vdvDev[nZone], "'VOLPRESET-',itoa(btn)"
				println("'send_command ',dpstoa(vdvDev[nZone]),', ',39,'VOLPRESET-',itoa(btn),39")
			}
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   VolumeComponent: channel button - command
//                   on BTN_VOL_PRESET_SAVE
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the .
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_VOL_PRESET_SAVE]
{
    push:
    {
        if (bActiveComponent)
		{
			bBTN_VOL_PRESET_SAVE = !(bBTN_VOL_PRESET_SAVE)
			[dvTP, BTN_VOL_PRESET_SAVE] = bBTN_VOL_PRESET_SAVE
		}
    }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP,BTN_VOL_DN] = [vdvDev[nZone],VOL_DN_FB]
[dvTP,BTN_VOL_UP] = [vdvDev[nZone],VOL_UP_FB]
[dvTP,VOL_MUTE_ON] = [vdvDev[nZone],VOL_MUTE_FB]

for(i=1 ; i<=length_array(BTN_OUTPUT) ; i++)
	[dvTP,BTN_OUTPUT[i]] = (nZone==i)


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

