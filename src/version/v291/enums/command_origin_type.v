module enums

import serializer

pub enum CommandOriginType as u32 {
	player                      = 0
	block                       = 1
	minecart_block              = 2
	dev_console                 = 3
	test                        = 4
	automation_player           = 5
	client_automation           = 6
	dedicated_server            = 7
	entity                      = 8
	virtual                     = 9
	game_argument               = 10
	entity_server               = 11
	precompiled                 = 12
	game_director_entity_server = 13
	script                      = 14
	execute_context             = 15
}

pub fn (e CommandOriginType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn CommandOriginType.decode(mut r serializer.Reader) !CommandOriginType {
	return unsafe { CommandOriginType(r.read_varuint32()!) }
}
