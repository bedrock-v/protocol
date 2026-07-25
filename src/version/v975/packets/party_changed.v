module packets

import serializer

pub struct PlayerPartyInfo {
pub mut:
	party_id        string
	is_party_leader bool
}

pub fn (t PlayerPartyInfo) encode(mut w serializer.Writer) {
	w.write_string(t.party_id)
	w.bool(t.is_party_leader)
}

pub fn PlayerPartyInfo.decode(mut r serializer.Reader) !PlayerPartyInfo {
	return PlayerPartyInfo{
		party_id:        r.read_string()!
		is_party_leader: r.bool()!
	}
}

pub struct PartyChangedPacket {
pub mut:
	party_info ?PlayerPartyInfo
}

pub fn (p &PartyChangedPacket) pid() u16 { return 342 }

pub fn (p &PartyChangedPacket) name() string { return 'PartyChangedPacket' }

pub fn (p &PartyChangedPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PartyChangedPacket) encode_payload(mut w serializer.Writer) {
	if v := p.party_info {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn (mut p PartyChangedPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.party_info = PlayerPartyInfo.decode(mut r)!
	}
}
