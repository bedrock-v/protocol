module packets

import protocol.serializer
import protocol.version.v34.types

pub struct CraftingEventPacket {
pub mut:
	window_id u8
	typ       i32
	uuid      []u8
	input     []types.Item
	output    []types.Item
}

pub fn (p &CraftingEventPacket) pid() u16 {
	return 0xbb
}

pub fn (p &CraftingEventPacket) name() string {
	return 'CraftingEventPacket'
}

pub fn (p &CraftingEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CraftingEventPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.window_id)
	w.be_i32(p.typ)
	w.write_raw(p.uuid)
	w.be_i32(i32(p.input.len))
	for s in p.input {
		s.encode(mut w)
	}
	w.be_i32(i32(p.output.len))
	for s in p.output {
		s.encode(mut w)
	}
}

pub fn (mut p CraftingEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.u8()!
	p.typ = r.be_i32()!
	p.uuid = r.read_raw(16)!
	icount := int(r.be_i32()!)
	for _ in 0 .. icount {
		p.input << types.Item.decode(mut r)!
	}
	ocount := int(r.be_i32()!)
	for _ in 0 .. ocount {
		p.output << types.Item.decode(mut r)!
	}
}
