module packets

import serializer
import nbt
import version.v662.types

pub struct AddVolumeEntityPacket {
pub mut:
	entity_network_id types.EntityNetID
	components        nbt.RootTag
	json_identifier   string
	instance_name     string
	min_bounds        types.NetworkBlockPosition
	max_bounds        types.NetworkBlockPosition
	dimension_type    i32
	engine_version    string
}

pub fn (p &AddVolumeEntityPacket) pid() u16 { return 166 }

pub fn (p &AddVolumeEntityPacket) name() string { return 'AddVolumeEntityPacket' }

pub fn (p &AddVolumeEntityPacket) can_be_sent_before_login() bool { return false }

pub fn (p &AddVolumeEntityPacket) encode_payload(mut w serializer.Writer) {
	p.entity_network_id.encode(mut w)
	w.write_nbt_compound_root(p.components)
	w.write_string(p.json_identifier)
	w.write_string(p.instance_name)
	p.min_bounds.encode(mut w)
	p.max_bounds.encode(mut w)
	w.write_varint32(p.dimension_type)
	w.write_string(p.engine_version)
}

pub fn (mut p AddVolumeEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_network_id = types.EntityNetID.decode(mut r)!
	p.components = r.read_nbt_compound_root()!
	p.json_identifier = r.read_string()!
	p.instance_name = r.read_string()!
	p.min_bounds = types.NetworkBlockPosition.decode(mut r)!
	p.max_bounds = types.NetworkBlockPosition.decode(mut r)!
	p.dimension_type = r.read_varint32()!
	p.engine_version = r.read_string()!
}
