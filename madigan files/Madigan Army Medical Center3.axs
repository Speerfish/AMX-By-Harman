PROGRAM_NAME='Madigan Army Medical Center'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(*  Speerfish
    www.speerfish.net
    Programmed by Armin 
    armin@speerfish.net *)
(***********************************************************)
(*  MASTER IP:   192.168.1.10        *) 
(*  LC NXD-CV5 IP:  192.168.1.101    *)
(*  SC NXD-CV5 IP:  192.168.1.102    *)

DEFINE_DEVICE
dvTp_Large_Conf		=	 10001: 1:0
dvTp_Small_Conf		=	 10002: 2:0

dvProjLargeConf 	=  	 5001: 1:0  // Christie LX 500
dvProjSmallConf 	=  	 5001: 2:0  // Christie LX 500
LCDALargeConf   	=  	 5001: 3:0  // Sharp Aquos LC-65D64U
LCDBLargeConf   	=  	 5001: 4:0  // Sharp Aquos LC-65D64U
dvLCDSmallConf  	=  	 5001: 5:0  // Sharp Aquos LC-65D64U
dvNexia			=  	 5001: 6:0  // Biamp Nexia CS
dvRGBSwitcher		=	 5001: 7:0  // Autopatch Precis LT
dvRelay			=	 5001: 8:0  // RELAY 1 - SURGE-X ON  RELAY 2 - SURGE-X OFF
dvVIDSwitcher   	=        5001: 9:0  // Autopatch Precis LT

DEFINE_CONSTANT
DEFINE_VARIABLE

DEFINE_START
send_command dvVIDSwitcher,		"'SET MODE DATA'"
send_command LCDALargeConf,		"'SET BAUD 9600,N,8,1 485 DISABLE HSOFF'"
send_command LCDBLargeConf,		"'SET BAUD 9600,N,8,1 485 DISABLE HSOFF'"
send_command dvRGBSwitcher,		"'SET BAUD 9600,N,8,1 485 DISABLE HSOFF'"
send_command dvVIDSwitcher,		"'SET BAUD 9600,N,8,1 485 DISABLE HSOFF'"
send_command dvLCDSmallConf,		"'SET BAUD 9600,N,8,1 485 DISABLE HSOFF'"
send_command dvProjLargeConf,		"'SET BAUD 19200,N,8,1 485 DISABLE HSOFF'"
send_command dvProjSmallConf,		"'SET BAUD 19200,N,8,1 485 DISABLE HSOFF'"
send_command dvNexia,			"'SET BAUD 38400,N,8,1 485 DISABLE HSOFF'"

