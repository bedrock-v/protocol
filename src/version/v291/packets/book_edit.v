module packets

import serializer

pub struct BookEditReplacePage {
pub mut:
	page_number u8
	text        string
	photo_name  string
}

pub struct BookEditAddPage {
pub mut:
	page_number u8
	text        string
	photo_name  string
}

pub struct BookEditDeletePage {
pub mut:
	page_number u8
}

pub struct BookEditSwapPages {
pub mut:
	page_number           u8
	secondary_page_number u8
}

pub struct BookEditSignBook {
pub mut:
	title  string
	author string
	xuid   string
}

pub type BookEditAction = BookEditAddPage
	| BookEditDeletePage
	| BookEditReplacePage
	| BookEditSignBook
	| BookEditSwapPages

pub fn (t BookEditAction) id() u8 {
	return match t {
		BookEditReplacePage { u8(0) }
		BookEditAddPage { u8(1) }
		BookEditDeletePage { u8(2) }
		BookEditSwapPages { u8(3) }
		BookEditSignBook { u8(4) }
	}
}

pub fn (t BookEditAction) encode_payload(mut w serializer.Writer) {
	match t {
		BookEditReplacePage {
			w.u8(t.page_number)
			w.write_string(t.text)
			w.write_string(t.photo_name)
		}
		BookEditAddPage {
			w.u8(t.page_number)
			w.write_string(t.text)
			w.write_string(t.photo_name)
		}
		BookEditDeletePage {
			w.u8(t.page_number)
		}
		BookEditSwapPages {
			w.u8(t.page_number)
			w.u8(t.secondary_page_number)
		}
		BookEditSignBook {
			w.write_string(t.title)
			w.write_string(t.author)
			w.write_string(t.xuid)
		}
	}
}

pub fn BookEditAction.decode_payload(id u8, mut r serializer.Reader) !BookEditAction {
	match id {
		0 {
			return BookEditReplacePage{
				page_number: r.u8()!
				text:        r.read_string()!
				photo_name:  r.read_string()!
			}
		}
		1 {
			return BookEditAddPage{
				page_number: r.u8()!
				text:        r.read_string()!
				photo_name:  r.read_string()!
			}
		}
		2 {
			return BookEditDeletePage{
				page_number: r.u8()!
			}
		}
		3 {
			return BookEditSwapPages{
				page_number:           r.u8()!
				secondary_page_number: r.u8()!
			}
		}
		4 {
			return BookEditSignBook{
				title:  r.read_string()!
				author: r.read_string()!
				xuid:   r.read_string()!
			}
		}
		else {
			return error('invalid BookEditAction ${id}')
		}
	}
}

pub struct BookEditPacket {
pub mut:
	action         BookEditAction = BookEditDeletePage{}
	inventory_slot u8
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
	w.u8(p.action.id())
	w.u8(p.inventory_slot)
	p.action.encode_payload(mut w)
}

pub fn (mut p BookEditPacket) decode_payload(mut r serializer.Reader) ! {
	action_id := r.u8()!
	p.inventory_slot = r.u8()!
	p.action = BookEditAction.decode_payload(action_id, mut r)!
}
