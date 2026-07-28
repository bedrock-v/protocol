module enums

import protocol.serializer

pub enum ActorBlockSyncMessageID as u32 {
	@none   = 0
	create  = 1
	destroy = 2
}

pub fn (e ActorBlockSyncMessageID) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ActorBlockSyncMessageID.decode(mut r serializer.Reader) !ActorBlockSyncMessageID {
	return unsafe { ActorBlockSyncMessageID(r.read_varuint32()!) }
}
