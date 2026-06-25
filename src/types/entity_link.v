module types

pub struct EntityLink {
pub mut:
	from_actor_unique_id     i64
	to_actor_unique_id       i64
	type                     int
	immediate                bool
	caused_by_rider          bool
	vehicle_angular_velocity f32
}
