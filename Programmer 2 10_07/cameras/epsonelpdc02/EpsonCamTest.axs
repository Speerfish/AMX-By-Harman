PROGRAM_NAME='EpsonCamTest'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 06/25/2002 AT: 10:58:32               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 07/18/2002 AT: 10:39:21         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 06/25/2002                              *)
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

LogDev = 0  // for logging to terminal

dvCamPort = 5001:1:0      // FIRST NXI SERIAL PORT

vdvCam = 33000:1:0     // Virtual Camera

dvTP     = 128:1:0       // CV10 Touchpanel

DEFINE_MODULE 'EpsonELPDC02' EpsonCam1(dvCamPort,vdvCam)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

INTEGER Cam1 = 1

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

CHAR Cam_String[30]
CHAR Module_Version[4]       //Module version

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

([dvTP,1],[dvTP,2])
([dvTP,4]..[dvTP,6])
([dvTP,7],[dvTP,8])
([dvTP,9]..[dvTP,11])
([dvTP,12]..[dvTP,14])
([dvTP,15]..[dvTP,17])
([dvTP,18]..[dvTP,20])
([dvTP,21],[dvTP,22])
([dvTP,39],[dvTP,40])

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

//####
//# Function : Log(CHAR logBuff[])
//# Purpose  : Logs information out debug port and terminates with CR/LF
//# Params   : logBuff : buffer to be logged
//# Return   : None
//# Notes    : None
//####

DEFINE_FUNCTION Log(CHAR logBuff[])
{
//    IF([vdvCAM,1])
//    {
        IF (LENGTH_STRING(logBuff))
        {
            SEND_STRING LOGDEV, "logBuff, $0D, $0A"
        }
//    }
}



//####
//# Function : LogHex(CHAR prefix[], CHAR logBuff[])
//# Purpose  : Log a hex string as ascii (i.e. 12 = "0B")
//# Params   : prefix : text to prefix output with
//#            buff   : hex string to log
//# Return   : None
//# Notes    : None
//####

DEFINE_FUNCTION LogHex(CHAR prefix[], CHAR buff[])
{
        stack_var CHAR     logBuff[200]
        stack_var INTEGER  i


        logBuff = prefix
        FOR (i = 1; i <= LENGTH_STRING(buff); i++)
        {
            logBuff = "logBuff, FORMAT('%02x', buff[i]), ' '"
        }

        Log(logBuff)
}

DEFINE_FUNCTION Process_cam (CHAR In_string[])  // Feedback from Camera
{
    CHAR In_info[10]
    
    In_info = REMOVE_STRING (In_string,'=',1)
    
    SWITCH (In_info)
    {
        CASE 'ROM=':
        {
            SEND_COMMAND dvTP, "'@TXT',1,MID_STRING(In_string,3,6)"
        }

        CASE 'VERSION=':
        {
            Module_Version = In_string  // Module version info
        }
        
        CASE 'POWER=':        // Camera online status
        {
            [dvTP,18] = ATOI(MID_STRING(In_string,3,1))        // on/off feedback
        }
        
        CASE 'OUTPUT=':        // Video source feedback
        {
            ON[dvTP,15 + ATOI(MID_STRING(In_string,1,1))] 
        }
    
        CASE 'FOCUS=':        // Focus auto/manual feedback
        {
            IF (In_string = '1:AUTO') ON[dvTP,5]
            ELSE OFF[dvTP,5]
        }
        
        CASE 'IRIS=':        // Iris auto/manual feedback
        {
            IF (In_string = '1:AUTO') ON[dvTP,10]
            ELSE OFF[dvTP,10]
        }
    
        CASE 'MODE=':        // Camera video mode?
        {
            ON[dvTP,39 + ATOI(MID_STRING(In_string,3,1))]      // NTSC/PAL feedback
        }
     
        CASE 'LAMP=':        // Camera video mode?
        {
            ON[dvTP,12 + ATOI(MID_STRING(In_string,3,1))]      // Lamp feedback
        }
     
        CASE 'LOCK=':        // Panel lockout?
        {
            ON[dvTP,21 + ATOI(MID_STRING(In_string,3,1))]      // Panel lockout feedback
        }
    }
}


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(* System Information Strings ******************************)
(* Use this section if there is a TP in the System!        *)
(*
    SEND_COMMAND TP,"'!F',250,'1'"
    SEND_COMMAND TP,"'TEXT250-',__NAME__"
    SEND_COMMAND TP,"'!F',251,'1'"
    SEND_COMMAND TP,"'TEXT251-',__FILE__,', ',S_DATE,', ',S_TIME"
    SEND_COMMAND TP,"'!F',252,'1'"
    SEND_COMMAND TP,"'TEXT252-',__VERSION__"
    SEND_COMMAND TP,"'!F',253,'1'"
    (* Must fill this (Master Ver) *)
    SEND_COMMAND TP,'TEXT253-'
    SEND_COMMAND TP,"'!F',254,'1'"
    (* Must fill this (Panel File) *)
    SEND_COMMAND TP,'TEXT254-'
    SEND_COMMAND TP,"'!F',255,'1'"
    (* Must fill this (Dealer Info) *)
    SEND_COMMAND TP,'TEXT255-'
*)

SEND_COMMAND dvTP, '@PPN-Camera'        // Turn on Camera popup & button
ON[dvTP,1]

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvCAM]      // Feedback from camera module
{
    STRING:
    {
        Cam_string = data.text
        SEND_COMMAND dvTP, "'@TXT',2,Cam_string"        // Echo to TP
        Process_cam(Cam_string)
    }
}

