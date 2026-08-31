module packets

import protocol.serializer

pub struct BookEditPacket {
pub mut:
	book_edit_type        u8
	inventory_slot        u8
	page_number           u8
	secondary_page_number u8
	text                  string
	photo_name            string
	title                 string
	author                string
}

pub fn (p &BookEditPacket) pid() u16 {
	return 97
}

pub fn (p &BookEditPacket) name() string {
	return 'BookEditPacket'
}

pub fn (p &BookEditPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BookEditPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.book_edit_type)
	w.u8(p.inventory_slot)
	match p.book_edit_type {
		0, 1 {
			w.u8(p.page_number)
			w.write_string(p.text)
			w.write_string(p.photo_name)
		}
		2 {
			w.u8(p.page_number)
		}
		3 {
			w.u8(p.page_number)
			w.u8(p.secondary_page_number)
		}
		4 {
			w.write_string(p.title)
			w.write_string(p.author)
		}
		else {}
	}
}

pub fn (mut p BookEditPacket) decode_payload(mut r serializer.Reader) ! {
	p.book_edit_type = r.u8()!
	p.inventory_slot = r.u8()!
	match p.book_edit_type {
		0, 1 {
			p.page_number = r.u8()!
			p.text = r.read_string()!
			p.photo_name = r.read_string()!
		}
		2 {
			p.page_number = r.u8()!
		}
		3 {
			p.page_number = r.u8()!
			p.secondary_page_number = r.u8()!
		}
		4 {
			p.title = r.read_string()!
			p.author = r.read_string()!
		}
		else {
			return error('Unknown book edit type ${p.book_edit_type}')
		}
	}
}
