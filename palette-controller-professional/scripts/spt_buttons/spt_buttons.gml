enum BUTTON_LABEL
{
	EXAMPLE
}

enum BUTTONS_EXAMPLE
{
	HOME,
	SAVE,
	LOAD,
	FLIP_HORIZONTAL,
	FLIP_VERTICAL,
	PAN_LEFT,
	PAN_RIGHT,
	PAN_DOWN,
	PAN,UP,
	HOLD_0,
	HOLD_1,
	HOLD_2,
	HOLD_3,
	HOLD_4,
	HOLD_5,
	HOLD_6,
	HOLD_7,
	REFRESH,
	UNDO,
	CANCEL,
	ACCEPT,
	DELETE,
	ZOOM_OUT,
	ZOOM_IN,
	SNAP_LEFT,
	SNAP_RIGHT,
	TOGGLE_GRID,
	TOGGLE_VIEW,
	TOGGLE_MUSIC,
	TOGGLE_SFX,
	SETTINGS,
	INFO,
	HELP,
	QUIT
}

function spt_buttons(_palette_id, _id)
{
	if _palette_id == BUTTON_LABEL.EXAMPLE
	{
		switch _id
		{
			case BUTTONS_EXAMPLE.HOME:
		
				show_message("HOME");
		
			break;
			
			case BUTTONS_EXAMPLE.QUIT:
		
				game_end(0);
		
			break;
		}
	}
}