DEFINE_EVENT
button_event[dvTp_Large_Conf,1]  // Power On
{
    push:
    {
	PULSE[dvRelay,1]
	SEND_STRING dvNexia, "'RECALL 1 PRESET 1001',$0D"
	WAIT 10
	SEND_STRING dvNexia,"'SET 1 FDRLVL 24 1 3',$0D"
	WAIT 10
	SEND_STRING dvNexia,"'SET 1 FDRLVL 17 1 3',$0D"
    }
}
button_event[dvTp_Large_Conf,2]  // Power Off
{
    push:
    {
	send_string LCDALargeConf,"'POWR0   ',$0D"
	send_string LCDBLargeConf,"'POWR0   ',$0D"
	send_string dvProjLargeConf,"'C01',$0D"
	SEND_STRING dvVIDSwitcher,"'DL1 2O1 3:4T'"
	SEND_STRING dvRGBSwitcher,"'DL1 201 3:4T'"
	SEND_STRING dvNexia, "'RECALL 1 PRESET 1003',$0D"
	wait 5
	send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	wait 5
	send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	wait 5
	send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	wait 5
	send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	PULSE[dvRelay,2]
    }
}
button_event[dvTp_Large_Conf,3]
button_event[dvTp_Large_Conf,4]
button_event[dvTp_Large_Conf,5]
button_event[dvTp_Large_Conf,6]
button_event[dvTp_Large_Conf,7] // Cart DVD Front
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 3):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I1O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 4):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 5):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I1O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 6):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 7):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C23',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I1O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,9]
button_event[dvTp_Large_Conf,10] // combine - divide
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 9):
	    {
	    SEND_COMMAND dvTp_Small_Conf,"'PAGE-Combined'"
	    SEND_STRING dvNexia,"'SET 1 FDRLVL 24 1 3',$0D"
	    WAIT 5
	    SEND_STRING dvNexia,"'SET 1 FDRLVL 24 2 3',$0D"
	    WAIT 5
	    SEND_STRING dvNexia,"'SET 1 FDRLVL 16 1 3',$0D"
	    WAIT 5
	    SEND_STRING dvNexia,"'SET 1 FDRLVL 17 1 3',$0D"
	    WAIT 5
	    SEND_STRING dvNexia, "'RECALL 1 PRESET 1005',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 10):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    send_string dvProjSmallConf,"'C01',$0D"
	    WAIT 5
	    SEND_COMMAND dvTp_Small_Conf,"'PAGE-Main'"
	    WAIT 5
	    SEND_COMMAND dvTp_Small_Conf,"'@PPN-WAIT_RoomResetting'"
	    WAIT 5
	    SEND_STRING dvNexia, "'RECALL 1 PRESET 1006',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    wait 5
	    SEND_STRING dvNexia, "'RECALL 1 PRESET 1004',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,23]
button_event[dvTp_Large_Conf,24]
button_event[dvTp_Large_Conf,25]
button_event[dvTp_Large_Conf,26]
button_event[dvTp_Large_Conf,27] // Cart PC Front
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 23):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 24):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 25):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 26):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 27):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,33]
button_event[dvTp_Large_Conf,34]
button_event[dvTp_Large_Conf,35]
button_event[dvTp_Large_Conf,36]
button_event[dvTp_Large_Conf,37] // Laptop Front
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 33):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 34):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 35):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 36):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 37):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,38]
button_event[dvTp_Large_Conf,39]
button_event[dvTp_Large_Conf,40]
button_event[dvTp_Large_Conf,41]
button_event[dvTp_Large_Conf,42] // Volume Control Large Conf
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 38):
	    {
		send_string dvNexia, "'SET 1 FDRLVL 24 1 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 39):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 24 1 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 40):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 24 1 2',$0D"    
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 41):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 17 1 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 42):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 17 1 2',$0D"
	    }
	}
    }
    hold[2,repeat]:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 38):
	    {
		send_string dvNexia, "'SET 1 FDRLVL 24 1 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 39):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 24 1 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 40):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 24 1 2',$0D"    
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 41):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 17 1 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 42):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 17 1 2',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,43]
button_event[dvTp_Large_Conf,44]
button_event[dvTp_Large_Conf,45]
button_event[dvTp_Large_Conf,46]
button_event[dvTp_Large_Conf,47] // Laptop Rear / Cart PC Rear
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 43):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I2O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 44):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 45):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I2O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 46):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 47):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I2O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,53]
button_event[dvTp_Large_Conf,54]
button_event[dvTp_Large_Conf,55]
button_event[dvTp_Large_Conf,56]
button_event[dvTp_Large_Conf,58]
button_event[dvTp_Large_Conf,59]
button_event[dvTp_Large_Conf,60]
button_event[dvTp_Large_Conf,61]
button_event[dvTp_Large_Conf,62] // Vol Control SM Conf
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 58):
	    {
		send_string dvNexia, "'SET 1 FDRLVL 24 1 -40',$0D"
		WAIT 2
		send_string dvNexia, "'SET 1 FDRLVL 24 2 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 59):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 24 1 2',$0D"
		WAIT 2
		send_string dvNexia, "'DEC 1 FDRLVL 24 2 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 60):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 24 1 2',$0D"
		WAIT 2
		send_string dvNexia, "'INC 1 FDRLVL 24 2 2',$0D"    
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 61):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 16 1 2',$0D"
		WAIT 2
		send_string dvNexia, "'DEC 1 FDRLVL 17 1 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 62):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 16 1 2',$0D"
		WAIT 2
		send_string dvNexia, "'INC 1 FDRLVL 17 1 2',$0D"
	    }
	}
    }
    hold[5,repeat]:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 58):
	    {
		send_string dvNexia, "'SET 1 FDRLVL 24 1 -40',$0D"
		WAIT 2
		send_string dvNexia, "'SET 1 FDRLVL 24 2 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 59):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 24 1 2',$0D"
		WAIT 2
		send_string dvNexia, "'DEC 1 FDRLVL 24 2 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 60):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 24 1 2',$0D"
		WAIT 2
		send_string dvNexia, "'INC 1 FDRLVL 24 2 2',$0D"    
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 61):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 16 1 2',$0D"
		WAIT 2
		send_string dvNexia, "'DEC 1 FDRLVL 16 1 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 62):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 16 1 2',$0D"
		WAIT 2
		send_string dvNexia, "'INC 1 FDRLVL 17 1 2',$0D"
	    }
	}
    }
}

