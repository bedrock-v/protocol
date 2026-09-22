module main

import protocol
import protocol.serializer

const known_zero_value_failures = [
	'AddVolumeEntityPacket',
	'AvailableActorIdentifiersPacket',
	'BlockActorDataPacket',
	'ClientBoundDebugRendererPacket',
	'EditorNetworkPacket',
	'JigsawStructureDataPacket',
	'MovementPredictionSyncPacket',
	'PositionTrackingDBServerBroadcastPacket',
	'StartGamePacket',
	'SyncActorPropertyPacket',
	'UpdateEquipPacket',
	'UpdateTradePacket',
]

// registered_packet_count is the size of the manifest the flattening followed.
// A packet quietly dropped from the pool would make every other check here
// pass while losing its coverage.
const registered_packet_count = 231

fn round_trip(pool protocol.PacketPool, id u16) !protocol.Packet {
	original := pool.get_packet_by_id(id) or { return error('pid ${id} is not registered') }
	bytes := protocol.encode_packet_to_bytes(original)
	mut r := serializer.new_reader(bytes)
	return pool.decode(mut r)!
}

fn test_pool_registers_the_whole_manifest() {
	pool := protocol.new_pool()
	assert pool.factories.len == registered_packet_count
}

fn test_every_registered_packet_round_trips() {
	pool := protocol.new_pool()
	mut failures := []string{}

	for id, factory in pool.factories {
		name := factory().name()
		decoded := round_trip(pool, id) or {
			failures << name
			continue
		}
		if decoded.pid() != id {
			failures << name
			continue
		}
		if '${factory()}' != '${decoded}' {
			failures << name
			continue
		}
	}
	failures.sort()

	mut expected := known_zero_value_failures.clone()
	expected.sort()

	regressions := failures.filter(it !in expected)
	fixed := expected.filter(it !in failures)

	println('round-tripped ${pool.factories.len - failures.len} of ${pool.factories.len} packets')
	if regressions.len > 0 {
		println('packets that stopped round-tripping: ${regressions}')
	}
	if fixed.len > 0 {
		println('packets that now round trip and can leave the list: ${fixed}')
	}

	assert regressions.len == 0
	assert fixed.len == 0
}
