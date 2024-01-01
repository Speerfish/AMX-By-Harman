MODULE_NAME='SharpSourceSelectComponent'(
										dev vdvDev[],
										dev dvTP
								   )
(***********************************************************)
(*  FILE CREATED ON: 12/09/2005  AT: 14:28:27              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/12/2007  AT: 14:41:38        *)
(***********************************************************)

DEFINE_DEVICE

DEFINE_CONSTANT
integer nButtons[] =
{
	196,	//  1 - Cycle Input Source
	1449	//  2 - Query Input Source
}

integer nVTButtons[] = 
{
	15,		//  1 - Currently selected source
	2020	//  2 - Source numpad display window
}
integer nInputBtns[] = 
{
	3310,	//  1 - Input 1
	3311,	//  2 - Input 2
	3312,	//  3 - Input 3
	3313,	//  4 - Input 4
	3314,	//  5 - Input 5
	3315,	//  6 - Input 6
	1445	//  7 - Invalid	   
}
integer nOutputBtns[] =
{
	301		// Output 1
}
char sInputLabels[][20] = 
{
	'INPUT,1',
	'INPUT,2',
	'INPUT,3',
	'INPUT,4',
	'INPUT,5',
	'INPUT,6',
	'INVALID,1'
}
integer nFBArray[] =
{
	301		// Output 1
}
#include 'SNAPI.axi'

DEFINE_VARIABLE

volatile integer nCurrOut = 1
volatile integer nOutputCount = 1
volatile integer nInputCount = 1
volatile integer nDbg = 1
volatile char sInputStore[1][20] = { '' }

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
		send_string 0, "'** Message from SourceSelectComponent.axs: ',sTxt"
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

nOutputCount = length_array(nOutputBtns)
nInputCount = length_array(nInputBtns)

DEFINE_EVENT

data_event[vdvDev]
{
	online:
	{
		stack_var integer x
		for (x = 1; x <= nOutputCount; x++)
		{
			if (fnFBLookup(nOutputBtns[x]))
			{
				[dvTP, nOutputBtns[x]] = (nCurrOut == x)
			}
		}
	}
	command:
	{
		if (find_string(data.text, '-', 1))
		{
			stack_var integer x
			stack_var integer nTempDev
			stack_var char sCmd[6]
			
			for (x = 1; x <= length_array(vdvDev); x++)
			{
				if (vdvDev[x] == data.device)
				{
					nTempDev = x
					break
				}
			}
			
			sCmd = remove_string(data.text, '-', 1)
			
			switch (sCmd)
			{
				case 'INPUT-' :
				{
					sInputStore[nTempDev] = upper_string(data.text)
					if (find_string(sInputStore[nTempDev], 'INVALID', 1))
					{
						sInputStore[nTempDev] = 'Unknown Input'
					}
					
					if (nTempDev == nCurrOut)
					{
						send_command dvTP, "'^TXT-',itoa(nVTButtons[1]),',0,',sInputStore[nCurrOut]"
						
						for (x = 1; x <= nInputCount; x++)
						{
							[dvTP, nInputBtns[x]] = (sInputStore[nCurrOut] == sInputLabels[x])
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

button_event[dvTP, nOutputBtns]
{
	push:
	{
		stack_var integer x
		nCurrOut = get_last(nOutputBtns)
		send_command dvTP, "'^TXT-',itoa(nVTButtons[1]),',0,',sInputStore[nCurrOut]"
		
		for (x = 1; x <= nOutputCount; x++)
		{
			if (fnFBLookup(nOutputBtns[x]))
			{
				[dvTP, nOutputBtns[x]] = (nCurrOut == x)
			}
		}
		
		for (x = 1; x <= nInputCount; x++)
		{
			[dvTP, nInputBtns[x]] = (sInputStore[nCurrOut] == sInputLabels[x])
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
			case 1 :	// Cycle Input Source
			{
				pulse[vdvDev[nCurrOut], SOURCE_CYCLE]
				fPrintf("'pulse[',dpstoa(vdvDev[nCurrOut]),', ',itoa(SOURCE_CYCLE),']'")
			}
			case 2 :	// Query Input Source
			{
				send_command vdvDev[nCurrOut], "'?INPUT'"
				fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'?INPUT',39")
			}
		}
	}
}

button_event[dvTP, nInputBtns]
{
	push:
	{
		stack_var integer nBtn
		stack_var integer x
		nBtn = get_last(nInputBtns)
		
//		sInputStore[nCurrOut] = sInputLabels[nBtn]
		send_command vdvDev[nCurrOut], "'INPUT-',sInputLabels[nBtn]"
		fPrintf("'send_command ',dpstoa(vdvDev[nCurrOut]),', ',39,'INPUT-',sInputLabels[nBtn],39")
		pulse[button.input]
//		send_command dvTP, "'^TXT-',itoa(nVTButtons[1]),',0,',sInputStore[nCurrOut]"
		
//		for (x = 1; x <= nInputCount; x++)
		{
//			[dvTP, nInputBtns[x]] = (sInputStore[nCurrOut] == sInputLabels[x])
		}
	}
}

DEFINE_PROGRAM
