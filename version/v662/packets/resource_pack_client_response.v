module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct ResourcePackClientResponsePacket {
pub mut:
	response          enums.ResourcePackResponse
	downloading_packs []string
}

pub fn (p &ResourcePackClientResponsePacket) pid() u16 {
	return 8
}

pub fn (p &ResourcePackClientResponsePacket) name() string {
	return 'ResourcePackClientResponsePacket'
}

pub fn (p &ResourcePackClientResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ResourcePackClientResponsePacket) encode_payload(mut w serializer.Writer) {
	p.response.encode(mut w)
	w.le_u16(u16(p.downloading_packs.len))
	for e in p.downloading_packs {
		w.write_string(e)
	}
}

pub fn (mut p ResourcePackClientResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.response = enums.ResourcePackResponse.decode(mut r)!
	{
		count := int(r.le_u16()!)
		p.downloading_packs = []string{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.downloading_packs << r.read_string()!
		}
	}
}
