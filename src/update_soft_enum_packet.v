module src

import src.serializer

pub struct UpdateSoftEnumPacket {
pub mut:
	enum_name string
	values    []string
	type      int
}

pub fn (p &UpdateSoftEnumPacket) pid() u16 {
	return update_soft_enum_packet
}

pub fn (p &UpdateSoftEnumPacket) name() string {
	return 'UpdateSoftEnumPacket'
}

pub fn (p &UpdateSoftEnumPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdateSoftEnumPacket) decode_payload(mut r serializer.Reader) ! {
	p.enum_name = r.read_string()!
	count := int(r.read_varuint32()!)
	p.values = []string{cap: count}
	for _ in 0 .. count {
		p.values << r.read_string()!
	}
	p.type = int(r.u8()!)
}

pub fn (p &UpdateSoftEnumPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.enum_name)
	w.write_varuint32(u32(p.values.len))
	for value in p.values {
		w.write_string(value)
	}
	w.u8(u8(p.type))
}
