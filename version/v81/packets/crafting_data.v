module packets

import protocol.serializer

pub struct CraftingEntry {
pub mut:
	typ  i32
	body []u8
}

pub struct CraftingDataPacket {
pub mut:
	entries       []CraftingEntry
	clean_recipes bool
}

pub fn (p &CraftingDataPacket) pid() u16 {
	return 0x2f
}

pub fn (p &CraftingDataPacket) name() string {
	return 'CraftingDataPacket'
}

pub fn (p &CraftingDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CraftingDataPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(i32(p.entries.len))
	for e in p.entries {
		w.be_i32(e.typ)
		w.be_i32(i32(e.body.len))
		w.write_raw(e.body)
	}
	w.u8(if p.clean_recipes { u8(1) } else { u8(0) })
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.be_i32()!)
	for _ in 0 .. count {
		typ := r.be_i32()!
		blen := int(r.be_i32()!)
		body := r.read_raw(blen)!
		p.entries << CraftingEntry{
			typ:  typ
			body: body
		}
	}
	p.clean_recipes = r.u8()! > 0
}
