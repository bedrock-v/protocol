module types

import protocol.serializer
import protocol.enums

pub struct CommandOriginData {
pub mut:
	command_type enums.CommandOriginType
	command_uuid Uuid
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
		command_uuid: Uuid.decode(mut r)!
		request_id:   r.read_string()!
		player_id:    r.le_i64()!
	}
}
