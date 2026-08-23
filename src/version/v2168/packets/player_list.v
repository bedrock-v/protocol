module packets

import protocol.serializer
import protocol.version.v2168.types
import protocol.version.v662.types as types_662
import protocol.version.v662.enums as enums_662
import protocol.version.v800.types as types_800

pub struct AddPlayerListEntry {
pub mut:
	uuid             types_662.Uuid
	target_actor_id  types_662.ActorUniqueID
	player_name      string
	xbl_xuid         string
	platform_chat_id string
	build_platform   enums_662.BuildPlatform
	serialized_skin  types.SerializedSkin
	is_teacher       bool
	is_host          bool
	is_sub_client    bool
	color            types_800.Color
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
	e.color.encode(mut w)
}

pub fn AddPlayerListEntry.decode(mut r serializer.Reader) !AddPlayerListEntry {
	return AddPlayerListEntry{
		uuid:             types_662.Uuid.decode(mut r)!
		target_actor_id:  types_662.ActorUniqueID.decode(mut r)!
		player_name:      r.read_string()!
		xbl_xuid:         r.read_string()!
		platform_chat_id: r.read_string()!
		build_platform:   enums_662.BuildPlatform.decode(mut r)!
		serialized_skin:  types.SerializedSkin.decode(mut r)!
		is_teacher:       r.bool()!
		is_host:          r.bool()!
		is_sub_client:    r.bool()!
		color:            types_800.Color.decode(mut r)!
	}
}

pub struct PlayerListRemove {
pub mut:
	uuid types_662.Uuid
}

pub struct PlayerListAdd {
pub mut:
	entry AddPlayerListEntry
}

pub type PlayerListEntry = PlayerListAdd | PlayerListRemove

pub fn (t PlayerListEntry) encode(mut w serializer.Writer) {
	match t {
		PlayerListRemove {
			w.write_varuint32(0)
			w.u8(1)
			t.uuid.encode(mut w)
		}
		PlayerListAdd {
			w.write_varuint32(1)
			w.u8(0)
			t.entry.encode(mut w)
		}
	}
}

pub fn PlayerListEntry.decode(mut r serializer.Reader) !PlayerListEntry {
	d := r.read_varuint32()!
	r.u8()!
	match d {
		0 {
			return PlayerListRemove{
				uuid: types_662.Uuid.decode(mut r)!
			}
		}
		1 {
			return PlayerListAdd{
				entry: AddPlayerListEntry.decode(mut r)!
			}
		}
		else {
			return error('invalid PlayerListEntry ${d}')
		}
	}
}

pub struct PlayerListPacket {
pub mut:
	entries []PlayerListEntry
}

pub fn (p &PlayerListPacket) pid() u16 {
	return 63
}

pub fn (p &PlayerListPacket) name() string {
	return 'PlayerListPacket'
}

pub fn (p &PlayerListPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerListPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.entries.len))
	for e in p.entries {
		e.encode(mut w)
	}
}

pub fn (mut p PlayerListPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.entries = []PlayerListEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.entries << PlayerListEntry.decode(mut r)!
	}
}
