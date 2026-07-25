module packets

import serializer
import version.v662.types
import version.v662.enums

pub struct AddPlayerListEntry {
pub mut:
	uuid             types.Uuid
	target_actor_id  types.ActorUniqueID
	player_name      string
	xbl_xuid         string
	platform_chat_id string
	build_platform   enums.BuildPlatform
	serialized_skin  types.SerializedSkin
	is_teacher       bool
	is_host          bool
	is_sub_client    bool
}

pub fn (e AddPlayerListEntry) encode(mut w serializer.Writer) {
	e.uuid.encode(mut w)
	e.target_actor_id.encode(mut w)
	w.write_string(e.player_name)
	w.write_string(e.xbl_xuid)
	w.write_string(e.platform_chat_id)
	e.build_platform.encode(mut w)
	e.serialized_skin.encode(mut w)
	w.bool(e.is_teacher)
	w.bool(e.is_host)
	w.bool(e.is_sub_client)
}

pub fn AddPlayerListEntry.decode(mut r serializer.Reader) !AddPlayerListEntry {
	return AddPlayerListEntry{
		uuid:             types.Uuid.decode(mut r)!
		target_actor_id:  types.ActorUniqueID.decode(mut r)!
		player_name:      r.read_string()!
		xbl_xuid:         r.read_string()!
		platform_chat_id: r.read_string()!
		build_platform:   enums.BuildPlatform.decode(mut r)!
		serialized_skin:  types.SerializedSkin.decode(mut r)!
		is_teacher:       r.bool()!
		is_host:          r.bool()!
		is_sub_client:    r.bool()!
	}
}

pub struct PlayerListAdd {
pub mut:
	add_player_list []AddPlayerListEntry
	is_trusted_skin []bool
}

pub struct PlayerListRemove {
pub mut:
	remove_player_list []types.Uuid
}

pub type PlayerListAction = PlayerListAdd | PlayerListRemove

pub struct PlayerListPacket {
pub mut:
	action PlayerListAction = PlayerListAdd{}
}

pub fn (p &PlayerListPacket) pid() u16 { return 63 }

pub fn (p &PlayerListPacket) name() string { return 'PlayerListPacket' }

pub fn (p &PlayerListPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PlayerListPacket) encode_payload(mut w serializer.Writer) {
	match p.action {
		PlayerListAdd {
			w.u8(0)
			w.write_varuint32(u32(p.action.add_player_list.len))
			for e in p.action.add_player_list {
				e.encode(mut w)
			}
			for i in 0 .. p.action.add_player_list.len {
				trusted := if i < p.action.is_trusted_skin.len {
					p.action.is_trusted_skin[i]
				} else {
					false
				}
				w.bool(trusted)
			}
		}
		PlayerListRemove {
			w.u8(1)
			w.write_varuint32(u32(p.action.remove_player_list.len))
			for e in p.action.remove_player_list {
				e.encode(mut w)
			}
		}
	}
}

pub fn (mut p PlayerListPacket) decode_payload(mut r serializer.Reader) ! {
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
			p.action = PlayerListAdd{
				add_player_list: entries
				is_trusted_skin: trusted
			}
		}
		1 {
			count := int(r.read_varuint32()!)
			mut uuids := []types.Uuid{cap: count}
			for _ in 0 .. count {
				uuids << types.Uuid.decode(mut r)!
			}
			p.action = PlayerListRemove{
				remove_player_list: uuids
			}
		}
		else {
			return error('invalid PlayerListPacket ${d}')
		}
	}
}
