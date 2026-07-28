module packets

import protocol.serializer

pub struct CommandStepPacket {
pub mut:
	command      string
	overload     string
	uvarint1     u32
	current_step u32
	done         bool
	client_id    u64
	input_json   string
	output_json  string
	trailing     []u8
}

pub fn (p &CommandStepPacket) pid() u16 {
	return 0x4f
}

pub fn (p &CommandStepPacket) name() string {
	return 'CommandStepPacket'
}

pub fn (p &CommandStepPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CommandStepPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.command)
	w.write_string(p.overload)
	w.write_varuint32(p.uvarint1)
	w.write_varuint32(p.current_step)
	w.bool(p.done)
	w.write_varuint64(p.client_id)
	w.write_string(p.input_json)
	w.write_string(p.output_json)
	w.write_raw(p.trailing)
}

pub fn (mut p CommandStepPacket) decode_payload(mut r serializer.Reader) ! {
	p.command = r.read_string()!
	p.overload = r.read_string()!
	p.uvarint1 = r.read_varuint32()!
	p.current_step = r.read_varuint32()!
	p.done = r.bool()!
	p.client_id = r.read_varuint64()!
	p.input_json = r.read_string()!
	p.output_json = r.read_string()!
	p.trailing = r.read_raw(r.remaining())!
}
