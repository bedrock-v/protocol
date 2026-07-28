module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct GatheringsConfig {
pub mut:
	experience_id   types_662.Uuid
	experience_name string
	world_id        types_662.Uuid
	world_name      string
	creator_id      string
	target_id       types_662.Uuid
	scenario_id     string
	server_id       string
}

pub fn (t GatheringsConfig) encode(mut w serializer.Writer) {
	t.experience_id.encode(mut w)
	w.write_string(t.experience_name)
	t.world_id.encode(mut w)
	w.write_string(t.world_name)
	w.write_string(t.creator_id)
	t.target_id.encode(mut w)
	w.write_string(t.scenario_id)
	w.write_string(t.server_id)
}

pub fn GatheringsConfig.decode(mut r serializer.Reader) !GatheringsConfig {
	return GatheringsConfig{
		experience_id:   types_662.Uuid.decode(mut r)!
		experience_name: r.read_string()!
		world_id:        types_662.Uuid.decode(mut r)!
		world_name:      r.read_string()!
		creator_id:      r.read_string()!
		target_id:       types_662.Uuid.decode(mut r)!
		scenario_id:     r.read_string()!
		server_id:       r.read_string()!
	}
}
