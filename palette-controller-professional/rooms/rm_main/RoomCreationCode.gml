// INITIALISE PROJECT

global.debug_enabled  = environment_get_variable("CI") != "";

window_set_caption("Palette Utility Professional v" + GM_version);									    // Set window caption text.
global.palette_controller = instance_create_layer(0, 0, "lyr_gui", obj_palette_controller);	// Generate instance of palette controller object.
example_palette = new obj_palette_controller.palette();

if global.debug_enabled == true then global.unit_test = instance_create_layer(0, 0, "lyr_gui", obj_unit_test);	