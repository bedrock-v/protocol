module src

import src.serializer

pub struct ClientboundTextureShiftPacket {
pub mut:
	action_id            u8
	collection_name      string
	from_step            string
	to_step              string
	all_steps            []string
	current_length_ticks u64
	total_length_ticks   u64
	enabled              bool
}

pub fn (p &ClientboundTextureShiftPacket) pid() u16 {
	return clientbound_texture_shift_packet
}

pub fn (p &ClientboundTextureShiftPacket) name() string {
	return 'ClientboundTextureShiftPacket'
}

pub fn (p &ClientboundTextureShiftPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientboundTextureShiftPacket) decode_payload(mut r serializer.Reader) ! {
	p.action_id = r.u8()!
	p.collection_name = r.read_string()!
	p.from_step = r.read_string()!
	p.to_step = r.read_string()!
	count := r.read_varuint32()!
	p.all_steps = []string{}
	for _ in 0 .. count {
		p.all_steps << r.read_string()!
	}
	p.current_length_ticks = r.read_varuint64()!
	p.total_length_ticks = r.read_varuint64()!
	p.enabled = r.bool()!
}

pub fn (p &ClientboundTextureShiftPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.action_id)
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
