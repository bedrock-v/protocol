module packets

import serializer

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
}
