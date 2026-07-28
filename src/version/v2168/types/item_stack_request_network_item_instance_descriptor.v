module types

import serializer

pub struct ItemStackRequestNetworkItemInstanceDescriptor {
pub mut:
	ingredient       RecipeIngredient
	block_runtime_id u32
	user_data_buffer []u8
}

pub fn (t ItemStackRequestNetworkItemInstanceDescriptor) encode(mut w serializer.Writer) {
	t.ingredient.encode(mut w)
	w.write_varuint32(t.block_runtime_id)
	w.write_item_extra_data(t.user_data_buffer)
}

pub fn ItemStackRequestNetworkItemInstanceDescriptor.decode(mut r serializer.Reader) !ItemStackRequestNetworkItemInstanceDescriptor {
	return ItemStackRequestNetworkItemInstanceDescriptor{
		ingredient:       RecipeIngredient.decode(mut r)!
		block_runtime_id: r.read_varuint32()!
		user_data_buffer: r.read_item_extra_data()!
	}
}
