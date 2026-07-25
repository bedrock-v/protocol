module unknown

import protocol
import version
import version.unknown.packets

pub const proto_version = version.ProtoVersion.unknown

pub fn new_pool() protocol.PacketPool {
	mut pool := protocol.new_empty_pool()
	pool.register(|| protocol.Packet(&packets.RequestNetworkSettingsPacket{}))
	return pool
}
