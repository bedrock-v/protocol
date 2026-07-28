module types

import protocol.serializer
import protocol.version.v662.enums

pub struct SyncedPlayerMovementSettings {
pub mut:
	authority_mode                      enums.ServerAuthMovementMode
	rewind_history_size                 i32
	server_authoritative_block_breaking bool
}

pub fn (t SyncedPlayerMovementSettings) encode(mut w serializer.Writer) {
	t.authority_mode.encode(mut w)
	w.write_varint32(t.rewind_history_size)
	w.bool(t.server_authoritative_block_breaking)
}

pub fn SyncedPlayerMovementSettings.decode(mut r serializer.Reader) !SyncedPlayerMovementSettings {
	return SyncedPlayerMovementSettings{
		authority_mode:                      enums.ServerAuthMovementMode.decode(mut r)!
		rewind_history_size:                 r.read_varint32()!
		server_authoritative_block_breaking: r.bool()!
	}
}
