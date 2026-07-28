module types

import protocol.serializer
import protocol.version.v291.enums

pub struct CommandOriginData {
pub mut:
	origin     enums.CommandOriginType
	uuid       Uuid
	request_id string
	player_id  i64
}

pub fn (t CommandOriginData) encode(mut w serializer.Writer) {
	t.origin.encode(mut w)
	t.uuid.encode(mut w)
	w.write_string(t.request_id)
	if t.origin in [enums.CommandOriginType.dev_console, enums.CommandOriginType.test] {
		w.write_varint64(t.player_id)
	}
}

pub fn CommandOriginData.decode(mut r serializer.Reader) !CommandOriginData {
	mut t := CommandOriginData{}
	t.origin = enums.CommandOriginType.decode(mut r)!
	t.uuid = Uuid.decode(mut r)!
	t.request_id = r.read_string()!
	if t.origin in [enums.CommandOriginType.dev_console, enums.CommandOriginType.test] {
		t.player_id = r.read_varint64()!
	} else {
		t.player_id = -1
	}
	return t
}
