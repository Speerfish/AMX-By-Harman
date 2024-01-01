PROGRAM_NAME='Prog I Exercises Cumulative'
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 12/08/2005  AT: 21:44:02        *)
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

	dvVol        =   302: 1:2010 // AXLink:    AXC-VOL3 in AXCENT3

	dvSwitch     =  5001: 1:0    // NXI Ser 1: Loopback Plug
	dvRelays     =  5001: 4:0    // NXI Relays
	dvDVD        =  5001: 5:0    // NXI IR 1:  CyberHome DVD-300
	dvProj       =  5001: 6:0    // NXI IR 2:  Sony VPLV-800Q
	dvVCR				 =  5001: 7:0    // NXI IR 3:  Sony SLV960HF

	dvTP         = 10001: 1:0    // NXT-CV7 Ports
	dvTP_DVD     = 10001: 2:0
	dvTP_Vol     = 10001: 3:0
	dvTP_Switch  = 10001: 4:0
	dvTP_Module  = 10001: 5:0
	dvTP_VCR     = 10001: 6:0
	
	vdvRelayComm = 33001: 1:0    // vdv for Relay Modules
	vdvVol       = 33002: 1:0    // vdv for DEFINE_CONNECT_LEVEL

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// These constants are for Exercise 3.1 and 3.2... no others.
btnScreenUp      = 38
btnScreenDn      = 39

// These constants are for Exercise 4 - DEFINE_CALL
btnCallSystemOn  = 41
btnCallSystemOff = 42
btnCallScreenUp  = 43
btnCallScreenDn  = 44
btnCallLiftUp    = 45
btnCallLiftDn    = 46
btnCallProjOn    = 47
btnCallProjOff   = 48

// These are standard IR positions
irPower         =  9
irPowerOn       = 27
irPowerOff      = 28

// States for Screen and Projector Lift
stateUp         =  0
stateMovingUp   =  1
stateMovingDn   =  2
stateDn         =  3

// States for Projector Power and System Power
stateOff        =  0 
stateTurningOff =  1
stateTurningOn  =  2
stateOn         =  3



