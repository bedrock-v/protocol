module current

import nbt
import protocol.types as model

// The bridge between the version independent model types and the shapes the
// selected version puts on the wire. Callers work in model types and never
// have to know which of the two a packet happens to want.

// shield_runtime_id is the item the client draws a blocking pose for. It is a
// runtime id, so it moves with the item palette rather than with the protocol.
const shield_runtime_id = 358

pub fn actor_unique_id(value i64) ActorUniqueID {
	return ActorUniqueID{
		value: value
	}
}

pub fn actor_runtime_id(value u64) ActorRuntimeID {
	return ActorRuntimeID{
		value: value
	}
}

pub fn vec3(v model.Vector3) [3]f32 {
	return [v.x, v.y, v.z]!
}

pub fn vec3_from_array(v [3]f32) model.Vector3 {
	return model.Vector3{v[0], v[1], v[2]}
}

pub fn block_pos(v model.BlockPosition) NetworkBlockPosition {
	return NetworkBlockPosition{
		x: i32(v.x)
		y: i32(v.y)
		z: i32(v.z)
	}
}

pub fn block_pos_from(v NetworkBlockPosition) model.BlockPosition {
	return model.BlockPosition{
		x: int(v.x)
		y: int(v.y)
		z: int(v.z)
	}
}

// block_pos_from_legacy reads the older of the two block position shapes, which
// the packets that predate NetworkBlockPosition still carry.
pub fn block_pos_from_legacy(v BlockPos) model.BlockPosition {
	return model.BlockPosition{
		x: int(v.x)
		y: int(v.y)
		z: int(v.z)
	}
}

pub fn item_descriptor(item model.ItemStack) NetworkItemStackDescriptor {
	return NetworkItemStackDescriptor{
		id:               i16(item.id)
		stack_size:       u16(item.count)
		aux_value:        u32(item.meta)
		block_runtime_id: u32(item.block_runtime_id)
		user_data_buffer: item.raw_extra_data
		blocking:         item.id == shield_runtime_id
	}
}

pub fn item_instance(item model.ItemStack) NetworkItemInstanceDescriptor {
	return NetworkItemInstanceDescriptor{
		id:               i32(item.id)
		stack_size:       u16(item.count)
		aux_value:        u32(item.meta)
		block_runtime_id: i32(item.block_runtime_id)
		user_data_buffer: item.raw_extra_data
		blocking:         item.id == shield_runtime_id
	}
}

pub fn item_descriptor_v2(item model.ItemStack) NetworkItemStackDescriptorV2 {
	return item_descriptor_v2_tracked(item, 0)
}

pub fn item_descriptor_v2_tracked(item model.ItemStack, net_id int) NetworkItemStackDescriptorV2 {
	mut d := NetworkItemStackDescriptorV2{
		id:               i16(item.id)
		stack_size:       u16(item.count)
		aux_value:        u32(item.meta)
		block_runtime_id: u32(item.block_runtime_id)
		user_data_buffer: item.raw_extra_data
		blocking:         item.id == shield_runtime_id
	}
	if item.count > 0 && item.id != 0 && net_id != 0 {
		d.net_id = i32(net_id)
	}
	return d
}

pub fn item_stack_from_descriptor_v2(item NetworkItemStackDescriptorV2) model.ItemStack {
	return model.ItemStack{
		id:               int(item.id)
		count:            int(item.stack_size)
		meta:             int(item.aux_value)
		block_runtime_id: int(item.block_runtime_id)
		raw_extra_data:   item.user_data_buffer
	}
}

pub fn level_sound_event(event_name string, position model.Vector3, data i32, actor_identifier string, entity_unique_id u64) &LevelSoundEventPacket {
	mut packet := &LevelSoundEventPacket{
		event_name:       event_name
		data:             data
		actor_identifier: actor_identifier
		entity_unique_id: entity_unique_id
	}
	packet.position[0] = position.x
	packet.position[1] = position.y
	packet.position[2] = position.z
	return packet
}

pub fn rotation_byte(value f32) i8 {
	mut scaled := int(value * 256.0 / 360.0)
	scaled %= 256
	if scaled < 0 {
		scaled += 256
	}
	return i8(u8(scaled))
}

pub fn uuid_from_bytes(b []u8) Uuid {
	mut uuid := Uuid{}
	for i := 0; i < 16 && i < b.len; i++ {
		uuid.bytes[i] = b[i]
	}
	return uuid
}

pub fn empty_nbt() nbt.RootTag {
	return nbt.RootTag{
		name: ''
		tag:  nbt.Tag(nbt.new_compound())
	}
}

pub fn game_type(value int) GameType {
	return unsafe { GameType(value) }
}
