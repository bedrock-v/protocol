module types

import serializer

pub struct IdentityInvalid {}

pub struct IdentityPlayer {
pub mut:
	player_unique_id i64
}

pub struct IdentityEntity {
pub mut:
	actor_id ActorUniqueID
}

pub struct IdentityFakePlayer {
pub mut:
	fake_player_name string
}

pub type IdentityDefinitionType = IdentityEntity
	| IdentityFakePlayer
	| IdentityInvalid
	| IdentityPlayer

pub fn (t IdentityDefinitionType) encode(mut w serializer.Writer) {
	match t {
		IdentityInvalid { w.i8(0) }
		IdentityPlayer {
			w.i8(1)
			w.write_varint64(t.player_unique_id)
		}
		IdentityEntity {
			w.i8(2)
			t.actor_id.encode(mut w)
		}
		IdentityFakePlayer {
			w.i8(3)
			w.write_string(t.fake_player_name)
		}
	}
}

pub fn IdentityDefinitionType.decode(mut r serializer.Reader) !IdentityDefinitionType {
	d := r.i8()!
	match d {
		0 { return IdentityInvalid{} }
		1 { return IdentityPlayer{ player_unique_id: r.read_varint64()! } }
		2 { return IdentityEntity{ actor_id: ActorUniqueID.decode(mut r)! } }
		3 { return IdentityFakePlayer{ fake_player_name: r.read_string()! } }
		else { return error('invalid IdentityDefinitionType ${d}') }
	}
}
