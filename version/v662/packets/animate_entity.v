module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct AnimateEntityPacket {
pub mut:
	animation                      string
	next_state                     string
	stop_expression                string
	stop_expression_molang_version enums.MolangVersion
	controller                     string
	blend_out_time                 f32
	runtime_ids                    []types.ActorRuntimeID
}

pub fn (p &AnimateEntityPacket) pid() u16 {
	return 158
}

pub fn (p &AnimateEntityPacket) name() string {
	return 'AnimateEntityPacket'
}

pub fn (p &AnimateEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AnimateEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.animation)
	w.write_string(p.next_state)
	w.write_string(p.stop_expression)
	p.stop_expression_molang_version.encode(mut w)
	w.write_string(p.controller)
	w.le_f32(p.blend_out_time)
	w.write_varuint32(u32(p.runtime_ids.len))
	for e in p.runtime_ids {
		e.encode(mut w)
	}
}

pub fn (mut p AnimateEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.animation = r.read_string()!
	p.next_state = r.read_string()!
	p.stop_expression = r.read_string()!
	p.stop_expression_molang_version = enums.MolangVersion.decode(mut r)!
	p.controller = r.read_string()!
	p.blend_out_time = r.le_f32()!
	{
		count := r.read_count()!
		p.runtime_ids = []types.ActorRuntimeID{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.runtime_ids << types.ActorRuntimeID.decode(mut r)!
		}
	}
}