(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

// Variables used as flags in a few exercises
VOLATILE INTEGER nStateScreen
VOLATILE INTEGER nStateProjPower
VOLATILE INTEGER nStateProjLift

// Exercise 3.2 (Conditionals) - Remembers last menu button 
VOLATILE INTEGER nLastMenu

// Exercise 4 (Subroutines) - I used these names as a shortcut
VOLATILE DEVCHAN dcScreenUp   = { dvRelays, 7 }
VOLATILE DEVCHAN dcScreenDn   = { dvRelays, 8 }
VOLATILE DEVCHAN dcProjLiftUp = { dvRelays,11 }
VOLATILE DEVCHAN dcProjLiftDn = { dvRelays,12 }

// Exercise 6 (Modules) - used for UI Module declaration
VOLATILE INTEGER nBtns[]      = {  1,  2,  3 } // Flash, Down, Up
VOLATILE INTEGER nRelayLEDs[] = {101,102,103,104}

// Exercise 7 (Levels)
VOLATILE INTEGER nVolFromCard[2]
VOLATILE INTEGER nVolPreset[2]

// Exercise 8 (Strings)
VOLATILE INTEGER nIn
VOLATILE INTEGER nOut
VOLATILE CHAR sBuffer[12]

VOLATILE INTEGER nLoop // Counter in DEFINE_PROGRAM loops

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

// These are mutually exclusive relays listed individually
([dvRelays,6],[dvRelays,7],[dvRelays,8])

// These are mutually exclusive relays listed as a block
([dvRelays,10]..[dvRelays,12])


(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)

DEFINE_CALL 'Projector Lift Up' // Exercise 4.1
{
	// If a lift command was being buffered, forget it.
	CANCEL_WAIT_UNTIL 'Next Lift Action'

	// If the projector is showing some ON state, use the
	// projector off call to turn the projector off
	IF ( nStateProjPower >= stateTurningOn ) 
	{ 
		CALL 'Projector Off'
	}

	// Wait until the lift is in the proper position to begin...
	WAIT_UNTIL ( nStateProjLift == stateDn ) 'Next Lift Action'
	{
		// Again, verify the projector is off.
	  IF ( nStateProjPower >= stateTurningOn ) 
		{ 
			CALL 'Projector Off'
		}
		
		// Wait until the projector is off or turning off...
		// ... then put up the lift.
		WAIT_UNTIL ( nStateProjPower == stateTurningOff OR
		             nStateProjPower == stateOff ) 'Next Lift Action'
		{
		            nStateProjLift = stateMovingUp
			                 ON[dcProjLiftUp]    // Proj Lift Requires
			WAIT 10 { TOTAL_OFF[dcProjLiftUp]  } //   1 sec pulse
			WAIT 80 { nStateProjLift = stateUp } // Lift finishes moving
		}
	}
}

DEFINE_CALL 'Projector Lift Down' // Exercise 4.1
{
	// Reverse logic of above routine, but we don't automatically
	// turn on the projector.

	CANCEL_WAIT_UNTIL 'Next Lift Action'

	WAIT_UNTIL ( nStateProjLift == stateUp ) 'Next Lift Action'
	{
	             nStateProjLift = stateMovingDn
											ON[dcProjLiftDn]
	  WAIT  10 { TOTAL_OFF[dcProjLiftDn]  }
		WAIT  80 { nStateProjLift = stateDn }
	}
}

DEFINE_CALL 'Projector On' // Exercise 4.1
{
	// If another projector command was buffered, cancel it.
	CANCEL_WAIT_UNTIL 'Next Projector Action'
	
	// Make sure the lift is down. 
	IF( nStateProjLift <= stateMovingUp )
	{ 
		CALL 'Projector Lift Down' 
	}
	
	// Wait until the projector is off.
	WAIT_UNTIL ( nStateProjPower == stateOff ) 'Next Projector Action'
	{
		// Again, make sure the lift is down. 
		IF( nStateProjLift <= stateMovingUp )
		{ 
			CALL 'Projector Lift Down' 
		}
		
		// Wait until the lift is down or moving down...
		WAIT_UNTIL ( nStateProjLift >= stateMovingDn ) 'Next Projector Action'
		{
								 nStateProjPower = stateTurningOn
								 PULSE[dvProj,irPowerOn]
			WAIT 300 { nStateProjPower = stateOn } // Lock out projector for 30sec
		}
	}
}

DEFINE_CALL 'Projector Off' // Exercise 4.1
{
	CANCEL_WAIT_UNTIL 'Next Projector Action'
	
	WAIT_UNTIL ( nStateProjPower >= stateOn ) 'Next Projector Action'
	{
							 nStateProjPower = stateTurningOff
		           PULSE[dvProj,irPowerOff]
		WAIT  10 { PULSE[dvProj,irPowerOff]   }
		WAIT 310 { nStateProjPower = stateOff }
	}
}

DEFINE_CALL 'Screen Up' // Exercise 4.1
{
	CANCEL_WAIT_UNTIL 'Next Screen Action'
	WAIT_UNTIL ( nStateScreen == stateDn ) 'Next Screen Action'
	{
							PULSE[dcScreenUp]
							nStateScreen = stateMovingUp
		WAIT 80 { nStateScreen = stateUp       }
	}
}

DEFINE_CALL 'Screen Down' // Exercise 4.1
{
	CANCEL_WAIT_UNTIL 'Next Screen Action'
	WAIT_UNTIL ( nStateScreen == stateUp ) 'Next Screen Action'
	{
	
							PULSE[dcScreenDn]
							nStateScreen = stateMovingDn
		WAIT 80 { nStateScreen = stateDn       }
	}
}

// In Exercise 7, this connects the touch panel active bargraph
//   and the second level on the card
DEFINE_CONNECT_LEVEL (vdvVol,1,dvVol,2,dvTP_Vol,6)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// Exercise 7 - This updates nVolFromCard values whenever 
//   the level changes on the volume card.
CREATE_LEVEL dvVol,1,nVolFromCard[1]
CREATE_LEVEL dvVol,2,nVolFromCard[2]

// Exercise 8 - Buffer from Switcher
CREATE_BUFFER dvSwitch,sBuffer

DEFINE_MODULE 'Marching_Relays_UI' RlyUI(vdvRelayComm,dvTP_Module,nBtns,nRelayLEDs)
DEFINE_MODULE 'Marching_Relays_Comm' RlyComm(vdvRelayComm,dvRelays)


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

(***********************************************************)
(* EXERCISE 2.1 - 2.3                                      *)
(***********************************************************)

BUTTON_EVENT[dvTP,10] // Exercise 2.1 - ON
{
	PUSH:
	{
		ON[dvRelays,1]
	}
}

BUTTON_EVENT[dvTP,11] // Exercise 2.1 - OFF
{
	PUSH:
	{
		OFF[dvRelays,1]
	}
}

BUTTON_EVENT[dvTP,12] // Exercise 2.1 - TO
{
	PUSH:
	{
		TO[dvRelays,2]
	}
}

BUTTON_EVENT[dvTP,13] // Exercise 2.1 - PULSE
{
	PUSH:
	{
		PULSE[dvRelays,3]
	}
}

BUTTON_EVENT[dvTP,14] // Exercise 2.1 - MIN_TO
{
	PUSH:
	{
		MIN_TO[dvRelays,4]
	}
}

BUTTON_EVENT[dvTP,15] // Exercise 2.2 - Toggle
{
	PUSH:
	{
		// This syntax flips the state of the relay...
		// ... make the relay equal to the opposite state.
		[dvRelays,5] = ![dvRelays,5]
	}
}

// This is "stacking events"... we list several buttons that
// can trigger the code in the event below.
BUTTON_EVENT[dvTP,16] // Exercise 2.2 - Mutually Exclusive On
BUTTON_EVENT[dvTP,17] // Exercise 2.2 - Mutually Exclusive On
BUTTON_EVENT[dvTP,18] // Exercise 2.2 - Mutually Exclusive On
{
	PUSH:
	{
		// BUTTON.INPUT.CHANNEL is a system variable equal to
		// the button number that originated this event.  It is
		// very useful, especially when stacked events are used.
		
		ON[dvRelays,BUTTON.INPUT.CHANNEL-10]

		// In this case, BUTTON.INPUT.CHANNEL can have a value 
		// between 16-18.  By subtracting 10, I end up with
		// relays 6-8, the proper numbers for my NXI.
	}
}

BUTTON_EVENT[dvTP,19] // Exercise 2.3 - Pulse on Release 
{
	RELEASE:
	{
		PULSE[dvRelays,9]
	}
}

BUTTON_EVENT[dvTP,20] // Exercise 2.3 - Mutually Exclusive Pulse
BUTTON_EVENT[dvTP,21] // Exercise 2.3 - Mutually Exclusive Pulse
BUTTON_EVENT[dvTP,22] // Exercise 2.3 - Mutually Exclusive Pulse
{
	PUSH:
	{
		PULSE[dvRelays,BUTTON.INPUT.CHANNEL-10]
	}
}

BUTTON_EVENT[dvTP,1] // Exercise 3.2 - Menu Button - CHANNELS
BUTTON_EVENT[dvTP,2] // Exercise 3.2 - Menu Button - WAITS & CONDITIONALS
BUTTON_EVENT[dvTP,3] // Exercise 3.2 - Menu Button - SUBROUTINES
BUTTON_EVENT[dvTP,4] // Exercise 3.2 - Menu Button - LEVELS
BUTTON_EVENT[dvTP,5] // Exercise 3.2 - Menu Button - STRINGS
{
	PUSH:
	{
		nLastMenu = BUTTON.INPUT.CHANNEL
	}
}

BUTTON_EVENT[dvTP,btnScreenUp] // Exercise 3.3 - Screen Up
{
	PUSH:
	{
		// If another screen request was made, forget about it.
		CANCEL_WAIT_UNTIL 'Next Screen Action'
		
		// Wait for screen to be stopped in the Down Position
		WAIT_UNTIL( nStateScreen == stateDn ) 'Next Screen Action'
		{
			// Set flag indicating screen is moving up
			nStateScreen = stateMovingUp
			
			// Activate relay for 7 sec to move screen up 
                       ON[dvRelays,7]
			WAIT 70 { TOTAL_OFF[dvRelays,7] 
			          // Set flag indicating screen is up
			          nStateScreen = stateUp
			        }
		}
	}
}

BUTTON_EVENT[dvTP,btnScreenDn] // Exercise 3.3 - Screen Down
{
	PUSH:
	{
		// If another screen request was made, forget about it.
		CANCEL_WAIT_UNTIL 'Next Screen Action'
		
		// Wait for screen to be stopped in the Up Position
		WAIT_UNTIL( nStateScreen == stateUp ) 'Next Screen Action'
		{
			// Set flag indicating screen is moving down
			nStateScreen = stateMovingDn
			
			// Activate relay for 7 sec to move screen down 
                       ON[dvRelays,8]
			WAIT 70 { TOTAL_OFF[dvRelays,8] 
			          // Set flag indicating screen is down
			          nStateScreen = stateDn
			        }
		}
	}
}

// Below, you'll find a handy shortcut if you have control  
// over the touch panel development:
//
// => Button "0" allows all buttons from dvTP_DVD (10001:2:0).
//    (In our example, only the DVD buttons are located on
//    port 2 of the touch panel.)  If all the button numbers 
//    match the IR codes, then BUTTON.INPUT.CHANNEL moves the 
//    value for you.  =)
//
// If you are dealing with an older G3 panel, or the codes
// don't like up like this, then you'll have to write out
// some button events until you take Programmer II.

BUTTON_EVENT[dvTP_DVD,0] // Exercise 3.2 - DVD IR Buttons
{
	PUSH:
	{
	
		
		PULSE[dvDVD,BUTTON.INPUT.CHANNEL]
	}
}

BUTTON_EVENT[dvTP,btnCallSystemOn] // Exercise 4.1 - System On
{
	PUSH:
	{
		          CALL 'Screen Down'
		          CALL 'Projector Lift Down'
		WAIT 10 { CALL 'Projector On'        }
	}
}

BUTTON_EVENT[dvTP,btnCallSystemOff] // Exercise 4.1 - System Off
{
	PUSH:
	{
		          CALL 'Projector Off'
		          CALL 'Screen Up'
		WAIT 10 { CALL 'Projector Lift Up' }
	}
}

BUTTON_EVENT[dvTP,btnCallScreenDn] // Exercise 4.1 - Screen Down
{
	PUSH:
	{
		CALL 'Screen Down'
	}
}

BUTTON_EVENT[dvTP,btnCallScreenUp] // Exercise 4.1 - Screen Up
{
	PUSH:
	{
		CALL 'Screen Up'
	}
}

BUTTON_EVENT[dvTP,btnCallLiftDn] // Exercise 4.1 - Lift Down
{
	PUSH:
	{
		CALL 'Projector Lift Down'
	}
}

BUTTON_EVENT[dvTP,btnCallLiftUp] // Exercise 4.1 - Lift Up
{
	PUSH:
	{
		CALL 'Projector Lift Up'
	}
}

BUTTON_EVENT[dvTP,btnCallProjOn] // Exercise 4.1 - Projector On
{
	PUSH:
	{
		CALL 'Projector On'
	}
}

BUTTON_EVENT[dvTP,btnCallProjOff] // Exercise 4.1 - Projector Off
{
	PUSH:
	{
		CALL 'Projector Off'
	}
}

BUTTON_EVENT[dvTP_Vol,4] // Exercise 7 - Volume 1 Up 
BUTTON_EVENT[dvTP_Vol,5] // Exercise 7 - Volume 1 Down
{
	PUSH:
	{
		// Only move if the volume is not muted.
		IF ( ![dvVol,6] )
		{
			TO[dvVol,BUTTON.INPUT.CHANNEL]
		}
	}
}

BUTTON_EVENT[dvTP_Vol,6] // Exercise 7 - Mute 1
BUTTON_EVENT[dvTP_Vol,9] // Exercise 7 - Mute 2
{
	PUSH:
	{
		[dvVol,BUTTON.INPUT.CHANNEL] = ![dvVol,BUTTON.INPUT.CHANNEL]
	}
}

LEVEL_EVENT[dvVol,1] // Exercise 7 - Vol Bargraph 1

{
	// Send a text representation to the screen.
	SEND_COMMAND dvTP_Vol,"'@TXT',1,ITOA(nVolFromCard[1]/2.55),'%'"

	// Update the bargraph
	SEND_LEVEL dvTP_Vol,5,nVolFromCard[1]
}

LEVEL_EVENT[dvVol,2] // Exercise 7 - Vol Bargraph 2
{
	// Send a text representation to the screen.
	SEND_COMMAND dvTP_Vol,"'@TXT',2,ITOA(nVolFromCard[2]/2.55),'%'"
	
	// We don't need to update the bargraph here - we are using
	// DEFINE_CONNECT_LEVEL (just before DEFINE_START) to link
	// the active bargraph to the vol card level.
}

BUTTON_EVENT[dvTP_Vol,21] // Exercise 7 - Preset 1
BUTTON_EVENT[dvTP_Vol,22] // Exercise 7 - Preset 2
{
	HOLD[20]:
	{
		nVolPreset[BUTTON.INPUT.CHANNEL-20] = nVolFromCard[BUTTON.INPUT.CHANNEL-20]
		SEND_COMMAND dvTP,'ADBEEP'
	}
	RELEASE:
	{
		SEND_COMMAND dvVol,"'P',ITOA(BUTTON.INPUT.CHANNEL-20),
		                    'L',ITOA(nVolPreset[BUTTON.INPUT.CHANNEL-20])"
	}
}

BUTTON_EVENT[dvTP_Switch,1]  // Exercise 8 - Input 1
BUTTON_EVENT[dvTP_Switch,2]  // Exercise 8 - Input 2
BUTTON_EVENT[dvTP_Switch,3]  // Exercise 8 - Input 3
BUTTON_EVENT[dvTP_Switch,4]  // Exercise 8 - Input 4
{
	PUSH:
	{
		nIn = BUTTON.INPUT.CHANNEL
	}
}

BUTTON_EVENT[dvTP_Switch,11] // Exercise 8 - Output 1
BUTTON_EVENT[dvTP_Switch,12] // Exercise 8 - Output 2
BUTTON_EVENT[dvTP_Switch,13] // Exercise 8 - Output 3
BUTTON_EVENT[dvTP_Switch,14] // Exercise 8 - Output 4
{
	PUSH:
	{
		nOut = BUTTON.INPUT.CHANNEL-10
	}
}

BUTTON_EVENT[dvTP_Switch,21] // Exercise 8 - Take
{
	PUSH:
	{
		SEND_STRING dvSwitch,"'*i',ITOA(nIn),'o',ITOA(nOut),'!'"
		TO[dvSwitch,1] // Used as a flag for take button status
	}
}

DATA_EVENT[dvSwitch] // Exercise 8 - Reply from switcher
{
	STRING:
	{
		STACK_VAR INTEGER nLength
		STACK_VAR CHAR sIn[2]
		STACK_VAR CHAR sOut[2]
		
		// Print buffer to screen
		SEND_COMMAND dvTP_Switch,"'@TXT',1,sBuffer"
		
		// Now, parse the string to a readable form...
		// This parsing routine is designed to be flexible 
		// for IO numbers that can be longer than 1 char.
		
			// Remove everything up to the 'i'
			REMOVE_STRING(sBuffer,'i',1)
			
			// Find the 'o' to determine the length of the input number
			nLength = FIND_STRING(sBuffer,'o',1) -1
			
			// Put the input number into a variable 
			sIn = LEFT_STRING(sBuffer,nLength)
			
			// Remove everything up to the 'o'
			REMOVE_STRING(sBuffer,'o',1)
			
			// Find the '!' to determine the length of the output number 
			nLength = FIND_STRING(sBuffer,'!',1) -1
			
			// Put the input number into a variable 
			sOut = LEFT_STRING(sBuffer,nLength)
			
			// Remove the delimiter, so the buffer is ready for the 
			// next command 
			REMOVE_STRING(sBuffer,'!',1)

		// With the in and out numbers captured, print the results
		// to the screen
		SEND_COMMAND dvTP_Switch,"'@TXT',2,
		                          'Input ',sIn,$0A,
															'is routed to',$0A,
															'Output ',sOut,'.'"
	}
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

// Exercise 5 System Call
// => System Calls are traditionally placed at the beginning 
//    of the DEFINE_PROGRAM section.
SYSTEM_CALL [1] 'VCR3' (dvVCR,dvTP_VCR,1,2,3,4,5,6,7,0,0)

SYSTEM_CALL 'VOL1'(dvTP_Vol,4,5,6,dvVol,4,5,6)
// Exercise 2.1 Button Feedback
[dvTP,10] =  [dvRelays,1]
[dvTP,11] = ![dvRelays,1]
[dvTP,12] =  [dvRelays,2]
[dvTP,13] =  [dvRelays,3]
[dvTP,14] =  [dvRelays,4]

// Exercise 2.2 Button Feedback
[dvTP,15] =  [dvRelays,5]
[dvTP,16] =  [dvRelays,6]
[dvTP,17] =  [dvRelays,7]
[dvTP,18] =  [dvRelays,8]

// Exercise 2.3 Button Feedback
[dvTP,19] =  [dvRelays,9]
[dvTP,20] =  [dvRelays,10]
[dvTP,21] =  [dvRelays,11]
[dvTP,22] =  [dvRelays,12]

// Exercise 3.2 Button Feedback
[dvTP,1] = ( nLastMenu == 1 )
[dvTP,2] = ( nLastMenu == 2 )
[dvTP,3] = ( nLastMenu == 3 )
[dvTP,4] = ( nLastMenu == 4 )
[dvTP,5] = ( nLastMenu == 5 )

// Exercise 3.3 Button Feedback
[dvTP,btnScreenUp] = ( nStateScreen == stateUp      OR
                       nStateScreen == stateMovingUp )
[dvTP,btnScreenDn] = ( nStateScreen == stateDn      OR
                       nStateScreen == stateMovingDn )

// Light up DVD buttons when the IR channel is pulsed
FOR(nLoop=1;nLoop<=255;nLoop++)
{
	[dvTP_DVD,nLoop] = [dvDVD,nLoop]
}

// Exercise 4.1 Button Feedback
[dvTP,btnCallSystemOn]  = ( nStateScreen    >= stateMovingDn  AND
                            nStateProjLift  >= stateMovingDn  AND
													  nStateProjPower >= stateTurningOn )
[dvTP,btnCallSystemOff] = ( nStateScreen    <= stateMovingUp  AND
                            nStateProjLift  <= stateMovingUp  AND
													  nStateProjPower <= stateTurningOff )
[dvTP,btnCallScreenDn]  = ( nStateScreen    >= stateMovingDn   )
[dvTP,btnCallScreenUp]  = ( nStateScreen    <= stateMovingUp   )
[dvTP,btnCallLiftDn]    = ( nStateProjLift  >= stateMovingDn   )
[dvTP,btnCallLiftUp]    = ( nStateProjLift  <= stateMovingUp   )
[dvTP,btnCallProjOn]    = ( nStateProjPower >= stateTurningOn  )
[dvTP,btnCallProjOff]   = ( nStateProjPower <= stateTurningOff )

// Exercise 4.2 - System Shutdown at 10pm
IF( TIME == '22:00:00' )
{
	CALL 'Screen Up'
	CALL 'Projector Lift Up' // Automatically turns proj off
}

// Exercise 7 Button Feedback
[dvTP_Vol,4] = [dvVol,4] // Vol 1 Up
[dvTP_Vol,5] = [dvVol,5] // Vol 1 Down
[dvTP_Vol,6] = [dvVol,6] // Mute 1
[dvTP_Vol,9] = [dvVol,9] // Mute 2
[dvTP_Vol,21] = ( nVolFromCard[1] == nVolPreset[1] ) // Preset 1
[dvTP_Vol,22] = ( nVolFromCard[2] == nVolPreset[2] ) // Preset 1

// Exercise 8 Button Feedback
FOR(nLoop=1;nLoop<=4;nLoop++)
{
	[dvTP_Switch,nLoop]    = ( nIn  == nLoop ) // Input Buttons
	[dvTP_Switch,nLoop+10] = ( nOut == nLoop ) // Output Buttons
}
[dvTP_Switch,21] = [dvSwitch,1] // Take Button

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

