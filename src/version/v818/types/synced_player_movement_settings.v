module types

import serializer

pub struct SyncedPlayerMovementSettings {
pub mut:
	rewind_history_size                 i32
	server_authoritative_block_breaking bool
}

pub fn (t SyncedPlayerMovementSettings) encode(mut w serializer.Writer) {
	w.write_varint32(t.rewind_history_size)
	w.bool(t.server_authoritative_block_breaking)
}

pub fn SyncedPlayerMovementSettings.decode(mut r serializer.Reader) !SyncedPlayerMovementSettings {
	return SyncedPlayerMovementSettings{
		rewind_history_size:                 r.read_varint32()!
		server_authoritative_block_breaking: r.bool()!
	}
}
