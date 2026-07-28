module packets

import protocol.serializer

pub enum UnlockedRecipesActionType as i32 {
	empty              = 0
	initially_unlocked = 1
	newly_unlocked     = 2
	remove_unlocked    = 3
	remove_all         = 4
}

pub fn (e UnlockedRecipesActionType) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn UnlockedRecipesActionType.decode(mut r serializer.Reader) !UnlockedRecipesActionType {
	return unsafe { UnlockedRecipesActionType(r.le_i32()!) }
}

pub struct UnlockedRecipesPacket {
pub mut:
	action           UnlockedRecipesActionType
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
	p.action.encode(mut w)
	w.write_varuint32(u32(p.unlocked_recipes.len))
	for recipe in p.unlocked_recipes {
		w.write_string(recipe)
	}
}

pub fn (mut p UnlockedRecipesPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = UnlockedRecipesActionType.decode(mut r)!
	count := int(r.read_varuint32()!)
	p.unlocked_recipes = []string{cap: count}
	for _ in 0 .. count {
		p.unlocked_recipes << r.read_string()!
	}
}
