module src

import src.serializer
import src.types
import nbt

pub struct AddVolumeEntityPacket {
pub mut:
	entity_net_id   u32
	data            nbt.RootTag
	json_identifier string
	instance_name   string
	min_bound       types.BlockPosition
	max_bound       types.BlockPosition
	dimension       int
	engine_version  string
}

pub fn (p &AddVolumeEntityPacket) pid() u16 {
	return add_volume_entity_packet
}

pub fn (p &AddVolumeEntityPacket) name() string {
	return 'AddVolumeEntityPacket'
}

pub fn (p &AddVolumeEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AddVolumeEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_net_id = r.read_varuint32()!
	p.data = r.read_nbt_compound_root()!
	p.json_identifier = r.read_string()!
	p.instance_name = r.read_string()!
	p.min_bound = r.read_block_position()!
	p.max_bound = r.read_block_position()!
	p.dimension = r.read_varint32()!
	p.engine_version = r.read_string()!
}

pub fn (p &AddVolumeEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.entity_net_id)
	w.write_nbt_compound_root(p.data)
	w.write_string(p.json_identifier)
	w.write_string(p.instance_name)
	w.write_block_position(p.min_bound)
	w.write_block_position(p.max_bound)
	w.write_varint32(p.dimension)
	w.write_string(p.engine_version)
}
