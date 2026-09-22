module enums

import protocol.serializer

pub struct BookEditReplacePage {
pub mut:
	page_index i32
	text       string
	photo_name string
}

pub struct BookEditAddPage {
pub mut:
	page_index i32
	text       string
	photo_name string
}

pub struct BookEditDeletePage {
pub mut:
	page_index i32
}

pub struct BookEditSwapPages {
pub mut:
	page_index_a i32
	page_index_b i32
}

pub struct BookEditFinalize {
pub mut:
	title  string
	author string
	xuid   string
}

pub type BookEditAction = BookEditAddPage
	| BookEditDeletePage
	| BookEditFinalize
	| BookEditReplacePage
	| BookEditSwapPages

pub fn (t BookEditAction) id() u32 {
	return match t {
		BookEditReplacePage { u32(0) }
		BookEditAddPage { u32(1) }
		BookEditDeletePage { u32(2) }
		BookEditSwapPages { u32(3) }
		BookEditFinalize { u32(4) }
	}
}

pub fn (t BookEditAction) encode_payload(mut w serializer.Writer) {
	match t {
		BookEditReplacePage {
			w.write_varint32(t.page_index)
			w.write_string(t.text)
			w.write_string(t.photo_name)
		}
		BookEditAddPage {
			w.write_varint32(t.page_index)
			w.write_string(t.text)
			w.write_string(t.photo_name)
		}
		BookEditDeletePage {
			w.write_varint32(t.page_index)
		}
		BookEditSwapPages {
			w.write_varint32(t.page_index_a)
			w.write_varint32(t.page_index_b)
		}
		BookEditFinalize {
			w.write_string(t.title)
			w.write_string(t.author)
			w.write_string(t.xuid)
		}
	}
}

pub fn (t BookEditAction) encode(mut w serializer.Writer) {
	w.write_varuint32(t.id())
	t.encode_payload(mut w)
}

pub fn BookEditAction.decode(mut r serializer.Reader) !BookEditAction {
	d := r.read_varuint32()!
	return BookEditAction.decode_payload(d, mut r)!
}

pub fn BookEditAction.decode_payload(d u32, mut r serializer.Reader) !BookEditAction {
	match d {
		0 {
			return BookEditReplacePage{
				page_index: r.read_varint32()!
				text:       r.read_string()!
				photo_name: r.read_string()!
			}
		}
		1 {
			return BookEditAddPage{
				page_index: r.read_varint32()!
				text:       r.read_string()!
				photo_name: r.read_string()!
			}
		}
		2 {
			return BookEditDeletePage{
				page_index: r.read_varint32()!
			}
		}
		3 {
			return BookEditSwapPages{
				page_index_a: r.read_varint32()!
				page_index_b: r.read_varint32()!
			}
		}
		4 {
			return BookEditFinalize{
				title:  r.read_string()!
				author: r.read_string()!
				xuid:   r.read_string()!
			}
		}
		else {
			return error('invalid BookEditAction ${d}')
		}
	}
}
