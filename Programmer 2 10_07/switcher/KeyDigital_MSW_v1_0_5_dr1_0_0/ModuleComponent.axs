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
MODULE_NAME = 'ModuleComponent' (dev vdvDev[], dev dvTP, dev dvTPMain, INTEGER nDevice, INTEGER nPages[])
(***********************************************************)
(* System Type : NetLinx                                   *)
(* Creation Date: 6/18/2007 3:15:37 PM                    *)
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
BTN_QUERY_DEBUG                 = 1605  // Button: Query Debug
BTN_QUERY_FIRMWARE_VERSION      = 1606  // Button: Query Device Firmware Version
BTN_QUERY_MODULE_VERSION        = 1607  // Button: Query Module Version
BTN_REINITIALIZE                = 1600  // Button: reinitialize
BTN_SET_DATE_TIME               = 1608  // Button: Set Date/Time

#IF_NOT_DEFINED BTN_DEBUG
INTEGER BTN_DEBUG[]             =       // Button: setDebugState
{
 1601, 1602, 1603, 1604
}
#END_IF // BTN_DEBUG


#IF_NOT_DEFINED BTN_DATE_TIME
INTEGER BTN_DATE_TIME[]         =       // Button: Date - Time
{
 3600, 3601, 3602, 3603, 3604,
 3605
}
#END_IF // BTN_DATE_TIME


#IF_NOT_DEFINED BTN_DEBUG_FB
INTEGER BTN_DEBUG_FB[]          =       // Button: processDebugEvent
{
 1601, 1602, 1603, 1604
}
#END_IF // BTN_DEBUG_FB


// Levels

// Variable Text Addresses
TXT_FIRMWARE_VERSION            = 1600  // Text: Device Firmware Version Text
TXT_MODULE_VERSION              = 1601  // Text: Module Version Text

#IF_NOT_DEFINED TXT_DATE_TIME
INTEGER TXT_DATE_TIME[]         =       // Text: Date - Time Text
{
 1609, 1610, 1611, 1612, 1613,
 1614
}
#END_IF // TXT_DATE_TIME


