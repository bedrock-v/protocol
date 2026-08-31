module packets

import protocol.serializer
import protocol.version.v137.types

pub struct PlayerListEntry {
pub mut:
	uuid             types.Uuid
	entity_unique_id i64
	username         string
	third_party_name string
	platform         i32
	skin_id          string
	skin_data        string
	cape_data        string
	geometry_model   string
	geometry_data    string
	xbox_user_id     string
	platform_chat_id string
}

pub struct PlayerListPacket {
pub mut:
	type    u8
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
	w.u8(p.type)
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		if p.type == 0 {
			entry.uuid.encode(mut w)
			w.write_varint64(entry.entity_unique_id)
			w.write_string(entry.username)
			w.write_string(entry.third_party_name)
			w.write_varint32(entry.platform)
			w.write_string(entry.skin_id)
			w.write_string(entry.skin_data)
			w.write_string(entry.cape_data)
			w.write_string(entry.geometry_model)
			w.write_string(entry.geometry_data)
			w.write_string(entry.xbox_user_id)
			w.write_string(entry.platform_chat_id)
		} else {
			entry.uuid.encode(mut w)
		}
	}
}

pub fn (mut p PlayerListPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.u8()!
	count := r.read_count()!
	p.entries = []PlayerListEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		mut entry := PlayerListEntry{}
		if p.type == 0 {
			entry.uuid = types.Uuid.decode(mut r)!
			entry.entity_unique_id = r.read_varint64()!
			entry.username = r.read_string()!
			entry.third_party_name = r.read_string()!
			entry.platform = r.read_varint32()!
			entry.skin_id = r.read_string()!
			entry.skin_data = r.read_string()!
			entry.cape_data = r.read_string()!
			entry.geometry_model = r.read_string()!
			entry.geometry_data = r.read_string()!
			entry.xbox_user_id = r.read_string()!
			entry.platform_chat_id = r.read_string()!
		} else {
			entry.uuid = types.Uuid.decode(mut r)!
		}
		p.entries << entry
	}
}
