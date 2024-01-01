MODULE_NAME='ALTINEX_MULTITASKER_UI' (DEV uvdvALTINEX_MULTITASKER, DEV udvTP, INTEGER nBUTTONS[])

(********************************************************************)
(* FILE CREATED ON: 09/08/03  AT: 14:54:46                          *)
(********************************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER MAX_SLOTS=19         // maximum number of card slots available on the MT100-100 card frame
VOLATILE INTEGER MAX_LABEL_LENGTH=20  // maximum length of a card's label
VOLATILE INTEGER MAX_TYPE_LENGTH =40  // maximum length of a card's firmware and type name
VOLATILE CHAR    EMPTY[5]='EMPTY'
VOLATILE INTEGER MAX_SOURCES=8        // stores the maximum number of inputs/outputs the comm module supports
VOLATILE INTEGER MAX_UNIT_ID=9        // stores the maximum Unit id number one unit can have
(********************************************************************)
DEFINE_VARIABLE

VOLATILE INTEGER UNIT_ID=0            // stores the Unit Id of the card frame we are controlling. Valid values are from 0..9. This UI supports unit id 0. 

VOLATILE CHAR cCARD_LABEL[MAX_SLOTS][MAX_LABEL_LENGTH] // define a two dimensional array to hold each card's label
VOLATILE CHAR cCARD_TYPE[MAX_SLOTS][MAX_TYPE_LENGTH]   // define a two dimensionala array to hold each card's firmware and type name
VOLATILE CHAR cSET_PATH[70]=''                         // stores the paths set by the user. Must use the Switch command to actually switch.
VOLATILE CHAR cPRINT_PATH[100]=''                       // prints to the text box the Path set by the user
VOLATILE INTEGER nCOUNTER=0
VOLATILE INTEGER bCARD_FLAG[MAX_SLOTS]                 // define an array to hold the card# selected to be grouped; 0=NOT SELECTED  1=SELECTED
VOLATILE INTEGER nSELECTION                            // stores the number/index of the button pressed by the user
VOLATILE CHAR    cADJUST[11]=''                        // stores a command name the TP string event will use to determine for who the adjustments are made. Internal tracking only.
VOLATILE INTEGER nINPUT      =0                        // stores the input# we are using to switch
VOLATILE INTEGER nOUTPUT     =0                        // stores the output# we are using to switch
VOLATILE INTEGER nSOURCE=0                             // stores the number of the source that will be used in the Path
VOLATILE INTEGER nENABLE_SOURCE=0                      // stores the number of the source that will be enabled or disabled on the Enable page
VOLATILE INTEGER nCARD_USED  =1                        // stores the number of the card we are currently using (values are 1..19)
VOLATILE CHAR  MESSAGE[7]='UNIT #'
VOLATILE CHAR cSWITCH_MESSAGE[100]=''                  // stores the input connection status on Main page
VOLATILE INTEGER nPOSITION   =1                        // stores the position number at which we can print the next firmware version information on the Setup screen
VOLATILE INTEGER nGROUP      =1                        // stores the group number 
VOLATILE INTEGER nCLEAR_GROUP=1                        // stores the group number to clear
VOLATILE CHAR cSTRING_BUFFER[50]                       // stores the cards that are part of a specific group
VOLATILE CHAR cENABLED_SOURCES[50]                     // stores the sources that are enabled 
VOLATILE INTEGER nTEMP_UNIT_ID=0                       // stores a temporary unit id untill the user confirms the change by pressing OK on the popup
VOLATILE INTEGER bNEXT=1                               // used only by Enable, Disable buttons. Allows for some time to pass before Enable or Disable can be pushed again
(********************************************************************)
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
// This function sends the path info to the communication module. It takes as parameter the new path
// in the format 'C#:i>o ' (where # is the card number, i=input number, o=output number followed by space; example: 'C1:1>2 ') 
DEFINE_FUNCTION fnUPDATE_PATH(CHAR cPATH[70])
{
    STACK_VAR INTEGER nSOURCE,nCARD
    STACK_VAR CHAR cTEMP[70]
    cTEMP=cPATH
    WHILE(LENGTH_STRING(cTEMP))
    {
        nCARD=ATOI(cTEMP)
        REMOVE_STRING(cTEMP,':',1)
        nSOURCE=ATOI(cTEMP)
        REMOVE_STRING(cTEMP,' ',1)// remove the space at the end
        IF(cCARD_LABEL[nCARD]<>'MT104-107')
            SEND_COMMAND uvdvALTINEX_MULTITASKER,"'PATH=',ITOA(nSOURCE),':*:',ITOA(nCARD),':',ITOA(UNIT_ID)"
        ELSE // MUST BE MT104-107 - SET A PATH FOR THE SVIDEO SOURCES. ADDITIONAL CODE CAN BE ADDED TO SUPPORT COMPOSITE ASWELL
            SEND_COMMAND uvdvALTINEX_MULTITASKER,"'PATH=',ITOA(nSOURCE),':S:',ITOA(nCARD),':',ITOA(UNIT_ID)"
       
    }      
} 
// THIS FUNCTION UPDATES THE TEXT BOX FOR THE FIRMARE VERSION AND CARD TYPE ON THE SETUP SCREEN
// IT ALSO UPDATES THE LABELS WITH DEFAULT VALUES
DEFINE_FUNCTION fnUPDATE_FIRMWARE(INTEGER nINDEX)
{
    IF(nPOSITION<=14)
        {
            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[90+nPOSITION],cCARD_TYPE[nINDEX]" 
            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[40+nPOSITION],cCARD_LABEL[nINDEX]" 
        }     
    nPOSITION++
    
}
DEFINE_FUNCTION fnCLEAR_TEXT_BOXES()
{
    FOR(nCOUNTER=1;nCOUNTER<=35;nCOUNTER++)
        {
            SEND_COMMAND udvTP,"'!T',nBUTTONS[75+nCOUNTER],''"
        }
    FOR(nCOUNTER=1;nCOUNTER<=MAX_SLOTS;nCOUNTER++)
        {
            SEND_COMMAND udvTP,"'!T',nBUTTONS[40+nCOUNTER],''"
        }   
}
(********************************************************************)
DEFINE_START



(********************************************************************)
DEFINE_EVENT

DATA_EVENT[uvdvALTINEX_MULTITASKER] // INCOMING STUFF FROM THE COMMUNICATION MODULE
{

    STRING:
        {
          SEND_STRING 0,"'UI RECEIVED FROM COMM:',DATA.TEXT"
          IF(FIND_STRING(DATA.TEXT,'=',1) && !FIND_STRING(DATA.TEXT,'VERSION',1) && !FIND_STRING(DATA.TEXT,'DEBUG',1))
            ON[udvTP,40] // TURN ON THE ONLINE INDICATOR
          SWITCH(REMOVE_STRING(DATA.TEXT,'=',1))
          {
            CASE 'SWITCH=':
                {
                    STACK_VAR INTEGER nIN,nOUT,nSTAT
                    REMOVE_STRING(DATA.TEXT,':',1)// REMOVE THE LEVEL PARAMETER - NOT USED
                    nIN=ATOI(DATA.TEXT)
                    REMOVE_STRING(DATA.TEXT,':',1)
                    nOUT=ATOI(DATA.TEXT)
                    REMOVE_STRING(DATA.TEXT,':',1)
                    nSTAT=ATOI(DATA.TEXT) // THIS TELLS US IF THE SOURCE IS ENABLED OR DISABLED
                    IF(nSTAT)
                        cSWITCH_MESSAGE="cSWITCH_MESSAGE,ITOA(nIN),'>',ITOA(nOUT),':ON  '"
                    ELSE
                        cSWITCH_MESSAGE="cSWITCH_MESSAGE,ITOA(nIN),'>',ITOA(nOUT),':OFF  '"
                    SEND_COMMAND udvTP,"'!T',nBUTTONS[81],cSWITCH_MESSAGE" 
                }
                BREAK
            CASE 'ENABLE_SOURCE=':
                {
                    cENABLED_SOURCES="cENABLED_SOURCES,ITOA(ATOI(DATA.TEXT)),', '"  
                    SEND_COMMAND udvTP,"'!T',nBUTTONS[87],cENABLED_SOURCES"     
                }
                BREAK
            CASE 'FIRMWARE=':
                {
                    STACK_VAR INTEGER nCARD_NUMBER
                    IF(FIND_STRING(DATA.TEXT,'C',1))
                    {nCARD_NUMBER=ATOI(RIGHT_STRING(DATA.TEXT,3))
                     cCARD_TYPE[nCARD_NUMBER]=DATA.TEXT
                     cCARD_LABEL[nCARD_NUMBER]=REMOVE_STRING(DATA.TEXT,'VER',1)
                     SET_LENGTH_STRING(cCARD_LABEL[nCARD_NUMBER],LENGTH_STRING(cCARD_LABEL[nCARD_NUMBER])-4)
                     fnUPDATE_FIRMWARE(nCARD_NUMBER)
                    }
                }
                BREAK
            CASE 'GROUP=':// GROUP MEMBERSHIP REPLY
                {
                    cSTRING_BUFFER="cSTRING_BUFFER,ITOA(ATOI(DATA.TEXT)),','" 
                    IF(LENGTH_STRING(cSTRING_BUFFER)%18==0 || LENGTH_STRING(cSTRING_BUFFER)%19==0 || LENGTH_STRING(cSTRING_BUFFER)%20==0)
                        cSTRING_BUFFER="cSTRING_BUFFER,13" 
                    SEND_COMMAND udvTP,"'@TXT',nBUTTONS[84],cSTRING_BUFFER"   
                }
          }
          IF(FIND_STRING(DATA.TEXT,'OK',1))
          {
            IF(nSELECTION==34)
                {cPRINT_PATH="cPRINT_PATH,cSET_PATH"
                 SEND_COMMAND udvTP,"'!T',nBUTTONS[89],cPRINT_PATH" 
                 IF(LENGTH_STRING(cPRINT_PATH)>=5)
                    SEND_COMMAND udvTP,"'@PPK-Mask'"
                }
            SEND_COMMAND udvTP,'@PPN-Done'
          }
        }

}
DATA_EVENT[udvTP] // STUFF FROM THE TOUCH PANEL
{
    ONLINE:
        {
            SEND_COMMAND udvTP,'@PPX' // Close all popups
            fnCLEAR_TEXT_BOXES()
            MESSAGE="MESSAGE,ITOA(UNIT_ID)"
            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[76],MESSAGE" // update the Unit id text box
            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[77],ITOA(nCARD_USED)" // update the card # text box
            SEND_COMMAND udvTP,"'!T',nBUTTONS[110],ITOA(UNIT_ID)" 
            FOR(nCOUNTER=1;nCOUNTER<=MAX_SLOTS;nCOUNTER++)
               {
                cCARD_LABEL[nCOUNTER]=EMPTY 
                cCARD_TYPE[nCOUNTER]=''
               }
        }
    STRING: // 
        {
            REMOVE_STRING(DATA.TEXT,'-',1)
            SWITCH(cADJUST)
            {
                CASE 'CARD#':// we are setting the card # to use
                    {
                        IF(ATOI(DATA.TEXT) && ATOI(DATA.TEXT)<=MAX_SLOTS)
                        {
                            nCARD_USED=ATOI(DATA.TEXT)// store the card#
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[77],ITOA(nCARD_USED)" // update the card # text box    
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[86],cCARD_LABEL[nCARD_USED]" 
                        }
                        cADJUST=''
                    }
                    BREAK
                CASE 'GROUPING':// We are grouping several cards 
                    {
                        IF(ATOI(DATA.TEXT) && ATOI(DATA.TEXT)<=9) // MAX OF 9 GROUPS ARE AVAILABLE
                        {
                            nGROUP=ATOI(DATA.TEXT)// store the GROUP#
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[82],ITOA(nGROUP)" // update the GROUP # text box    
                            
                        }
                        cADJUST=''   
                    }
                    BREAK
                CASE 'GROUP CLEAR'://We are clearing a group
                    {
                       IF(ATOI(DATA.TEXT) && ATOI(DATA.TEXT)<=9) // MAX OF 9 GROUPS ARE AVAILABLE
                        {
                            nCLEAR_GROUP=ATOI(DATA.TEXT)// store the GROUP# TO CLEAR
                            cSTRING_BUFFER=''
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[83],ITOA(nCLEAR_GROUP)" // update the GROUP # TO CLEAR text box    
                            SEND_COMMAND uvdvALTINEX_MULTITASKER,"'GROUP?',ITOA(nCLEAR_GROUP),':',ITOA(UNIT_ID)"// QUERY THE CURRENT MEMBERSHIP
                        }
                        cADJUST=''  
                    }
                    BREAK
                
                CASE 'INPUT#':// we are using input# (used on Main page)
                    {
                        IF(ATOI(DATA.TEXT)<=MAX_SOURCES && nCARD_USED)
                        {
                            nINPUT=ATOI(DATA.TEXT)
                            cSWITCH_MESSAGE=''// RESET
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[81],''"// RESET
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[79],ITOA(nINPUT)" // update the input# text box on Main page
                            SEND_COMMAND uvdvALTINEX_MULTITASKER,"'SWITCH?I:',ITOA(nINPUT),':',ITOA(nCARD_USED)"// QUERY THE SWITCH STATUS FOR THE INPUT
                            cENABLED_SOURCES=''
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[87],cENABLED_SOURCES"// RESET THE ENABLED SOURCES TEXT BOX AND BUFFER
                        }
                        cADJUST=''    
                    }
                    BREAK
                CASE 'OUTPUT#':// we are using output# (used on Main page)
                    {
                        IF(ATOI(DATA.TEXT)<=MAX_SOURCES && nCARD_USED)
                        {
                            nOUTPUT=ATOI(DATA.TEXT)
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[80],ITOA(nOUTPUT)" // update the output# text box on Main page
                        }
                        cADJUST=''    
                    }
                    BREAK
                CASE 'PATH': // we are setting the source for the path
                    {
                        IF(ATOI(DATA.TEXT)<=MAX_SOURCES && nCARD_USED)
                        {
                            nSOURCE=ATOI(DATA.TEXT)
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[88],ITOA(nSOURCE)"
                        }
                        cADJUST=''
                    }
                    BREAK
                CASE 'SOURCE': // WE ARE GETTING THE SOURCE# TO ENABLE/DISABLE
                    {
                        IF(ATOI(DATA.TEXT)<=MAX_SOURCES && nCARD_USED)
                        {
                            nENABLE_SOURCE=ATOI(DATA.TEXT)
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[85],ITOA(nENABLE_SOURCE)"  
                            
                        }
                        cADJUST=''
                    }
                    BREAK 
                CASE 'UNITID':// WE ARE SETTING THE UNIT ID 
                    {
                        IF(ATOI(DATA.TEXT)>=0 && ATOI(DATA.TEXT)<=MAX_UNIT_ID)
                        {
                            nTEMP_UNIT_ID=ATOI(DATA.TEXT)
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[110],ITOA(nTEMP_UNIT_ID)" 
                            
                        }
                        cADJUST=''
                    }
            }
              
        }
}
BUTTON_EVENT[udvTP,nBUTTONS]
{

    PUSH:
         {
            nSELECTION=GET_LAST(nBUTTONS)
            IF(nSELECTION>=11 && nSELECTION<=29) // If Card# buttons pressed on the Grouping page
            {
                bCARD_FLAG[nSELECTION-10]=!bCARD_FLAG[nSELECTION-10]
                [udvTP,nBUTTONS[nSELECTION]]=bCARD_FLAG[nSELECTION-10] // Feedback stuff
            }  
            
            ELSE
            {
                SWITCH(nSELECTION)
                {
                    
                    CASE 1: // Card# button on Main page
                    CASE 30:// Card# button on Set Path page
                        {
                            cADJUST='CARD#' // Setting the card number
                            SEND_COMMAND udvTP,"'AKEYP'"    
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[79],''"// CLEAR THE INPUT TEXT BOX
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[80],''"// CLEAR THE OUTPUT TEXT BOX
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[81],''"// CLEAR THE SWITCH STATUS ON MAIN PAGE
                            nINPUT=0
                            nOUTPUT=0
                            cSWITCH_MESSAGE=''// RESET
                            cENABLED_SOURCES=''
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[87],cENABLED_SOURCES"  // CLEAR THE ENABLED SOURCES
                        }
                        BREAK
                    CASE 2: // INPUT# button on Main page
                        {
                            cADJUST='INPUT#' // Setting the input number
                            SEND_COMMAND udvTP,"'AKEYP'" 
                        }
                        BREAK    
                    CASE 3: // OUTPUT# button on Main page
                        {
                            cADJUST='OUTPUT#' // Setting the input number
                            SEND_COMMAND udvTP,"'AKEYP'" 
                        }
                        BREAK
                    CASE 4: // SWITCH ON MAIN PAGE
                        {
                            IF(nINPUT && nOUTPUT)
                                SEND_COMMAND uvdvALTINEX_MULTITASKER,"'SWITCH=0:',ITOA(nINPUT),':',ITOA(nOUTPUT),':C:',ITOA(nCARD_USED),':',ITOA(UNIT_ID)"
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[79],''"// CLEAR THE INPUT TEXT BOX
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[80],''"// CLEAR THE OUTPUT TEXT BOX
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[81],''"// CLEAR THE SWITCH STATUS ON MAIN PAGE
                            cSWITCH_MESSAGE=''// RESET
                            
                        }
                        BREAK
                    CASE 5:// GROUP BUTTON ON GROUPING PAGE
                        {
                            cADJUST='GROUPING' // Setting the input number
                            SEND_COMMAND udvTP,"'AKEYP'"    
                        }
                        BREAK
                    CASE 6:// GO BUTTON ON GROUPING PAGE
                        {
                            STACK_VAR CHAR cTEMP[60]
                            FOR(nCOUNTER=1;nCOUNTER<=MAX_SLOTS;nCOUNTER++)
                                IF(bCARD_FLAG[nCOUNTER]) cTEMP="cTEMP,ITOA(nCOUNTER),':'"
                            SEND_COMMAND uvdvALTINEX_MULTITASKER,"'GROUP=',cTEMP,ITOA(nGROUP),':',ITOA(UNIT_ID)"
                            FOR(nCOUNTER=1;nCOUNTER<=MAX_SLOTS;nCOUNTER++)
                                {
                                    bCARD_FLAG[nCOUNTER]=0
                                    [udvTP,nBUTTONS[nCOUNTER+10]]=bCARD_FLAG[nCOUNTER] // Feedback stuff
                                }
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[84],''" 
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[83],''" 
                        }
                        BREAK
                    CASE 7:// GROUP BUTTON ON GROUPING PAGE (clear group)
                        {
                            cADJUST='GROUP CLEAR' // Setting the input number
                            SEND_COMMAND udvTP,"'AKEYP'"    
                        }
                        BREAK
                    CASE 8:// CLEAR GROUP
                        {
                            SEND_COMMAND uvdvALTINEX_MULTITASKER,"'CLEAR_GROUP=',ITOA(nCLEAR_GROUP),':',ITOA(UNIT_ID)"
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[83],''"
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[84],''"
                        }
                        BREAK
                    CASE 32: // Source# button on Set Path page
                        {
                            cADJUST='PATH' // Setting the source number for the path
                            SEND_COMMAND udvTP,"'AKEYP'"   
                        }
                        BREAK
                    
                    CASE 34: // Go button on Set Path page
                        {
                          IF(nSOURCE)  
                            {
                             cSET_PATH="'C',ITOA(nCARD_USED),':',ITOA(nSOURCE),' '"
                             fnUPDATE_PATH(cSET_PATH) // this function sends the path info to the comm
                            }
                            nSOURCE=0
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[88],''"
                            
                            
                        }
                        BREAK
                    CASE 35:// SWITCH BUTTON ON SET PATH PAGE
                        {
                            cPRINT_PATH=''// CLEAR THE SET PATH PAGE TEXT BOX
                            cSET_PATH=''
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[89],''" 
                            SEND_COMMAND uvdvALTINEX_MULTITASKER,'SWITCH'
                            SEND_COMMAND udvTP,"'@PPN-Mask'"
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[81],''"// CLEAR THE SWITCH STATUS TEXT BOX ON THE MAIN PAGE
                        }
                        BREAK
                    CASE 37:// UNIT ID BUTTON ON POPUP
                        {
                            cADJUST='UNITID' // SETTING THE UNIT ID ON POPUP
                            SEND_COMMAND udvTP,"'AKEYP'"   
                        }
                        BREAK
                    CASE 38: // OK TO CHANGE THE UNIT ID
                        {
                            IF(nTEMP_UNIT_ID<=MAX_UNIT_ID)  
                               {
                                SEND_COMMAND uvdvALTINEX_MULTITASKER,"'SET_ID=',ITOA(nTEMP_UNIT_ID)" 
                                UNIT_ID=nTEMP_UNIT_ID
                               }
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[110],ITOA(UNIT_ID)" 
                            MESSAGE='UNIT #'
                            MESSAGE="MESSAGE,ITOA(UNIT_ID)"
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[76],MESSAGE" // update the Unit id text box
                            nTEMP_UNIT_ID=0
                        }
                        BREAK
                    CASE 39:// CANCEL THE CHANGE OF THE UNIT ID
                        {
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[110],ITOA(UNIT_ID)" 
                            nTEMP_UNIT_ID=0   
                        }
                        BREAK    
                    CASE 60:// REFRESH BUTTON ON SETUP PAGE
                        {
                            nPOSITION=1
                            FOR(nCOUNTER=1;nCOUNTER<=MAX_SLOTS;nCOUNTER++)
                                {
                                    cCARD_LABEL[nCOUNTER]=EMPTY 
                                    cCARD_TYPE[nCOUNTER]=''
                                    SEND_COMMAND udvTP,"'!T',nBUTTONS[40+nCOUNTER],''"
                                    SEND_COMMAND udvTP,"'!T',nBUTTONS[90+nCOUNTER],''"
                                }
                            FOR(nCOUNTER=1;nCOUNTER<=MAX_SLOTS;nCOUNTER++)
                                SEND_COMMAND uvdvALTINEX_MULTITASKER,"'FIRMWARE?',ITOA(nCOUNTER),':',ITOA(UNIT_ID)"
                        }
                        BREAK
                    CASE 61: // Set Paths button on Main page
                        {
                            IF(LENGTH_STRING(cPRINT_PATH)<5)
                                SEND_COMMAND udvTP,"'@PPN-Mask'"
                            ELSE
                                SEND_COMMAND udvTP,"'@PPK-Mask'"
                        }
                        BREAK
                    CASE 62: // CLOSE BUTTON ON SET PATH PAGE
                             SEND_COMMAND udvTP,"'@PPK-Mask'"
                        BREAK
                    CASE 63: // SOURCE# BUTTON ON ENABLE PAGE
                        {
                            cADJUST='SOURCE' // Getting the source number on the Enable page
                            SEND_COMMAND udvTP,"'AKEYP'"      
                        }
                    CASE 64:// ENABLE BUTTON ON ENABLE PAGE
                        {
                          IF(bNEXT)  
                           {bNEXT=0
                            cSWITCH_MESSAGE=''// RESET
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[81],''"// RESET THE MAIN PAGE 
                            cENABLED_SOURCES=''
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[87],cENABLED_SOURCES"
                            IF(FIND_STRING(cCARD_TYPE[nCARD_USED],'MT???.???',1))// IF MT108-107 CARD
                                SEND_COMMAND uvdvALTINEX_MULTITASKER,"'SELECT=',ITOA(nENABLE_SOURCE),':C:',ITOA(nCARD_USED),':',ITOA(UNIT_ID)"   
                            ELSE // REST OF CARDS (EXCEPT MT104-107 AND MT106-102)
                                SEND_COMMAND uvdvALTINEX_MULTITASKER,"'ENABLE_SOURCE=',ITOA(nENABLE_SOURCE),':C:',ITOA(nCARD_USED),':',ITOA(UNIT_ID)"   
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[85],''" // CLEAR THE SOURCE SELECTED
                            nENABLE_SOURCE=0
                            WAIT 20
                                bNEXT=1
                           } 
                            
                        }
                        BREAK
                    CASE 65:// DISABLE BUTTON ON ENABLE PAGE
                        {
                          IF(bNEXT) 
                           {bNEXT=0
                            cSWITCH_MESSAGE=''// RESET
                            SEND_COMMAND udvTP,"'@TXT',nBUTTONS[81],''"// RESET THE MAIN PAGE
                            cENABLED_SOURCES=''
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[87],cENABLED_SOURCES"  
                            IF(FIND_STRING(cCARD_TYPE[nCARD_USED],'MT???.???',1))// IF MT108.107 CARD
                                SEND_COMMAND uvdvALTINEX_MULTITASKER,"'SELECT=0:C:',ITOA(nCARD_USED),':',ITOA(UNIT_ID)"   
                            ELSE // REST OF CARDS (EXCEPT MT104-107)
                                SEND_COMMAND uvdvALTINEX_MULTITASKER,"'DISABLE_SOURCE=',ITOA(nENABLE_SOURCE),':C:',ITOA(nCARD_USED),':',ITOA(UNIT_ID)"   
                            SEND_COMMAND udvTP,"'!T',nBUTTONS[85],''" // CLEAR THE SOURCE SELECTED
                            nENABLE_SOURCE=0  
                            WAIT 20
                                bNEXT=1
                           }
                        }
                        BREAK
                }
            }
               
         }


}

DEFINE_PROGRAM

