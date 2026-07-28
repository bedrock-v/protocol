module main

import protocol
import protocol.serializer
import protocol.version
import protocol.version.v1001
import protocol.version.v1001.packets
import protocol.version.v662.packets as packets_662

fn roundtrip(p protocol.Packet, mut pool protocol.PacketPool) !protocol.Packet {
	encoded := protocol.encode_packet_to_bytes(p)
	mut r := serializer.new_reader(encoded)
	return pool.decode(mut r)!
}

fn main() {
	mut pool := v1001.new_pool()
	println('v1001 proto=${v1001.proto_version.protocol_id()} mc=${v1001.proto_version.minecraft_version()}')
	println('Registered packet count: ${pool.factories.len}')

	req := &packets_662.RequestNetworkSettingsPacket{
		client_network_version: i32(version.ProtoVersion.v1001.protocol_id())
	}
	println('RequestNetworkSettings encoded: ${protocol.encode_packet_to_bytes(req).hex()}')
	d1 := roundtrip(req, mut pool)!
	if d1 is packets_662.RequestNetworkSettingsPacket {
		assert d1.client_network_version == i32(version.ProtoVersion.v1001.protocol_id())
		println('  -> client_network_version=${d1.client_network_version} OK')
	}

	dis := &packets.DisconnectPacket{}
	d2 := roundtrip(dis, mut pool)!
	if d2 is packets.DisconnectPacket {
		println('  Disconnect OK')
	}

	println('All v1001 roundtrip checks passed.')
}
