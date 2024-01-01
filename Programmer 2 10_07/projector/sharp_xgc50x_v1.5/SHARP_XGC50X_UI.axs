MODULE_NAME='SHARP_XGC50X_UI'(DEV udvTP,DEV uvdvSHARP_XGC50X,INTEGER SHARP_BUTTONS[])
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 02/26/2003 AT: 15:17:51               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/27/2003 AT: 15:38:39         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 02/26/2003                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*  UI code for the Sharp XGC50X projector.                *)
(*  Cnina - AMX                                            *)
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

VOLATILE INTEGER nSELECTION // 
VOLATILE INTEGER bMUTE // BOOLEAN = MUTE ON/OFF
VOLATILE INTEGER nLAMP_LIFE // STORES THE LAMP LIFE
VOLATILE INTEGER nLAMP // STORES THE LAMP STATE
VOLATILE INTEGER bVIDEO // STORES THE VIDEO VALUE
VOLATILE INTEGER bFREEZE// STORES THE FREEZE VALUE
VOLATILE INTEGER bPOWER // STORES THE POWER VALUE
VOLATILE INTEGER nINPUT // STORES THE INPUT NUMBER RETURNED BY THE COMM

VOLATILE INTEGER bKEYLOCK // STORES THE KEYLOCK VALUE
VOLATILE INTEGER bAUTOPOWER_OFF // STORES THE VALUE OF THE AUTOPOWER_OFF FEATURE
VOLATILE INTEGER nVOLUME // STORES THE API VOLUME PERCENTAGE
VOLATILE INTEGER nREAL_VOLUME // STORES THE REAL VOLUME AS SHOWN ON THE DEVICE
VOLATILE CHAR cCOMMAND_IS[20] // STORES THE COMMAND WE WANT THE TP DATA EVENT TO PROCESS
VOLATILE INTEGER nCONTRAST
VOLATILE INTEGER nTINT
VOLATILE INTEGER nCOLOR
VOLATILE INTEGER nBRIGHTNESS
VOLATILE INTEGER nSHARPNESS
VOLATILE INTEGER nPIP // CYCLES THRU THE DIFFERENT PIP OPTIONS
VOLATILE INTEGER nOSD // CYCLES THRU THE DIFFERENT OSD OPTIONS
VOLATILE INTEGER nBACKGROUND_PIC // TOGGLES THE BACKGROUND PICTURE TO OFF OR SHARP PICTURE
VOLATILE INTEGER nSTARTUP_PIC // TOGGLES THE STARTUP PICTURE TO OFF OR SHARP PICTURE
VOLATILE INTEGER nREVERSE // TOGGLES THE REVERSE MODE ON/OFF
VOLATILE INTEGER nINVERT  // TOGGLES THE INVERT MODE ON/OFF

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
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
nBACKGROUND_PIC=1
nSTARTUP_PIC=1
SEND_COMMAND udvTP,"'@PPK-Wait'"
SEND_COMMAND udvTP,"'@PPK-Select_input'"
SET_PULSE_TIME(10)
(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[udvTP]// sending stuff to the COMM module
{
    STRING:
        {
            REMOVE_STRING(DATA.TEXT,'-',1)
            IF(LENGTH_STRING(DATA.TEXT) && nINPUT)
              SWITCH(cCOMMAND_IS)
              {
               CASE 'TINT':      SEND_COMMAND uvdvSHARP_XGC50X,"'TINT=',ITOA(ATOI(DATA.TEXT)),':',ITOA(nINPUT)"
                                 BREAK
               CASE 'CONTRAST':  SEND_COMMAND uvdvSHARP_XGC50X,"'CONTRAST=',ITOA(ATOI(DATA.TEXT)),':',ITOA(nINPUT)"
                                 BREAK
               CASE 'COLOR':     SEND_COMMAND uvdvSHARP_XGC50X,"'COLOR=',ITOA(ATOI(DATA.TEXT)),':',ITOA(nINPUT)"
                                 BREAK
               CASE 'BRIGHTNESS':SEND_COMMAND uvdvSHARP_XGC50X,"'BRIGHTNESS=',ITOA(ATOI(DATA.TEXT)),':',ITOA(nINPUT)"
                                 BREAK
               CASE 'SHARPNESS': SEND_COMMAND uvdvSHARP_XGC50X,"'SHARPNESS=',ITOA(ATOI(DATA.TEXT)),':',ITOA(nINPUT)"
                                 BREAK
               CASE 'H-POSITION':SEND_COMMAND uvdvSHARP_XGC50X,"'H-POSITION=',ITOA(ATOI(DATA.TEXT))"
                                 BREAK
               CASE 'V-POSITION':SEND_COMMAND uvdvSHARP_XGC50X,"'V-POSITION=',ITOA(ATOI(DATA.TEXT))"
                                 BREAK
               CASE 'KEYSTONE':  SEND_COMMAND uvdvSHARP_XGC50X,"'KEYSTONE=',ITOA(ATOI(DATA.TEXT))"
                                 BREAK
              }
            ELSE IF(LENGTH_STRING(DATA.TEXT) && !nINPUT && bPOWER)
                {
                 SEND_COMMAND udvTP,"'@PPN-Select_input'"
                 SEND_COMMAND udvTP,"'@PPK-Wait'"
                }
        }
}

DATA_EVENT[uvdvSHARP_XGC50X] // events coming from the COMM module
{
    STRING:
        {
            SEND_STRING 0,"'UI RECEIVED FROM COMM : ',DATA.TEXT"
            CANCEL_WAIT 'WAIT FOR COMMAND'
            IF(DATA.TEXT=='ACK' || DATA.TEXT=='NACK')
                {
                 SWITCH(DATA.TEXT)
                 {
                    CASE 'ACK': SEND_COMMAND udvTP,"'@TXT',100,'OK'"
                                BREAK
                    CASE 'NACK':SEND_COMMAND udvTP,"'@TXT',100,'NOT ok'"
                                BREAK
                 }
                
                }
            ELSE
                SEND_COMMAND udvTP,"'@TXT',100,''"// CLEAR OUT
            SEND_COMMAND udvTP,"'@PPK-Wait'"
            SELECT
            {
                ACTIVE(FIND_STRING(DATA.TEXT,'LAMPLIFE=',1)):
                    {
                        nLAMP_LIFE=ATOI(DATA.TEXT)
                        
                        SEND_LEVEL udvTP,SHARP_BUTTONS[93],(nLAMP_LIFE*255/100)
                        SEND_COMMAND udvTP,"'@TXT',SHARP_BUTTONS[80],ITOA(nLAMP_LIFE)"
                    }
                ACTIVE(FIND_STRING(DATA.TEXT,'LAMP=',1)):
                    {
                        nLAMP=ATOI(DATA.TEXT)
                    }
                
                ACTIVE(FIND_STRING(DATA.TEXT,'POWER=',1)):
                    {
                        bPOWER=ATOI(DATA.TEXT)                    
                    }
                
                
                
            }
        }
}
BUTTON_EVENT[udvTP,SHARP_BUTTONS]
{
    PUSH:
        {
           nSELECTION=GET_LAST(SHARP_BUTTONS)
           CANCEL_WAIT 'WAIT FOR COMMAND'
           WAIT 50 'WAIT FOR COMMAND' // POPUP TIME OUT
               SEND_COMMAND udvTP,"'@PPK-Wait'"           
           SWITCH(nSELECTION) // sending stuff to the COMM module
           {
            CASE 42:// POWER OFF
                    SEND_COMMAND uvdvSHARP_XGC50X,"'POWER=0'"
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    
                    //bPOWER=0
                    BREAK
            CASE  2:// POWER ON
                    SEND_COMMAND uvdvSHARP_XGC50X,"'POWER=1'"
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    
                    //bPOWER=1
                    BREAK
            CASE 3: bMUTE=!bMUTE
                    SEND_COMMAND uvdvSHARP_XGC50X,"'MUTE=',ITOA(bMUTE)"
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    BREAK
            CASE 4: bVIDEO=!bVIDEO
                    SEND_COMMAND uvdvSHARP_XGC50X,"'VIDEO=',ITOA(bVIDEO)"
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    BREAK
            CASE 5: SEND_COMMAND udvTP,'@PPK-Image'
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    SEND_COMMAND uvdvSHARP_XGC50X,"'INPUT=1'" // API INPUT 1 = DEVICE INPUT 1
                    nINPUT=1
                    BREAK
            CASE 6: SEND_COMMAND udvTP,'@PPK-Image'
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    SEND_COMMAND uvdvSHARP_XGC50X,"'INPUT=6'" // API INPUT 6 = DEVICE INPUT 2
                    nINPUT=2
                    BREAK
            CASE 7: SEND_COMMAND udvTP,'@PPK-Image'
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    SEND_COMMAND uvdvSHARP_XGC50X,"'INPUT=4'" // API INPUT 4 = DEVICE INPUT 3
                    nINPUT=3
                    BREAK
            CASE 8: SEND_COMMAND udvTP,'@PPK-Image'
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    SEND_COMMAND uvdvSHARP_XGC50X,"'INPUT=2'" // API INPUT 2 = DEVICE INPUT 4
                    nINPUT=4
                    BREAK
            CASE 9: bFREEZE=!bFREEZE
                    SEND_COMMAND uvdvSHARP_XGC50X,"'FREEZE=',ITOA(bFREEZE)"
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    BREAK
            CASE 10:SEND_COMMAND uvdvSHARP_XGC50X,"'AUTO_SYNC=S:1'"// START AUTO SYNC W/ DISPLAY ON
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    PULSE[udvTP,SHARP_BUTTONS[10]]
                    BREAK
           
            
            CASE 16:
            CASE 17:
            CASE 18:
            CASE 19:IF(nINPUT==1 || nINPUT=6) // RGB/COMPONENT INPUTS #1 AND #2 ON DEVICE, #1 AND #6 PER API
                        {
                         SEND_COMMAND uvdvSHARP_XGC50X,"'GAMMA=RGB:',ITOA(nSELECTION-15)"// GAMMA 
                         SEND_COMMAND udvTP,"'@PPN-Wait'"
                        }
                    ELSE IF(nINPUT=2 || nINPUT=4) // VIDEO INPUTS #3 AND #4 ON DEVICE
                        {
                         SEND_COMMAND uvdvSHARP_XGC50X,"'GAMMA=VIDEO:',ITOA(nSELECTION-15)"// GAMMA 
                         SEND_COMMAND udvTP,"'@PPN-Wait'"
                        }
                    ELSE
                        SEND_COMMAND udvTP,"'@PPN-Select_input'"
                    PULSE[udvTP,SHARP_BUTTONS[nSELECTION]]
                    BREAK 
            CASE 20:nPIP++
                    IF(nPIP==5) nPIP=0
                    SEND_COMMAND uvdvSHARP_XGC50X,"'PIP=',ITOA(nPIP)"// PIP
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    PULSE[udvTP,SHARP_BUTTONS[20]]
                    BREAK
                     
            
            CASE 22:SEND_COMMAND udvTP,'AKEYP' // POPUP THE KEYPAD
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    cCOMMAND_IS='CONTRAST'
                    BREAK
            CASE 23:SEND_COMMAND udvTP,'AKEYP' // POPUP THE KEYPAD
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    cCOMMAND_IS='BRIGHTNESS'
                    BREAK
            CASE 24:nOSD++
                    IF(nOSD==3) nOSD=0
                    SEND_COMMAND uvdvSHARP_XGC50X,"'OSD=',ITOA(nOSD)"//OSD 
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    PULSE[udvTP,SHARP_BUTTONS[24]]
                    BREAK
            CASE 25:// NOT USED 
                    BREAK
            CASE 26:SEND_COMMAND udvTP,'AKEYP' // POPUP THE KEYPAD
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    cCOMMAND_IS='COLOR'
                    BREAK
            CASE 27:SEND_COMMAND udvTP,'AKEYP' // POPUP THE KEYPAD
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    cCOMMAND_IS='TINT'
                    BREAK
            CASE 28:SEND_COMMAND udvTP,'AKEYP' // POPUP THE KEYPAD
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    cCOMMAND_IS='SHARPNESS'
                    BREAK 
            
            
            CASE 34:SEND_COMMAND udvTP,'AKEYB' // POPUP THE KEYPAD
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    cCOMMAND_IS='H-POSITION'
                    BREAK
            CASE 35:SEND_COMMAND udvTP,'AKEYB' // POPUP THE KEYPAD
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    cCOMMAND_IS='V-POSITION'
                    BREAK
            
            
            CASE 43:
            CASE 44:
            CASE 45:// AUTO SYNC SETTINGS W/ AUTO SYNC DISPLAY ON
                    SEND_COMMAND uvdvSHARP_XGC50X,"'AUTO_SYNC=',ITOA(nSELECTION-43),':1'"//
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    PULSE[udvTP,SHARP_BUTTONS[nSELECTION]]
                    BREAK
            
            CASE 48:
            CASE 49:
            CASE 50:
            CASE 51:
            CASE 52:
            CASE 53:
            CASE 54:SEND_COMMAND uvdvSHARP_XGC50X,"'VIDEO_SYSTEM=',ITOA(nSELECTION-47)"//
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    BREAK
            CASE 55:IF(nBACKGROUND_PIC=1) 
                            nBACKGROUND_PIC=4
                    ELSE IF(nBACKGROUND_PIC=4) 
                            nBACKGROUND_PIC=1
                    SEND_COMMAND uvdvSHARP_XGC50X,"'BACKGROUND_PIC=',ITOA(nBACKGROUND_PIC)"//
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    PULSE[udvTP,SHARP_BUTTONS[55]]
                    BREAK
            CASE 56:IF(nSTARTUP_PIC=1) 
                           nSTARTUP_PIC=3
                    ELSE IF(nSTARTUP_PIC=3) 
                           nSTARTUP_PIC=1
                    SEND_COMMAND uvdvSHARP_XGC50X,"'STARTUP_PIC=',ITOA(nSTARTUP_PIC)"//
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    PULSE[udvTP,SHARP_BUTTONS[56]]
                    BREAK
            
            
            CASE 58:SEND_COMMAND uvdvSHARP_XGC50X,"'LAMPLIFE?'"
                    SEND_COMMAND uvdvSHARP_XGC50X,"'LAMP?'" 
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    BREAK       
            CASE 59:nREVERSE=!nREVERSE
                    SEND_COMMAND uvdvSHARP_XGC50X,"'PROJ_MODE=R:',ITOA(nREVERSE)"// REVERSE
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    PULSE[udvTP,SHARP_BUTTONS[59]]
                    BREAK 
            CASE 60:nINVERT=!nINVERT
                    SEND_COMMAND uvdvSHARP_XGC50X,"'PROJ_MODE=I:',ITOA(nINVERT)"// INVERT
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    PULSE[udvTP,SHARP_BUTTONS[60]]
                    BREAK
            CASE 61:bKEYLOCK=!bKEYLOCK
                    IF(bKEYLOCK)
                        SEND_COMMAND uvdvSHARP_XGC50X,"'KEYLOCK=0'"// KEY LOCK OFF
                    ELSE
                        SEND_COMMAND uvdvSHARP_XGC50X,"'KEYLOCK=2'"// KEY LOCK LEVEL B
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    BREAK 
            CASE 62://ENGLISH
            CASE 63://GERMAN
                    SEND_COMMAND uvdvSHARP_XGC50X,"'LANGUAGE=',ITOA(nSELECTION-61)"
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    BREAK
            CASE 64:// KEYSTONE
                    SEND_COMMAND udvTP,'AKEYB' // POPUP THE KEYPAD
                    SEND_COMMAND udvTP,"'@PPN-Wait'"
                    cCOMMAND_IS='KEYSTONE'
                    BREAK
       
                               
           }  
        }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

  
// FEEDBACK 
[udvTP,SHARP_BUTTONS[42]]=(bPOWER=0)
[udvTP,SHARP_BUTTONS[2]]=(bPOWER=1)
[udvTP,SHARP_BUTTONS[67]]=(nLAMP=1)// LAMP STATE





(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

