module types

import serializer

pub struct EduSharedUriResource {
pub mut:
	button_name string
	link_uri    string
}

pub fn (t EduSharedUriResource) encode(mut w serializer.Writer) {
	w.write_string(t.button_name)
	w.write_string(t.link_uri)
}

pub fn EduSharedUriResource.decode(mut r serializer.Reader) !EduSharedUriResource {
	return EduSharedUriResource{
		button_name: r.read_string()!
		link_uri:    r.read_string()!
	}
}
