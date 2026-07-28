module packets

import protocol.serializer

pub struct UnlockedRecipesPacket {
pub mut:
	newly_unlocked   bool
	unlocked_recipes []string
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
	w.bool(p.newly_unlocked)
	w.write_varuint32(u32(p.unlocked_recipes.len))
	for recipe in p.unlocked_recipes {
		w.write_string(recipe)
	}
}

pub fn (mut p UnlockedRecipesPacket) decode_payload(mut r serializer.Reader) ! {
	p.newly_unlocked = r.bool()!
	count := int(r.read_varuint32()!)
	p.unlocked_recipes = []string{cap: count}
	for _ in 0 .. count {
		p.unlocked_recipes << r.read_string()!
	}
}
