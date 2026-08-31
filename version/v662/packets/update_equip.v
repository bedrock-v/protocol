module packets

import protocol.serializer
import bedrock_v.nbt
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct UpdateEquipPacket {
pub mut:
	container_id    enums.ContainerID
	container_type  enums.ContainerType
	size            i32
	target_actor_id types.ActorUniqueID
	data_tags       nbt.RootTag
}

pub fn (p &UpdateEquipPacket) pid() u16 {
	return 81
}

pub fn (p &UpdateEquipPacket) name() string {
	return 'UpdateEquipPacket'
}

pub fn (p &UpdateEquipPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateEquipPacket) encode_payload(mut w serializer.Writer) {
	p.container_id.encode(mut w)
	p.container_type.encode(mut w)
	w.write_varint32(p.size)
	p.target_actor_id.encode(mut w)
	w.write_nbt_compound_root(p.data_tags)
}

pub fn (mut p UpdateEquipPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = enums.ContainerID.decode(mut r)!
	p.container_type = enums.ContainerType.decode(mut r)!
	p.size = r.read_varint32()!
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
	p.data_tags = r.read_nbt_compound_root()!
}
