MODULE_NAME='SharpVolumeComponent'(
								dev vdvDev[],
								dev dvTP
							 )
(***********************************************************)
(*  FILE CREATED ON: 12/09/2005  AT: 09:32:16              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/12/2007  AT: 08:09:54        *)
(***********************************************************)

DEFINE_DEVICE

DEFINE_CONSTANT
integer nButtons[] = 
{
	24,		//  1 - Volume Up
	25,		//  2 - Volume Down
	26,		//  3 - Set Volume Mute
	376,	//  4 - Set Volume Preset
	199,	//  5 - Cycle Volume Mute
	138,	//  6 - Cycle Volume Preset
	3001,	//  7 - Set Volume Level (release)
	1370	//  8 - Query volume preset
}

integer nTPVolLevels[] =
{
	1
}
integer nOutputBtns[] =
{
	301		// Output 1
}

integer nPresetBtns[] =
{
	371		// Volume Preset 1
}
integer nFBArray[] =
{
	301,	// Output 1
	376,	// Set Volume Preset
	371		// Volume Preset 1
}
#include 'SNAPI.axi'

DEFINE_VARIABLE

volatile integer nDbg = 1
volatile integer bSet = 0
volatile integer nBlink = 0
volatile integer nCurrOut = 1	// default to output (zone) 1 so that "normal" volume will work

volatile integer nOutputCount = 1
volatile integer nPresetCount = 1
volatile integer nDeviceCount = 1
integer nVolLevelValue[1] = { 0 }
integer nVolPreset[7] = { 0, 0, 0, 0, 0, 0, 0 }

//*******************************************************************
// Function : updateLevels											*
// Purpose  : to update the volume levels whenever a new output		*
//			  is selected											*
// Params   : none													*
// Return   : none													*
//*******************************************************************
define_function updateLevels ()
{
	send_level dvTP, nTPVolLevels[1], nVolLevelValue[nCurrOut]
}

//*******************************************************************
// Function : fPrintf												*
// Purpose  : to print a line to the telnet session					*
// Params   : sTxt - the data to print to the telnet session		*
// Return   : none													*
//*******************************************************************
define_function fPrintf (char sTxt[])
{
	if (nDbg > 2)
	{
		send_string 0, "'** Message from VolumeComponent.axs: ',sTxt"
	}
}

//*******************************************************************
// Function : fnFBLookup											*
// Purpose  : to look up whether this module is controlling 		*
//			  feedback for the button								*
// Params   : nChNo - the channel to test for feedback control		*
// Return   : integer - 1 for do feedback, 0 for do not do feedback	*
//*******************************************************************
define_function integer fnFBLookup (integer nChNo)
{
	stack_var integer z
	stack_var integer nFB
	nFB = 0
	z = 0
	for (z = 1; z <= length_array(nFBArray); z++)
	{
		if (nFBArray[z] == nChNo)
		{
			nFB = z
			break
		}
	}
/*	if (nFB)
	{
		fPrintf("'This component has feedback control over button #',itoa(nChNo)")
	}
	else
	{
		fPrintf("'This component does not have feedback control over button #',itoa(nChNo)")
	}
*/	return nFB
}

//*******************************************************************
// Function : dpstoa												*
// Purpose  : to convert a device's DPS to ascii for displaying		*
// Params   : dvIn - the device to be represented in ascii			*
// Return   : char[20] - the ascii representation of the dvIn's DPS	*
//*******************************************************************
define_function char[20] dpstoa (dev dvIn)
{
	return "itoa(dvIn.number),':',itoa(dvIn.port),':',itoa(dvIn.system)"
}

DEFINE_START

nPresetCount = length_array(nPresetBtns)
nOutputCount = length_array(nOutputBtns)
nDeviceCount = length_array(vdvDev)

DEFINE_EVENT

data_event[vdvDev]
{
	command:
	{
		if (find_string(data.text, '-', 1))
		{
			stack_var integer x
			stack_var char sCmd[10]
			sCmd = remove_string(data.text, '-', 1)
			
			switch (sCmd)
			{
				case 'VOLPRESET-' :
				{
					stack_var integer nTempOut
					
					for (x = 1; x <= nDeviceCount; x++)
					{
						if (vdvDev[x] == data.device)
						{
							nTempOut = x
							break
						}
					}
					
					nVolPreset[nTempOut] = atoi(data.text)
					
					if (nTempOut == nCurrOut)
					{
						for (x = 1; x <= nPresetCount; x++)
						{
							if (fnFBLookup(nPresetBtns[x]))
							{
								[dvTP, nPresetBtns[x]] = (nVolPreset[nCurrOut] == x)
							}
						}
					}
				}// End case 'VOLPRESET-' :
				case 'DEBUG-' :
				{
					nDbg = atoi(data.text)
				}// End case 'DEBUG-' :
			}// End switch (sCmd)
		}// End if (find_string(data.text, '-', 1))
	}// End command:
}// End data_event[vdvDev]

button_event[dvTP, nOutputBtns]
{
	push:
	{
		stack_var integer x
		nCurrOut = get_last(nOutputBtns)
		updateLevels()
		
		for (x = 1; x <= nOutputCount; x++)
		{
			if (fnFBLookup(nOutputBtns[x]))
			{
				[dvTP, nOutputBtns[x]] = (nCurrOut == x)
			}
		}
	}
}

