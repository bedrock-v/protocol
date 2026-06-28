module types

pub const command_origin_dev_console = u32(3)
pub const command_origin_test = u32(4)

pub struct CommandOriginData {
pub mut:
	type                   u32
	uuid                   UUID
	request_id             string
	player_actor_unique_id i64
}
