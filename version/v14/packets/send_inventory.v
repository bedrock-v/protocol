module packets

import protocol.serializer
import protocol.version.v14.types

pub struct SendInventoryPacket {
pub mut:
	eid      i32
	windowid u8
	slots    []types.OldItem
	armor    []types.OldItem
}

pub fn (p &SendInventoryPacket) pid() u16 {
	return 0xae
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
	w.be_i16(i16(p.slots.len))
	for slot in p.slots {
		slot.encode(mut w)
	}
	if p.windowid == 1 {
		for slot in p.armor {
			slot.encode(mut w)
		}
	}
}

pub fn (mut p SendInventoryPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.windowid = r.u8()!
	count := int(r.be_u16()!)
	p.slots = []types.OldItem{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.slots << types.OldItem.decode(mut r)!
	}
	if p.windowid == 1 {
		p.armor = []types.OldItem{cap: 4}
		for _ in 0 .. 4 {
			p.armor << types.OldItem.decode(mut r)!
		}
	}
}
