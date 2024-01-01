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
MODULE_NAME = 'SwitcherComponent' (dev vdvDev[], dev dvTP, dev dvTPMain, INTEGER nDevice, INTEGER nPages[])
(***********************************************************)
(* System Type : NetLinx                                   *)
(* Creation Date: 4/5/2007 5:51:27 PM                    *)
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
BTN_GET_INPUT                   = 2000  // Button: getInput
BTN_GET_OUTPUT                  = 2001  // Button: getOutput
BTN_GET_SWT_PRESET              = 2002  // Button: getSwitcherPreset

// Levels

// Variable Text Addresses

/* G4 CHANNELS
BTN_SWT_PRESET_SAVE             = 260   // Button: Save Switcher Preset

#IF_NOT_DEFINED BTN_SWT_PRESET
INTEGER BTN_SWT_PRESET[]        =       // Button: Switcher Preset
{
  261,  262,  263,  264,  265,
  266,  267,  268,  269,  270,
  271,  272,  273,  274,  275,
  276,  277,  278,  279,  280
}
#END_IF // BTN_SWT_PRESET

BTN_SWT_LEVEL_AUDIO             = 323   // Button: Audio
BTN_SWT_LEVEL_VIDEO             = 322   // Button: Video
BTN_SWT_LEVEL_ALL               = 321   // Button: All

#IF_NOT_DEFINED BTN_SWT_OUTPUT
INTEGER BTN_SWT_OUTPUT[]        =       // Button: Output
{
  301,  302,  303,  304,  305,
  306,  307,  308,  309,  310,
  311,  312,  313,  314,  315,
  316,  317,  318,  319,  320
}
#END_IF // BTN_SWT_OUTPUT


#IF_NOT_DEFINED BTN_SWT_INPUT
INTEGER BTN_SWT_INPUT[]         =       // Button: Input
{
  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,
  291,  292,  293,  294,  295,
  296,  297,  298,  299,  300
}
#END_IF // BTN_SWT_INPUT

BTN_SWT_TAKE                    = 257   // Button: Take
*/

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT



INTEGER MAX_INPUTS = 20
INTEGER MAX_OUTPUTS = 20
CHAR SWITCH_LEVEL[][20] = 
{
    'ALL',
    'VIDEO',
    'AUDIO'
};


