module packets

import protocol.serializer
import protocol.version.v291.types

pub struct CraftingEventPacket {
pub mut:
	container_id  i8
	crafting_type i32
	uuid          types.Uuid
	inputs        []types.ItemData
	outputs       []types.ItemData
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
	w.i8(p.container_id)
	w.write_varint32(p.crafting_type)
	p.uuid.encode(mut w)
	w.write_varuint32(u32(p.inputs.len))
	for input in p.inputs {
		input.encode(mut w)
	}
	w.write_varuint32(u32(p.outputs.len))
	for output in p.outputs {
		output.encode(mut w)
	}
}

pub fn (mut p CraftingEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = r.i8()!
	p.crafting_type = r.read_varint32()!
	p.uuid = types.Uuid.decode(mut r)!
	input_count := r.read_count()!
	p.inputs = []types.ItemData{cap: serializer.prealloc(input_count)}
	for _ in 0 .. input_count {
		p.inputs << types.ItemData.decode(mut r)!
	}
	output_count := r.read_count()!
	p.outputs = []types.ItemData{cap: serializer.prealloc(output_count)}
	for _ in 0 .. output_count {
		p.outputs << types.ItemData.decode(mut r)!
	}
}
