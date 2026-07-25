module enums

pub enum CommandParam as i32 {
	int             = 1
	float           = 2
	value           = 3
	wildcard_int    = 4
	operator        = 5
	target          = 6
	wildcard_target = 7
	file_path       = 14
	string          = 29
	block_position  = 37
	position        = 38
	message         = 41
	text            = 43
	json            = 47
	command         = 54
}