/* SNAPI CHANNELS
DATA_INITIALIZED                = 252   // Button: processDataInitializedEvent
DEVICE_COMMUNICATING            = 251   // Button: processDeviceOnLineEvent
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

char sVERSION[MAX_ZONE][20] = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }
char sFWVERSION[MAX_ZONE][20] = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }

// The following variables must have a length equal to the number of outputs ~ the size of the BTN_MODULE_OUTPUT array
volatile integer nSet = 0		// Tells what is being set (Month, Day, Year, Hour, Minute, Second) per output
volatile char sMonth[2]			// Holds the month per output
volatile char sDay[2]			// Holds the day per output
volatile char sYear[4]			// Holds the year per output
volatile char sHour[2]			// Holds the hour per output
volatile char sMinute[2]		// Holds the minute per output
volatile char sSecond[2]		// Holds the second per output


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


    send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[1]),',0,',sMonth"
    send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[2]),',0,',sDay"
    send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[3]),',0,',sYear"
    send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[4]),',0,',sHour"
    send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[5]),',0,',sMinute"
    send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[6]),',0,',sSecond"


    println ("'OnZoneChange'")
}

DEFINE_MUTUALLY_EXCLUSIVE
([dvTp,BTN_DEBUG[1]]..[dvTp,BTN_DEBUG[LENGTH_ARRAY(BTN_DEBUG)]])



(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

strCompName = 'ModuleComponent'
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
        nCurrentZone = 1
        bNoLevelReset = 0

		send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[1]),',0,',sMonth"
		send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[2]),',0,',sDay"
		send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[3]),',0,',sYear"
		send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[4]),',0,',sHour"
		send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[5]),',0,',sMinute"
		send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[6]),',0,',sSecond"

    }
    OFFLINE:
    {
        bNoLevelReset = 1
    }

}


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       DATA_EVENT for vdvDev
//                   ModuleComponent: data event 
//
// PURPOSE:          This data event is used to listen for SNAPI component
//                   commands and track feedback for the ModuleComponent.
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
            // SNAPI::?VERSION
            CASE 'VERSION' :
            {
                sVERSION[nZone] = DuetParseCmdParam(cCmd)
                SEND_COMMAND dvTP,"'^TXT-',ITOA(TXT_MODULE_VERSION),',0,', sVERSION[nZone]"

            }
            // SNAPI::?FWVERSION
            CASE 'FWVERSION' :
            {
                sFWVERSION[nZone] = DuetParseCmdParam(cCmd)
                SEND_COMMAND dvTP,"'^TXT-',ITOA(TXT_FIRMWARE_VERSION),',0,', sFWVERSION[nZone]"

            }
            
            //----------------------------------------------------------
            // CODE-BLOCK For ModuleComponent
            //
            // The following case statements are used in conjunction
            // with the ModuleComponent code-block.
            //----------------------------------------------------------
            

            // SNAPI::DEBUG-<state>
            CASE 'DEBUG' :
            {
                // get parameter value from SNAPI command and set feeback on user interface
                nDbg = ATOI(DuetParseCmdParam(cCmd))
                OFF [dvTP,BTN_DEBUG_FB]
                IF (nDbg)
                    ON[dvTP,BTN_DEBUG_FB[nDbg]]
            }

        }
    }
}


//----------------------------------------------------------
// CHANNEL_EVENTs For ModuleComponent
//
// The following channel events are used in conjunction
// with the ModuleComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   ModuleComponent: channel button - command
//                   on BTN_REINITIALIZE
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the ModuleComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_REINITIALIZE]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[1], 'REINIT'
            println ("'send_command ',dpstoa(vdvDev[1]),', ',39,'REINIT',39")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   ModuleComponent: channel button - command
//                   on BTN_QUERY_MODULE_VERSION
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the ModuleComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_QUERY_MODULE_VERSION]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[1], '?VERSION'
            println ("'send_command ',dpstoa(vdvDev[1]),', ',39,'?VERSION',39")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   ModuleComponent: channel button - command
//                   on BTN_QUERY_FIRMWARE_VERSION
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the ModuleComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_QUERY_FIRMWARE_VERSION]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[1], '?FWVERSION'
            println ("'send_command ',dpstoa(vdvDev[1]),', ',39,'?FWVERSION',39")
        }
    }
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   ModuleComponent: channel button - command
//                   on BTN_QUERY_DEBUG
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the ModuleComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_QUERY_DEBUG]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[1], '?DEBUG'
            println ("'send_command ',dpstoa(vdvDev[1]),', ',39,'?DEBUG',39")
        }
    }
}


//----------------------------------------------------------
// EXTENDED EVENTS For ModuleComponent
//
// The following events are used in conjunction
// with the ModuleComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       DATA_EVENT for dvTP
//                   ModuleComponent: Keypad
//                   on SETUP CHANNEL
//
// PURPOSE:          This button event is used to listen for input from the keypad
//                   on the touch panel and update the ModuleComponent Text Fields.
//
// LOCAL VARIABLES:  {nBtn} Current button/text
//
//---------------------------------------------------------------------------------
data_event[dvTP.number:1:0]
{
    string:
    {
		if (bActiveComponent)
		{
			if (nSet)
			{
				println("'Data from TP: ',data.text")
				if (find_string(data.text, 'ABORT', 1))
				{
					nSet = 0
				}
				else
				{
					STACK_VAR integer nBtn
					
					nBtn = nSet
					remove_string(data.text, 'KEYP-', 1)
					switch (nBtn)
					{
						case 1 : // MONTH
						{
							if (atoi(data.text) > 12)
							{
								send_command dvTP, "'@AKP-',data.text,';Month must be 1-12'"
							}
							else
							{
								if ((atoi(data.text) < 10) && (length_string(data.text) < 2))
								{
									sMonth = "'0', data.text"
								}
								else
								{
									sMonth = data.text
								}
								send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[nBtn]),',0,',sMonth"
								nSet = 0
							}
						}
						case 2 : // DAY
						{
							if (atoi(data.text) > 31)
							{
								send_command dvTP, "'@AKP-',data.text,';Day must be 1-31'"
							}
							else
							{
								if ((atoi(data.text) < 10) && (length_string(data.text) < 2))
								{
									sDay = "'0', data.text"
								}
								else
								{
									sDay = data.text
								}
								send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[nBtn]),',0,',sDay"
								nSet = 0
							}
						}
						case 3 : // YEAR
						{
							if (length_string(data.text) != 4)
							{
								send_command dvTP, "'@AKP-',data.text,';Year must be four digits'"
							}
							else
							{
								sYear = data.text
								send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[nBtn]),',0,',sYear"
								nSet = 0
							}
						}
						case 4 : // HOUR
						{
							if (atoi(data.text) > 24)
							{
								send_command dvTP, "'@AKP-',data.text,';Hour must be 1-24'"
							}
							else
							{
								if ((atoi(data.text) < 10) && (length_string(data.text) < 2))
								{
									sHour = "'0', data.text"
								}
								else
								{
									sHour = data.text
								}
								send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[nBtn]),',0,',sHour"
								nSet = 0
							}
						}
						case 5 : // MINUTE
						{
							if (atoi(data.text) > 59)
							{
								send_command dvTP, "'@AKP-',data.text,';Minute must be 1-59'"
							}
							else
							{
								if ((atoi(data.text) < 10) && (length_string(data.text) < 2))
								{
									sMinute = "'0', data.text"
								}
								else
								{
									sMinute = data.text
								}
								send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[nBtn]),',0,',sMinute"
								nSet = 0
							}
						}
						case 6 : // SECOND
						{
							if (atoi(data.text) > 59)
							{
								send_command dvTP, "'@AKP-',data.text,';Seconds must be 1-59'"
							}
							else
							{
								if ((atoi(data.text) < 10) && (length_string(data.text) < 2))
								{
									sSecond = "'0', data.text"
								}
								else
								{
									sSecond = data.text
								}
								send_command dvTP, "'^TXT-',itoa(TXT_DATE_TIME[nBtn]),',0,',sSecond"
								nSet = 0
							}
						}
					}
				}
			}
		}
		
    } // string
}

//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   ModuleComponent: channel range button - command
//                   on BTN_DATE_TIME
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the ModuleComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_DATE_TIME]
{
    push:
    {
		if (bActiveComponent)
		{
			nSet = GET_LAST(BTN_DATE_TIME) //button.input.channel
			switch (nSet)
			{
				case 1 : // MONTH
				{
					send_command dvTP, "'@AKP-;Enter Month (##)'"
				}
				case 2 : // DAY
				{
					send_command dvTP, "'@AKP-;Enter Day (##)'"
				}
				case 3 : // YEAR
				{
					send_command dvTP, "'@AKP-;Enter Year (####)'"
				}
				case 4 : // HOUR
				{
					send_command dvTP, "'@AKP-;Enter Hour (##)'"
				}
				case 5 : // MINUTE
				{
					send_command dvTP, "'@AKP-;Enter Minute (##)'"
				}
				case 6 : // SECOND
				{
					send_command dvTP, "'@AKP-;Enter Second (##)'"
				}
			}
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   ModuleComponent: channel button - command
//                   on BTN_SET_DATE_TIME
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the ModuleComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_SET_DATE_TIME]
{
    push:
    {
		if (bActiveComponent)
		{
			send_command vdvDev[1], "'CLOCK-',sMonth,'/',sDay,'/',
				sYear,' ',sHour,':',sMinute,':',sSecond"
			println("'send_command ',dpstoa(vdvDev[1]),', ',39,'CLOCK-',sMonth,'/',sDay,'/',
				sYear,' ',sHour,':',sMinute,':',sSecond,39")
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   ModuleComponent: channel range button - command
//                   on BTN_DEBUG
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the ModuleComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTp, BTN_DEBUG]
{
    push:
    {
		if (bActiveComponent)
		{
			stack_var integer btn
			btn = get_last(BTN_DEBUG)
			
			send_command vdvDev[1], "'DEBUG-',itoa(btn)"
			println("'send_command ',dpstoa(vdvDev[1]),', ',39,'DEBUG-',itoa(btn),39")
		}
    }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP,DEVICE_COMMUNICATING] = [vdvDev[1],DEVICE_COMMUNICATING]
[dvTP,DATA_INITIALIZED] = [vdvDev[1],DATA_INITIALIZED]

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

