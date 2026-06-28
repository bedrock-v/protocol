module protocol

import serializer

pub struct UnlockedRecipesPacket {
pub mut:
	type    u32
	recipes []string
}

pub fn (p &UnlockedRecipesPacket) pid() u16 {
	return unlocked_recipes_packet
}

pub fn (p &UnlockedRecipesPacket) name() string {
	return 'UnlockedRecipesPacket'
}

pub fn (p &UnlockedRecipesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UnlockedRecipesPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.le_u32()!
	count := r.read_varuint32()!
	p.recipes = []string{}
	for _ in 0 .. count {
		p.recipes << r.read_string()!
	}
}

pub fn (p &UnlockedRecipesPacket) encode_payload(mut w serializer.Writer) {
	w.le_u32(p.type)
	w.write_varuint32(u32(p.recipes.len))
	for s in p.recipes {
		w.write_string(s)
	}
}
