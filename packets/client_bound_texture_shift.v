module packets

import protocol.serializer

pub enum ClientBoundTextureShiftAction as u8 {
	invalid     = 0
	initialize  = 1
	start       = 2
	set_enabled = 3
	sync        = 4
}

pub struct ClientBoundTextureShiftPacket {
pub mut:
	action               ClientBoundTextureShiftAction
	collection_name      string
	from_step            string
	to_step              string
	all_steps            []string
	current_length_ticks u64
	total_length_ticks   u64
	enabled              bool
}

pub fn (p &ClientBoundTextureShiftPacket) pid() u16 {
	return 336
}

pub fn (p &ClientBoundTextureShiftPacket) name() string {
	return 'ClientBoundTextureShiftPacket'
}

pub fn (p &ClientBoundTextureShiftPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundTextureShiftPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.action))
	w.write_string(p.collection_name)
	w.write_string(p.from_step)
	w.write_string(p.to_step)
	w.write_varuint32(u32(p.all_steps.len))
	for s in p.all_steps {
		w.write_string(s)
	}
	w.write_varuint64(p.current_length_ticks)
	w.write_varuint64(p.total_length_ticks)
	w.bool(p.enabled)
}

pub fn (mut p ClientBoundTextureShiftPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { ClientBoundTextureShiftAction(r.u8()!) }
	p.collection_name = r.read_string()!
	p.from_step = r.read_string()!
	p.to_step = r.read_string()!
	count := r.read_count()!
	p.all_steps = []string{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.all_steps << r.read_string()!
	}
	p.current_length_ticks = r.read_varuint64()!
	p.total_length_ticks = r.read_varuint64()!
	p.enabled = r.bool()!
}
