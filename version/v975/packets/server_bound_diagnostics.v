module packets

import protocol.serializer

pub enum MemoryCategoryCounterType as u8 {
	unknown                                    = 0
	invalid_size_unknown                       = 1
	actor                                      = 2
	actor_animation                            = 3
	actor_rendering                            = 4
	balancer                                   = 5
	block_ticking_queues                       = 6
	biome_storage                              = 7
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
	memory_count := r.read_count()!
	p.memory_category_values = []MemoryCategoryCounter{cap: serializer.prealloc(memory_count)}
	for _ in 0 .. memory_count {
		p.memory_category_values << MemoryCategoryCounter.decode(mut r)!
	}
	entity_count := r.read_count()!
	p.entity_diagnostics = []EntityDiagnosticTimingInfo{cap: serializer.prealloc(entity_count)}
	for _ in 0 .. entity_count {
		p.entity_diagnostics << EntityDiagnosticTimingInfo.decode(mut r)!
	}
	system_count := r.read_count()!
	p.system_diagnostics = []SystemDiagnosticTimingInfo{cap: serializer.prealloc(system_count)}
	for _ in 0 .. system_count {
		p.system_diagnostics << SystemDiagnosticTimingInfo.decode(mut r)!
	}
}
