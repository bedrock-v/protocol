module main

import protocol
import serializer
import version.v662
import version.v662.packets
import version.v662.types
import version.v662.enums

fn roundtrip(p protocol.Packet, mut pool protocol.PacketPool) !protocol.Packet {
	bytes := protocol.encode_packet_to_bytes(p)
	mut r := serializer.new_reader(bytes)
	return pool.decode(mut r)!
}

fn main() {
	println('proto=${v662.proto_version.protocol_id()} mc=${v662.proto_version.minecraft_version()}')
	mut pool := v662.new_pool()
	println('v662 registered: ${pool.factories.len}')

	// ActorEvent
	ae := &packets.ActorEventPacket{
		target_runtime_id: types.ActorRuntimeID{
			value: 123456
		}
		event_id: enums.ActorEvent.hurt
		data:     7
	}
	d1 := roundtrip(ae, mut pool)!
	if d1 is packets.ActorEventPacket {
		assert d1.data == 7
		assert d1.event_id == .hurt
		println('  ActorEvent OK')
	}

	// TextPacket - sum type + sub-stream discriminant split
	tp := &packets.TextPacket{
		message_type: enums.TextChat{
			player_name: 'eris'
			message:     'selam'
		}
		localize:    true
		sender_xuid: 'xuid123'
		platform_id: 'plat'
	}
	d2 := roundtrip(tp, mut pool)!
	if d2 is packets.TextPacket {
		assert d2.localize == true
		assert d2.sender_xuid == 'xuid123'
		if d2.message_type is enums.TextChat {
			assert d2.message_type.player_name == 'eris'
			assert d2.message_type.message == 'selam'
		} else {
			panic('text message_type wrong variant')
		}
		println('  TextPacket (sum type) OK')
	}

	// MovePlayer - PlayerPositionMode sum + sub-stream split + tuples
	mp := &packets.MovePlayerPacket{
		player_runtime_id: types.ActorRuntimeID{
			value: 42
		}
		position:        [f32(1.5), 2.5, 3.5]!
		rotation:        [f32(10.0), 20.0]!
		y_head_rotation: 30.0
		position_mode:   enums.PlayerPositionTeleport{
			teleportation_cause: 5
			source_actor_type:   9
		}
		on_ground:         true
		riding_runtime_id: types.ActorRuntimeID{
			value: 0
		}
		tick: 999
	}
	d3 := roundtrip(mp, mut pool)!
	if d3 is packets.MovePlayerPacket {
		assert d3.position[0] == 1.5
		assert d3.tick == 999
		assert d3.on_ground == true
		if d3.position_mode is enums.PlayerPositionTeleport {
			assert d3.position_mode.teleportation_cause == 5
			assert d3.position_mode.source_actor_type == 9
		} else {
			panic('move_player position_mode wrong variant')
		}
		println('  MovePlayer (sum + sub-stream + tuples) OK')
	}

	// UpdateAttributes - nested entry vecs
	ua := &packets.UpdateAttributesPacket{
		target_runtime_id: types.ActorRuntimeID{
			value: 7
		}
		attribute_list: [
			packets.AttributeData{
				min_value:      0.0
				max_value:      20.0
				current_value:  15.0
				default_value:  20.0
				attribute_name: 'minecraft:health'
				attribute_modifiers: []
			},
		]
		ticks_since_sim_started: 12345
	}
	d4 := roundtrip(ua, mut pool)!
	if d4 is packets.UpdateAttributesPacket {
		assert d4.attribute_list.len == 1
		assert d4.attribute_list[0].attribute_name == 'minecraft:health'
		assert d4.ticks_since_sim_started == 12345
		println('  UpdateAttributes (nested vecs) OK')
	}

	println('All v662 roundtrip tests passed.')
}
