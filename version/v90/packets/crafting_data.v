module packets

import protocol.serializer

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
	return 0x31
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
		w.be_i32(e.type)
		w.be_i32(i32(e.payload.len))
		w.write_raw(e.payload)
	}
	w.u8(if p.clean_recipes { u8(1) } else { u8(0) })
}

pub fn (mut p CraftingDataPacket) decode_payload(mut r serializer.Reader) ! {
	n := int(r.be_i32()!)
	for _ in 0 .. n {
		t := r.be_i32()!
		l := int(r.be_i32()!)
		mut payload := []u8{}
		if l > 0 {
			payload = r.read_raw(l)!
		}
		p.entries << CraftingEntry{
			type:    t
			payload: payload
		}
	}
	p.clean_recipes = r.u8()! > 0
}
