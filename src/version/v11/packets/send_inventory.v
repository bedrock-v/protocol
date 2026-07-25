module packets

import serializer
import version.v14.types as types_14

pub struct SendInventoryPacket {
pub mut:
	eid      i32
	windowid u8
	slots    []types_14.OldItem
	armor    []types_14.OldItem
}

pub fn (p &SendInventoryPacket) pid() u16 {
	return 0xad
}

pub fn (p &SendInventoryPacket) name() string {
	return 'SendInventoryPacket'
}

pub fn (p &SendInventoryPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SendInventoryPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.u8(p.windowid)
	w.be_u16(u16(p.slots.len))
	for slot in p.slots {
		slot.encode(mut w)
	}
	if p.windowid == 1 {
		for i in 0 .. 4 {
			p.armor[i].encode(mut w)
		}
	}
}

pub fn (mut p SendInventoryPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.windowid = r.u8()!
	count := int(r.be_u16()!)
	p.slots = []types_14.OldItem{cap: count}
	for _ in 0 .. count {
		p.slots << types_14.OldItem.decode(mut r)!
	}
	if p.windowid == 1 {
		for _ in 0 .. 4 {
			p.armor << types_14.OldItem.decode(mut r)!
		}
	}
}
