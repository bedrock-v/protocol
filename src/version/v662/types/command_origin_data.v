module types

import serializer
import version.v662.enums

pub struct CommandOriginData {
pub mut:
	command_type enums.CommandOriginType = enums.CommandOriginPlayer{}
	command_uuid Uuid
	request_id   string
}

pub fn (t CommandOriginData) encode(mut w serializer.Writer) {
	w.write_varuint32(t.command_type.id())
	t.command_uuid.encode(mut w)
	w.write_string(t.request_id)
	t.command_type.encode_payload(mut w)
}

pub fn CommandOriginData.decode(mut r serializer.Reader) !CommandOriginData {
	id := r.read_varuint32()!
	command_uuid := Uuid.decode(mut r)!
	request_id := r.read_string()!
	command_type := enums.CommandOriginType.decode_payload(id, mut r)!
	return CommandOriginData{
		command_type: command_type
		command_uuid: command_uuid
		request_id:   request_id
	}
}
