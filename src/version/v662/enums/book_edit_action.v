module enums

import serializer

pub struct BookEditReplacePage {
pub mut:
	page_index i8
	text       string
	photo_name string
}

pub struct BookEditAddPage {
pub mut:
	page_index i8
	text       string
	photo_name string
}

pub struct BookEditDeletePage {
pub mut:
	page_index i8
}

pub struct BookEditSwapPages {
pub mut:
	page_index_a i8
	page_index_b i8
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

pub fn (t BookEditAction) id() i8 {
	return match t {
		BookEditReplacePage { i8(0) }
		BookEditAddPage { i8(1) }
		BookEditDeletePage { i8(2) }
		BookEditSwapPages { i8(3) }
		BookEditFinalize { i8(4) }
	}
}

pub fn (t BookEditAction) encode_payload(mut w serializer.Writer) {
	match t {
		BookEditReplacePage {
			w.i8(t.page_index)
			w.write_string(t.text)
			w.write_string(t.photo_name)
		}
		BookEditAddPage {
			w.i8(t.page_index)
			w.write_string(t.text)
			w.write_string(t.photo_name)
		}
		BookEditDeletePage {
			w.i8(t.page_index)
		}
		BookEditSwapPages {
			w.i8(t.page_index_a)
			w.i8(t.page_index_b)
		}
		BookEditFinalize {
			w.write_string(t.title)
			w.write_string(t.author)
			w.write_string(t.xuid)
		}
	}
}

pub fn (t BookEditAction) encode(mut w serializer.Writer) {
	w.i8(t.id())
	t.encode_payload(mut w)
}

pub fn BookEditAction.decode(mut r serializer.Reader) !BookEditAction {
	d := r.i8()!
	return BookEditAction.decode_payload(d, mut r)!
}

pub fn BookEditAction.decode_payload(d i8, mut r serializer.Reader) !BookEditAction {
	match d {
		0 {
			return BookEditReplacePage{
				page_index: r.i8()!
				text:       r.read_string()!
				photo_name: r.read_string()!
			}
		}
		1 {
			return BookEditAddPage{
				page_index: r.i8()!
				text:       r.read_string()!
				photo_name: r.read_string()!
			}
		}
		2 {
			return BookEditDeletePage{
				page_index: r.i8()!
			}
		}
		3 {
			return BookEditSwapPages{
				page_index_a: r.i8()!
				page_index_b: r.i8()!
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
