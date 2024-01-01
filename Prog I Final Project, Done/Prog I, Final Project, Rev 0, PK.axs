PROGRAM_NAME='Prog I, Final Project, Rev 0, PK'
(***********************************************************)
(*  FILE CREATED ON: 10/11/2004  AT: 11:45:38              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 10/12/2004  AT: 10:13:59        *)
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

  dvLights		=    96: 1:2021 // Radia Lighting System
								//   AXLink connection
  dvVolume		=   100: 1:2021 // AXB-VOL3 box
								//   AXLink connection
  dvSwitcher	=  5001: 1:2021 // Extron MAV62 Switcher
								//   NXI 1st serial port
  dvVCR         =  5001: 8:2021 // Samsung VR8460 VCR
							    //   NXI 1st IR port
								//   Uses 'VCR3' System Call 
								//   Uses my IR file:
								//    'Samsung VR8460 VCR.irl'
  dvSAT         =  5001: 8:2021 // The VCR is being used for
								//   television reception.
  dvDVD			=  5001: 9:2021 // Panasonic DVD-A110 DVD
								//   NXI 2nd IR port 
								//   Uses 'DVD2' System Call 
								//   Uses AMX IR file:
								//    'Panas061.irl'
  dvVSS2		=  5001:16:2021 // AMX VSS2 Video Sync Sensor
								//   NXI I/Os:
								//   1 - VCR
								//   2 - DVD
  dvTP			= 10001: 1:0    // NXT-CV7 Touch Panel (Local)
								//   Ethernet Connection
								//   Uses Touch Panel File:
								//    'Programming I Final  
								//    Project REV3, PK.TP4'

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

  SAT = 1
  DVD = 2
  VCR = 1

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

  // These track light levels for touchpanel bargraphs
  VOLATILE INTEGER nLightZone1
  VOLATILE INTEGER nLightZone2
  // Stores light preset levels
  PERSISTENT INTEGER nLightPresetMemory[5][2] 

  // This tracks the volume level for the touch panel bargraph
  VOLATILE INTEGER nVolumeLevel		

  // This tracks the current TV channel
  NON_VOLATILE INTEGER nTVChannel
  // This stores the TV preset numbers
  PERSISTENT INTEGER nTVPreset[6]

  // This will be used as a buffer from the touchpanel
  VOLATILE CHAR sTPBuffer[20]
  
  // This tracks which System Macro was last triggered.
  VOLATILE INTEGER nSystemMacro

  // This acts as a flag to indicate the automatic power down
  // is in progress, preventing the system from triggering it
  // while it's already in progress.
  VOLATILE INTEGER nSysPower
  
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

