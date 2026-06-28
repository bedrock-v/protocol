module protocol

import serializer

pub const book_edit_type_replace_page = 0
pub const book_edit_type_add_page = 1
pub const book_edit_type_delete_page = 2
pub const book_edit_type_swap_pages = 3
pub const book_edit_type_sign_book = 4

pub struct BookEditPacket {
pub mut:
	inventory_slot        int
	type                  int
	page_number           int
	secondary_page_number int
	text                  string
	photo_name            string
	title                 string
	author                string
	xuid                  string
}

pub fn (p &BookEditPacket) pid() u16 {
	return book_edit_packet
}

pub fn (p &BookEditPacket) name() string {
	return 'BookEditPacket'
}

pub fn (p &BookEditPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p BookEditPacket) decode_payload(mut r serializer.Reader) ! {
	p.inventory_slot = int(r.read_varint32()!)
	p.type = int(r.read_varuint32()!)
	match p.type {
		book_edit_type_replace_page, book_edit_type_add_page {
			p.page_number = int(r.read_varint32()!)
			p.text = r.read_string()!
			p.photo_name = r.read_string()!
		}
		book_edit_type_delete_page {
			p.page_number = int(r.read_varint32()!)
		}
		book_edit_type_swap_pages {
			p.page_number = int(r.read_varint32()!)
			p.secondary_page_number = int(r.read_varint32()!)
		}
		book_edit_type_sign_book {
			p.title = r.read_string()!
			p.author = r.read_string()!
			p.xuid = r.read_string()!
		}
		else {
			return error('unknown book edit type ${p.type}')
		}
	}
}

pub fn (p &BookEditPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.inventory_slot))
	w.write_varuint32(u32(p.type))
	match p.type {
		book_edit_type_replace_page, book_edit_type_add_page {
			w.write_varint32(i32(p.page_number))
			w.write_string(p.text)
			w.write_string(p.photo_name)
		}
		book_edit_type_delete_page {
			w.write_varint32(i32(p.page_number))
		}
		book_edit_type_swap_pages {
			w.write_varint32(i32(p.page_number))
			w.write_varint32(i32(p.secondary_page_number))
		}
		book_edit_type_sign_book {
			w.write_string(p.title)
			w.write_string(p.author)
			w.write_string(p.xuid)
		}
		else {}
	}
}
