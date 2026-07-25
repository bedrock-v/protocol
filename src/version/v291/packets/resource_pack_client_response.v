module packets

import serializer

pub enum ResourcePackResponseStatus as u8 {
	@none          = 0
	refused        = 1
	send_packs     = 2
	have_all_packs = 3
	completed      = 4
}

pub struct ResourcePackClientResponsePacket {
pub mut:
	status   ResourcePackResponseStatus
	pack_ids []string
}

pub fn (p &ResourcePackClientResponsePacket) pid() u16 {
	return 8
}

pub fn (p &ResourcePackClientResponsePacket) name() string {
	return 'ResourcePackClientResponsePacket'
}

pub fn (p &ResourcePackClientResponsePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePackClientResponsePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.status))
	w.le_u16(u16(p.pack_ids.len))
	for pack_id in p.pack_ids {
		w.write_string(pack_id)
	}
}

pub fn (mut p ResourcePackClientResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.status = unsafe { ResourcePackResponseStatus(r.u8()!) }
	count := int(r.le_u16()!)
	p.pack_ids = []string{cap: count}
	for _ in 0 .. count {
		p.pack_ids << r.read_string()!
	}
}
