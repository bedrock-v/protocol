module enums

pub enum CommandParam as i32 {
	int             = 1
	float           = 2
	value           = 3
	wildcard_int    = 4
	operator        = 5
	target          = 6
	wildcard_target = 7
	string          = 26
	position        = 28
	message         = 31
	text            = 33
	json            = 36
	command         = 43
}
