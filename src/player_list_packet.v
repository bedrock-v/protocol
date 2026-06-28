module protocol

import serializer
import types

pub const player_list_type_add = u8(0)
pub const player_list_type_remove = u8(1)

pub struct PlayerListEntry {
pub mut:
	uuid             types.UUID
	actor_unique_id  i64
	username         string
	xbox_user_id     string
	platform_chat_id string
	build_platform   i32
	skin             types.SkinData
	is_teacher       bool
	is_host          bool
	is_sub_client    bool
	color            u32
	verified         bool
}

pub struct PlayerListPacket {
pub mut:
	type    u8
	entries []PlayerListEntry
}

pub fn (p &PlayerListPacket) pid() u16 {
	return player_list_packet
}

pub fn (p &PlayerListPacket) name() string {
	return 'PlayerListPacket'
}

pub fn (p &PlayerListPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerListPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.u8()!
	count := r.read_varuint32()!
	p.entries = []PlayerListEntry{}
	for _ in 0 .. count {
		mut e := PlayerListEntry{
			uuid: r.read_uuid()!
		}
		if p.type == player_list_type_add {
			e.actor_unique_id = r.read_actor_unique_id()!
			e.username = r.read_string()!
			e.xbox_user_id = r.read_string()!
			e.platform_chat_id = r.read_string()!
			e.build_platform = r.le_i32()!
			e.skin = r.read_skin()!
			e.is_teacher = r.bool()!
			e.is_host = r.bool()!
			e.is_sub_client = r.bool()!
			e.color = r.le_u32()!
		}
		p.entries << e
	}
	if p.type == player_list_type_add {
		for i in 0 .. p.entries.len {
			p.entries[i].verified = r.bool()!
		}
	}
}

pub fn (p &PlayerListPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.type)
	w.write_varuint32(u32(p.entries.len))
	for e in p.entries {
		w.write_uuid(e.uuid)
		if p.type == player_list_type_add {
			w.write_actor_unique_id(e.actor_unique_id)
			w.write_string(e.username)
			w.write_string(e.xbox_user_id)
			w.write_string(e.platform_chat_id)
			w.le_i32(e.build_platform)
			w.write_skin(e.skin)
			w.bool(e.is_teacher)
			w.bool(e.is_host)
			w.bool(e.is_sub_client)
			w.le_u32(e.color)
		}
	}
	if p.type == player_list_type_add {
		for e in p.entries {
			w.bool(e.verified)
		}
	}
}
