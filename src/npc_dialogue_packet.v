module protocol

import serializer

pub struct NpcDialoguePacket {
pub mut:
	npc_actor_unique_id i64
	action_type         int
	dialogue            string
	scene_name          string
	npc_name            string
	action_json         string
}

pub fn (p &NpcDialoguePacket) pid() u16 {
	return npc_dialogue_packet
}

pub fn (p &NpcDialoguePacket) name() string {
	return 'NpcDialoguePacket'
}

pub fn (p &NpcDialoguePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p NpcDialoguePacket) decode_payload(mut r serializer.Reader) ! {
	p.npc_actor_unique_id = r.le_i64()!
	p.action_type = int(r.read_varint32()!)
	p.dialogue = r.read_string()!
	p.scene_name = r.read_string()!
	p.npc_name = r.read_string()!
	p.action_json = r.read_string()!
}

pub fn (p &NpcDialoguePacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.npc_actor_unique_id)
	w.write_varint32(i32(p.action_type))
	w.write_string(p.dialogue)
	w.write_string(p.scene_name)
	w.write_string(p.npc_name)
	w.write_string(p.action_json)
}
