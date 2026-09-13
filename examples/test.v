import protocol
import protocol.serializer
import protocol.version
import protocol.current
import protocol.version.v662.packets as packets_662
import pool
import v

mut pool := current.new_pool()

println('proto=${current.proto_version.protocol_id()} mc=${current.proto_version.minecraft_version()}')

// encode any packet from the pool's version slice
packet := &packets_662.RequestNetworkSettingsPacket{
	client_network_version: i32(current.proto_version.protocol_id())
}

bytes := protocol.encode_packet_to_bytes(packet)

// decode straight from bytes
mut r := serializer.new_reader(bytes)

decoded := pool.decode(mut r)!

if decoded is packets_662.RequestNetworkSettingsPacket {
	println('decoded=${decoded.name()} client_network_version=${decoded.client_network_version}')
}

// pick a pool from a client's protocol id
v := version.from_protocol_id(1001)

println('selected=${v} mc=${v.minecraft_version()}')
