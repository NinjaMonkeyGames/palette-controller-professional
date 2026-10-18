// Simplified States
enum PALETTE_STATE 
{
    NORMAL,
    ACTIVE,   // Replaces the "sticky/inset" states
    DISABLED
}

/// @description Generate 2D grid

global.palette_list = []; // Stores array of grid structs

/**
 * @function palette()
 * @constructor
 * @description      Generates a 2D palette grid with sound effects and cursor swapping.
 * @since v0.1.0
 * @param   {Asset.GMSprite}    [_sprite_enabled]           Sprite asset used when enabled.
 * @param   {Asset.GMSprite}    [_sprite_disabled]          Sprite asset used when disabled.
 * @param   {Asset.GMSprite}    [_sprite_inset]             Sprite asset used for the inset state.
 * @param   {Real}              [_scale_enabled]            Scale factor when enabled.
 * @param   {Real}              [_scale_disabled]           Scale factor when disabled.
 * @param   {Real}              [_scale_inset]              Scale factor for the inset state.
 * @param   {Real}              [_alpha_enabled]            Alpha transparency when enabled.
 * @param   {Real}              [_alpha_disabled]           Alpha transparency when disabled.
 * @param   {Real}              [_alpha_inset]              Alpha transparency for the inset state.
 * @param   {Real}              [_angle_enabled]            Rotation angle when enabled.
 * @param   {Real}              [_angle_disabled]           Rotation angle when disabled.
 * @param   {Real}              [_angle_inset]              Rotation angle for the inset state.
 * @param   {Real}              [_x_offset]                 Initial X offset position for the grid.
 * @param   {Real}              [_y_offset]                 Initial Y offset position for the grid.
 * @param   {Real}              [_line_break_qty]           Number of items per row before wrapping.
 * @param   {Asset.GMSound}     [_sound_click=snd_click]    Sound effect played on click.
 * @param   {Asset.GMSound}     [_sound_hover=snd_hover]    Sound effect played on hover.
 * @param   {Asset.GMSound}     [_sound_inset=snd_inset]    Sound effect played when toggled to inset/active.
 * @param   {Asset.GMSound}     [_sound_disabled=snd_disabled] Sound effect played when clicking a disabled item.
 * @returns {Struct}                                        A new palette struct.
 */

