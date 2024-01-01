PROGRAM_NAME='KeyboardParsing'

DEFINE_VARIABLE
INTEGER nTPNUMBER
CHAR	sTPDATA[128]
INTEGER bTPDONE

DEFINE_EVENT
DATA_EVENT[dvTP]
{
	string:
		{
			select
			{
				active(	FIND_STRING(DATA.TEXT,"'ABORT'",1) ):
				{
					CANCEL_WAIT_UNTIL 'TP'
				}
				active(find_string(DATA.TEXT,"'KEYB-'",1) ):
				{	
					REMOVE_STRING(DATA.TEXT,"'KEYB-'",1)
					sTPDATA = DATA.TEXT
				}
				active(find_string(DATA.TEXT,"'KEYP-'",1) ):
				{	
					REMOVE_STRING(DATA.TEXT,"'KEYP-'",1)
					nTPNUMBER = ATOI(DATA.TEXT)
				}
			}
			PULSE[bTPDONE]		//PARSING FINISHED!!
		}
}