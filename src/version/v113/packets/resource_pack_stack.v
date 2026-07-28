module packets

import protocol.serializer

pub struct PackStackEntry {
pub mut:
	pack_id string
	version string
}

pub struct ResourcePackStackPacket {
pub mut:
	must_accept     bool
	behaviour_stack []PackStackEntry
	resource_stack  []PackStackEntry
}

pub fn (p &ResourcePackStackPacket) pid() u16 {
	return 0x07
}

pub fn (p &ResourcePackStackPacket) name() string {
	return 'ResourcePackStackPacket'
}

pub fn (p &ResourcePackStackPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePackStackPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.must_accept)
	w.write_varuint32(u32(p.behaviour_stack.len))
	for e in p.behaviour_stack {
		w.write_string(e.pack_id)
		w.write_string(e.version)
	}
	w.write_varuint32(u32(p.resource_stack.len))
	for e in p.resource_stack {
		w.write_string(e.pack_id)
		w.write_string(e.version)
	}
}

pub fn (mut p ResourcePackStackPacket) decode_payload(mut r serializer.Reader) ! {
	p.must_accept = r.bool()!
	n := int(r.read_varuint32()!)
	for _ in 0 .. n {
		p.behaviour_stack << PackStackEntry{
			pack_id: r.read_string()!
			version: r.read_string()!
		}
	}
	m := int(r.read_varuint32()!)
	for _ in 0 .. m {
		p.resource_stack << PackStackEntry{
			pack_id: r.read_string()!
			version: r.read_string()!
		}
	}
}
