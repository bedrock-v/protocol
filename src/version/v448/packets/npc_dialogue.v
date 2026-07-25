module packets

import serializer

pub enum NpcDialogueAction as i32 {
	open  = 0
	close = 1
}

pub struct NpcDialoguePacket {
pub mut:
	unique_entity_id i64
	action           NpcDialogueAction
	dialogue         string
	scene_name       string
	npc_name         string
	action_json      string
}

pub fn (p &NpcDialoguePacket) pid() u16 {
	return 169
}

pub fn (p &NpcDialoguePacket) name() string {
	return 'NpcDialoguePacket'
}

pub fn (p &NpcDialoguePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &NpcDialoguePacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.unique_entity_id)
	w.write_varint32(i32(p.action))
	w.write_string(p.dialogue)
	w.write_string(p.scene_name)
	w.write_string(p.npc_name)
	w.write_string(p.action_json)
}

pub fn (mut p NpcDialoguePacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_entity_id = r.le_i64()!
	p.action = unsafe { NpcDialogueAction(r.read_varint32()!) }
	p.dialogue = r.read_string()!
	p.scene_name = r.read_string()!
	p.npc_name = r.read_string()!
	p.action_json = r.read_string()!
}
