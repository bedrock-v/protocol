module protocol

import serializer

pub struct MemoryCategoryCounter {
pub mut:
	category u8
	bytes    u64
}

pub struct EntityDiagnosticTimingInfo {
pub mut:
	display_name     string
	entity           string
	time_in_ns       u64
	percent_of_total u8
}

pub struct SystemDiagnosticTimingInfo {
pub mut:
	display_name     string
	system_index     u64
	time_in_ns       u64
	percent_of_total u8
}

pub struct WhiskerScopeDataSummary {
pub mut:
	label              string
	indentation        string
	total_high_cost_ns u64
	total_mid_cost_ns  u64
	total_low_cost_ns  u64
}

pub struct ServerboundDiagnosticsPacket {
pub mut:
	avg_fps                       f32
	avg_server_sim_tick_time_ms   f32
	avg_client_sim_tick_time_ms   f32
	avg_begin_frame_time_ms       f32
	avg_input_time_ms             f32
	avg_render_time_ms            f32
	avg_end_frame_time_ms         f32
	avg_remainder_time_percent    f32
	avg_unaccounted_time_percent  f32
	memory_category_values        []MemoryCategoryCounter
	entity_diagnostics            []EntityDiagnosticTimingInfo
	system_diagnostics            []SystemDiagnosticTimingInfo
	whisker_scopes                []WhiskerScopeDataSummary
}

pub fn (p &ServerboundDiagnosticsPacket) pid() u16 {
	return serverbound_diagnostics_packet
}

pub fn (p &ServerboundDiagnosticsPacket) name() string {
	return 'ServerboundDiagnosticsPacket'
}

pub fn (p &ServerboundDiagnosticsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerboundDiagnosticsPacket) decode_payload(mut r serializer.Reader) ! {
	p.avg_fps = r.le_f32()!
	p.avg_server_sim_tick_time_ms = r.le_f32()!
	p.avg_client_sim_tick_time_ms = r.le_f32()!
	p.avg_begin_frame_time_ms = r.le_f32()!
	p.avg_input_time_ms = r.le_f32()!
	p.avg_render_time_ms = r.le_f32()!
	p.avg_end_frame_time_ms = r.le_f32()!
	p.avg_remainder_time_percent = r.le_f32()!
	p.avg_unaccounted_time_percent = r.le_f32()!

	mem_count := r.read_varuint32()!
	p.memory_category_values = []MemoryCategoryCounter{}
	for _ in 0 .. mem_count {
		p.memory_category_values << MemoryCategoryCounter{
			category: r.u8()!
			bytes:    r.le_u64()!
		}
	}
	entity_count := r.read_varuint32()!
	p.entity_diagnostics = []EntityDiagnosticTimingInfo{}
	for _ in 0 .. entity_count {
		p.entity_diagnostics << EntityDiagnosticTimingInfo{
			display_name:     r.read_string()!
			entity:           r.read_string()!
			time_in_ns:       r.le_u64()!
			percent_of_total: r.u8()!
		}
	}
	system_count := r.read_varuint32()!
	p.system_diagnostics = []SystemDiagnosticTimingInfo{}
	for _ in 0 .. system_count {
		p.system_diagnostics << SystemDiagnosticTimingInfo{
			display_name:     r.read_string()!
			system_index:     r.le_u64()!
			time_in_ns:       r.le_u64()!
			percent_of_total: r.u8()!
		}
	}
	whisker_count := r.read_varuint32()!
	p.whisker_scopes = []WhiskerScopeDataSummary{}
	for _ in 0 .. whisker_count {
		p.whisker_scopes << WhiskerScopeDataSummary{
			label:              r.read_string()!
			indentation:        r.read_string()!
			total_high_cost_ns: r.le_u64()!
			total_mid_cost_ns:  r.le_u64()!
			total_low_cost_ns:  r.le_u64()!
		}
	}
}

pub fn (p &ServerboundDiagnosticsPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.avg_fps)
	w.le_f32(p.avg_server_sim_tick_time_ms)
	w.le_f32(p.avg_client_sim_tick_time_ms)
	w.le_f32(p.avg_begin_frame_time_ms)
	w.le_f32(p.avg_input_time_ms)
	w.le_f32(p.avg_render_time_ms)
	w.le_f32(p.avg_end_frame_time_ms)
	w.le_f32(p.avg_remainder_time_percent)
	w.le_f32(p.avg_unaccounted_time_percent)

	w.write_varuint32(u32(p.memory_category_values.len))
	for m in p.memory_category_values {
		w.u8(m.category)
		w.le_u64(m.bytes)
	}
	w.write_varuint32(u32(p.entity_diagnostics.len))
	for e in p.entity_diagnostics {
		w.write_string(e.display_name)
		w.write_string(e.entity)
		w.le_u64(e.time_in_ns)
		w.u8(e.percent_of_total)
	}
	w.write_varuint32(u32(p.system_diagnostics.len))
	for s in p.system_diagnostics {
		w.write_string(s.display_name)
		w.le_u64(s.system_index)
		w.le_u64(s.time_in_ns)
		w.u8(s.percent_of_total)
	}
	w.write_varuint32(u32(p.whisker_scopes.len))
	for ws in p.whisker_scopes {
		w.write_string(ws.label)
		w.write_string(ws.indentation)
		w.le_u64(ws.total_high_cost_ns)
		w.le_u64(ws.total_mid_cost_ns)
		w.le_u64(ws.total_low_cost_ns)
	}
}
