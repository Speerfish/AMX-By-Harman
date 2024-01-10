PROGRAM_NAME='Weld County'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(*  Speerfish
    www.speerfish.net
    Programmed by Armin 
    armin@speerfish.net *)
(***********************************************************)
DEFINE_DEVICE
dvKp_Large_Conf			=  1: 1:0
dvKp_Small_Conf			=  3: 1:0

dvSwitcher	 		=  5001: 1:0  // Kramer VP-2X2   232
dvProjSmallConf 		=  5001: 2:0  // Hitachi CP-X505 232
dvProjLargeConf 		=  5001: 3:0  // Hitachi CP-X505  IR

DEFINE_CONSTANT
char projon[]  			= {$BE,$EF,$03,$06,$00,$BA,$D2,$01,$00,$00,$60,$01,$00,$0D}
char projrgb[] 			= {$BE,$EF,$03,$06,$00,$FE,$D2,$01,$00,$00,$20,$00,$00,$0D}
char projoff[] 			= {$BE,$EF,$03,$06,$00,$2A,$D3,$01,$00,$00,$60,$00,$00,$0D}
char projvoldn[]		= {$BE,$EF,$03,$06,$00,$AB,$CC,$04,$00,$60,$20,$00,$00,$0D}
char projvolup[]		= {$BE,$EF,$03,$06,$00,$7A,$CD,$05,$00,$60,$20,$00,$00,$0D}

char room1v[]   		= {$01,$81,$81,$81,$0D}
char room1a[]			= {$02,$81,$81,$81,$0D}
char room2v[]   		= {$01,$82,$82,$81,$0D}
char room2a[]   		= {$02,$82,$82,$81,$0D}
char roomcombinev[]		= {$01,$81,$82,$81,$0D}
char roomcombinea[]		= {$02,$81,$82,$81,$0D}
char room1vmute[]		= {$01,$81,$80,$81,$0D}
char room1amute[]		= {$02,$81,$80,$81,$0D}
char room2vmute[]		= {$01,$82,$80,$81,$0D}
char room2amute[]		= {$02,$82,$80,$81,$0D}

DEFINE_START
send_command dvProjSmallConf,	"'SET BAUD 19200,N,8,1 485 DISABLE HSOFF'"
send_command dvSwitcher,	"'SET BAUD 9600,N,8,1 485 DISABLE HSOFF'"

DEFINE_EVENT
button_event[dvKp_Large_Conf,1]  // Power On
{
    push:
    {
	pulse[dvProjLargeConf,9]
	wait 10
	pulse[dvProjLargeConf,34]
	WAIT 10
	SEND_STRING dvSwitcher, room1a
	wait 10
	SEND_STRING dvSwitcher, room1v
    }
}
button_event[dvKp_Large_Conf,2]  // Power Off
{
    push:
    {
	pulse[dvProjLargeConf,9]
	WAIT 10
	pulse[dvProjLargeConf,9]
	WAIT 10
	SEND_STRING dvSwitcher, room1amute
	wait 10
	send_string dvSwitcher, room1vmute
    }
}
button_event[dvKp_Large_Conf,3]  // Combine
{
    push:
    {
	SEND_STRING dvProjSmallConf, projon
	WAIT 10
	SEND_STRING dvProjSmallConf, projrgb
	wait 10
	send_string dvSwitcher, room1v
	wait 10
	send_string dvSwitcher, room1a
	WAIT 10
	SEND_STRING dvSwitcher, roomcombinea
	wait 10
	send_string dvSwitcher, roomcombinev
	wait 10
	pulse[dvProjLargeConf,9]
	Wait 10
	pulse[dvProjLargeConf,34]
    }
}
button_event[dvKp_Large_Conf,4]  // Seperate
{
    push:
    {
	send_string dvProjSmallConf, projoff
	wait 10
	send_string dvSwitcher, room1a
	wait 10
	send_string dvSwitcher, room1v
    }
}
button_event[dvKp_Large_Conf,7]  // Volume Up
{
    push:
    {
	pulse[dvProjLargeConf,13]
	wait 10
	pulse[dvProjLargeConf,15]
    }
    hold[2,repeat]:
    {
	pulse[dvProjLargeConf,13]
	wait 5
	pulse[dvProjLargeConf,15]
    }
}
button_event[dvKp_Large_Conf,8]  // Volume Down
{
    push:
    {
	pulse[dvProjLargeConf,13]
	wait 10
	pulse[dvProjLargeConf,14]
    }
    hold[2,repeat]:
    {
	pulse[dvProjLargeConf,13]
	wait 5
	pulse[dvProjLargeConf,14]
    }
}
button_event[dvKp_Small_Conf,1]  // Power On
{
    push:
    {
	SEND_STRING dvProjSmallConf, projon
	WAIT 10
	SEND_STRING dvProjSmallConf, projrgb
	WAIT 10
	SEND_STRING dvSwitcher, room2a
	wait 10
	send_string dvSwitcher, room2v

    }
}
button_event[dvKp_Small_Conf,2]  // Power Off
{
    push:
    {
	SEND_STRING dvProjSmallConf, projoff
	wait 10
	SEND_STRING dvSwitcher, room2amute
	wait 10
	send_string dvSwitcher, room2vmute
    }
}
button_event[dvKp_Small_Conf,7]  // Volume Up
{
    push:
    {
	send_string dvProjSmallConf, projvolup
    }
    hold[2,repeat]:
    {
	send_string dvProjSmallConf, projvolup
    }
}
button_event[dvKp_Small_Conf,8]  // Volume Down
{
    push:
    {
	send_string dvProjSmallConf, projvoldn
    }
    hold[2,repeat]:
    {
	send_string dvProjSmallConf, projvoldn
    }
}