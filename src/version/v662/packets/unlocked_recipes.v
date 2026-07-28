module packets

import protocol.serializer

pub struct UnlockedRecipesPacket {
pub mut:
	packet_type           u32
	unlocked_recipes_list []string
}

pub fn (p &UnlockedRecipesPacket) pid() u16 {
	return 199
}

pub fn (p &UnlockedRecipesPacket) name() string {
	return 'UnlockedRecipesPacket'
}

pub fn (p &UnlockedRecipesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UnlockedRecipesPacket) encode_payload(mut w serializer.Writer) {
	w.le_u32(p.packet_type)
	w.write_varuint32(u32(p.unlocked_recipes_list.len))
	for e in p.unlocked_recipes_list {
		w.write_string(e)
	}
}

pub fn (mut p UnlockedRecipesPacket) decode_payload(mut r serializer.Reader) ! {
	p.packet_type = r.le_u32()!
	{
		count := int(r.read_varuint32()!)
		p.unlocked_recipes_list = []string{cap: count}
		for _ in 0 .. count {
			p.unlocked_recipes_list << r.read_string()!
		}
	}
}
