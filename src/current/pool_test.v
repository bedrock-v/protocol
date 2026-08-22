module current

import protocol
import protocol.serializer

// A packet the pool builds has to be the type a caller can name, or every
// dispatch written against this module silently falls through to its default.
fn test_the_pool_builds_packets_this_module_can_name() {
	mut pool := new_packet_pool()

	request := &RequestNetworkSettingsPacket{
		client_network_version: selected_protocol
	}
	mut reader := serializer.new_reader(protocol.encode_packet_to_bytes(request))
	decoded := pool.decode(mut reader)!
	assert decoded.name() == 'RequestNetworkSettingsPacket'
	if decoded is RequestNetworkSettingsPacket {
		assert decoded.client_network_version == selected_protocol
	} else {
		assert false, 'a decoded packet did not match the alias it was built from'
	}

	mut login_reader := serializer.new_reader(protocol.encode_packet_to_bytes(&LoginPacket{}))
	login := pool.decode(mut login_reader)!
	assert login is LoginPacket
}