BUTTON_EVENT[dvTP,1]    // popup controls
BUTTON_EVENT[dvTP,2]
{
    PUSH:
    {
        ON[dvTP,BUTTON.INPUT.CHANNEL]
    }
}

BUTTON_EVENT[dvTP,3]
{
    PUSH:
    {
         Pulse[dvTP,3]
         SEND_COMMAND vdvCam, "'ROM?'"
    }
}

BUTTON_EVENT[dvTP,7]    // Zoom controls
BUTTON_EVENT[dvTP,8]
{
    PUSH:
    {
        ON[dvTP,BUTTON.INPUT.CHANNEL]
        IF (BUTTON.INPUT.CHANNEL=7)
            SEND_COMMAND vdvCam, "'ZOOM=1:-'"
        Else SEND_COMMAND vdvCam, "'ZOOM=1:+'"
    }
    
    Release:
    {
        OFF[dvTP,BUTTON.INPUT.CHANNEL]
        SEND_COMMAND vdvCam, "'ZOOM=1:S'"
    }
}

BUTTON_EVENT[dvTP,9]    // Iris Close/Open Controls
BUTTON_EVENT[dvTP,11]
{
    PUSH:
    {
        ON[dvTP,BUTTON.INPUT.CHANNEL]
        IF (BUTTON.INPUT.CHANNEL=9)
            SEND_COMMAND vdvCam, "'IRIS=1:-'"
        Else SEND_COMMAND vdvCam, "'IRIS=1:+'"
    }
    
    Release:
    {
        OFF[dvTP,BUTTON.INPUT.CHANNEL]
        SEND_COMMAND vdvCam, "'IRIS=1:S'"
    }
}

BUTTON_EVENT[dvTP,10]   // Auto Iris; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'IRIS=1:AUTO'"
    }    
}

BUTTON_EVENT[dvTP,4]    // Focus Near/Far Controls
BUTTON_EVENT[dvTP,6]
{
    PUSH:
    {
        ON[dvTP,BUTTON.INPUT.CHANNEL]
        IF (BUTTON.INPUT.CHANNEL=4)
            SEND_COMMAND vdvCam, "'FOCUS=1:-'"
        Else SEND_COMMAND vdvCam, "'FOCUS=1:+'"
    }
    
    RELEASE:
    {
        OFF[dvTP,BUTTON.INPUT.CHANNEL]
        SEND_COMMAND vdvCam, "'FOCUS=1:S'"
    }

}

BUTTON_EVENT[dvTP,5]   // Auto focus; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'FOCUS=1:AUTO'"
    }    
}

BUTTON_EVENT[dvTP,12]       // Lamp selection
BUTTON_EVENT[dvTP,13]       // Get feedback from camera
BUTTON_EVENT[dvTP,14]
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'LAMP=1:',ITOA(BUTTON.INPUT.CHANNEL-12)"
    }
}

BUTTON_EVENT[dvTP,15]       // Video input selection
BUTTON_EVENT[dvTP,16]       // Feedback supplied from camera module
BUTTON_EVENT[dvTP,17]
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'OUTPUT=1:',ITOA(BUTTON.INPUT.CHANNEL-15)"
    }
}

BUTTON_EVENT[dvTP,21]       // Front Panel lockout
BUTTON_EVENT[dvTP,22]       // Get feedback from camera
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'LOCK=1:',ITOA(BUTTON.INPUT.CHANNEL-21)"
    }
}

BUTTON_EVENT[dvTP,31]       // Video RGB display size & position
BUTTON_EVENT[dvTP,32]
BUTTON_EVENT[dvTP,33]
BUTTON_EVENT[dvTP,34]
BUTTON_EVENT[dvTP,35]
BUTTON_EVENT[dvTP,36]
BUTTON_EVENT[dvTP,37]
BUTTON_EVENT[dvTP,38]
{
    PUSH:
    {
        ON[dvTP,BUTTON.INPUT.CHANNEL]
        SEND_COMMAND vdvCam, "'POSIT=1:',ITOA(BUTTON.INPUT.CHANNEL-30)"
    }
    
    Release:
    {
        OFF[dvTP,BUTTON.INPUT.CHANNEL]
        SEND_COMMAND vdvCam, 'POSIT=1:0'
    }
}

BUTTON_EVENT[dvTP,39]       // Video NTSC/PAL
BUTTON_EVENT[dvTP,40]       // Get feedback from camera
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'MODE=1:',ITOA(BUTTON.INPUT.CHANNEL-39)"
    }
}

BUTTON_EVENT[dvTP,101]   // Auto focus; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'LAMP?'"
    }    
}

BUTTON_EVENT[dvTP,102]   // Auto focus; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'POWER?'"
    }    
}

BUTTON_EVENT[dvTP,103]   // Auto focus; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'VERSION?'"
    }    
}

BUTTON_EVENT[dvTP,104]   // Auto focus; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'OUTPUT?'"
    }    
}

BUTTON_EVENT[dvTP,105]   // Auto focus; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'FOCUS?'"
    }    
}

BUTTON_EVENT[dvTP,106]   // Auto focus; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'IRIS?'"
    }    
}

BUTTON_EVENT[dvTP,107]   // Auto focus; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'MODE?'"
    }    
}

BUTTON_EVENT[dvTP,108]   // Auto focus; get feedback from module
{
    PUSH:
    {
        SEND_COMMAND vdvCam, "'LOCK?'"
    }    
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

