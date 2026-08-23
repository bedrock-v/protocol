module packets

import protocol.serializer

pub enum TextType as u8 {
	raw           = 0
	chat          = 1
	translation   = 2
	popup         = 3
	jukebox_popup = 4
	tip           = 5
	system        = 6
	whisper       = 7
	announcement  = 8
}

pub struct TextPacket {
pub mut:
	text_type         TextType
	needs_translation bool
	source_name       string
	message           string
	parameters        []string
	xuid              string
	platform_chat_id  string
}

pub fn (p &TextPacket) pid() u16 {
	return 9
}

pub fn (p &TextPacket) name() string {
	return 'TextPacket'
}

pub fn (p &TextPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TextPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.text_type))
	w.bool(p.needs_translation)
	match p.text_type {
		.chat, .whisper, .announcement {
			w.write_string(p.source_name)
			w.write_string(p.message)
		}
		.raw, .tip, .system {
			w.write_string(p.message)
		}
		.translation, .popup, .jukebox_popup {
			w.write_string(p.message)
			w.write_varuint32(u32(p.parameters.len))
			for param in p.parameters {
				w.write_string(param)
			}
		}
	}
	w.write_string(p.xuid)
	w.write_string(p.platform_chat_id)
}

pub fn (mut p TextPacket) decode_payload(mut r serializer.Reader) ! {
	type_id := r.u8()!
	if type_id > u8(TextType.announcement) {
		return error('unsupported text type ${type_id}')
	}
	p.text_type = unsafe { TextType(type_id) }
	p.needs_translation = r.bool()!
	match p.text_type {
		.chat, .whisper, .announcement {
			p.source_name = r.read_string()!
			p.message = r.read_string()!
		}
		.raw, .tip, .system {
			p.message = r.read_string()!
		}
		.translation, .popup, .jukebox_popup {
			p.message = r.read_string()!
			count := r.read_count()!
			mut parameters := []string{cap: serializer.prealloc(count)}
			for _ in 0 .. count {
				parameters << r.read_string()!
			}
			p.parameters = parameters
		}
	}
	p.xuid = r.read_string()!
	p.platform_chat_id = r.read_string()!
}
