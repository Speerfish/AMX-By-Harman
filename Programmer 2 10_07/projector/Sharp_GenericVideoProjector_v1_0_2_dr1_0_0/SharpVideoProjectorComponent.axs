MODULE_NAME='SharpVideoProjectorComponent'(
										dev vdvDev,
										dev dvTP
									 )
(***********************************************************)
(*  FILE CREATED ON: 12/19/2005  AT: 09:07:18              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/12/2007  AT: 08:10:48        *)
(***********************************************************)

DEFINE_DEVICE

DEFINE_CONSTANT
integer nButtons[] = 
{
	1340	//  1 - Query Projector Preset
}

integer nPresetBtns[] =
{
	261,	// Preset 1
	262,	// Preset 2
	263,	// Preset 3
	264,	// Preset 4
	265,	// Preset 5
	266,	// Preset 6
	267		// Preset 7
}

integer nFBArray[] =
{
	261,	// Preset 1
	262,	// Preset 2
	263,	// Preset 3
	264,	// Preset 4
	265,	// Preset 5
	266,	// Preset 6
	267		// Preset 7
}
DEFINE_VARIABLE

volatile integer nPreset = 0
volatile integer nPresetCount = 0
volatile integer nDbg = 1

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
		send_string 0, "'** Message from VideoProjectorComponent.axs: ',sTxt"
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

DEFINE_EVENT

data_event[vdvDev]
{
	command:
	{
		if (find_string(data.text, '-', 1))
		{
			stack_var integer x
			stack_var char sCmd[15]
			sCmd = remove_string(data.text, '-', 1)
			
			switch (sCmd)
			{
				case 'VPROJPRESET-' :
				{
					nPreset = atoi(data.text)
					for (x = 1; x <= nPresetCount; x++)
					{
						if (fnFBLookup(nPresetBtns[x]))
						{
							[dvTP, nPresetBtns[x]] = (nPreset == x)
						}
					}
				}
				case 'DEBUG-' :
				{
					nDbg = atoi(data.text)
				}
			}
		}
	}
}

button_event[dvTP, nPresetBtns]
{
	push:
	{
		stack_var integer x
		nPreset = get_last(nPresetBtns)
		send_command vdvDev, "'VPROJPRESET-',itoa(nPreset)"
		fPrintf("'send_command ',dpstoa(vdvDev),', ',39,'VPROJPRESET-',itoa(nPreset),39")
		
		for (x = 1; x <= nPresetCount; x++)
		{
			if (fnFBLookup(nPresetBtns[x]))
			{
				[dvTP, nPresetBtns[x]] = (nPreset == x)
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
		
		switch(nBtn)
		{
			case 1 :	// Query Projector Preset
			{
				send_command vdvDev, "'?VPROJPRESET'"
				fPrintf("'send_command ',dpstoa(vdvDev),', ',39,'?VPROJPRESET',39")
			}
		}
	}
}

DEFINE_PROGRAM
