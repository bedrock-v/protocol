module packets

import protocol.serializer
import protocol.version.v662.types

pub enum CreativeItemCategory as i32 {
	all               = 0
	construction      = 1
	nature            = 2
	equipment         = 3
	items             = 4
	item_command_only = 5
	undefined         = 6
}

pub fn (e CreativeItemCategory) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn CreativeItemCategory.decode(mut r serializer.Reader) !CreativeItemCategory {
	return unsafe { CreativeItemCategory(r.le_i32()!) }
}

pub struct CreativeItemGroup {
pub mut:
	category CreativeItemCategory
	name     string
	icon     types.NetworkItemInstanceDescriptor
}

pub fn (t CreativeItemGroup) encode(mut w serializer.Writer) {
	t.category.encode(mut w)
	w.write_string(t.name)
	t.icon.encode(mut w)
}

pub fn CreativeItemGroup.decode(mut r serializer.Reader) !CreativeItemGroup {
	return CreativeItemGroup{
		category: CreativeItemCategory.decode(mut r)!
		name:     r.read_string()!
		icon:     types.NetworkItemInstanceDescriptor.decode(mut r)!
	}
}

pub struct CreativeItemData {
pub mut:
	creative_net_id u32
	item_instance   types.NetworkItemInstanceDescriptor
	group_id        u32
}

pub fn (t CreativeItemData) encode(mut w serializer.Writer) {
	w.write_varuint32(t.creative_net_id)
	t.item_instance.encode(mut w)
	w.write_varuint32(t.group_id)
}

pub fn CreativeItemData.decode(mut r serializer.Reader) !CreativeItemData {
	return CreativeItemData{
		creative_net_id: r.read_varuint32()!
		item_instance:   types.NetworkItemInstanceDescriptor.decode(mut r)!
		group_id:        r.read_varuint32()!
	}
}

pub struct CreativeContentPacket {
pub mut:
	groups   []CreativeItemGroup
	contents []CreativeItemData
}

pub fn (p &CreativeContentPacket) pid() u16 {
	return 145
}

pub fn (p &CreativeContentPacket) name() string {
	return 'CreativeContentPacket'
}

pub fn (p &CreativeContentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CreativeContentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.groups.len))
	for e in p.groups {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.contents.len))
	for e in p.contents {
		e.encode(mut w)
	}
}

pub fn (mut p CreativeContentPacket) decode_payload(mut r serializer.Reader) ! {
	{
		count := r.read_count()!
		p.groups = []CreativeItemGroup{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.groups << CreativeItemGroup.decode(mut r)!
		}
	}
	{
		count := r.read_count()!
		p.contents = []CreativeItemData{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.contents << CreativeItemData.decode(mut r)!
		}
	}
}
