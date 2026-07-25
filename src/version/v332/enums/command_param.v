module enums

pub enum CommandParam as i32 {
	int             = 1
	float           = 2
	value           = 3
	wildcard_int    = 4
	operator        = 5
	target          = 6
	wildcard_target = 7
	file_path       = 15
	string          = 28
	position        = 30
	message         = 33
	text            = 35
	json            = 38
	command         = 45
}