DEFINE_CALL 'SendLightPreset' (INTEGER nPresets)
{
  // The levels for feedback from Radia (and on the touchpanel
  // range from 0-255, but the commands to the Radia are looking
  // for a percentage number.  That's why the "/2.55" is at the
  // end of that string.
  SEND_COMMAND dvLights,"'P1L',
		  ITOA(nLightPresetMemory[nPresets][1]/2.55)"
  SEND_COMMAND dvLights,"'P2L',
		  ITOA(nLightPresetMemory[nPresets][2]/2.55)"
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// The CREATE_LEVEL commands establish variables to
// automatically track changes in levels.  This section
// establishes the link between the level and a variable,
// but LEVEL_EVENTs later on will cause the information
// to automatically update to the panel.
CREATE_LEVEL dvLights,1,nLightZone1
CREATE_LEVEL dvLights,2,nLightZone2
CREATE_LEVEL dvVolume,1,nVolumeLevel

// This establishes sTPBuffer to receive any string data
// from the touch panel.  We'll parse the data from this
// variable in a DATA_EVENT.
CREATE_BUFFER dvTP,sTPBuffer

// These establish the preset variable values when the
// system boots up.
nLightPresetMemory[1][1] = 255
nLightPresetMemory[1][2] = 255
nLightPresetMemory[2][1] = 217 // Calculated 85*255/100
nLightPresetMemory[2][2] = 102 // Calculated 40*255/100
nLightPresetMemory[3][1] = 128 // Calculated 50*255/100
nLightPresetMemory[3][2] = 153 // Calculated 60*255/100
nLightPresetMemory[4][1] = 64  // Calculated 25*255/100
nLightPresetMemory[4][2] = 26  // Calculated 10*255/100
nLightPresetMemory[5][1] = 0
nLightPresetMemory[5][2] = 0
nTVPreset[1] = 6
nTVPreset[2] = 42
nTVPreset[3] = 37
nTVPreset[4] = 14
nTVPreset[5] = 61
nTVPreset[6] = 8

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

BUTTON_EVENT[dvTP,4]    // Light Zone 1 Up 
BUTTON_EVENT[dvTP,5]    // Light Zone 2 Up 
{
  PUSH:
  {
		// Uses channel 129 or 130 to ramp up.
		TO[dvLights,BUTTON.INPUT.CHANNEL+125]
  }
}

BUTTON_EVENT[dvTP,6]    // Light Zone 1 Down 
BUTTON_EVENT[dvTP,7]    // Light Zone 2 Down 
{
  PUSH:
  {
		// Uses channel 135 or 136 to ramp up.
		TO[dvLights,BUTTON.INPUT.CHANNEL+129]
  }
}

LEVEL_EVENT[dvLights,1] // Update Light Bargraph 1
{
  // This event is triggered by a change in level 1 on 
  // the lighting system.  When that happens, we send 
  // the new level to the touch panel bargraph 1.
  SEND_LEVEL dvTP,1,nLightZone1
}

LEVEL_EVENT[dvLights,2] // Update Light Bargraph 2
{
  // This event is triggered by a change in level 2 on 
  // the lighting system.  When that happens, we send 
  // the new level to the touch panel bargraph 2.
  SEND_LEVEL dvTP,2,nLightZone2
}

BUTTON_EVENT [dvTP,8]   // Light Preset - 100%
BUTTON_EVENT [dvTP,9]   // Light Preset - PARTY
BUTTON_EVENT [dvTP,10]  // Light Preset - READ
BUTTON_EVENT [dvTP,11]  // Light Preset - MOVIE
BUTTON_EVENT [dvTP,12]  // Light Preset - 0%
{
  PUSH: // Recall the reset (through a subroutine)
  {
		CALL 'SendLightPreset' (BUTTON.INPUT.CHANNEL-7)
  }
}

LEVEL_EVENT [dvVolume,1] // Update Volume Bargraph
{
  // This event is triggered by a change in level 1 on 
  // the AXB-VOL3 volume box.  When that happens, we  
  // send the new level to the touch panel bargraph 3.
  SEND_LEVEL dvTP,3,nVolumeLevel
}

BUTTON_EVENT [dvTP,13]   // Volume Up
BUTTON_EVENT [dvTP,14]   // Volume Down
{
  PUSH:
  {
		// Pulse channels 1 or 2 on the volume box.
		TO[dvVolume,BUTTON.INPUT.CHANNEL-12]
  }
}

BUTTON_EVENT [dvTP,15] // Device Menu, SAT TV
{
  PUSH:
  {
		IF ([dvVSS2,VCR]==0) // If the VSS2 doesn't detect a video
		{				     // signal from the VCR...
			PULSE [dvVCR,9]    // ... toggle power to ON.
		}
		ELSE                 // If the VCR is on...
		{                    // ... pulse STOP to make sure the
			PULSE [dvVCR,2]    // TV tuner shows on the screen
		}				     // instead of the tape.
	
		SEND_STRING dvSwitcher,'1*1!' // Send VCR to Out 1
	}
}

BUTTON_EVENT [dvTP,16] // Device Menu, DVD
{
  PUSH:
  {
		IF ([dvVSS2,DVD]==0) // If the VSS2 doesn't detect a video
		{				     // signal from the DVD player...
			PULSE [dvDVD,9]    // ... toggle power to ON.
		}
		SEND_STRING dvSwitcher,'2*1!' // Send DVD to Out 1
  }
}

BUTTON_EVENT [dvTP,17] // Device Menu, VCR
{
  PUSH:
  {
		IF ([dvVSS2,VCR]==0) // If the VSS2 doesn't detect a video
		{				     // signal from the VCR...
			PULSE [dvVCR,9]    //    ... toggle power to ON.
		}
		SEND_STRING dvSwitcher,'1*1!' // Send VCR to Out 1
  }
}

BUTTON_EVENT [dvTP,78] // DVD "Title" Menu
BUTTON_EVENT [dvTP,79] // DVD Menu
BUTTON_EVENT [dvTP,80] // DVD Cursor Up 
BUTTON_EVENT [dvTP,81] // DVD Cursor Down 
BUTTON_EVENT [dvTP,82] // DVD Cursor Right 
BUTTON_EVENT [dvTP,83] // DVD Cursor Left
{
  PUSH:
  {
		PULSE[dvDVD,BUTTON.INPUT.CHANNEL-34]
  }
}

BUTTON_EVENT [dvTP,84] // DVD Menu Select 
{
  PUSH:
  {
		PULSE[dvDVD,21]
  }
}

BUTTON_EVENT [dvTP,61] // TV Preset 1
BUTTON_EVENT [dvTP,62] // TV Preset 2
BUTTON_EVENT [dvTP,63] // TV Preset 3
BUTTON_EVENT [dvTP,64] // TV Preset 4
BUTTON_EVENT [dvTP,65] // TV Preset 5
BUTTON_EVENT [dvTP,66] // TV Preset 6
{
  PUSH:
  {
		// Load channel from TV Memory
		nTVChannel = nTVPreset[BUTTON.INPUT.CHANNEL-60]
	
		// Send channel to SAT Receiver (VCR)
		SEND_COMMAND dvSAT,"'CH',nTVChannel"
	
		// Update Channel Readout in the touchpanel
		SEND_COMMAND dvTP,"'@TXT',1,ITOA(nTVChannel)"
  }
}

BUTTON_EVENT [dvTP,51] // TV Channel Up
{
  PUSH:
  {
		// Update Channel number for readout
		nTVChannel++
	
		// If the Number is over 99...
		IF ( nTVChannel > 99 ) 
		{ 
			// ... roll the counter to channel 2
			nTVChannel = 2
	  
			// ... and send the channel to the SAT receiver
			SEND_COMMAND dvSAT,"'CH',nTVChannel"
		}
		// Otherwise...
		ELSE
		{
			// ... pulse channel up code.
			PULSE [dvSAT,22]	  
		}
	
		// Update channel readout in touchpanel
		SEND_COMMAND dvTP,"'@TXT',1,ITOA(nTVChannel)"
  }
}

BUTTON_EVENT [dvTP,52] // TV Channel Down
{
  PUSH:
  {
		// Update channel number for readout
		nTVChannel--

		// If the channel goes below 2...
		IF ( nTVChannel < 2 ) 
		{ 
			// ... roll the counter to channel 99 ...
			nTVChannel = 99 
	  
			// ... and send the channel to the SAT Receiver.
			SEND_COMMAND dvSAT,"'CH',nTVChannel"
		}
		// Otherwise...
		ELSE
		{
			// ... pulse the channel down code.
			PULSE[dvSAT,23]
		}
	
		// Update channel readout in touchpanel
		SEND_COMMAND dvTP,"'@TXT',1,ITOA(nTVChannel)"
	}
}

DATA_EVENT [dvTP]      // Message from TP keypad
{
  STRING:
  {
		// The keypad sends a string starting with 'AKEYP-'.  So,
		// delete everything to the '-' at the end of the header.
		REMOVE_STRING (sTPBuffer,'-',1)
	
		// If the channel number is valid (from 2 and 99)
		IF ( ATOI(sTPBuffer) >= 2 AND ATOI(sTPBuffer) <= 99 )
		{
			// Update the tracking variable 
			nTVChannel = ATOI(sTPBuffer)
	  
			// Send the channel to the SAT TV box using 'CH'
			SEND_COMMAND dvSAT,"'CH',nTVChannel"
	
			// Update the channel readout on the screen
			SEND_COMMAND dvTP,"'@TXT',1,ITOA(nTVChannel)"
		}
	
		// Clear the buffer out for the next message
		CLEAR_BUFFER sTPBuffer
  }
}

DATA_EVENT [dvSAT]      // Initialize as IR, Carrier On
{
  ONLINE:
  {
		SEND_COMMAND dvSAT,'SET MODE IR'
		SEND_COMMAND dvSAT,'CARON'
  }
}

DATA_EVENT [dvDVD]      // Initialize as IR, Carrier On
{
  ONLINE:
  {
		SEND_COMMAND dvDVD,'SET MODE IR'
		SEND_COMMAND dvDVD,'CARON'
  }
}

DATA_EVENT [dvSwitcher] // Initialize as 9600,N,8,1
{
  ONLINE:
  {
		// Serial settings were pulled from switcher manual.
		// Our SEND_COMMAND structure is in Software History.
		SEND_COMMAND dvSwitcher,'SET BAUD 9600,N,8,1'
  }
}

DATA_EVENT [dvVolume]   // Set ramp time for Vol card
{
  ONLINE:
  {
		// Ramp time for Channels 1 & 2 is 
		//   4 sec from top to bottom
		SEND_COMMAND dvVolume,'P0R40'
  }
}

DATA_EVENT [dvLights]   // Set ramp time for Radia lighting
{
  ONLINE:
  {
		// Default ramp time 2sec from top to bottom
		SEND_COMMAND dvLights,'RT2'
  }
}

BUTTON_EVENT [dvTP,1] // System Macro - Power ON 
{
  PUSH:
  {
		nSystemMacro = 1
	
		// If the VCR is off, toggle it on.
		IF ([dvVSS2,VCR]==0) { PULSE [dvVCR,9] }
	
		// If the DVD is off, toggle it on.
		IF ([dvVSS2,DVD]==0) { PULSE [dvDVD,9] }
	
		// Set lights to party (preset 2)
		CALL 'SendLightPreset' (2)
  }
}

BUTTON_EVENT [dvTP,2] // System Macro - Movie
{
  PUSH:
  {
		nSystemMacro = 2
  
		// If the VCR is off, toggle it on.
		IF ([dvVSS2,VCR]==0) { PULSE [dvVCR,9] }
	
		// If the DVD is off, toggle it on.
		IF ([dvVSS2,DVD]==0) { PULSE [dvDVD,9] }
	
		// Lights to read (preset 3)
		CALL 'SendLightPreset' (3)
	
		// Wait 4 seconds for the rest...
		WAIT 40 'Movie Macro'
		{
			// Volume to 60% (1 sec ramp)
			SEND_COMMAND dvVolume,'P0L60%T10'
	  
			// Lights to movie (preset 4)
			CALL 'SendLightPreset' (4)
	  
			nSystemMacro = 1
		}
  }
}

BUTTON_EVENT [dvTP,3] // System Macro - Power OFF 
{
  PUSH:
  {
		nSystemMacro = 3
	
		// Lights to party (preset 2)
		CALL 'SendLightPreset' (2)

		// Volume to 20% (1 sec ramp)
		SEND_COMMAND dvVolume,'P0L20%T10'

		// Wait 3 seconds for more...
		WAIT 30 'System Off Macro A'
		{	
			// If the VCR is on, toggle it off.
			IF ([dvVSS2,VCR]==1) { PULSE [dvVCR,9] }
	
			// If the DVD is on, toggle it off.
			IF ([dvVSS2,DVD]==1) { PULSE [dvDVD,9] }
	  
			// Wait 7 more seconds for the rest 
			WAIT 70 'System Off Macro B'
			{
				// Lights to off (preset 5)
				CALL 'SendLightPreset' (5)
			}
		}
  }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

// System call used for DVD and VCR transport controls/status
SYSTEM_CALL [1] 'VCR3' (dvVCR,dvTP,91,92,93,94,95,96,97,0,0)
SYSTEM_CALL [1] 'DVD2' (dvDVD,dvTP,71,72,73,74,75,76,77,0)

// Buttons for light presets turn on if the current light
// level is within +/- one of the saved preset level.
[dvTP,8]  = ( nLightZone1 == 255 AND   // Preset 100%
			  nLightZone2 == 255 )
[dvTP,9]  = ( nLightZone1 >= 216 AND   // Preset Party
			  nLightZone1 <= 218 AND
			  nLightZone2 >= 101 AND 
			  nLightZone2 <= 103 )
[dvTP,10] = ( nLightZone1 >= 127 AND   // Preset Read
			  nLightZone1 <= 129 AND
			  nLightZone2 >= 152 AND 
			  nLightZone2 <= 154 )
[dvTP,11] = ( nLightZone1 >= 63  AND   // Preset Movie
			  nLightZone1 <= 65  AND
			  nLightZone2 >= 25  AND 
			  nLightZone2 <= 27  )
[dvTP,12] = ( nlightZone1 ==   0 AND   // Preset 0%
			  nLightZone2 ==   0 )

// Lighting buttons look at lighting up and down channels
// to get their status info.			  
[dvTP,4] = [dvLights,129] // Button Status - Light Zone 1 Up 
[dvTP,5] = [dvLights,130] // Button Status - Light Zone 2 Up
[dvTP,6] = [dvLights,135] // Button Status - Light Zone 1 Down
[dvTP,7] = [dvLights,136] // Button Status - Light Zone 2 Down

// Volume buttons look at volume up and down channels
// to get their status info.
[dvTP,13] = [dvVolume,1] // Button Status - Volume Up 
[dvTP,14] = [dvVolume,2] // Button Status - Volume Down

// If the currnet TV channel is equal to a preset channel,
// light the preset button.
[dvTP,61] = ( nTVChannel ==  6 ) // Preset 1 (ESPN)
[dvTP,62] = ( nTVChannel == 42 ) // Preset 1 (AMC)
[dvTP,63] = ( nTVChannel == 37 ) // Preset 1 (Comedy)
[dvTP,64] = ( nTVChannel == 14 ) // Preset 1 (CNN)
[dvTP,65] = ( nTVChannel == 61 ) // Preset 1 (Food)
[dvTP,66] = ( nTVChannel ==  8 ) // Preset 1 (MTV)

// System Macro ON button:
[dvTP,1] = ( nSystemMacro  < 3 AND // The OFF Macro wasn't triggered 
			 [dvVSS2,VCR] == 1 AND // The VCR is on 
			 [dvVSS2,DVD] == 1 )   // The DVD is on

// System Macro MOVIE button
[dvTP,2] = ( nSystemMacro == 2 )   // The MOVIE macro was triggered

// System Macro OFF button:
[dvTP,3] = ( nSystemMacro  = 3 AND // The OFF Macro was triggered 
			 [dvVSS2,VCR] == 0 AND // The VCR is off  
			 [dvVSS2,DVD] == 0 )   // The DVD is off 

// At 6pm, shut everything down automatically
IF ( TIME == '18:00:00' AND nSysPower == 0 )
{
  nSysPower    = 1
  nSystemMacro = 3

  // Volume to 20% (1 sec ramp)
  SEND_COMMAND dvVolume,'P0L20%T10'

  // Lights to off (preset 5)
  CALL 'SendLightPreset' (5)

  // Wait 3 seconds for more...
  WAIT 30 'System Off Macro A'
  {	
		// If the VCR is on, toggle it off.
		IF ([dvVSS2,VCR]==1) { PULSE [dvVCR,9] }
	
		// If the DVD is on, toggle it off.
		IF ([dvVSS2,DVD]==1) { PULSE [dvDVD,9] }
	
	nSysPower = 0
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)