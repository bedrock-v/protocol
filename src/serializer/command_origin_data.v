module serializer

import types

pub fn (mut r Reader) read_command_origin_data() !types.CommandOriginData {
	return types.CommandOriginData{
		type:                   r.read_string()!
		uuid:                   r.read_uuid()!
		request_id:             r.read_string()!
		player_actor_unique_id: r.le_i64()!
	}
}

pub fn (mut w Writer) write_command_origin_data(data types.CommandOriginData) {
	w.write_string(data.type)
	w.write_uuid(data.uuid)
	w.write_string(data.request_id)
	w.le_i64(data.player_actor_unique_id)
}
