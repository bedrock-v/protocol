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

// A click on a block arrives in the standalone transaction packet, and the
// body behind its type is what says where and what was clicked. Reading the
// type but not the body leaves the click looking like nothing happened.
fn test_an_item_use_transaction_carries_its_click() {
	sent := &InventoryTransactionPacket{
		transaction_type: .item_use_transaction
		use_item:         UseItemTransactionData{
			action_type: .place
			position:    NetworkBlockPosition{
				x: 251
				y: 67
				z: -411
			}
			face:        1
			slot:        3
			trigger_type: .player_input
		}
	}
	mut pool := new_packet_pool()
	mut reader := serializer.new_reader(protocol.encode_packet_to_bytes(sent))
	decoded := pool.decode(mut reader)!
	if decoded is InventoryTransactionPacket {
		click := decoded.use_item or {
			assert false, 'the item use body was not read back'
			return
		}
		assert click.action_type == .place
		assert click.position.x == 251
		assert click.position.y == 67
		assert click.position.z == -411
		assert click.face == 1
		assert click.slot == 3
		assert click.trigger_type == .player_input
	} else {
		assert false, 'the packet did not decode as an InventoryTransactionPacket'
	}
}

// Every other transaction type leaves the body alone rather than reading one
// that is not there.
fn test_a_normal_transaction_has_no_click() {
	mut pool := new_packet_pool()
	mut reader := serializer.new_reader(protocol.encode_packet_to_bytes(&InventoryTransactionPacket{
		transaction_type: .normal_transaction
	}))
	decoded := pool.decode(mut reader)!
	if decoded is InventoryTransactionPacket {
		assert decoded.use_item == none
	} else {
		assert false, 'the packet did not decode as an InventoryTransactionPacket'
	}
}
