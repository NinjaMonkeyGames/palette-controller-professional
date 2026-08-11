/// @description Loops through draw code for each palette instance

var _list_size = array_length(global.palette_list);

for (var _i = 0; _i < _list_size; _i++)
{
    var current_instance = global.palette_list[_i]; 
    current_instance.draw();
}