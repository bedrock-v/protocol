module enums

pub enum CommandParam as i32 {
	int             = 1
	float           = 2
	value           = 3
	wildcard_int    = 4
	operator        = 5
	target          = 6
	wildcard_target = 8
	file_path       = 15
	string          = 31
	block_position  = 39
	position        = 40
	message         = 43
	text            = 45
	json            = 49
	command         = 56
}
