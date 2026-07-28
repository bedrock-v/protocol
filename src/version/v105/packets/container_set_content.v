module packets

import protocol.serializer
import protocol.version.v105.types

pub struct ContainerSetContentPacket {
pub mut:
	windowid u8
	slots    []types.EraBItem
	hotbar   []i32
}

pub fn (p &ContainerSetContentPacket) pid() u16 {
	return 0x35
}

pub fn (p &ContainerSetContentPacket) name() string {
	return 'ContainerSetContentPacket'
}

pub fn (p &ContainerSetContentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerSetContentPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
	w.write_varuint32(u32(p.slots.len))
	for s in p.slots {
		s.encode(mut w)
	}
	if p.windowid == 0 && p.hotbar.len > 0 {
		w.write_varuint32(u32(p.hotbar.len))
		for h in p.hotbar {
			w.write_varint32(h)
		}
	} else {
		w.write_varuint32(0)
	}
}

pub fn (mut p ContainerSetContentPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	n := int(r.read_varuint32()!)
	for _ in 0 .. n {
		p.slots << types.EraBItem.decode(mut r)!
	}
	if p.windowid == 0 {
		m := int(r.read_varuint32()!)
		for _ in 0 .. m {
			p.hotbar << r.read_varint32()!
		}
	}
}
