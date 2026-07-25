module enums

pub enum CommandParam as i32 {
	int             = 1
	float           = 2
	value           = 3
	wildcard_int    = 4
	operator        = 5
	target          = 6
	wildcard_target = 7
	string          = 24
	position        = 26
	message         = 29
	text            = 31
	json            = 34
	command         = 41
}