(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE



#IF_NOT_DEFINED _uPanelIO
STRUCTURE _uPanelIO
{
    INTEGER    nInput
    CHAR       sSwitchLevel[20]
    INTEGER    nOutput[MAX_INPUTS][MAX_OUTPUTS]
    INTEGER    nLevel[MAX_INPUTS]
    INTEGER    bState[MAX_INPUTS]
}
#END_IF


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

char sSWITCHPRESET[MAX_ZONE][20] = { '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' }

VOLATILE _uPanelIO uPanelIO[MAX_ZONE]
VOLATILE INTEGER bBTN_SWT_PRESET_SAVE = 0
VOLATILE INTEGER nBTN_SWT_OUTPUT = 0
VOLATILE INTEGER bBTN_SWT_OUTPUT[MAX_OUTPUTS] = FALSE


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


//*********************************************************************
// Function : initialize
// Purpose  : initialize any variables to default values
// Params   : none
// Return   : none
//*********************************************************************
DEFINE_FUNCTION Initialize()
{
    STACK_VAR INTEGER nLoop
    STACK_VAR INTEGER i
    STACK_VAR INTEGER x
    
	for (nLoop = 1; nLoop <= MAX_OUTPUTS; nLoop++)
		bBTN_SWT_OUTPUT[MAX_OUTPUTS] = FALSE
	
    for (nLoop = 1; nLoop <= LENGTH_ARRAY(nZoneBtns); nLoop++)
    {
		uPanelIO[nLoop].nInput = 1
		for (i = 1; i <= MAX_INPUTS; i++)
		{
			uPanelIO[nLoop].nLevel[i] = 0
			uPanelIO[nLoop].bState[i] = FALSE
			uPanelIO[nLoop].sSwitchLevel = ''
			for (x = 1; x <= MAX_OUTPUTS; x++)
				uPanelIO[nLoop].nOutput[i][x] = 0
		}
    }
}


DEFINE_MUTUALLY_EXCLUSIVE
([dvTp,BTN_SWT_PRESET[1]]..[dvTp,BTN_SWT_PRESET[LENGTH_ARRAY(BTN_SWT_PRESET)]])
([dvTp,BTN_SWT_INPUT[1]]..[dvTp,BTN_SWT_INPUT[LENGTH_ARRAY(BTN_SWT_INPUT)]])


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

strCompName = 'SwitcherComponent'

// Initialize all place holder variables here
Initialize()


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

    }
    OFFLINE:
    {
        bNoLevelReset = 1
    }

}


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       DATA_EVENT for vdvDev
//                   SwitcherComponent: data event 
//
// PURPOSE:          This data event is used to listen for SNAPI component
//                   commands and track feedback for the SwitcherComponent.
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
            // SNAPI::SWITCHPRESET-<preset>
            CASE 'SWITCHPRESET' :
            {
                sSWITCHPRESET[nZone] = DuetParseCmdParam(cCmd)
                // get parameter value from SNAPI command and set feeback on user interface
                nParameter = ATOI(sSWITCHPRESET[nZone])
                off[dvTP,BTN_SWT_PRESET]
                if (nParameter)
                    on[dvTP,BTN_SWT_PRESET[nParameter]]

            }
            
            //----------------------------------------------------------
            // CODE-BLOCK For SwitcherComponent
            //
            // The following case statements are used in conjunction
            // with the SwitcherComponent code-block.
            //----------------------------------------------------------
            

			//SNAPI::SWITCH-L<sl>I<input>O<output>
			case 'SWITCH' :
			{
				STACK_VAR CHAR    cInput[12]
				STACK_VAR CHAR    cOutput[12]
				STACK_VAR INTEGER nLevel
				STACK_VAR INTEGER nInput
				STACK_VAR INTEGER nOutput
				STACK_VAR INTEGER nPanelLoop
				STACK_VAR INTEGER nLoop
				
				// parse out data and store
				GET_BUFFER_CHAR(cCmd) // clip the 'L'
				
				// determine level; remove level command string
				FOR (nLoop = 1; nLoop <= LENGTH_ARRAY(SWITCH_LEVEL); nLoop++)
				{
					IF (FIND_STRING(cCmd, SWITCH_LEVEL[nLoop], 1))
					{
						REMOVE_STRING(cCmd, "SWITCH_LEVEL[nLoop],'I'", 1)
						uPanelIO[nCurrentZone].sSwitchLevel = SWITCH_LEVEL[nLoop]
						BREAK
					}
				}
				
				// remove input parameter; clip the 'O'
				cInput = REMOVE_STRING(cCmd, "'O'", 1)
				SET_LENGTH_STRING(cInput,LENGTH_STRING(cInput)-1)
				
				// set input value
				nInput = ATOI(cInput)
				
				IF (nInput > 0)
				{
					// output select feedback
					FOR(nLoop = 1; nLoop <= MAX_OUTPUTS; nLoop++)
					{
						OFF[uPanelIO[nCurrentZone].nOutput[nInput][nLoop]]
						OFF[bBTN_SWT_OUTPUT[nLoop]]
					}
					
					FOR(nLoop=1; nLoop<=MAX_OUTPUTS; nLoop++)
					{
						IF(FIND_STRING(cCmd,"','",1))
						{
							// remove output parameter; clip the ',' comma character
							cOutput = REMOVE_STRING(cCmd,"','",1)
							SET_LENGTH_STRING(cOutput,LENGTH_STRING(cOutput)-1)
							
							// set output value
							nOutput = ATOI(cOutput)
							
							// set output state
							if (nOutput > 0)
								ON[uPanelIO[nCurrentZone].nOutput[nInput][nOutput]]
						}
						ELSE // Comma not found, must be last param
						{
							// remove output parameter
							cOutput = cCmd
							
							// set output value
							nOutput = ATOI(cOutput)
							
							// set output state
							if (nOutput > 0)
								ON[uPanelIO[nCurrentZone].nOutput[nInput][nOutput]]
							
							// exit for loop
							//nLoop = MAX_OUTPUTS+1
							BREAK;
						}
					}
					
					// update panel input
					uPanelIO[nCurrentZone].nInput = nInput
					uPanelIO[nCurrentZone].bState[nInput] = TRUE
					[dvTP, BTN_SWT_INPUT[nInput]] = uPanelIO[nCurrentZone].bState[nInput]
					
					// update panel outputs
					FOR(nLoop = 1; nLoop <= MAX_OUTPUTS; nLoop++)
					{
						bBTN_SWT_OUTPUT[nLoop] = (uPanelIO[nCurrentZone].nOutput[nInput][nLoop])
						[dvTP,BTN_SWT_OUTPUT[nLoop]] = bBTN_SWT_OUTPUT[nLoop]
					}
				}
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
// CHANNEL_EVENTs For SwitcherComponent
//
// The following channel events are used in conjunction
// with the SwitcherComponent code-block.
//----------------------------------------------------------


//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   SwitcherComponent: channel button - command
//                   on BTN_GET_SWT_PRESET
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the SwitcherComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_GET_SWT_PRESET]
{
    push:
    {
        if (bActiveComponent)
        {
            send_command vdvDev[nCurrentZone], '?SWITCHPRESET'
            println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?SWITCHPRESET',39")
        }
    }
}


