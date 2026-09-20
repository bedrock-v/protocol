module main

import protocol
import protocol.serializer
import protocol.packets

fn roundtrip(p protocol.Packet, mut pool protocol.PacketPool) !protocol.Packet {
	encoded := protocol.encode_packet_to_bytes(p)
	mut r := serializer.new_reader(encoded)
	return pool.decode(mut r)!
}

fn main() {
	mut pool := protocol.new_pool()
	println('current proto=${protocol.protocol_id} mc=${protocol.minecraft_version}')
	println('Registered packet count: ${pool.factories.len}')

	req := &packets.RequestNetworkSettingsPacket{
		client_network_version: i32(protocol.protocol_id)
	}
	println('RequestNetworkSettings encoded: ${protocol.encode_packet_to_bytes(req).hex()}')
	d1 := roundtrip(req, mut pool)!
	if d1 is packets.RequestNetworkSettingsPacket {
		assert d1.client_network_version == i32(protocol.protocol_id)
		println('  -> client_network_version=${d1.client_network_version} OK')
	}

	dis := &packets.DisconnectPacket{}
	d2 := roundtrip(dis, mut pool)!
	if d2 is packets.DisconnectPacket {
		println('  Disconnect OK')
	}

	println('All current roundtrip checks passed.')
}
