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
	string          = 27
	position        = 29
	message         = 32
	text            = 34
	json            = 37
	command         = 44
}