//----------------------------------------------------------
// EXTENDED EVENTS For SwitcherComponent
//
// The following events are used in conjunction
// with the SwitcherComponent code-block.
//----------------------------------------------------------



//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   SwitcherComponent: channel range button - command
//                   on BTN_SWT_PRESET
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the .
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_SWT_PRESET]
{
    push:
    {
        if (bActiveComponent)
		{
			stack_var integer btn
			btn = get_last(BTN_SWT_PRESET)
			
			IF (bBTN_SWT_PRESET_SAVE = TRUE)
			{
				send_command vdvDev[nCurrentZone], "'SWITCHERPRESETSAVE-',itoa(btn)"
				println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'SWITCHERPRESETSAVE-',itoa(btn),39")
				
				// reset the button state
				bBTN_SWT_PRESET_SAVE = FALSE
				[dvTP, BTN_SWT_PRESET_SAVE] = bBTN_SWT_PRESET_SAVE
			}
			ELSE
			{
				send_command vdvDev[nCurrentZone], "'SWITCHERPRESET-',itoa(btn)"
				println("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'SWITCHERPRESET-',itoa(btn),39")
			}
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   SwitcherComponent: channel button - command
//                   on BTN_SWT_PRESET_SAVE
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the .
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
button_event[dvTP, BTN_SWT_PRESET_SAVE]
{
    push:
    {
        if (bActiveComponent)
		{
			bBTN_SWT_PRESET_SAVE = !(bBTN_SWT_PRESET_SAVE)
			[dvTP, BTN_SWT_PRESET_SAVE] = bBTN_SWT_PRESET_SAVE
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   SwitcherComponent: channel range button - command
//                   on BTN_SWT_INPUT
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the .
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_SWT_INPUT]
{
    push:
    {
        if (bActiveComponent)
        {
			STACK_VAR INTEGER nLoop
			STACK_VAR INTEGER nInput
			STACK_VAR INTEGER nOutput[MAX_OUTPUTS]
			
			// get panel input selection
			nInput = GET_LAST(BTN_SWT_INPUT)
			
			IF (uPanelIO[nCurrentZone].nInput <> nInput)
			{
				uPanelIO[nCurrentZone].nInput = nInput
				uPanelIO[nCurrentZone].bState[nInput] = TRUE
			}
			ELSE
			{
				uPanelIO[nCurrentZone].bState[nInput] = !(uPanelIO[nCurrentZone].bState[nInput])
			}
			
			IF (uPanelIO[nCurrentZone].bState[nInput] = TRUE)
			{
				FOR(nLoop = 1; nLoop <= MAX_OUTPUTS; nLoop++)
					nOutput[nLoop] = uPanelIO[nCurrentZone].nOutput[nInput][nLoop]
			}
			ELSE
			{
				FOR(nLoop = 1; nLoop <= MAX_OUTPUTS; nLoop++)
					nOutput[nLoop] = 0
			}
			
			// update panel input
			[dvTP, BTN_SWT_INPUT[nInput]] = uPanelIO[nCurrentZone].bState[nInput]
			
			// output select feedback
			FOR(nLoop = 1; nLoop <= MAX_OUTPUTS; nLoop++)
				[dvTP,BTN_SWT_OUTPUT[nLoop]] = (nOutput[nLoop])
        }
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   SwitcherComponent: channel range button - command
//                   on BTN_SWT_OUTPUT
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the .
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_SWT_OUTPUT]
{
    push:
    {
        if (bActiveComponent)
        {
			stack_var integer btn
			stack_var integer nInput
			
			btn = GET_LAST(BTN_SWT_OUTPUT)
			nBTN_SWT_OUTPUT = btn
			bBTN_SWT_OUTPUT[btn] = !(bBTN_SWT_OUTPUT[btn])
			
			nInput = uPanelIO[nCurrentZone].nInput
			if (nInput)
			{
				// Change the output for the current input
				uPanelIO[nCurrentZone].nOutput[nInput][btn] = bBTN_SWT_OUTPUT[btn]
			}
			
			[dvTP, BTN_SWT_OUTPUT[btn]] = bBTN_SWT_OUTPUT[btn]
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   SwitcherComponent: channel button - command
//                   on BTN_GET_INPUT
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the SwitcherComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_GET_INPUT]
{
    push:
    {
        if (bActiveComponent)
        {
			if (nBTN_SWT_OUTPUT && bBTN_SWT_OUTPUT[nBTN_SWT_OUTPUT])
			{
				stack_var char sl[20]
				
				sl = uPanelIO[nCurrentZone].sSwitchLevel
				IF (LENGTH_STRING(sl) > 0)
				{
					send_command vdvDev[nCurrentZone], "'?INPUT-',sl,',',itoa(nBTN_SWT_OUTPUT)"
					println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?INPUT-',sl,',',itoa(nBTN_SWT_OUTPUT),39")
				}
				ELSE
				{
					send_command vdvDev[nCurrentZone], "'?INPUT-',itoa(nBTN_SWT_OUTPUT)"
					println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?INPUT-',itoa(nBTN_SWT_OUTPUT),39")
				}
			}
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
BUTTON_EVENT[dvTP, BTN_GET_OUTPUT]
{
    push:
    {
        if (bActiveComponent)
        {
			if (uPanelIO[nCurrentZone].nInput)
			{
				stack_var integer nInput
				
				nInput = uPanelIO[nCurrentZone].nInput
				if (uPanelIO[nCurrentZone].bState[nInput])
				{
					stack_var char sl[20]
					
					sl = uPanelIO[nCurrentZone].sSwitchLevel
					IF (LENGTH_STRING(sl) > 0)
					{
						send_command vdvDev[nCurrentZone], "'?OUTPUT-',sl,',',itoa(uPanelIO[nCurrentZone].nInput)"
						println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?OUTPUT-',sl,',',itoa(uPanelIO[nCurrentZone].nInput),39")
					}
					ELSE
					{
						send_command vdvDev[nCurrentZone], "'?OUTPUT-',itoa(uPanelIO[nCurrentZone].nInput)"
						println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'?OUTPUT-',itoa(uPanelIO[nCurrentZone].nInput),39")
					}
				}
			}
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   SwitcherComponent: channel button - command
//                   on BTN_SWT_LEVEL_ALL,
//                   BTN_SWT_LEVEL_VIDEO,
//                   BTN_SWT_LEVEL_AUDIO,
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the SwitcherComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_SWT_LEVEL_ALL]
BUTTON_EVENT[dvTP, BTN_SWT_LEVEL_VIDEO]
BUTTON_EVENT[dvTP, BTN_SWT_LEVEL_AUDIO]
{
    push:
    {
        if (bActiveComponent)
        {
			stack_var integer btn
			stack_var integer lev
			
			btn = button.input.channel
			lev = (btn - BTN_SWT_LEVEL_ALL) + 1
			if (uPanelIO[nCurrentZone].sSwitchLevel != SWITCH_LEVEL[lev])
				uPanelIO[nCurrentZone].sSwitchLevel = SWITCH_LEVEL[lev]
			else
				uPanelIO[nCurrentZone].sSwitchLevel = ''
		}
    }
}
//---------------------------------------------------------------------------------
//
// EVENT TYPE:       BUTTON_EVENT for dvTP
//                   SwitcherComponent: channel button - command
//                   on BTN_SWT_TAKE
//
// PURPOSE:          This button event is used to listen for input 
//                   on the touch panel and update the SwitcherComponent.
//
// LOCAL VARIABLES:  {none}
//
//---------------------------------------------------------------------------------
BUTTON_EVENT[dvTP, BTN_SWT_TAKE]
{
    push:
    {
      if (bActiveComponent)
      {
			 if (uPanelIO[nCurrentZone].nInput)
			 {
				stack_var integer nInput
				stack_var integer nLoop
				
				nInput = uPanelIO[nCurrentZone].nInput
				if (uPanelIO[nCurrentZone].bState[nInput])
				{
					stack_var char sOutputString[100]
					stack_var char sl[20]
					
					sl = uPanelIO[nCurrentZone].sSwitchLevel
					
					for (nLoop = 1; nLoop <= MAX_OUTPUTS; nLoop++)
					{
						IF (uPanelIO[nCurrentZone].nOutput[nInput][nLoop])
							sOutputString = "sOutputString, itoa(nLoop), ','"
					}
					set_length_string (sOutputString, length_string(sOutputString) - 1)
					
					send_command vdvDev[nCurrentZone], "'CL',sl,'I',itoa(nInput),'O',sOutputString"
					println ("'send_command ',dpstoa(vdvDev[nCurrentZone]),', ',39,'CL',sl,'I',itoa(nInput),',',sOutputString,39")
				}
			 }
			}
    }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


[dvTP, BTN_SWT_LEVEL_ALL] = (uPanelIO[nCurrentZone].sSwitchLevel = SWITCH_LEVEL[1])
[dvTP, BTN_SWT_LEVEL_VIDEO] = (uPanelIO[nCurrentZone].sSwitchLevel = SWITCH_LEVEL[2])
[dvTP, BTN_SWT_LEVEL_AUDIO] = (uPanelIO[nCurrentZone].sSwitchLevel = SWITCH_LEVEL[3])
wait 10
{
    if (bBTN_SWT_PRESET_SAVE)
    {
		// blink the button
		[dvTP, BTN_SWT_PRESET_SAVE] = ![dvTP, BTN_SWT_PRESET_SAVE]
    }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

