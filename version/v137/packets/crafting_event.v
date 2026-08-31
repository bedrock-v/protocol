module packets

import protocol.serializer
import protocol.version.v137.types

pub struct CraftingEventPacket {
pub mut:
	window_id u8
	type      i32
	id        types.Uuid
	input     []types.ItemData
	output    []types.ItemData
}

pub fn (p &CraftingEventPacket) pid() u16 {
	return 53
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
	for item in p.input {
		item.encode(mut w)
	}
	w.write_varuint32(u32(p.output.len))
	for item in p.output {
		item.encode(mut w)
	}
}

pub fn (mut p CraftingEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.u8()!
	p.type = r.read_varint32()!
	p.id = types.Uuid.decode(mut r)!
	input_count := r.read_count()!
	p.input = []types.ItemData{cap: serializer.prealloc(input_count)}
	for _ in 0 .. input_count {
		p.input << types.ItemData.decode(mut r)!
	}
	output_count := r.read_count()!
	p.output = []types.ItemData{cap: serializer.prealloc(output_count)}
	for _ in 0 .. output_count {
		p.output << types.ItemData.decode(mut r)!
	}
}
