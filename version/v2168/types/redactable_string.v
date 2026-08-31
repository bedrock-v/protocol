module types

import protocol.serializer

pub struct RedactableString {
pub mut:
	unredacted string
	redacted   ?string
}

pub fn (t RedactableString) encode(mut w serializer.Writer) {
	w.write_string(t.unredacted)
	if v := t.redacted {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
}

pub fn RedactableString.decode(mut r serializer.Reader) !RedactableString {
	mut t := RedactableString{}
	t.unredacted = r.read_string()!
	if r.bool()! {
		t.redacted = r.read_string()!
	}
	return t
}
