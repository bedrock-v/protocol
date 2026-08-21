// current is the protocol version the server speaks, behind names that do not
// move when that version changes. Every version specific detail lives in this
// module: a bump edits the values below and the aliases next to them, and
// leaves the callers alone.
module current

import protocol
import protocol.version
import protocol.version.v2192

pub const selected_protocol = 2192
pub const selected_minecraft_version = '1.26.50'

// player_auth_input_packet_id is looked up before a packet is decoded, so it
// cannot come from the pool.
pub const player_auth_input_packet_id = u16(144)

pub fn proto_version() version.ProtoVersion {
	return version.ProtoVersion.v2192
}

pub fn new_packet_pool() protocol.PacketPool {
	return v2192.new_pool()
}
