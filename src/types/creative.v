module types

pub struct CreativeGroupEntry {
pub mut:
	category_id   int
	category_name string
	icon          ItemStack
}

pub struct CreativeItemEntry {
pub mut:
	entry_id int
	item     ItemStack
	group_id int
}
