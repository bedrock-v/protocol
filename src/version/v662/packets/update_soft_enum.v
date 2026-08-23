module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct UpdateSoftEnumPacket {
pub mut:
	enum_name   string
	values      []string
	update_type enums.SoftEnumUpdateType
}

pub fn (p &UpdateSoftEnumPacket) pid() u16 {
	return 114
}

pub fn (p &UpdateSoftEnumPacket) name() string {
	return 'UpdateSoftEnumPacket'
}

pub fn (p &UpdateSoftEnumPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateSoftEnumPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.enum_name)
	w.write_varuint32(u32(p.values.len))
	for e in p.values {
		w.write_string(e)
	}
	p.update_type.encode(mut w)
}

pub fn (mut p UpdateSoftEnumPacket) decode_payload(mut r serializer.Reader) ! {
	p.enum_name = r.read_string()!
	{
		count := r.read_count()!
		p.values = []string{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.values << r.read_string()!
		}
	}
	p.update_type = enums.SoftEnumUpdateType.decode(mut r)!
}
