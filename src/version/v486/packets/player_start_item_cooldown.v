module packets

import serializer

pub struct PlayerStartItemCooldownPacket {
pub mut:
	item_category     string
	cooldown_duration i32
}

pub fn (p &PlayerStartItemCooldownPacket) pid() u16 {
	return 176
}

pub fn (p &PlayerStartItemCooldownPacket) name() string {
	return 'PlayerStartItemCooldownPacket'
}

pub fn (p &PlayerStartItemCooldownPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerStartItemCooldownPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.item_category)
	w.write_varint32(p.cooldown_duration)
}

pub fn (mut p PlayerStartItemCooldownPacket) decode_payload(mut r serializer.Reader) ! {
	p.item_category = r.read_string()!
	p.cooldown_duration = r.read_varint32()!
}