button_event[dvTp_Large_Conf,63]
button_event[dvTp_Large_Conf,64]
button_event[dvTp_Large_Conf,65]
button_event[dvTp_Large_Conf,66]
button_event[dvTp_Large_Conf,67]
button_event[dvTp_Large_Conf,68]
button_event[dvTp_Large_Conf,69]
button_event[dvTp_Large_Conf,70] // Combined Cart DVD Front
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 63):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I1O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 64):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 65):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I1O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 66):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 67):
	    {
	    send_string dvLCDSmallConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string dvLCDSmallConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string dvLCDSmallConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I1O5T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 68):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 69):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C23',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I1O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 70):
	    {
	    send_string dvProjSmallConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjSmallConf,"'C23',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I1O2T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,83]
button_event[dvTp_Large_Conf,84]
button_event[dvTp_Large_Conf,85]
button_event[dvTp_Large_Conf,86]
button_event[dvTp_Large_Conf,87]
button_event[dvTp_Large_Conf,88]
button_event[dvTp_Large_Conf,89]
button_event[dvTp_Large_Conf,90] // Combined Cart PC Front
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 83):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 84):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 85):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 86):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 87):
	    {
	    send_string dvLCDSmallConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string dvLCDSmallConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string dvLCDSmallConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O5T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 88):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 89):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 90):
	    {
	    send_string dvProjSmallConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjSmallConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O2T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,93]
button_event[dvTp_Large_Conf,94]
button_event[dvTp_Large_Conf,95]
button_event[dvTp_Large_Conf,96]
button_event[dvTp_Large_Conf,97]
button_event[dvTp_Large_Conf,98]
button_event[dvTp_Large_Conf,99]
button_event[dvTp_Large_Conf,100] // combined laptop front
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 93):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 94):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 95):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 96):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	     ACTIVE (BUTTON.INPUT.CHANNEL = 97):
	    {
	    send_string dvLCDSmallConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string dvLCDSmallConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string dvLCDSmallConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O5T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 98):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 99):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 100):
	    {
	    send_string dvProjSmallConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjSmallConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I1O2T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,103]
button_event[dvTp_Large_Conf,104]
button_event[dvTp_Large_Conf,105]
button_event[dvTp_Large_Conf,106]
button_event[dvTp_Large_Conf,108]
button_event[dvTp_Large_Conf,109]
button_event[dvTp_Large_Conf,111]
button_event[dvTp_Large_Conf,112] // combined Rack DVD
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 103):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I3O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 104):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 105):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I3O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 106):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 111):
	    {
	    send_string dvLCDSmallConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string dvLCDSmallConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string dvLCDSmallConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I3O5T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 108):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 109):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C23',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I3O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 112):
	    {
	    send_string dvProjSmallConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjSmallConf,"'C23',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I3O2T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,113]
button_event[dvTp_Large_Conf,114]
button_event[dvTp_Large_Conf,115]
button_event[dvTp_Large_Conf,116]
button_event[dvTp_Large_Conf,117]
button_event[dvTp_Large_Conf,118]
button_event[dvTp_Large_Conf,119]
button_event[dvTp_Large_Conf,120] // combined Rack PC
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 113):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I3O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 114):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 115):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I3O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 116):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 117):
	    {
	    send_string dvLCDSmallConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string dvLCDSmallConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string dvLCDSmallConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I3O5T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 118):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 119):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    wait 70
	    send_string dvProjLargeConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I3O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 120):
	    {
	    send_string dvProjSmallConf,"'C00',$0D"
	    wait 70
	    send_string dvProjSmallConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I3O2T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    }
	}
    }
}

