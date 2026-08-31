module enums

import protocol.serializer

pub enum CommandOriginType {
	player                      = 0
	command_block               = 1
	minecart_command_block      = 2
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
	scripting                   = 14
	execute_context             = 15
}

pub fn (e CommandOriginType) wire_name() string {
	return match e {
		.player { 'player' }
		.command_block { 'commandblock' }
		.minecart_command_block { 'minecartcommandblock' }
		.dev_console { 'devconsole' }
		.test { 'test' }
		.automation_player { 'automationplayer' }
		.client_automation { 'clientautomation' }
		.dedicated_server { 'dedicatedserver' }
		.entity { 'entity' }
		.virtual { 'virtual' }
		.game_argument { 'gameargument' }
		.entity_server { 'entityserver' }
		.precompiled { 'precompiled' }
		.game_director_entity_server { 'gamedirectorentityserver' }
		.scripting { 'scripting' }
		.execute_context { 'executecontext' }
	}
}

pub fn (e CommandOriginType) encode(mut w serializer.Writer) {
	w.write_string(e.wire_name())
}

pub fn CommandOriginType.decode(mut r serializer.Reader) !CommandOriginType {
	s := r.read_string()!
	match s {
		'player' { return CommandOriginType.player }
		'commandblock' { return CommandOriginType.command_block }
		'minecartcommandblock' { return CommandOriginType.minecart_command_block }
		'devconsole' { return CommandOriginType.dev_console }
		'test' { return CommandOriginType.test }
		'automationplayer' { return CommandOriginType.automation_player }
		'clientautomation' { return CommandOriginType.client_automation }
		'dedicatedserver' { return CommandOriginType.dedicated_server }
		'entity' { return CommandOriginType.entity }
		'virtual' { return CommandOriginType.virtual }
		'gameargument' { return CommandOriginType.game_argument }
		'entityserver' { return CommandOriginType.entity_server }
		'precompiled' { return CommandOriginType.precompiled }
		'gamedirectorentityserver' { return CommandOriginType.game_director_entity_server }
		'scripting' { return CommandOriginType.scripting }
		'executecontext' { return CommandOriginType.execute_context }
		else { return error('invalid CommandOriginType ${s}') }
	}
}
