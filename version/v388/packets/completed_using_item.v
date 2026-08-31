module packets

import protocol.serializer

pub enum ItemUseType as i32 {
	unknown     = -1
	equip_armor = 0
	eat         = 1
	attack      = 2
	consume     = 3
	throw       = 4
	shoot       = 5
	place       = 6
	fill_bottle = 7
	fill_bucket = 8
	pour_bucket = 9
	use_tool    = 10
	interact    = 11
	retrieved   = 12
	dyed        = 13
	traded      = 14
}

pub struct CompletedUsingItemPacket {
pub mut:
	item_id  u16
	use_type ItemUseType = ItemUseType.unknown
}

pub fn (p &CompletedUsingItemPacket) pid() u16 {
	return 142
}

pub fn (p &CompletedUsingItemPacket) name() string {
	return 'CompletedUsingItemPacket'
}

pub fn (p &CompletedUsingItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CompletedUsingItemPacket) encode_payload(mut w serializer.Writer) {
	w.le_u16(p.item_id)
	w.le_i32(i32(p.use_type))
}

pub fn (mut p CompletedUsingItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.item_id = r.le_u16()!
	p.use_type = unsafe { ItemUseType(r.le_i32()!) }
}
