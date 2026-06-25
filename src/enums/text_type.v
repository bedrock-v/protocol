module enums

pub enum TextType as u8 {
	raw               = 0
	chat              = 1
	translation       = 2
	popup             = 3
	jukebox_popup     = 4
	tip               = 5
	system            = 6
	whisper           = 7
	announcement      = 8
	json_whisper      = 9
	json              = 10
	json_announcement = 11
}
