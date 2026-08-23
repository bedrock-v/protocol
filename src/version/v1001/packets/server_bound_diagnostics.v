module packets

import protocol.serializer

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
	whisker_scopes               []WhiskerScopeDataSummary
}

pub fn (p &ServerBoundDiagnosticsPacket) pid() u16 {
	return 315
}

pub fn (p &ServerBoundDiagnosticsPacket) name() string {
	return 'ServerBoundDiagnosticsPacket'
}

pub fn (p &ServerBoundDiagnosticsPacket) can_be_sent_before_login() bool {
	return false
}

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
		count := r.read_count()!
		p.memory_category_values = []MemoryCategoryCounter{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.memory_category_values << MemoryCategoryCounter.decode(mut r)!
		}
	}
	{
		count := r.read_count()!
		p.entity_diagnostics = []EntityDiagnosticTimingInfo{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.entity_diagnostics << EntityDiagnosticTimingInfo.decode(mut r)!
		}
	}
	{
		count := r.read_count()!
		p.system_diagnostics = []SystemDiagnosticTimingInfo{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.system_diagnostics << SystemDiagnosticTimingInfo.decode(mut r)!
		}
	}
	{
		count := r.read_count()!
		p.whisker_scopes = []WhiskerScopeDataSummary{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.whisker_scopes << WhiskerScopeDataSummary.decode(mut r)!
		}
	}
}

pub struct WhiskerScopeDataSummary {
pub mut:
	label              string
	indentation        string
	total_high_cost_ns i64
	total_mid_cost_ns  i64
	total_low_cost_ns  i64
}

pub fn (t WhiskerScopeDataSummary) encode(mut w serializer.Writer) {
	w.write_string(t.label)
	w.write_string(t.indentation)
	w.le_i64(t.total_high_cost_ns)
	w.le_i64(t.total_mid_cost_ns)
	w.le_i64(t.total_low_cost_ns)
}

pub fn WhiskerScopeDataSummary.decode(mut r serializer.Reader) !WhiskerScopeDataSummary {
	return WhiskerScopeDataSummary{
		label:              r.read_string()!
		indentation:        r.read_string()!
		total_high_cost_ns: r.le_i64()!
		total_mid_cost_ns:  r.le_i64()!
		total_low_cost_ns:  r.le_i64()!
	}
}

pub struct MemoryCategoryCounter {
pub mut:
	category      MemoryCategoryCounterType
	current_bytes i64
}

pub fn (t MemoryCategoryCounter) encode(mut w serializer.Writer) {
	t.category.encode(mut w)
	w.le_i64(t.current_bytes)
}

pub fn MemoryCategoryCounter.decode(mut r serializer.Reader) !MemoryCategoryCounter {
	return MemoryCategoryCounter{
		category:      MemoryCategoryCounterType.decode(mut r)!
		current_bytes: r.le_i64()!
	}
}

pub enum MemoryCategoryCounterType as u8 {
	unknown                                    = 0
	invalid_size_unknown                       = 1
	actor                                      = 2
	actor_animation                            = 3
	actor_rendering                            = 4
	block_ticking_queues                       = 5
	biome_storage                              = 6
	cereal                                     = 7
	circuit_system                             = 8
	client                                     = 9
	commands                                   = 10
	db_storage                                 = 11
	debug                                      = 12
	documentation                              = 13
	ecs_systems                                = 14
	fmod                                       = 15
	fonts                                      = 16
	im_gui                                     = 17
	input                                      = 18
	json_ui                                    = 19
	json_ui_control_factory_json               = 20
	json_ui_control_tree                       = 21
	json_ui_control_tree_control_element       = 22
	json_ui_control_tree_populate_data_binding = 23
	json_ui_control_tree_populate_focus        = 24
	json_ui_control_tree_populate_layout       = 25
	json_ui_control_tree_populate_other        = 26
	json_ui_control_tree_populate_sprite       = 27
	json_ui_control_tree_populate_text         = 28
	json_ui_control_tree_populate_tts          = 29
	json_ui_control_tree_visibility            = 30
	json_ui_create_ui                          = 31
	json_ui_defs                               = 32
	json_ui_layout_manager                     = 33
	json_ui_layout_manager_remove_dependencies = 34
	json_ui_layout_manager_init_variable       = 35
	languages                                  = 36
	level                                      = 37
	level_structures                           = 38
	level_chunk                                = 39
	level_chunk_gen                            = 40
	level_chunk_gen_thread_local               = 41
	light_volume_manager                       = 42
	network                                    = 43
	marketplace                                = 44
	material_dragon_compiled_definition        = 45
	material_dragon_material                   = 46
	material_dragon_resource                   = 47
	material_dragon_uniform_map                = 48
	material_render_material                   = 49
	material_render_material_group             = 50
	material_variation_manager                 = 51
	mo_lang                                    = 52
	ore_ui                                     = 53
	persona                                    = 54
	player                                     = 55
	render_chunk                               = 56
	render_chunk_index_buffer                  = 57
	render_chunk_vertex_buffer                 = 58
	rendering                                  = 59
	rendering_library                          = 60
	request_log                                = 61
	resource_packs                             = 62
	sound                                      = 63
	sub_chunk_biome_data                       = 64
	sub_chunk_block_data                       = 65
	sub_chunk_light_data                       = 66
	textures                                   = 67
	vr                                         = 68
	weather_renderer                           = 69
	world_generator                            = 70
	tasks                                      = 71
	test                                       = 72
	scripting                                  = 73
	scripting_runtime                          = 74
	scripting_context                          = 75
	scripting_context_bindings_mc              = 76
	scripting_context_bindings_gt              = 77
	scripting_context_run                      = 78
	data_driven_ui                             = 79
	data_driven_ui_defs                        = 80
	gameface                                   = 81
	gameface_system                            = 82
	gameface_dom                               = 83
	gameface_css                               = 84
	gameface_display                           = 85
	gameface_temp_allocator                    = 86
	gameface_pool_allocator                    = 87
	gameface_dump                              = 88
	gameface_media                             = 89
	gameface_json                              = 90
	gameface_script_engine                     = 91
}

pub fn (e MemoryCategoryCounterType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn MemoryCategoryCounterType.decode(mut r serializer.Reader) !MemoryCategoryCounterType {
	return unsafe { MemoryCategoryCounterType(r.u8()!) }
}

pub struct EntityDiagnosticTimingInfo {
pub mut:
	display_name  string
	entity        string
	ns_time       i64
	total_percent u8
}

pub fn (t EntityDiagnosticTimingInfo) encode(mut w serializer.Writer) {
	w.write_string(t.display_name)
	w.write_string(t.entity)
	w.le_i64(t.ns_time)
	w.u8(t.total_percent)
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

pub fn (t SystemDiagnosticTimingInfo) encode(mut w serializer.Writer) {
	w.write_string(t.display_name)
	w.le_i64(t.system_index)
	w.le_i64(t.ns_time)
	w.u8(t.total_percent)
}

pub fn SystemDiagnosticTimingInfo.decode(mut r serializer.Reader) !SystemDiagnosticTimingInfo {
	return SystemDiagnosticTimingInfo{
		display_name:  r.read_string()!
		system_index:  r.le_i64()!
		ns_time:       r.le_i64()!
		total_percent: r.u8()!
	}
}
