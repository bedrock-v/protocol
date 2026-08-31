module types

import protocol.serializer
import protocol.version.v944.types as types_944

// The click's trigger and face travel as single unsigned bytes. Reading either
// as a varint costs nothing on the way out and mangles the way in: a face of 1
// comes back as -1 through zigzag, which points the placement at the block
// that was clicked instead of the space next to it.
fn test_the_byte_sized_fields_are_written_as_one_byte_each() {
	mut w := serializer.new_writer()
	UseItemTransactionData{
		action_type:  .place
		trigger_type: .player_input
		position:     types_944.NetworkBlockPosition{
			x: 1
			y: 2
			z: 3
		}
		face:         1
	}.encode(mut w)

	// action type, trigger, x, y, z, face - one byte apiece at these values.
	assert w.bytes()[0..6] == [u8(0), 1, 2, 4, 6, 1]
}

fn test_a_click_round_trips() {
	mut w := serializer.new_writer()
	UseItemTransactionData{
		action_type:  .destroy
		trigger_type: .simulation_tick
		position:     types_944.NetworkBlockPosition{
			x: 251
			y: 67
			z: -411
		}
		face:         4
		slot:         8
	}.encode(mut w)

	mut r := serializer.new_reader(w.bytes())
	read := UseItemTransactionData.decode(mut r)!
	assert read.action_type == .destroy
	assert read.trigger_type == .simulation_tick
	assert read.position.x == 251
	assert read.position.y == 67
	assert read.position.z == -411
	assert read.face == 4
	assert read.slot == 8
}