button_event[dvTp_Large_Conf,123]
button_event[dvTp_Large_Conf,124]
button_event[dvTp_Large_Conf,125]
button_event[dvTp_Large_Conf,126]
button_event[dvTp_Large_Conf,127] // Cart DVD Rear
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 123):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I2O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 124):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 125):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I2O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 126):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 127):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C23',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I2O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,133]
button_event[dvTp_Large_Conf,134]
button_event[dvTp_Large_Conf,135]
button_event[dvTp_Large_Conf,136]
button_event[dvTp_Large_Conf,137]
button_event[dvTp_Large_Conf,138]
button_event[dvTp_Large_Conf,139]
button_event[dvTp_Large_Conf,140] // combined laptop rear - cart pc rear
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 133):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I2O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 134):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 135):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I2O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 136):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	     ACTIVE (BUTTON.INPUT.CHANNEL = 137):
	    {
	    send_string dvLCDSmallConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string dvLCDSmallConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string dvLCDSmallConf,"'IAVD7   ',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I2O5T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 138):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 139):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I2O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 140):
	    {
	    send_string dvProjSmallConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjSmallConf,"'C05',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I2O2T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Large_Conf,153]
button_event[dvTp_Large_Conf,154]
button_event[dvTp_Large_Conf,155]
button_event[dvTp_Large_Conf,156]
button_event[dvTp_Large_Conf,157]
button_event[dvTp_Large_Conf,158]
button_event[dvTp_Large_Conf,159]
button_event[dvTp_Large_Conf,160] // Combined Cart DVD Rear
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 153):
	    {
	    send_string LCDALargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDALargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDALargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I2O3T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 154):
	    {
	    send_string LCDALargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 155):
	    {
	    send_string LCDBLargeConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string LCDBLargeConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string LCDBLargeConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I2O4T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 156):
	    {
	    send_string LCDBLargeConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 157):
	    {
	    send_string dvLCDSmallConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string dvLCDSmallConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string dvLCDSmallConf,"'IAVD1   ',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I2O5T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 158):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 159):
	    {
	    send_string dvProjLargeConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjLargeConf,"'C23',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I2O1T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 160):
	    {
	    send_string dvProjSmallConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjSmallConf,"'C23',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I2O2T'"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 1 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 2 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 3 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 4 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    }
	}
    }
}
button_event[dvTp_Small_Conf,1]
{
    push:
    {
	PULSE[dvRelay,1]
	SEND_STRING dvNexia, "'RECALL 1 PRESET 1002',$0D"
	WAIT 5
	SEND_STRING dvNexia,"'SET 1 FDRLVL 24 2 3',$0D"
	WAIT 5
	SEND_STRING dvNexia,"'SET 1 FDRLVL 16 1 3',$0D"
    }
}
button_event[dvTp_Small_Conf,2]    // Power Off
{
    push:
	{
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    send_string dvProjSmallConf,"'C01',$0D"
	    SEND_STRING dvVIDSwitcher,"'DL1 2O2 5T'"
	    SEND_STRING dvRGBSwitcher,"'DL1 202 5T'"
	    SEND_STRING dvNexia, "'RECALL 1 PRESET 1004',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5 
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    PULSE[dvRelay,2]
	}
}

button_event[dvTp_Small_Conf,38]
button_event[dvTp_Small_Conf,39]
button_event[dvTp_Small_Conf,40]
button_event[dvTp_Small_Conf,41]
button_event[dvTp_Small_Conf,42] // Volume SM Conference
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 38):
	    {
		send_string dvNexia, "'SET 1 FDRLVL 24 2 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 39):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 24 2 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 40):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 24 2 2',$0D"    
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 41):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 16 1 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 42):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 16 1 2',$0D"
	    }
	}
    }
    hold[2,repeat]:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 38):
	    {
		send_string dvNexia, "'SET 1 FDRLVL 24 2 -40',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 39):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 24 2 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 40):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 24 2 2',$0D"    
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 41):
	    {
		send_string dvNexia, "'DEC 1 FDRLVL 16 1 2',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 42):
	    {
		send_string dvNexia, "'INC 1 FDRLVL 16 1 2',$0D"
	    }
	}
    }
}
button_event[dvTp_Small_Conf,43]
button_event[dvTp_Small_Conf,44]
button_event[dvTp_Small_Conf,45]
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 43):
	    {
	    send_string dvLCDSmallConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string dvLCDSmallConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string dvLCDSmallConf,"'IAVD1   ',$0D"
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I3O5T'"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 44):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 45):
	    {
	    send_string dvProjSmallConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjSmallConf,"'C23',$0D"
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 0',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 -40',$0D"
	    SEND_STRING dvVIDSwitcher,"'CL1 2I3O2T'"
	    }
	}
    }
}
button_event[dvTp_Small_Conf,53]
button_event[dvTp_Small_Conf,54]
button_event[dvTp_Small_Conf,55]
{
    PUSH:
    {
	SELECT
        {
	    ACTIVE (BUTTON.INPUT.CHANNEL = 53):
	    {
	    send_string dvLCDSmallConf,"'RSPW1   ',$0D"
	    WAIT 5
	    send_string dvLCDSmallConf,"'POWR1   ',$0D"
	    WAIT 10
	    send_string dvLCDSmallConf,"'IAVD7   ',$0D"
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I3O5T'"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 54):
	    {
	    send_string dvLCDSmallConf,"'POWR0   ',$0D"
	    }
	    ACTIVE (BUTTON.INPUT.CHANNEL = 55):
	    {
	    send_string dvProjSmallConf,"'C00',$0D"
	    WAIT 70
	    send_string dvProjSmallConf,"'C05',$0D"
	    send_string dvNexia, "'SET 1 FDRLVL 5 5 -40',$0D"
	    wait 5
	    send_string dvNexia, "'SET 1 FDRLVL 5 6 0',$0D"
	    SEND_STRING dvRGBSwitcher,"'CL1 2I3O2T'"
	    }
	}
    }
}
DEFINE_PROGRAM