button_event[dvTP, nPresetBtns]
{
	push:
	{
		stack_var integer x
		nVolPreset[nCurrOut] = get_last (nPresetBtns)
		
		if (bSet)
		{
			send_command vdvDev[nCurrOut], "'VOLPRESETSAVE-',itoa(nVolPreset[nCurrOut])"
			fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'VOLPRESETSAVE-',itoa(nVolPreset[nCurrOut]),39")
		}
		else
		{
			send_command vdvDev[nCurrOut], "'VOLPRESET-',itoa(nVolPreset[nCurrOut])"
			fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'VOLPRESET-',itoa(nVolPreset[nCurrOut]),39")
		}
		bSet = 0
		for (x = 1; x <= nPresetCount; x++)
		{
			if (fnFBLookup(nPresetBtns[x]))
			{
				[dvTP, nPresetBtns[x]] = (nVolPreset[nCurrOut] == x)
			}
		}
	}
}

button_event[dvTP, nButtons]
{
	push:
	{
		stack_var integer nBtn
		nBtn = get_last(nButtons)
		
		switch (nBtn)
		{
			case 1 :	// Volume Up
			{
				on[vdvDev[nCurrOut], VOL_UP]
				fPrintf("'on[',dpstoa(vdvDev[nCurrOut]),', ',itoa(VOL_UP),']'")
			}
			case 2 :	// Volume Down
			{
				on[vdvDev[nCurrOut], VOL_DN]
				fPrintf("'on[',dpstoa(vdvDev[nCurrOut]),', ',itoa(VOL_DN),']'")
			}
			case 3 :	// Set Volume Mute
			{
				[vdvDev[nCurrOut], VOL_MUTE_ON] = ![vdvDev[nCurrOut], VOL_MUTE_ON]
				fPrintf("'[',dpstoa(vdvDev[nCurrOut]),', ',itoa(VOL_MUTE_ON),'] = ![',dpstoa(vdvDev[nCurrOut]),', ',itoa(VOL_MUTE_ON),']'")
			}
			case 4 :	// Set Volume Preset
			{
				bSet = !bSet
				nBlink = fnFBLookup(nButtons[4])
			}
			case 5 :	// Cycle Volume Mute
			{
				pulse[vdvDev[nCurrOut], VOL_MUTE]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(VOL_MUTE),']'")
			}
			case 6 :	// Cycle Volume Preset
			{
				pulse[vdvDev[nCurrOut], VOL_PRESET]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(VOL_PRESET),']'")
			}
			case 8 :	// Query volume preset
			{
				send_command vdvDev[nCurrOut], "'?VOLPRESET'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'?VOLPRESET',39")
			}
		}
	}
	release:
	{
		stack_var integer nBtn
		nBtn = get_last(nButtons)
		
		switch (nBtn)
		{
			case 1 :	// Volume Up
			{
				off[vdvDev[nCurrOut], VOL_UP]
				fPrintf("'off[',dpstoa(vdvDev[nCurrOut]),', ',itoa(VOL_UP),']'")
			}
			case 2 :	// Volume Down
			{
				off[vdvDev[nCurrOut], VOL_DN]
				fPrintf("'off[',dpstoa(vdvDev[nCurrOut]),', ',itoa(VOL_DN),']'")
			}
			case 7 :	// Set Volume Level
			{
				send_level vdvDev[nCurrOut], VOL_LVL, nVolLevelValue[nCurrOut]
				fPrintf("'send_level ',dpstoa(vdvDev[nCurrOut]),', ',itoa(VOL_LVL),', ',itoa(nVolLevelValue[nCurrOut])")
			}
		}
	}
}

level_event[dvTP, nTPVolLevels[1]]
{
	nVolLevelValue[nCurrOut] = level.value
}

level_event[vdvDev, VOL_LVL]
{
	stack_var integer x
	for (x = 1; x <= nDeviceCount; x++)
	{
		if (vdvDev[x] == level.input.device)
		{
			break
		}
	}
	
	send_string 0, "'VolumeComponent Info: Volume Level = ',itoa(level.value)"
	nVolLevelValue[x] = level.value
	if (x == nCurrOut)
	{
		send_level dvTP, nTPVolLevels[1], nVolLevelValue[nCurrOut]
		fPrintf("'send_level ',dpstoa(dvTP),', ',itoa(nTPVolLevels[1]),', ',itoa(nVolLevelValue[nCurrOut])")
	}
}

DEFINE_PROGRAM
[dvTP, nButtons[1]] = [vdvDev[nCurrOut], VOL_UP_FB]
[dvTP, nButtons[2]] = [vdvDev[nCurrOut], VOL_DN_FB]
[dvTP, nButtons[3]] = [vdvDev[nCurrOut], VOL_MUTE_FB]

wait 10
{
	if (nBlink)
	{
		if (bSet)
		{
			[dvTP, nButtons[4]] = ![dvTP, nButtons[4]]
		}
		else
		{
			[dvTP, nButtons[4]] = 0
		}
	}
}