function palette
(
_sprite_enabled = spr_enabled, _sprite_disabled = spr_disabled, _sprite_inset = spr_inset,
_scale_enabled = 0.5, _scale_disabled = 0.4, _scale_inset = 0.45,
_alpha_enabled = 1, _alpha_disabled = 1, _alpha_inset = 1,
_angle_enabled = 0, _angle_disabled = 0, _angle_inset = 0,
_x_offset = 128, _y_offset = 128, 
_line_break_qty = 10,
_sound_click = snd_click, _sound_hover = snd_hover,
_sound_inset = snd_inset, _sound_disabled = snd_disabled
)  
constructor
{
    /// @description Calculation variables
    
    /**
     * @function palette_id()
     * @constructor
     * @description      Generates a unique palette ID.
     * @since v0.1.0
     * @returns {Real}                           Palette ID.
     */
    
    palette_id = (function() 
    {
        static _instances = [];
        array_push(_instances, self);
        return array_length(_instances) - 1;
    })();
    
    cache_cursor = window_get_cursor();
    last_hovered_index = -1;
    palette_data = [];
    
    x_offset = _x_offset;
    y_offset = _y_offset;
    x_gap = 8;
    y_gap = 8;
    
    /// @description Imported variables
    
    sprite_enabled  = _sprite_enabled;
    sprite_disabled = _sprite_disabled;
    sprite_inset    = _sprite_inset;
    
    scale_enabled   = _scale_enabled;
    scale_disabled  = _scale_disabled;
    scale_inset     = _scale_inset;
    
    alpha_enabled   = _alpha_enabled;
    alpha_disabled  = _alpha_disabled;
    alpha_inset     = _alpha_inset;
    
    angle_enabled   = _angle_enabled; 
    angle_disabled  = _angle_disabled;
    angle_inset     = _angle_inset;
    
    line_break_qty  = _line_break_qty;
    
    sound_click     = _sound_click;
    sound_hover     = _sound_hover;
    sound_inset     = _sound_inset;
    sound_disabled  = _sound_disabled;

    column_qty = sprite_get_number(sprite_enabled);
    row_qty = round(column_qty / line_break_qty);
    
    sprite_width = sprite_get_width(_sprite_enabled) * scale_enabled;
    sprite_height = sprite_get_height(_sprite_enabled) * scale_enabled;
    
    /**
     * @function set_palette()
     * @constructor
     * @description      Generates default palette.
     * @since v0.1.0
     */
    
    static set_palette = function()
    {
        for (var _index = 0; _index < column_qty; _index++)
        {
            var _column = _index mod line_break_qty;
            var _row = _index div line_break_qty;
            
            palette_data[_index] = 
            {
                state   : PALETTE_STATE.NORMAL,
                sticky  : true,
                x: x_offset + (_column * (sprite_width + x_gap)),
                y: y_offset + (_row * (sprite_height + y_gap)),
            }
        }
    }
    
    set_palette();
    
    /**
     * @function get_index_at()
     * @constructor
     * @description      Gets index for button at arbitrary coordinates (mouse, virtual cursor, etc.).
     * @since v0.1.0
     * @param           {Real}   [_x]    X coordinate to check button selection against.
     * @param           {Real}   [_y]    Y coordinate to check button selection against.
     * @returns         {Real}           Palette index, or -1 if none found.        
     */
    
    static get_index_at = function(_x, _y) 
    {
        for (var _index = 0; _index < column_qty; _index++)
        {
            var _x1 = palette_data[_index].x;
            var _y1 = palette_data[_index].y;
            var _x2 = palette_data[_index].x + sprite_width;
            var _y2 = palette_data[_index].y + sprite_height;
            
            if (point_in_rectangle(_x, _y, _x1, _y1, _x2, _y2))
            {
                return _index;
            }
        }
        return -1;
    }
    
    /**
     * @function set_state()
     * @constructor
     * @description      Sets state of a palette item (button).
     * @since v0.1.0
     * @param           {Real}   [_id]       ID of the palette item (button) to set the state of.
     * @param           {Real}   [_state]    The state to set.
     */
    
    static set_state = function(_id, _state) 
    {
        if (_id >= 0 && _id < column_qty)
        {
            palette_data[_id].state = _state;
        }
    }

    /**
     * @function select_index()
     * @constructor
     * @description      Device-agnostic core logic: selects or toggles a palette item by index.
     * @since v0.1.0
     * @param           {Real}   [_index]    Index of the palette button to select.
     */
    
    static select_index = function(_index)
    {
        if (_index < 0 || _index >= column_qty) return;
        var _item = palette_data[_index];
        
        if (_item.state == PALETTE_STATE.DISABLED)
        {
            if (audio_exists(sound_disabled))
            {
                audio_play_sound(sound_disabled, 0, false);
            }
            return;
        }
        
        if (_item.sticky)
        {
            if (_item.state == PALETTE_STATE.ACTIVE)
            {
                set_state(_index, PALETTE_STATE.NORMAL);
                if (audio_exists(sound_click))
                {
                    audio_play_sound(sound_click, 0, false);
                }
            }
            else
            {
                set_state(_index, PALETTE_STATE.ACTIVE);
                if (audio_exists(sound_inset))
                {
                    audio_play_sound(sound_inset, 0, false);
                }
            }
        }
        else
        {
            if (audio_exists(sound_click))
            {
                audio_play_sound(sound_click, 0, false);
            }
        }
    }

    /**
     * @function handle_hover()
     * @constructor
     * @description      Manages hover states and cursor swapping based on input coordinates.
     * @since v0.1.0
     * @param           {Real}   [_x]    X coordinate of pointer/cursor.
     * @param           {Real}   [_y]    Y coordinate of pointer/cursor.
     * @returns         {Real}           Currently hovered index.
     */
    
    static handle_hover = function(_x, _y)
    {
        var _hovered_index = get_index_at(_x, _y);
        
        if (_hovered_index != last_hovered_index)
        {
            if (last_hovered_index != -1 && palette_data[last_hovered_index].state != PALETTE_STATE.DISABLED)
            {
                window_set_cursor(cache_cursor);
            }
            
            if (_hovered_index != -1 && palette_data[_hovered_index].state != PALETTE_STATE.DISABLED)
            {
                window_set_cursor(cr_handpoint);
                
                if (audio_exists(sound_hover))
                {
                    audio_play_sound(sound_hover, 0, false);
                }
            }
            
            last_hovered_index = _hovered_index;
        }
        
        return _hovered_index;
    }
        
    static step = function()
    {
        var _mx = mouse_x;
        var _my = mouse_y;
        
        var _hovered_index = handle_hover(_mx, _my);
        
        var _is_pressing = mouse_check_button(mb_left);
        var _pressed_index = get_index_at(_mx, _my);
        
        if (mouse_check_button_pressed(mb_left))
        {
            if (_pressed_index != -1)
            {
                select_index(_pressed_index);
            }
        }
        
        draw(_hovered_index, _is_pressing, _pressed_index);
    }
        
    /**
     * @function draw()
     * @constructor
     * @description										Draw palette based on palette data and external interaction state.
     * @since v0.1.0
     * @param           {Real}   [_hovered_index=-1]    Index currently hovered over.
     * @param           {Bool}   [_is_pressing=false]   Whether the input device is actively held down.
     * @param           {Real}   [_pressed_index=-1]      Index currently being pressed down.
     */
    
    static draw = function(_hovered_index = -1, _is_pressing = false, _pressed_index = -1) 
    {
        for (var _index = 0; _index < column_qty; _index++)
        {
            var _item = palette_data[_index];
            var _is_hovered = (_index == _hovered_index);
            var _is_last_clicked = (_index == _pressed_index);
            //var _sprite, _scale, _alpha, _angle;
            
            switch (_item.state)
            {
                case PALETTE_STATE.DISABLED:
				
                    _sprite = sprite_disabled;
                    _scale  = scale_disabled;
                    _alpha  = alpha_disabled;
                    _angle  = angle_disabled;
					
                break;
                
                case PALETTE_STATE.ACTIVE:
				
                    if (_is_last_clicked && _is_pressing) 
                    {
                        _sprite = sprite_enabled;
                        _scale  = scale_enabled;
                    } 
						else 
                    {
                        _sprite = sprite_inset;
                        _scale  = scale_inset;
                    }
                    _alpha = alpha_inset;
                    _angle = angle_inset;
					
                break;
                
                case PALETTE_STATE.NORMAL:
				
                default:
                    if (_is_last_clicked && _is_pressing) 
                    {
                        _sprite = sprite_inset;
                        _scale  = scale_inset;
                    } 
						else if (_is_hovered) 
                    {
                        _sprite = sprite_enabled;
                        _scale  = scale_enabled - 0.1;
                    } 
						else 
                    {
                        _sprite = sprite_enabled;
                        _scale  = scale_enabled;
                    }
                    _alpha = alpha_enabled;
                    _angle = angle_enabled;
					
                break;
            }
            
            draw_sprite_ext
            (
                _sprite,
                _index, 
                _item.x, 
                _item.y, 
                _scale, 
                _scale, 
                _angle, 
                c_white, 
                _alpha
            );
        }
    }
    
    /// @function destroy
    
    static destroy = function() 
    {
        if (last_hovered_index != -1)
        {
            window_set_cursor(cache_cursor);
        }
        
        var _pos = array_get_index(global.palette_list, self);
        if (_pos != -1)
        {
            array_delete(global.palette_list, _pos, 1);
        }
    }
    
    array_push(global.palette_list, self);
}