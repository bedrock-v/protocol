module protocol


pub fn (mut r Reader) read_creative_item_net_id() !int {
	return int(r.read_varuint32()!)
}

pub fn (mut w Writer) write_creative_item_net_id(id int) {
	w.write_varuint32(u32(id))
}

pub fn (mut r Reader) read_creative_group_entry() !CreativeGroupEntry {
	return CreativeGroupEntry{
		category_id:   int(r.le_i32()!)
		category_name: r.read_string()!
		icon:          r.read_item_stack_without_stack_id()!
	}
}

pub fn (mut w Writer) write_creative_group_entry(entry CreativeGroupEntry) {
	w.le_i32(i32(entry.category_id))
	w.write_string(entry.category_name)
	w.write_item_stack_without_stack_id(entry.icon)
}

pub fn (mut r Reader) read_creative_item_entry() !CreativeItemEntry {
	entry_id := r.read_creative_item_net_id()!
	item := r.read_item_stack_without_stack_id()!
	group_id := int(r.read_varuint32()!)
	return CreativeItemEntry{
		entry_id: entry_id
		item:     item
		group_id: group_id
	}
}

pub fn (mut w Writer) write_creative_item_entry(entry CreativeItemEntry) {
	w.write_creative_item_net_id(entry.entry_id)
	w.write_item_stack_without_stack_id(entry.item)
	w.write_varuint32(u32(entry.group_id))
}
