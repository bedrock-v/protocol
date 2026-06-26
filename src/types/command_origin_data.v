module types

pub struct CommandOriginData {
pub mut:
	type                   string
	uuid                   UUID
	request_id             string
	player_actor_unique_id i64
}
