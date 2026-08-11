/// @description Loops through step code for each palette instance

var _list_size = array_length(global.palette_list);

for (var i = 0; i < _list_size; i++)
{
    var current_instance = global.palette_list[i];
    current_instance.step();
}