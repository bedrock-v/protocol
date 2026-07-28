module packets

import protocol.serializer
import protocol.version.v100.types

pub struct CraftingEventPacket {
pub mut:
	window_id u8
	type      i32
	id        types.EraBUuid
	input     []types.EraBItem
	output    []types.EraBItem
}

pub fn (p &CraftingEventPacket) pid() u16 {
	return 0x36
}

pub fn (p &CraftingEventPacket) name() string {
	return 'CraftingEventPacket'
}

pub fn (p &CraftingEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CraftingEventPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.window_id)
	w.write_varint32(p.type)
	p.id.encode(mut w)
	w.write_varuint32(u32(p.input.len))
	for it in p.input {
		it.encode(mut w)
	}
	w.write_varuint32(u32(p.output.len))
	for it in p.output {
		it.encode(mut w)
	}
}

pub fn (mut p CraftingEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.u8()!
	p.type = r.read_varint32()!
	p.id = types.EraBUuid.decode(mut r)!
	n := int(r.read_varuint32()!)
	for _ in 0 .. n {
		p.input << types.EraBItem.decode(mut r)!
	}
	m := int(r.read_varuint32()!)
	for _ in 0 .. m {
		p.output << types.EraBItem.decode(mut r)!
	}
}
