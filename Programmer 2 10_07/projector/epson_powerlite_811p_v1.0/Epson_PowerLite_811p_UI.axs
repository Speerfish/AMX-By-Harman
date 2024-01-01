MODULE_NAME='Epson_PowerLite_811p_UI' (DEV vdvDEVICE, DEV dvTP, INTEGER nCHAN_BTN[], INTEGER nTXT_BTN[])
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 01/30/2003 AT: 08:51:36               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 08/22/2003 AT: 13:10:36         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 02/12/2004                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

(***********************************************************)
(* System Type : Netlinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE CHAR sVERSION[5]        // STORES NETLINX COMM MODULE VERSION NUMBER
VOLATILE CHAR cADJUSTMENT[4] = ''// STORES THE VALUE WE ARE SENDING FOR THE ADJUSTMENT
VOLATILE INTEGER nDEBUG = 0      // TRACKS THE ON/OFF STATE OF DEBUG MSGS SENT TO THE TELNET SESSION
VOLATILE INTEGER nDEVICE_SCALE=0 // TRACKS WHETHER WE'RE USING THE API OR DEVICE SCALE RANGES
VOLATILE INTEGER nCOLOR_CONTROL=0// STORES THE COLOR CONTROL SETTING
VOLATILE INTEGER nCOLOR_MODE = 0 // STORES THE COLOR MODE SETTING
VOLATILE INTEGER nINPUT = 0      // STORES THE CURRENT INPUT SOURCE
VOLATILE INTEGER nSCREEN_MUTE=0  // STORES THE SCREEN MUTE SETTING
VOLATILE INTEGER nENABLE_BRIGHT_LEVEL=1 // INDICATES WHEN ITS OK TO ACTIVATE THE TP BRIGHTNESS LEVEL
VOLATILE INTEGER nENABLE_CONT_LEVEL=1 // INDICATES WHEN ITS OK TO ACTIVATE THE TP CONTRAST LEVEL
VOLATILE INTEGER nENABLE_SHARP_LEVEL=1 // INDICATES WHEN ITS OK TO ACTIVATE THE TP SHARPNESS LEVEL
VOLATILE INTEGER nENABLE_TINT_LEVEL=1 // INDICATES WHEN ITS OK TO ACTIVATE THE TP TINT LEVEL
VOLATILE INTEGER nENABLE_COLOR_LEVEL=1 // INDICATES WHEN ITS OK TO ACTIVATE THE TP COLOR LEVEL
VOLATILE INTEGER nVOLUME = 0     // STORES THE CURRENT VOLUME LEVEL
VOLATILE INTEGER nCOUNT_POP = 0         // INDICATES IF THE COUNT DOWN POPUP IS ALREADY ON
VOLATILE SLONG slBRIGHTNESS = 0  // STORES THE CURRENT BRIGHTNESS LEVEL
VOLATILE SLONG slCONTRAST = 0    // STORES THE CURRENT CONTRAST LEVEL
VOLATILE SLONG slSHARPNESS = 0   // STORES THE CURRENT SHARPNESS LEVEL
VOLATILE SLONG slTINT = 0        // STORES THE CURRENT TINT LEVEL
VOLATILE SLONG slCOLOR = 0       // STORES THE CURRENT COLOR LEVEL
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
DEFINE_FUNCTION SLONG Scale_Range(SLONG Num_In, SLONG Min_In, SLONG Max_In, SLONG Min_Out, SLONG Max_Out)
{
    STACK_VAR
    SLONG Val_In
    SLONG Range_In
    SLONG Range_Out
    SLONG Whole_Num
    FLOAT Num_Out
    
    Val_In = Num_In                 // Get input value
    IF(Val_In == Min_In)            // Handle endpoints
        {Num_Out = Min_Out}
    ELSE IF(Val_In == Max_In)
        {Num_Out = Max_Out}
    ELSE                            // Otherwise scale...
    {
        Range_In = Max_In - Min_In      // Establish input range
        Range_Out = Max_Out - Min_Out   // Establish output range
        Val_In = Val_In - Min_In        // Remove input offset
        Num_Out = Val_In * Range_Out    // Multiply by output range
        Num_Out = Num_Out / Range_In    // Then divide by input range
        Num_Out = Num_Out + Min_Out     // Add in minimum output value
        Whole_Num = TYPE_CAST(Num_Out)  // Store the whole number only of the result
        IF (((Num_Out - Whole_Num)* 100.0) >= 50.0) { Num_Out++ }    // round up
    }
    Return TYPE_CAST(Num_Out)
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvDEVICE]
{
    STRING:
    {
        STACK_VAR CHAR cCMD[25]
        
        IF(nDEBUG) { SEND_STRING 0, "'UI RECEIVED FROM COMM: ',DATA.TEXT" }
        IF(FIND_STRING(DATA.TEXT, '=', 1)) { cCMD = REMOVE_STRING(DATA.TEXT, '=', 1) }        
        ELSE { cCMD = DATA.TEXT }
        SWITCH(cCMD)
        {
            // FIND MATCHING STRING AND PARSE REST OF MESSAGE. PROVIDE FEEDBACK TO THE 
            // TOUCH PANEL.
            CASE 'BASS=': {}
            CASE 'BRIGHTNESS=':
            {
                slBRIGHTNESS = ATOI(DATA.TEXT)
                IF (!nDEVICE_SCALE)
                {
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[3],ITOA(slBRIGHTNESS),'%'"
                    SEND_LEVEL dvTP,1,slBRIGHTNESS*255/100
                }
                ELSE
                {
                    STACK_VAR SLONG slVALUE
                        
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[3],ITOA(slBRIGHTNESS)"
                    slVALUE = slBRIGHTNESS
                    slVALUE = Scale_Range(slVALUE, 0, 237, 0, 100)
                    SEND_LEVEL dvTP,1,slVALUE*255/100
                }
                // DISABLE LEVEL ACTIVITY TO GIVE THE LEVELS A CHANCE TO UPDATE
                nENABLE_BRIGHT_LEVEL=0
                CANCEL_WAIT 'ENABLE BRIGHT LEVEL'
                WAIT 3 'ENABLE BRIGHT LEVEL' { nENABLE_BRIGHT_LEVEL = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }
            CASE 'CEILING_PROJECTION=': { [dvTP, nCHAN_BTN[54]] = ATOI(DATA.TEXT) }
            CASE 'COLOR=':
            {
                slCOLOR = ATOI(DATA.TEXT)
                IF (!nDEVICE_SCALE)
                {
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[7],ITOA(slCOLOR),'%'"
                    SEND_LEVEL dvTP,5,slCOLOR*255/100
                }
                ELSE
                {
                    STACK_VAR SLONG slVALUE
                        
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[7],ITOA(slCOLOR)"
                    slVALUE = slCOLOR
                    slVALUE = Scale_Range(slVALUE, 0, 237, 0, 100)
                    SEND_LEVEL dvTP,5,slVALUE*255/100
                }
                // DISABLE LEVEL ACTIVITY TO GIVE THE LEVELS A CHANCE TO UPDATE
                nENABLE_COLOR_LEVEL=0
                CANCEL_WAIT 'ENABLE COLOR LEVEL'
                WAIT 3 'ENABLE COLOR LEVEL' { nENABLE_COLOR_LEVEL = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }
            CASE 'COLOR_CONTROL=': { nCOLOR_CONTROL = ATOI(DATA.TEXT) }
            CASE 'COLOR_MODE=': { nCOLOR_MODE= ATOI(DATA.TEXT) }
            CASE 'COLOR_SETTING=': {}
            CASE 'CONTRAST=':
            {
                slCONTRAST = ATOI(DATA.TEXT)
                IF (!nDEVICE_SCALE)
                {
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[4],ITOA(slCONTRAST),'%'"
                    SEND_LEVEL dvTP,2,slCONTRAST*255/100
                }
                ELSE
                {
                    STACK_VAR SLONG slVALUE
                        
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[4],ITOA(slCONTRAST)"
                    slVALUE = slCONTRAST
                    slVALUE = Scale_Range(slVALUE, 0, 237, 0, 100)
                    SEND_LEVEL dvTP,2,slVALUE*255/100
                }
                // DISABLE LEVEL ACTIVITY TO GIVE THE LEVELS A CHANCE TO UPDATE
                nENABLE_CONT_LEVEL=0
                CANCEL_WAIT 'ENABLE CONT LEVEL'
                WAIT 3 'ENABLE CONT LEVEL' { nENABLE_CONT_LEVEL = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }
            CASE 'COOLDOWNTIME=': {}
            CASE 'COOLING=':
            {
                IF (!nCOUNT_POP)
                {
                    SEND_COMMAND dvTP, 'PPON-Time_Out'
                    ON[nCOUNT_POP]
                }
                SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[2],'PROJECTOR COOLING DOWN: ',DATA.TEXT"
                IF (ATOI(DATA.TEXT) == 0)
                {
                    SEND_COMMAND dvTP, 'PPOF-Time_Out'
                    OFF[nCOUNT_POP]
                }
            }
            CASE 'DEBUG=': { nDEBUG = ATOI(DATA.TEXT) }
            CASE 'DEVICE_SCALE=':
            {
                IF (nDEVICE_SCALE <> ATOI(DATA.TEXT))
                {
                    nDEVICE_SCALE = ATOI(DATA.TEXT)
                    // UPDATE THE TOUCH PANELS LEVELS
                    SEND_COMMAND vdvDEVICE, 'BRIGHTNESS?'
                    SEND_COMMAND vdvDEVICE, 'CONTRAST?'
                    SEND_COMMAND vdvDEVICE, 'SHARPNESS?'
                    SEND_COMMAND vdvDEVICE, 'TINT?'
                    SEND_COMMAND vdvDEVICE, 'COLOR?'
                }
            }
            CASE 'ERRORM=': { SEND_STRING 0, "'ERROR:',DATA.TEXT" }
            CASE 'INPUT=':
            {
                nINPUT = ATOI(DATA.TEXT)
                SEND_COMMAND vdvDEVICE, 'VOLUME?'
            }
            CASE 'KEYSTONE=': {}
            CASE 'LAMPTIME=': { SEND_COMMAND dvTP, "'@TXT', nTXT_BTN[1], DATA.TEXT" }
            CASE 'MUTE=':
            {
                OFF[dvTP, nCHAN_BTN[69]]
                OFF[dvTP, nCHAN_BTN[70]]
                IF (ATOI(DATA.TEXT) == 1)
                {
                    ON[dvTP, nCHAN_BTN[69]]
                    nVOLUME = 0
                }
                ELSE IF (ATOI(DATA.TEXT) == 0)
                {
                    ON[dvTP, nCHAN_BTN[70]]
                    SEND_COMMAND vdvDEVICE, 'VOLUME?'
                }
            }
            CASE 'NOISE=': { [dvTP, nCHAN_BTN[58]] = ATOI(DATA.TEXT) }
            CASE 'POSITION=': {}
            CASE 'POWER=':
            {
                OFF[dvTP, nCHAN_BTN[29]]
                OFF[dvTP, nCHAN_BTN[30]]
                IF (ATOI(DATA.TEXT) == 1) { ON[dvTP, nCHAN_BTN[30]] }
                ELSE IF (ATOI(DATA.TEXT) == 0) { ON[dvTP, nCHAN_BTN[29]] }
            }
            CASE 'REAR_PROJECTION=': { [dvTP, nCHAN_BTN[55]] = ATOI(DATA.TEXT) }
            CASE 'SCREEN_MUTE=': { nSCREEN_MUTE = ATOI(DATA.TEXT) }
            CASE 'SHARPNESS=':
            {
                slSHARPNESS = ATOI(DATA.TEXT)
                IF (!nDEVICE_SCALE)
                {
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[5],ITOA(slSHARPNESS),'%'"
                    SEND_LEVEL dvTP,3,slSHARPNESS*255/100
                }
                ELSE
                {
                    STACK_VAR SLONG slVALUE
                        
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[5],ITOA(slSHARPNESS)"
                    slVALUE = slSHARPNESS
                    slVALUE = Scale_Range(slVALUE, 0, 233, 0, 100)
                    SEND_LEVEL dvTP,3,slVALUE*255/100
                }
                // DISABLE LEVEL ACTIVITY TO GIVE THE LEVELS A CHANCE TO UPDATE
                nENABLE_SHARP_LEVEL=0
                CANCEL_WAIT 'ENABLE SHARP LEVEL'
                WAIT 3 'ENABLE SHARP LEVEL' { nENABLE_SHARP_LEVEL = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }
            CASE 'TINT=':
            {
                slTINT = ATOI(DATA.TEXT)
                IF (!nDEVICE_SCALE)
                {
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[6],ITOA(slTINT),'%'"
                    SEND_LEVEL dvTP,4,slTINT*255/100
                }
                ELSE
                {
                    STACK_VAR SLONG slVALUE
                        
                    SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[6],ITOA(slTINT)"
                    slVALUE = slTINT
                    slVALUE = Scale_Range(slVALUE, 0, 237, 0, 100)
                    SEND_LEVEL dvTP,4,slVALUE*255/100
                }
                // DISABLE LEVEL ACTIVITY TO GIVE THE LEVELS A CHANCE TO UPDATE
                nENABLE_TINT_LEVEL=0
                CANCEL_WAIT 'ENABLE TINT LEVEL'
                WAIT 3 'ENABLE TINT LEVEL' { nENABLE_TINT_LEVEL = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }
            CASE 'TREBLE=': {}
            CASE 'VERSION=': { sVERSION = DATA.TEXT }
            CASE 'VOLUME=':
            {
                IF (!nDEVICE_SCALE) { nVOLUME = ATOI(DATA.TEXT) }
                ELSE { nVOLUME = TYPE_CAST(Scale_Range(ATOI(DATA.TEXT), 0, 255, 0, 100)) }
            }
            CASE 'WARMING=':
            {
                IF (!nCOUNT_POP)
                {
                    SEND_COMMAND dvTP, 'PPON-Time_Out'
                    ON[nCOUNT_POP]
                }
                SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[2],'PROJECTOR WARMING UP: ',DATA.TEXT"
                IF (ATOI(DATA.TEXT) == 0)
                {
                    SEND_COMMAND dvTP, 'PPOF-Time_Out'
                    OFF[nCOUNT_POP]
                }
            }
            CASE 'WARMUP_COOLDOWN_ENABLE=': {}
            CASE 'WARMUPTIME=': {}
        }// END SWITCH(cCMD)
    }// END STRING
}// END DATA_EVENT[vdvDEVICE]

DATA_EVENT[dvTP]
{
    ONLINE: 
    {
        SEND_COMMAND dvTP, '@PPX'
        SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[1],''"
        SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[2],''"
        SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[3],''"
        SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[4],''"
        SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[5],''"
        SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[6],''"
        SEND_COMMAND dvTP, "'@TXT',nTXT_BTN[7],''"
    }
}// END DATA_EVENT[dvTP]

LEVEL_EVENT[dvTP, 1]    // BRIGHTNESS
LEVEL_EVENT[dvTP, 2]    // CONTRAST
LEVEL_EVENT[dvTP, 3]    // SHARPNESS
LEVEL_EVENT[dvTP, 4]    // TINT
LEVEL_EVENT[dvTP, 5]    // COLOR
{
    SWITCH(LEVEL.INPUT.LEVEL)
    {
        CASE 1:
        {
            IF (nENABLE_BRIGHT_LEVEL)   // THE BRIGHTNESS LEVEL IS FINISHED UPDATING
            {
                CANCEL_WAIT 'SEND NEW BRIGHT LEVEL'
                WAIT 2 'SEND NEW BRIGHT LEVEL'
                {
                    IF (!nDEVICE_SCALE)
                    {
                        SEND_COMMAND vdvDEVICE,"'BRIGHTNESS=',ITOA(LEVEL.VALUE*100/255)"
                        SEND_COMMAND vdvDEVICE, "'BRIGHTNESS?'"
                    }
                    ELSE
                    {
                        LOCAL_VAR SLONG slVAL
                        
                        slVAL = Scale_Range(LEVEL.VALUE*100/255, 0, 100, 0, 237)
                        SEND_COMMAND vdvDEVICE,"'BRIGHTNESS=',ITOA(slVAL)"
                        SEND_COMMAND vdvDEVICE,"'BRIGHTNESS?'"
                    }
                }
            }
        }
        CASE 2:
        {
            IF (nENABLE_CONT_LEVEL)     // THE CONTRAST LEVEL IS FINISHED UPDATING
            {
                CANCEL_WAIT 'SEND NEW CONT LEVEL'
                WAIT 2 'SEND NEW CONT LEVEL'
                {
                    IF (!nDEVICE_SCALE)
                    {
                        SEND_COMMAND vdvDEVICE,"'CONTRAST=',ITOA(LEVEL.VALUE*100/255)"
                        SEND_COMMAND vdvDEVICE,"'CONTRAST?'"
                    }
                    ELSE
                    {
                        LOCAL_VAR SLONG slVAL
                        
                        slVAL = Scale_Range(LEVEL.VALUE*100/255, 0, 100, 0, 237)
                        SEND_COMMAND vdvDEVICE,"'CONTRAST=',ITOA(slVAL)"
                        SEND_COMMAND vdvDEVICE,"'CONTRAST?'"
                    }
                }
            }
        }
        CASE 3:
        {
            IF (nENABLE_SHARP_LEVEL)    // THE SHARPNESS LEVEL IS FINISHED UPDATING
            {
                CANCEL_WAIT 'SEND NEW SHARP LEVEL'
                WAIT 2 'SEND NEW SHARP LEVEL'
                {
                    IF (!nDEVICE_SCALE)
                    {
                        SEND_COMMAND vdvDEVICE,"'SHARPNESS=',ITOA(LEVEL.VALUE*100/255)"
                        SEND_COMMAND vdvDEVICE,"'SHARPNESS?'"
                    }
                    ELSE
                    {
                        LOCAL_VAR SLONG slVAL
                        
                        slVAL = Scale_Range(LEVEL.VALUE*100/255, 0, 100, 0, 233)
                        SEND_COMMAND vdvDEVICE,"'SHARPNESS=',ITOA(slVAL)"
                        SEND_COMMAND vdvDEVICE,"'SHARPNESS?'"
                    }
                }
            }
        }
        CASE 4:
        {
            IF (nENABLE_TINT_LEVEL)     // THE TINT LEVEL IS FINISHED UPDATING
            {
                CANCEL_WAIT 'SEND NEW TINT LEVEL'
                WAIT 2 'SEND NEW TINT LEVEL'
                {
                    IF (!nDEVICE_SCALE)
                    {
                        SEND_COMMAND vdvDEVICE,"'TINT=',ITOA(LEVEL.VALUE*100/255)"
                        SEND_COMMAND vdvDEVICE,"'TINT?'"
                    }
                    ELSE
                    {
                        LOCAL_VAR SLONG slVAL
                        
                        slVAL = Scale_Range(LEVEL.VALUE*100/255, 0, 100, 0, 237)
                        SEND_COMMAND vdvDEVICE,"'TINT=',ITOA(slVAL)"
                        SEND_COMMAND vdvDEVICE,"'TINT?'"
                    }
                }
            }
        }
        CASE 5:
        {
            IF (nENABLE_COLOR_LEVEL)     // THE COLOR LEVEL IS FINISHED UPDATING
            {
                CANCEL_WAIT 'SEND NEW COLOR LEVEL'
                WAIT 2 'SEND NEW COLOR LEVEL'
                {
                    IF (!nDEVICE_SCALE)
                    {
                        SEND_COMMAND vdvDEVICE,"'COLOR=',ITOA(LEVEL.VALUE*100/255)"
                        SEND_COMMAND vdvDEVICE,"'COLOR?'"
                    }
                    ELSE
                    {
                        LOCAL_VAR SLONG slVAL
                        
                        slVAL = Scale_Range(LEVEL.VALUE*100/255, 0, 100, 0, 237)
                        SEND_COMMAND vdvDEVICE,"'COLOR=',ITOA(slVAL)"
                        SEND_COMMAND vdvDEVICE,"'COLOR?'"
                    }
                }
            }
        }
    }// END SWITCH(LEVEL.INPUT.LEVEL)
}

BUTTON_EVENT[dvTP, nCHAN_BTN]
{
    PUSH:
    {
        STACK_VAR INTEGER nBTN
    
        nBTN = GET_LAST(nCHAN_BTN)
        SWITCH(nBTN)
        {
            CASE 11:                  // RGB ANALOG INPUT 1
            {
                PULSE[dvTP, nCHAN_BTN[11]]
                SEND_COMMAND vdvDEVICE, "'INPUT=1'"
            }
            CASE 12:                  // RGB DIGITAL INPUT 1
            {
                PULSE[dvTP, nCHAN_BTN[12]]
                SEND_COMMAND vdvDEVICE, "'INPUT=6'"
            }
            CASE 13:                  // RGB ANALOG INPUT 2
            {
                PULSE[dvTP, nCHAN_BTN[13]]
                SEND_COMMAND vdvDEVICE, "'INPUT=8'"
            }
            CASE 14:                  // RGB VIDEO INPUT 1
            {
                PULSE[dvTP, nCHAN_BTN[14]]
                SEND_COMMAND vdvDEVICE, "'INPUT=7'"
            }
            CASE 15:                  // COMPONENT (YCbCr)
            {
                PULSE[dvTP, nCHAN_BTN[15]]
                SEND_COMMAND vdvDEVICE, "'INPUT=5'"
            }
            CASE 16:                  // COMPONENT (YPbPr)
            {
                PULSE[dvTP, nCHAN_BTN[16]]
                SEND_COMMAND vdvDEVICE, "'INPUT=10'"
            }
            CASE 18:                  // S-VIDEO
            {
                PULSE[dvTP, nCHAN_BTN[18]]
                SEND_COMMAND vdvDEVICE, "'INPUT=2'"
            }
            CASE 19:                  // VIDEO (RCA)
            {
                PULSE[dvTP, nCHAN_BTN[19]]
                SEND_COMMAND vdvDEVICE, "'INPUT=4'"
            }
            CASE 20:                  // RGB-Video RGsB
            {
                PULSE[dvTP, nCHAN_BTN[20]]
                SEND_COMMAND vdvDEVICE, "'INPUT=9'"
            }
            CASE 21:                  // TEMPERATURE COLOR CONTROL
            {
                PULSE[dvTP, nCHAN_BTN[21]]
                SEND_COMMAND vdvDEVICE, 'COLOR_CONTROL=1'
            }
            CASE 22:                  // RGB COLOR CONTROL
            {
                PULSE[dvTP, nCHAN_BTN[22]]
                SEND_COMMAND vdvDEVICE, 'COLOR_CONTROL=2'
            }
            CASE 23:                  // sRGB COLOR MODE
            {
                PULSE[dvTP, nCHAN_BTN[23]]
                SEND_COMMAND vdvDEVICE, "'COLOR_MODE=1'"
            }
            CASE 24:                  // NORMAL COLOR MODE
            {
                PULSE[dvTP, nCHAN_BTN[24]]
                SEND_COMMAND vdvDEVICE, "'COLOR_MODE=2'"
            }
            CASE 25:                  // MEETING COLOR MODE
            {
                PULSE[dvTP, nCHAN_BTN[25]]
                SEND_COMMAND vdvDEVICE, "'COLOR_MODE=3'"
            }
            CASE 26:                  // PRESENTATION COLOR MODE
            {
                PULSE[dvTP, nCHAN_BTN[26]]
                SEND_COMMAND vdvDEVICE, "'COLOR_MODE=4'"
            }
            CASE 27:                  // THEATER COLOR MODE
            {
                PULSE[dvTP, nCHAN_BTN[27]]
                SEND_COMMAND vdvDEVICE, "'COLOR_MODE=5'"
            }
            CASE 28:                  // AMUSEMENT COLOR MODE
            {
                PULSE[dvTP, nCHAN_BTN[28]]
                SEND_COMMAND vdvDEVICE, "'COLOR_MODE=6'"
            }
            CASE 29:                  // POWER OFF BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'POWER=0'
            }
            CASE 30:                  // POWER ON BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'POWER=1'
            }
            CASE 32:                  // VOLUME DRECREMENT
            {
                SEND_COMMAND vdvDEVICE, 'VOLUME=-'
            }
            CASE 33:                  // VOLUME INCREMENT
            {
                SEND_COMMAND vdvDEVICE, 'VOLUME=+'
            }
            CASE 35:                  // ASPECT RATIO BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'ASPECT=T'
            }
            CASE 37:                  // LEFT CURSOR BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'CURSOR=<'
            }
            CASE 38:                  // RIGHT CURSOR BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'CURSOR=>'
            }
            CASE 39:                  // UP CURSOR BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'CURSOR=+'
            }
            CASE 40:                  // DOWN CURSOR BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'CURSOR=-'
            }
            CASE 41:                  // MENU TOGGLE BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'MENUSELECT'
            }
            CASE 42:                  // HELP MENU TOGGLE BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'MENU'
            }
            CASE 43:                  // ENTER BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'HELP'
            }
            CASE 44:                  // BACK BUTTON
            {
                SEND_COMMAND vdvDEVICE, 'RETURN'
            }
            CASE 51:                  // BLACK SCREEN
            {
                PULSE[dvTP, nCHAN_BTN[51]]
                SEND_COMMAND vdvDEVICE, "'SCREEN_MUTE=0'"
            }
            CASE 52:                  // BLUE SCREEN
            {
                PULSE[dvTP, nCHAN_BTN[52]]
                SEND_COMMAND vdvDEVICE, "'SCREEN_MUTE=1'"
            }
            CASE 53:                  // LOGO
            {
                PULSE[dvTP, nCHAN_BTN[53]]
                SEND_COMMAND vdvDEVICE, "'SCREEN_MUTE=2'"
            }
            CASE 54:                  // CEILING PROJECTION
            {
                IF ([dvTP, nCHAN_BTN[54]]) { SEND_COMMAND vdvDEVICE, 'CEILING_PROJECTION=0' }
                ELSE { SEND_COMMAND vdvDEVICE, 'CEILING_PROJECTION=1' }
            }
            CASE 55:                  // REAR PROJECTION
            {
                IF ([dvTP, nCHAN_BTN[55]]) { SEND_COMMAND vdvDEVICE, 'REAR_PROJECTION=0' }
                ELSE { SEND_COMMAND vdvDEVICE, 'REAR_PROJECTION=1' }
            }
            CASE 58:                  // NOISE
            {
                IF ([dvTP, nCHAN_BTN[58]]) { SEND_COMMAND vdvDEVICE, 'NOISE=0' }
                ELSE { SEND_COMMAND vdvDEVICE, 'NOISE=1' }
            }
            CASE 61:                  // EXIT ZOOM
            {
                SEND_COMMAND vdvDEVICE, 'ZOOM=C'
            }
            CASE 62:                  // DECREMENT ZOOM
            {
                SEND_COMMAND vdvDEVICE, 'ZOOM=-'
            }
            CASE 63:                  // INCREMENT ZOOM
            {
                SEND_COMMAND vdvDEVICE, 'ZOOM=+'
            }
            CASE 64:                  // DETAILS MENU BUTTON
            {
                SEND_COMMAND dvTP, "'@TXT', nTXT_BTN[1], ''"
                SEND_COMMAND vdvDEVICE, 'LAMPTIME?'
            }
            CASE 69:                  // A/V MUTE ON
            {
                SEND_COMMAND vdvDEVICE, 'MUTE=1'
            }
            CASE 70:                  // A/V MUTE OFF
            {
                SEND_COMMAND vdvDEVICE, 'MUTE=0'
            }
            CASE 71:                  // VOLUME 10%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=10'" }
                ELSE
                {
                    STACK_VAR SLONG slVAL
                    
                    slVAL = Scale_Range(10, 0, 100, 0, 255)
                    SEND_COMMAND vdvDEVICE, "'VOLUME=',ITOA(slVAL)"
                }
            }
            CASE 72:                  // VOLUME 20%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=20'" }
                ELSE
                {
                    STACK_VAR SLONG slVAL
                    
                    slVAL = Scale_Range(20, 0, 100, 0, 255)
                    SEND_COMMAND vdvDEVICE, "'VOLUME=',ITOA(slVAL)"
                }
            }
            CASE 73:                  // VOLUME 30%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=30'" }
                ELSE
                {
                    STACK_VAR SLONG slVAL
                    
                    slVAL = Scale_Range(30, 0, 100, 0, 255)
                    SEND_COMMAND vdvDEVICE, "'VOLUME=',ITOA(slVAL)"
                }
            }
            CASE 74:                  // VOLUME 40%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=40'" }
                ELSE
                {
                    STACK_VAR SLONG slVAL
                    
                    slVAL = Scale_Range(40, 0, 100, 0, 255)
                    SEND_COMMAND vdvDEVICE, "'VOLUME=',ITOA(slVAL)"
                }
            }
            CASE 75:                  // VOLUME 50%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=50'" }
                ELSE
                {
                    STACK_VAR SLONG slVAL
                    
                    slVAL = Scale_Range(50, 0, 100, 0, 255)
                    SEND_COMMAND vdvDEVICE, "'VOLUME=',ITOA(slVAL)"
                }                                       
            }
            CASE 76:                  // VOLUME 60%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=60'" }
                ELSE
                {
                    STACK_VAR SLONG slVAL
                    
                    slVAL = Scale_Range(60, 0, 100, 0, 255)
                    SEND_COMMAND vdvDEVICE, "'VOLUME=',ITOA(slVAL)"
                }
            }
            CASE 77:                  // VOLUME 70%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=70'" }
                ELSE
                {
                    STACK_VAR SLONG slVAL
                    
                    slVAL = Scale_Range(70, 0, 100, 0, 255)
                    SEND_COMMAND vdvDEVICE, "'VOLUME=',ITOA(slVAL)"
                }
            }
            CASE 78:                  // VOLUME 80%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=80'" }
                ELSE
                {
                    STACK_VAR SLONG slVAL
                    
                    slVAL = Scale_Range(80, 0, 100, 0, 255)
                    SEND_COMMAND vdvDEVICE, "'VOLUME=',ITOA(slVAL)"
                }
            }
            CASE 79:                  // VOLUME 90%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=90'" }
                ELSE
                {
                    STACK_VAR SLONG slVAL
                    
                    slVAL = Scale_Range(90, 0, 100, 0, 255)
                    SEND_COMMAND vdvDEVICE, "'VOLUME=',ITOA(slVAL)"
                }
            }
            CASE 80:                  // VOLUME 100%
            {
                IF (!nDEVICE_SCALE) { SEND_COMMAND vdvDEVICE, "'VOLUME=100'" }
                ELSE { SEND_COMMAND vdvDEVICE, "'VOLUME=255'" }
            }
        }// END SWITCH
    }// END PUSH
}// EMD BUTTON_EVENT[dvTP, nCHAN_BTN]
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP, nCHAN_BTN[11]] = (nINPUT == 1)              // RGB ANALOG INPUT 1
[dvTP, nCHAN_BTN[12]] = (nINPUT == 6)              // RGB DIGITAL INPUT 1
[dvTP, nCHAN_BTN[13]] = (nINPUT == 8)              // RGB ANALOG INPUT 2
[dvTP, nCHAN_BTN[14]] = (nINPUT == 7)              // RGB VIDEO INPUT 1
[dvTP, nCHAN_BTN[15]] = (nINPUT == 5)              // COMPONENT (YCbCr)
[dvTP, nCHAN_BTN[16]] = (nINPUT == 10)             // COMPONENT (YPbPr)
[dvTP, nCHAN_BTN[18]] = (nINPUT == 2)              // S-VIDEO
[dvTP, nCHAN_BTN[19]] = (nINPUT == 4)              // VIDEO (RCA)
[dvTP, nCHAN_BTN[20]] = (nINPUT == 9)              // RGB-Video RGsB

