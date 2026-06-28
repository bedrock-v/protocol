module protocol

import serializer

pub struct ResourcePackClientResponsePacket {
pub mut:
	status   int
	pack_ids []string
}

pub fn (p &ResourcePackClientResponsePacket) pid() u16 {
	return resource_pack_client_response_packet
}

pub fn (p &ResourcePackClientResponsePacket) name() string {
	return 'ResourcePackClientResponsePacket'
}

pub fn (p &ResourcePackClientResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ResourcePackClientResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.status = int(r.u8()!)
	count := int(r.le_u16()!)
	p.pack_ids = []string{}
	for _ in 0 .. count {
		p.pack_ids << r.read_string()!
	}
}

pub fn (p &ResourcePackClientResponsePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.status))
	w.le_u16(u16(p.pack_ids.len))
	for id in p.pack_ids {
		w.write_string(id)
	}
}
