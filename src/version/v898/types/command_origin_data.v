module types

import serializer
import version.v662.types as types_662
import version.v898.enums

pub struct CommandOriginData {
pub mut:
	command_type enums.CommandOriginType
	command_uuid types_662.Uuid
	request_id   string
	player_id    i64
}

pub fn (t CommandOriginData) encode(mut w serializer.Writer) {
	t.command_type.encode(mut w)
	t.command_uuid.encode(mut w)
	w.write_string(t.request_id)
	w.le_i64(t.player_id)
}

pub fn CommandOriginData.decode(mut r serializer.Reader) !CommandOriginData {
	return CommandOriginData{
		command_type: enums.CommandOriginType.decode(mut r)!
		command_uuid: types_662.Uuid.decode(mut r)!
		request_id:   r.read_string()!
		player_id:    r.le_i64()!
	}
}
