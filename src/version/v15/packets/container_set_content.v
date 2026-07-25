module packets

import serializer
import version.v14.types

pub struct ContainerSetContentPacket {
pub mut:
	windowid u8
	slots    []types.OldItem
	hotbar   []i32
}

pub fn (p &ContainerSetContentPacket) pid() u16 {
	return 0xb4
}

pub fn (p &ContainerSetContentPacket) name() string {
	return 'ContainerSetContentPacket'
}

pub fn (p &ContainerSetContentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerSetContentPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
	w.be_i16(i16(p.slots.len))
	for slot in p.slots {
		slot.encode(mut w)
	}
	if p.windowid == 0 {
		w.be_i16(i16(p.hotbar.len))
		for v in p.hotbar {
			w.be_i32(v)
		}
	}
}

pub fn (mut p ContainerSetContentPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	count := int(r.be_u16()!)
	p.slots = []types.OldItem{cap: count}
	for _ in 0 .. count {
		p.slots << types.OldItem.decode(mut r)!
	}
	if p.windowid == 0 {
		hcount := int(r.be_u16()!)
		p.hotbar = []i32{cap: hcount}
		for _ in 0 .. hcount {
			p.hotbar << r.be_i32()!
		}
	}
}
