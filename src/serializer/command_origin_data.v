module serializer

import types

pub fn (mut r Reader) read_command_origin_data() !types.CommandOriginData {
	mut data := types.CommandOriginData{
		type:       r.read_varuint32()!
		uuid:       r.read_uuid()!
		request_id: r.read_string()!
	}
	if data.type == types.command_origin_dev_console || data.type == types.command_origin_test {
		data.player_actor_unique_id = r.read_varint64()!
	}
	return data
}

pub fn (mut w Writer) write_command_origin_data(data types.CommandOriginData) {
	w.write_varuint32(data.type)
	w.write_uuid(data.uuid)
	w.write_string(data.request_id)
	if data.type == types.command_origin_dev_console || data.type == types.command_origin_test {
		w.write_varint64(data.player_actor_unique_id)
	}
}
