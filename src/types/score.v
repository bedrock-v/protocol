module types

pub const score_entry_type_player = 1
pub const score_entry_type_entity = 2
pub const score_entry_type_fake_player = 3

pub struct ScorePacketEntry {
pub mut:
	scoreboard_id   i64
	objective_name  string
	score           int
	type            int
	actor_unique_id i64
	custom_name     string
}

pub struct ScoreboardIdentityEntry {
pub mut:
	scoreboard_id   i64
	actor_unique_id i64
}
