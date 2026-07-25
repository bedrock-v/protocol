module packets

import serializer
import version.v800.types
import version.v662.types as types_662
import version.v662.enums as enums_662

pub struct AddPlayerListEntry {
pub mut:
	uuid             types_662.Uuid
	target_actor_id  types_662.ActorUniqueID
	player_name      string
	xbl_xuid         string
	platform_chat_id string
	build_platform   enums_662.BuildPlatform
	serialized_skin  types_662.SerializedSkin
	is_teacher       bool
	is_host          bool
	is_sub_client    bool
	color            types.Color
}

pub fn (t AddPlayerListEntry) encode(mut w serializer.Writer) {
	t.uuid.encode(mut w)
	t.target_actor_id.encode(mut w)
	w.write_string(t.player_name)
	w.write_string(t.xbl_xuid)
	w.write_string(t.platform_chat_id)
	t.build_platform.encode(mut w)
	t.serialized_skin.encode(mut w)
	w.bool(t.is_teacher)
	w.bool(t.is_host)
	w.bool(t.is_sub_client)
	t.color.encode(mut w)
}

pub fn AddPlayerListEntry.decode(mut r serializer.Reader) !AddPlayerListEntry {
	mut t := AddPlayerListEntry{}
	t.uuid = types_662.Uuid.decode(mut r)!
	t.target_actor_id = types_662.ActorUniqueID.decode(mut r)!
	t.player_name = r.read_string()!
	t.xbl_xuid = r.read_string()!
	t.platform_chat_id = r.read_string()!
	t.build_platform = enums_662.BuildPlatform.decode(mut r)!
	t.serialized_skin = types_662.SerializedSkin.decode(mut r)!
	t.is_teacher = r.bool()!
	t.is_host = r.bool()!
	t.is_sub_client = r.bool()!
	t.color = types.Color.decode(mut r)!
	return t
}

pub struct PlayerListAdd {
pub mut:
	add_player_list []AddPlayerListEntry
	is_trusted_skin []bool
}

pub struct PlayerListRemove {
pub mut:
	remove_player_list []types_662.Uuid
}

pub type PlayerListAction = PlayerListAdd | PlayerListRemove

pub fn (t PlayerListAction) encode(mut w serializer.Writer) {
	match t {
		PlayerListAdd {
			w.u8(0)
			w.write_varuint32(u32(t.add_player_list.len))
			for e in t.add_player_list {
				e.encode(mut w)
			}
			for i in 0 .. t.add_player_list.len {
				if i < t.is_trusted_skin.len {
					w.bool(t.is_trusted_skin[i])
				} else {
					w.bool(false)
				}
			}
		}
		PlayerListRemove {
			w.u8(1)
			w.write_varuint32(u32(t.remove_player_list.len))
			for e in t.remove_player_list {
				e.encode(mut w)
			}
		}
	}
}

pub fn PlayerListAction.decode(mut r serializer.Reader) !PlayerListAction {
	d := r.u8()!
	match d {
		0 {
			count := int(r.read_varuint32()!)
			mut entries := []AddPlayerListEntry{cap: count}
			for _ in 0 .. count {
				entries << AddPlayerListEntry.decode(mut r)!
			}
			mut trusted := []bool{cap: count}
			for _ in 0 .. count {
				trusted << r.bool()!
			}
			return PlayerListAdd{
				add_player_list: entries
				is_trusted_skin: trusted
			}
		}
		1 {
			count := int(r.read_varuint32()!)
			mut uuids := []types_662.Uuid{cap: count}
			for _ in 0 .. count {
				uuids << types_662.Uuid.decode(mut r)!
			}
			return PlayerListRemove{
				remove_player_list: uuids
			}
		}
		else {
			return error('invalid PlayerListPacket action ${d}')
		}
	}
}

pub struct PlayerListPacket {
pub mut:
	action PlayerListAction = PlayerListAdd{}
}

pub fn (p &PlayerListPacket) pid() u16 { return 63 }

pub fn (p &PlayerListPacket) name() string { return 'PlayerListPacket' }

pub fn (p &PlayerListPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PlayerListPacket) encode_payload(mut w serializer.Writer) {
	p.action.encode(mut w)
}

pub fn (mut p PlayerListPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = PlayerListAction.decode(mut r)!
}