[dvTP, nCHAN_BTN[21]] = (nCOLOR_CONTROL == 1)      // TEMP COLOR
[dvTP, nCHAN_BTN[22]] = (nCOLOR_CONTROL == 2)      // RGB COLOR

[dvTP, nCHAN_BTN[23]] = (nCOLOR_MODE == 1)         // sRGB
[dvTP, nCHAN_BTN[24]] = (nCOLOR_MODE == 2)         // NORMAL
[dvTP, nCHAN_BTN[25]] = (nCOLOR_MODE == 3)         // MEETING
[dvTP, nCHAN_BTN[26]] = (nCOLOR_MODE == 4)         // PRESENTATION
[dvTP, nCHAN_BTN[27]] = (nCOLOR_MODE == 5)         // THEATER
[dvTP, nCHAN_BTN[28]] = (nCOLOR_MODE == 6)         // AMUSEMENT

[dvTP, nCHAN_BTN[51]] = (nSCREEN_MUTE == 0)        // BLACK SCREEN
[dvTP, nCHAN_BTN[52]] = (nSCREEN_MUTE == 1)        // BLUE SCREEN
[dvTP, nCHAN_BTN[53]] = (nSCREEN_MUTE == 2)        // LOGO

[dvTP, nCHAN_BTN[71]] = (nVOLUME >= 10)            // VOLUME 10% BUTTON
[dvTP, nCHAN_BTN[72]] = (nVOLUME >= 20)            // VOLUME 20% BUTTON
[dvTP, nCHAN_BTN[73]] = (nVOLUME >= 30)            // VOLUME 30% BUTTON
[dvTP, nCHAN_BTN[74]] = (nVOLUME >= 40)            // VOLUME 40% BUTTON
[dvTP, nCHAN_BTN[75]] = (nVOLUME >= 50)            // VOLUME 50% BUTTON
[dvTP, nCHAN_BTN[76]] = (nVOLUME >= 60)            // VOLUME 60% BUTTON
[dvTP, nCHAN_BTN[77]] = (nVOLUME >= 70)            // VOLUME 70% BUTTON
[dvTP, nCHAN_BTN[78]] = (nVOLUME >= 80)            // VOLUME 80% BUTTON
[dvTP, nCHAN_BTN[79]] = (nVOLUME >= 90)            // VOLUME 90% BUTTON
[dvTP, nCHAN_BTN[80]] = (nVOLUME == 100)           // VOLUME 100% BUTTON
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

