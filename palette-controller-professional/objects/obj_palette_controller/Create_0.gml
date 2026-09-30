// CREATES A CONSTRUCTOR CLASS  FOR GENERATING A 2D GRID

/// @description Generate 2D grid

global.palette_list = [];							// Stores array of grid structs

/// @function palette()
/// @description Generates a 2D palette grid using the specified sprites, transforms, and layout settings.
/// @since v0.1.0
///
/// @param {Real} [_sprite_enabled=spr_enabled]		Sprite used for the enabled state.
/// @param {Real} [_sprite_disabled=spr_disabled]	Sprite used for the disabled state.
/// @param {Real} [_sprite_inset=spr_inset]			Sprite used for the inset state.
///
/// @param {Real} [_scale_enabled=0.5]				Display scale for the enabled sprite.
/// @param {Real} [_scale_disabled=0.5]				Display scale for the disabled sprite.
/// @param {Real} [_scale_inset=0.5]				Display scale for the inset sprite.
///
/// @param {Real} [_alpha_enabled=1]				Alpha value for the enabled sprite.
/// @param {Real} [_alpha_disabled=1]				Alpha value for the disabled sprite.
/// @param {Real} [_alpha_inset=1]					Alpha value for the inset sprite.
///
/// @param {Real} [_angle_enabled=0]				Rotation angle for the enabled sprite.
/// @param {Real} [_angle_disabled=0]				Rotation angle for the disabled sprite.
/// @param {Real} [_angle_inset=0]					Rotation angle for the inset sprite.
///
/// @param {Real} [_x_offset=64]					Horizontal starting position, measured from the top-left origin.
/// @param {Real} [_y_offset=32]					Vertical starting position, measured from the top-left origin.
/// @param {Real} [_line_break_qty=10]				Number of palette entries before starting a new line.
///
/// @returns {Struct} A new palette struct.			

function palette
(
_sprite_enabled = spr_enabled, _sprite_disabled = spr_disabled, _sprite_inset = spr_inset,
_scale_enabled = 0.5, _scale_disabled = 0.5, _scale_inset = 0.5,
_alpha_enabled = 1, _alpha_disabled = 1, _alpha_inset = 1,
_angle_enabled = 0, _angle_disabled = 0, _angle_inset = 0,
_x_offset = 64, _y_offset = 32, 
_line_break_qty = 10, 

)  
constructor
{
	/// @description Calculation variables
		
	cache_cursor = window_get_cursor();
	
	palette_data = [];
	
	x_offset		= _x_offset;
    y_offset		= _y_offset;
	
	x_gap = 8;
	y_gap = 8;
	
	/// @description Imported variables
	
	sprite_enabled	= _sprite_enabled;
	sprite_disabled	= _sprite_disabled;
	sprite_inset		= _sprite_inset;
	
	scale_enabled	= _scale_enabled;
	scale_disabled	= _scale_disabled;
	scale_inset			= _scale_inset;
	
	alpha_enabled	= _alpha_enabled;
	alpha_disabled	=_alpha_disabled;
	alpha_inset		= _alpha_inset;
	
	angle_enabled	= _alpha_enabled;
	angle_disabled	=_alpha_disabled;
	angle_inset		= _alpha_inset;
	
	line_break_qty	= _line_break_qty;

	column_qty = sprite_get_number(sprite_enabled) ;
	row_qty = round(column_qty / line_break_qty);
	
	sprite_width = sprite_get_width(_sprite_enabled) * scale_enabled;
	sprite_height = sprite_get_height(_sprite_enabled) * scale_enabled;
	
    /// @function			set_palette
    /// @description		Updates or initialises first palette. 				

	static set_palette = function()
	{
		for (var _index = 0; _index < column_qty; _index++)
		{
			var _column = _index mod line_break_qty;
	        var _row = _index div line_break_qty;
			
			palette_data[_index] = 
			{
				sprite : sprite_inset,
					
			    x : x_offset + (_column * (sprite_width + x_gap)),
			    y : y_offset + (_row * (sprite_height + y_gap)),
					
				x_scale : scale_enabled,
				y_scale : scale_enabled,
					
				angle : angle_enabled,
				alpha : alpha_enabled,
			}
		}
	}
	
	set_palette();
	
	/// @function					get_index
    /// @description				Calculate index of the selected palette item.
	/// @param		{Real}	[_x]	X value to check against. (Default is mouse but this allows for other inputs)
	/// @param		{Real}	[_y]	Y value to check against. (Default is mouse but this allows for other inputs) 
	/// @return		{Real}			Return index of the selected palette item. (returns -1 if nothing is selected)
	
    static get_index = function(_x = mouse_x, _y = mouse_y) 
    {
		for (var _index = 0; _index < column_qty; _index++)
		{
			var _x1 = palette_data[_index].x;
			var _y1 = palette_data[_index].y;
			var _x2 = palette_data[_index].x + sprite_width;
			var _y2 = palette_data[_index].y + sprite_height;
			
			if point_in_rectangle(_x, _y, _x1, _y1, _x2, _y2)
			{
				return _index;
			} 
		}
		
		return -1;
	}
	
	/// @function		step
    /// @description	Execute step code for grid constructor instance.
	
    static step = function() 
    {
		show_debug_message(get_index());
	}
				
    static draw = function() 
    {
		var _cache_data = palette_data;
		
		for (var _index = 0; _index < column_qty; _index++)
		{
			draw_sprite_ext
			(
			_cache_data[ _index].sprite,
			_index, 
			_cache_data[ _index].x, 
			_cache_data[ _index].y, 
			_cache_data[ _index].x_scale, 
			_cache_data[ _index].y_scale, 
			_cache_data[ _index].angle, c_white, 
			_cache_data[ _index].alpha
			);
		}
	}
	
	/// @function destroy()
	/// @description Cleans up the instance from the global list and clears data
	
	static destroy = function() 
	{
	    
	}
	
    array_push(global.palette_list, self); // Add copy of self to grid array.
}