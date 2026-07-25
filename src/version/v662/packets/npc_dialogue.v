module packets

import serializer

pub enum NpcDialogueActionType as i32 {
	open  = 0
	close = 1
}

pub struct NpcDialoguePacket {
pub mut:
	npc_raw_id              u64
	npc_dialogue_action_type NpcDialogueActionType
	dialogue                string
	scene_name              string
	npc_name                string
	action_json             string
}

pub fn (p &NpcDialoguePacket) pid() u16 { return 169 }

pub fn (p &NpcDialoguePacket) name() string { return 'NpcDialoguePacket' }

pub fn (p &NpcDialoguePacket) can_be_sent_before_login() bool { return false }

pub fn (p &NpcDialoguePacket) encode_payload(mut w serializer.Writer) {
	w.le_u64(p.npc_raw_id)
	w.write_varint32(i32(p.npc_dialogue_action_type))
	w.write_string(p.dialogue)
	w.write_string(p.scene_name)
	w.write_string(p.npc_name)
	w.write_string(p.action_json)
}

pub fn (mut p NpcDialoguePacket) decode_payload(mut r serializer.Reader) ! {
	p.npc_raw_id = r.le_u64()!
	p.npc_dialogue_action_type = unsafe { NpcDialogueActionType(r.read_varint32()!) }
	p.dialogue = r.read_string()!
	p.scene_name = r.read_string()!
	p.npc_name = r.read_string()!
	p.action_json = r.read_string()!
}
