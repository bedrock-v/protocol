module packets

import serializer

pub struct CraftingEntry {
pub mut:
	type    i32
	payload []u8
}

pub struct CraftingDataPacket {
pub mut:
	entries       []CraftingEntry
	clean_recipes bool
}

pub fn (p &CraftingDataPacket) pid() u16 {
	return 0x36
}

pub fn (p &CraftingDataPacket) name() string {
	return 'CraftingDataPacket'
}

pub fn (p &CraftingDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CraftingDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.entries.len))
	for e in p.entries {
		w.write_varint32(e.type)
		w.write_raw(e.payload)
	}
	w.u8(if p.clean_recipes { u8(1) } else { u8(0) })
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	n := int(r.read_varuint32()!)
	for _ in 0 .. n {
		p.entries << CraftingEntry{
			type: r.read_varint32()!
		}
	}
	p.clean_recipes = r.u8()! > 0
}
