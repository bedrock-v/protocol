module packets

import serializer

pub struct ResourcePackClientResponsePacket {
pub mut:
	status   u8
	pack_ids []string
}

pub fn (p &ResourcePackClientResponsePacket) pid() u16 {
	return 0x08
}

pub fn (p &ResourcePackClientResponsePacket) name() string {
	return 'ResourcePackClientResponsePacket'
}

pub fn (p &ResourcePackClientResponsePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePackClientResponsePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.status)
	w.le_i16(i16(p.pack_ids.len))
	for id in p.pack_ids {
		w.write_string(id)
	}
}

pub fn (mut p ResourcePackClientResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.status = r.u8()!
	n := int(r.le_i16()!)
	for _ in 0 .. n {
		p.pack_ids << r.read_string()!
	}
}
