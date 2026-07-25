module packets

import serializer

pub enum MemoryCategoryCounterType as u8 {
	unknown                                    = 0
	invalid_size_unknown                       = 1
	actor                                      = 2
	actor_animation                            = 3
	actor_rendering                            = 4
	block_ticking_queues                       = 5
	biome_storage                              = 6
	blobs                                      = 7
	cereal                                     = 8
	circuit_system                             = 9
	client                                     = 10
	commands                                   = 11
	db_storage                                 = 12
	debug                                      = 13
	documentation                              = 14
	ecs_systems                                = 15
	fmod                                       = 16
	fonts                                      = 17
	im_gui                                     = 18
	input                                      = 19
	json_ui                                    = 20
	json_ui_control_factory_json               = 21
	json_ui_control_tree                       = 22
	json_ui_control_tree_control_element       = 23
	json_ui_control_tree_populate_data_binding = 24
	json_ui_control_tree_populate_focus        = 25
	json_ui_control_tree_populate_layout       = 26
	json_ui_control_tree_populate_other        = 27
	json_ui_control_tree_populate_sprite       = 28
	json_ui_control_tree_populate_text         = 29
	json_ui_control_tree_populate_tts          = 30
	json_ui_control_tree_visibility            = 31
	json_ui_create_ui                          = 32
	json_ui_defs                               = 33
	json_ui_layout_manager                     = 34
	json_ui_layout_manager_remove_dependencies = 35
	json_ui_layout_manager_init_variable       = 36
	languages                                  = 37
	level                                      = 38
	level_structures                           = 39
	level_chunk                                = 40
	level_chunk_gen                            = 41
	level_chunk_gen_thread_local               = 42
	light_volume_manager                       = 43
	network                                    = 44
	marketplace                                = 45
	material_dragon_compiled_definition        = 46
	material_dragon_material                   = 47
	material_dragon_resource                   = 48
	material_dragon_uniform_map                = 49
	material_render_material                   = 50
	material_render_material_group             = 51
	material_variation_manager                 = 52
	mo_lang                                    = 53
	ore_ui                                     = 54
	ore_ui_client                              = 55
	persona_pieces                             = 56
	persona_animations                         = 57
	persona_textures                           = 58
	persona_characters                         = 59
	persona_skin_packs                         = 60
	persona_repo                               = 61
	player                                     = 62
	render_chunk                               = 63
	render_chunk_index_buffer                  = 64
	render_chunk_vertex_buffer                 = 65
	rendering                                  = 66
	rendering_bgfx_init                        = 67
	rendering_bgfx_start_frame                 = 68
	rendering_bgfx_tessellator                 = 69
	rendering_bgfx_end_frame                   = 70
	rendering_bgfx_graphics_tasks_init         = 71
	rendering_library                          = 72
	rendering_polygon_operator_pool            = 73
	rendering_pbr_texture_data                 = 74
	rendering_render_registry                  = 75
	rendering_setup                            = 76
	rendering_vertices                         = 77
	request_log                                = 78
	resource_packs                             = 79
	sound                                      = 80
	sub_chunk_biome_data                       = 81
	sub_chunk_block_data                       = 82
	sub_chunk_light_data                       = 83
	textures                                   = 84
	weather_renderer                           = 85
	world_generator                            = 86
	tasks                                      = 87
	test                                       = 88
	test_load_test_flags                       = 89
	scripting                                  = 90
	scripting_runtime                          = 91
	scripting_context                          = 92
	scripting_context_bindings_mc              = 93
	scripting_context_bindings_gt              = 94
	scripting_context_run                      = 95
	data_driven_ui                             = 96
	data_driven_ui_defs                        = 97
	gameface                                   = 98
	gameface_system                            = 99
	gameface_dom                               = 100
	gameface_css                               = 101
	gameface_display                           = 102
	gameface_temp_allocator                    = 103
	gameface_pool_allocator                    = 104
	gameface_dump                              = 105
	gameface_media                             = 106
	gameface_json                              = 107
	gameface_script_engine                     = 108
	gameface_script                            = 109
	gameface_layout                            = 110
}

