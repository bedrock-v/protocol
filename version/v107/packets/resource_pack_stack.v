module packets

import protocol.serializer

pub struct ResourcePackStackEntry {
pub mut:
	pack_id string
	version string
}

pub struct ResourcePackStackPacket {
pub mut:
	must_accept     bool
	behaviour_stack []ResourcePackStackEntry
	resource_stack  []ResourcePackStackEntry
}

pub fn (p &ResourcePackStackPacket) pid() u16 {
	return 0x08
}

pub fn (p &ResourcePackStackPacket) name() string {
	return 'ResourcePackStackPacket'
}

pub fn (p &ResourcePackStackPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePackStackPacket) encode_payload(mut w serializer.Writer) {
	w.u8(if p.must_accept { u8(1) } else { u8(0) })
	w.le_i16(i16(p.behaviour_stack.len))
	for e in p.behaviour_stack {
		w.write_string(e.pack_id)
		w.write_string(e.version)
	}
	w.le_i16(i16(p.resource_stack.len))
	for e in p.resource_stack {
		w.write_string(e.pack_id)
		w.write_string(e.version)
	}
}

pub fn (mut p ResourcePackStackPacket) decode_payload(mut r serializer.Reader) ! {
	p.must_accept = r.u8()! > 0
	n := int(r.le_i16()!)
	for _ in 0 .. n {
		p.behaviour_stack << ResourcePackStackEntry{
			pack_id: r.read_string()!
			version: r.read_string()!
		}
	}
	m := int(r.le_i16()!)
	for _ in 0 .. m {
		p.resource_stack << ResourcePackStackEntry{
			pack_id: r.read_string()!
			version: r.read_string()!
		}
	}
}
