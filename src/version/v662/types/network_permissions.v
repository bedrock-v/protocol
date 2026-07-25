module types

import serializer

pub struct NetworkPermissions {
pub mut:
	server_auth_sound_enabled bool
}

pub fn (t NetworkPermissions) encode(mut w serializer.Writer) {
	w.bool(t.server_auth_sound_enabled)
}

pub fn NetworkPermissions.decode(mut r serializer.Reader) !NetworkPermissions {
	return NetworkPermissions{
		server_auth_sound_enabled: r.bool()!
	}
}
