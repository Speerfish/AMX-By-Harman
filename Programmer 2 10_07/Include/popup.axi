PROGRAM_NAME='popup'

DEFINE_CONSTANT
integer SRC_BTNS[] =
{
	1, 2, 3, 4, 5
}

DEFINE_EVENT
BUTTON_EVENT[dvTP,SRC_BTNS]
{                
	push:
	{
		local_var integer i
		
		switch(button.input.channel)
		{
			case 1:	send_command dvTP,"'@PPN-RELAYS'"
			case 2: send_command dvTP,"'@PPN-SWITCHER'"
			case 3: send_command dvTP,"'@PPN-PRESETS'"
			case 4: send_command dvTP,"'@PPN-TCP'"
			case 5: send_command dvTP,"'@PPN-TIMELINE'"
		}
		for( i = 1; i <= length_array(SRC_BTNS); i++ )
		{
			[dvTP,i] = (button.input.channel == i)
		}
	}
}