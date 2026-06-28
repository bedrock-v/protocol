module protocol

import serializer

pub struct PartyChangedPacket {
pub mut:
	party_id     string
	party_leader bool
}

pub fn (p &PartyChangedPacket) pid() u16 {
	return party_changed_packet
}

pub fn (p &PartyChangedPacket) name() string {
	return 'PartyChangedPacket'
}

pub fn (p &PartyChangedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PartyChangedPacket) decode_payload(mut r serializer.Reader) ! {
	p.party_id = r.read_string()!
	p.party_leader = r.bool()!
}

pub fn (p &PartyChangedPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.party_id)
	w.bool(p.party_leader)
}
