module types

import protocol.serializer

pub struct ItemUseTransaction {
pub mut:
	action_type     u32
	block_position  BlockPosition
	block_face      i32
	hotbar_slot     i32
	item_in_hand    ItemData
	player_position Vector3f
	click_position  Vector3f
}

pub fn (t ItemUseTransaction) encode(mut w serializer.Writer) {
	w.write_varuint32(t.action_type)
	t.block_position.encode(mut w)
	w.write_varint32(t.block_face)
	w.write_varint32(t.hotbar_slot)
	t.item_in_hand.encode(mut w)
	t.player_position.encode(mut w)
	t.click_position.encode(mut w)
}

pub fn ItemUseTransaction.decode(mut r serializer.Reader) !ItemUseTransaction {
	return ItemUseTransaction{
		action_type:     r.read_varuint32()!
		block_position:  BlockPosition.decode(mut r)!
		block_face:      r.read_varint32()!
		hotbar_slot:     r.read_varint32()!
		item_in_hand:    ItemData.decode(mut r)!
		player_position: Vector3f.decode(mut r)!
		click_position:  Vector3f.decode(mut r)!
	}
}
