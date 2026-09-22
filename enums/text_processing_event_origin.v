module enums

import protocol.serializer

pub enum TextProcessingEventOrigin as i32 {
	unknown               = -1
	server_chat_public    = 0
	server_chat_whisper   = 1
	sign_text             = 2
	anvil_text            = 3
	book_and_quill_text   = 4
	command_block_text    = 5
	block_actor_data_text = 6
	join_event_text       = 7
	leave_event_text      = 8
	slash_command_chat    = 9
	cartography_text      = 10
	kick_command          = 11
	title_command         = 12
	summon_command        = 13
	server_form           = 14
	count                 = 15
}

pub fn (e TextProcessingEventOrigin) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn TextProcessingEventOrigin.decode(mut r serializer.Reader) !TextProcessingEventOrigin {
	return unsafe { TextProcessingEventOrigin(r.le_i32()!) }
}
