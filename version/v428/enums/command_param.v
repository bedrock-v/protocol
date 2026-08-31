module enums

pub enum CommandParam as i32 {
	int             = 1
	float           = 3
	value           = 4
	wildcard_int    = 5
	operator        = 6
	target          = 7
	wildcard_target = 9
	file_path       = 16
	string          = 32
	block_position  = 40
	position        = 41
	message         = 44
	text            = 46
	json            = 50
	block_states    = 60
	command         = 63
}