pub fn (e MemoryCategoryCounterType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn MemoryCategoryCounterType.decode(mut r serializer.Reader) !MemoryCategoryCounterType {
	return unsafe { MemoryCategoryCounterType(r.u8()!) }
}

pub struct MemoryCategoryCounter {
pub mut:
	category      MemoryCategoryCounterType
	current_bytes i64
}

pub fn (e MemoryCategoryCounter) encode(mut w serializer.Writer) {
	e.category.encode(mut w)
	w.le_i64(e.current_bytes)
}

pub fn MemoryCategoryCounter.decode(mut r serializer.Reader) !MemoryCategoryCounter {
	return MemoryCategoryCounter{
		category:      MemoryCategoryCounterType.decode(mut r)!
		current_bytes: r.le_i64()!
	}
}

pub struct EntityDiagnosticTimingInfo {
pub mut:
	display_name  string
	entity        string
	ns_time       i64
	total_percent u8
}

pub fn (e EntityDiagnosticTimingInfo) encode(mut w serializer.Writer) {
	w.write_string(e.display_name)
	w.write_string(e.entity)
	w.le_i64(e.ns_time)
	w.u8(e.total_percent)
}

pub fn EntityDiagnosticTimingInfo.decode(mut r serializer.Reader) !EntityDiagnosticTimingInfo {
	return EntityDiagnosticTimingInfo{
		display_name:  r.read_string()!
		entity:        r.read_string()!
		ns_time:       r.le_i64()!
		total_percent: r.u8()!
	}
}

pub struct SystemDiagnosticTimingInfo {
pub mut:
	display_name  string
	system_index  i64
	ns_time       i64
	total_percent u8
}

pub fn (e SystemDiagnosticTimingInfo) encode(mut w serializer.Writer) {
	w.write_string(e.display_name)
	w.le_i64(e.system_index)
	w.le_i64(e.ns_time)
	w.u8(e.total_percent)
}

pub fn SystemDiagnosticTimingInfo.decode(mut r serializer.Reader) !SystemDiagnosticTimingInfo {
	return SystemDiagnosticTimingInfo{
		display_name:  r.read_string()!
		system_index:  r.le_i64()!
		ns_time:       r.le_i64()!
		total_percent: r.u8()!
	}
}

pub struct SystemCategory {
pub mut:
	category_name string
	system_index  i64
}

pub fn (e SystemCategory) encode(mut w serializer.Writer) {
	w.write_string(e.category_name)
	w.le_i64(e.system_index)
}

pub fn SystemCategory.decode(mut r serializer.Reader) !SystemCategory {
	return SystemCategory{
		category_name: r.read_string()!
		system_index:  r.le_i64()!
	}
}

pub struct WhiskerScopeDataSummary {
pub mut:
	indentation        string
	label              string
	total_high_cost_ns i64
	total_mid_cost_ns  i64
	total_low_cost_ns  i64
}

pub fn (e WhiskerScopeDataSummary) encode(mut w serializer.Writer) {
	w.write_string(e.indentation)
	w.write_string(e.label)
	w.le_i64(e.total_high_cost_ns)
	w.le_i64(e.total_mid_cost_ns)
	w.le_i64(e.total_low_cost_ns)
}

pub fn WhiskerScopeDataSummary.decode(mut r serializer.Reader) !WhiskerScopeDataSummary {
	return WhiskerScopeDataSummary{
		indentation:        r.read_string()!
		label:              r.read_string()!
		total_high_cost_ns: r.le_i64()!
		total_mid_cost_ns:  r.le_i64()!
		total_low_cost_ns:  r.le_i64()!
	}
}

pub struct ServerBoundDiagnosticsPacket {
pub mut:
	avg_fps                      f32
	avg_server_tick_time_ms      f32
	avg_client_tick_time_ms      f32
	avg_begin_frame_time_ms      f32
	avg_input_time_ms            f32
	avg_render_time_ms           f32
	avg_end_frame_time_ms        f32
	avg_remainder_time_percent   f32
	avg_unnacounted_time_percent f32
	memory_category_values       []MemoryCategoryCounter
	entity_diagnostics           []EntityDiagnosticTimingInfo
	system_diagnostics           []SystemDiagnosticTimingInfo
	system_categories            []SystemCategory
	whisker_scopes               []WhiskerScopeDataSummary
}

pub fn (p &ServerBoundDiagnosticsPacket) pid() u16 { return 315 }

pub fn (p &ServerBoundDiagnosticsPacket) name() string { return 'ServerBoundDiagnosticsPacket' }

pub fn (p &ServerBoundDiagnosticsPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ServerBoundDiagnosticsPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.avg_fps)
	w.le_f32(p.avg_server_tick_time_ms)
	w.le_f32(p.avg_client_tick_time_ms)
	w.le_f32(p.avg_begin_frame_time_ms)
	w.le_f32(p.avg_input_time_ms)
	w.le_f32(p.avg_render_time_ms)
	w.le_f32(p.avg_end_frame_time_ms)
	w.le_f32(p.avg_remainder_time_percent)
	w.le_f32(p.avg_unnacounted_time_percent)
	w.write_varuint32(u32(p.memory_category_values.len))
	for e in p.memory_category_values {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.entity_diagnostics.len))
	for e in p.entity_diagnostics {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.system_diagnostics.len))
	for e in p.system_diagnostics {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.system_categories.len))
	for e in p.system_categories {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.whisker_scopes.len))
	for e in p.whisker_scopes {
		e.encode(mut w)
	}
}

pub fn (mut p ServerBoundDiagnosticsPacket) decode_payload(mut r serializer.Reader) ! {
	p.avg_fps = r.le_f32()!
	p.avg_server_tick_time_ms = r.le_f32()!
	p.avg_client_tick_time_ms = r.le_f32()!
	p.avg_begin_frame_time_ms = r.le_f32()!
	p.avg_input_time_ms = r.le_f32()!
	p.avg_render_time_ms = r.le_f32()!
	p.avg_end_frame_time_ms = r.le_f32()!
	p.avg_remainder_time_percent = r.le_f32()!
	p.avg_unnacounted_time_percent = r.le_f32()!
	{
		count := int(r.read_varuint32()!)
		p.memory_category_values = []MemoryCategoryCounter{cap: count}
		for _ in 0 .. count {
			p.memory_category_values << MemoryCategoryCounter.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.entity_diagnostics = []EntityDiagnosticTimingInfo{cap: count}
		for _ in 0 .. count {
			p.entity_diagnostics << EntityDiagnosticTimingInfo.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.system_diagnostics = []SystemDiagnosticTimingInfo{cap: count}
		for _ in 0 .. count {
			p.system_diagnostics << SystemDiagnosticTimingInfo.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.system_categories = []SystemCategory{cap: count}
		for _ in 0 .. count {
			p.system_categories << SystemCategory.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.whisker_scopes = []WhiskerScopeDataSummary{cap: count}
		for _ in 0 .. count {
			p.whisker_scopes << WhiskerScopeDataSummary.decode(mut r)!
		}
	}
}
