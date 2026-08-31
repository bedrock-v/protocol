module enums

import protocol.serializer

// wire value is category << 8 | discriminant, written as a big endian u16
// so the bytes land as [category][discriminant] like vanilla writes them

pub struct TextRaw {
pub mut:
	message string
}

pub struct TextChat {
pub mut:
	player_name string
	message     string
}

pub struct TextTranslate {
pub mut:
	message        string
	parameter_list []string
}

pub struct TextPopup {
pub mut:
	message        string
	parameter_list []string
}

pub struct TextJukeboxPopup {
pub mut:
	message        string
	parameter_list []string
}

pub struct TextTip {
pub mut:
	message string
}

pub struct TextSystemMessage {
pub mut:
	message string
}

pub struct TextWhisper {
pub mut:
	player_name string
	message     string
}

pub struct TextAnnouncement {
pub mut:
	player_name string
	message     string
}

pub struct TextObjectWhisper {
pub mut:
	message string
}

pub struct TextObject {
pub mut:
	message string
}

pub struct TextObjectAnnouncement {
pub mut:
	message string
}

pub type TextPacketType = TextAnnouncement
	| TextChat
	| TextJukeboxPopup
	| TextObject
	| TextObjectAnnouncement
	| TextObjectWhisper
	| TextPopup
	| TextRaw
	| TextSystemMessage
	| TextTip
	| TextTranslate
	| TextWhisper

fn write_string_list(mut w serializer.Writer, list []string) {
	w.write_varuint32(u32(list.len))
	for s in list {
		w.write_string(s)
	}
}

fn read_string_list(mut r serializer.Reader) ![]string {
	count := r.read_count()!
	mut out := []string{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		out << r.read_string()!
	}
	return out
}

pub fn (t TextPacketType) id() u16 {
	return match t {
		TextRaw { u16(0) }
		TextChat { u16(257) }
		TextTranslate { u16(514) }
		TextPopup { u16(515) }
		TextJukeboxPopup { u16(516) }
		TextTip { u16(5) }
		TextSystemMessage { u16(6) }
		TextWhisper { u16(263) }
		TextAnnouncement { u16(264) }
		TextObjectWhisper { u16(9) }
		TextObject { u16(10) }
		TextObjectAnnouncement { u16(11) }
	}
}

pub fn (t TextPacketType) encode_payload(mut w serializer.Writer) {
	match t {
		TextRaw {
			w.write_string(t.message)
		}
		TextChat {
			w.write_string(t.player_name)
			w.write_string(t.message)
		}
		TextTranslate {
			w.write_string(t.message)
			write_string_list(mut w, t.parameter_list)
		}
		TextPopup {
			w.write_string(t.message)
			write_string_list(mut w, t.parameter_list)
		}
		TextJukeboxPopup {
			w.write_string(t.message)
			write_string_list(mut w, t.parameter_list)
		}
		TextTip {
			w.write_string(t.message)
		}
		TextSystemMessage {
			w.write_string(t.message)
		}
		TextWhisper {
			w.write_string(t.player_name)
			w.write_string(t.message)
		}
		TextAnnouncement {
			w.write_string(t.player_name)
			w.write_string(t.message)
		}
		TextObjectWhisper {
			w.write_string(t.message)
		}
		TextObject {
			w.write_string(t.message)
		}
		TextObjectAnnouncement {
			w.write_string(t.message)
		}
	}
}

pub fn (t TextPacketType) encode(mut w serializer.Writer) {
	w.be_u16(t.id())
	t.encode_payload(mut w)
}

pub fn TextPacketType.decode(mut r serializer.Reader) !TextPacketType {
	d := r.be_u16()!
	return TextPacketType.decode_payload(d, mut r)!
}

pub fn TextPacketType.decode_payload(d u16, mut r serializer.Reader) !TextPacketType {
	match d {
		0 {
			return TextRaw{
				message: r.read_string()!
			}
		}
		257 {
			return TextChat{
				player_name: r.read_string()!
				message:     r.read_string()!
			}
		}
		514 {
			return TextTranslate{
				message:        r.read_string()!
				parameter_list: read_string_list(mut r)!
			}
		}
		515 {
			return TextPopup{
				message:        r.read_string()!
				parameter_list: read_string_list(mut r)!
			}
		}
		516 {
			return TextJukeboxPopup{
				message:        r.read_string()!
				parameter_list: read_string_list(mut r)!
			}
		}
		5 {
			return TextTip{
				message: r.read_string()!
			}
		}
		6 {
			return TextSystemMessage{
				message: r.read_string()!
			}
		}
		263 {
			return TextWhisper{
				player_name: r.read_string()!
				message:     r.read_string()!
			}
		}
		264 {
			return TextAnnouncement{
				player_name: r.read_string()!
				message:     r.read_string()!
			}
		}
		9 {
			return TextObjectWhisper{
				message: r.read_string()!
			}
		}
		10 {
			return TextObject{
				message: r.read_string()!
			}
		}
		11 {
			return TextObjectAnnouncement{
				message: r.read_string()!
			}
		}
		else {
			return error('invalid TextPacketType ${d}')
		}
	}
}
