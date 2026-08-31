module packets

import protocol.serializer

pub struct ResourcePackEntry {
pub mut:
	pack_id string
	version string
	size    i64
}

pub struct ResourcePacksInfoPacket {
pub mut:
	must_accept     bool
	behaviour_packs []ResourcePackEntry
	resource_packs  []ResourcePackEntry
}

pub fn (p &ResourcePacksInfoPacket) pid() u16 {
	return 0x07
}

pub fn (p &ResourcePacksInfoPacket) name() string {
	return 'ResourcePacksInfoPacket'
}

pub fn (p &ResourcePacksInfoPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePacksInfoPacket) encode_payload(mut w serializer.Writer) {
	w.u8(if p.must_accept { u8(1) } else { u8(0) })
	w.be_i16(i16(p.behaviour_packs.len))
	for e in p.behaviour_packs {
		w.write_string(e.pack_id)
		w.write_string(e.version)
		w.be_i64(e.size)
	}
	w.be_i16(i16(p.resource_packs.len))
	for e in p.resource_packs {
		w.write_string(e.pack_id)
		w.write_string(e.version)
		w.be_i64(e.size)
	}
}

pub fn (mut p ResourcePacksInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.must_accept = r.u8()! > 0
	n := int(r.be_u16()!)
	for _ in 0 .. n {
		p.behaviour_packs << ResourcePackEntry{
			pack_id: r.read_string()!
			version: r.read_string()!
			size:    r.be_i64()!
		}
	}
	m := int(r.be_u16()!)
	for _ in 0 .. m {
		p.resource_packs << ResourcePackEntry{
			pack_id: r.read_string()!
			version: r.read_string()!
			size:    r.be_i64()!
		}
	}
}
