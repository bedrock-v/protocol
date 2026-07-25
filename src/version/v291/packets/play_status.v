module packets

import serializer

pub enum PlayStatus as i32 {
	login_success                                = 0
	login_failed_client_old                      = 1
	login_failed_server_old                      = 2
	player_spawn                                 = 3
	login_failed_invalid_tenant                  = 4
	login_failed_edition_mismatch_edu_to_vanilla = 5
	login_failed_edition_mismatch_vanilla_to_edu = 6
	failed_server_full_sub_client                = 7
	editor_to_vanilla_mismatch                   = 8
	vanilla_to_editor_mismatch                   = 9
}

pub struct PlayStatusPacket {
pub mut:
	status PlayStatus
}

pub fn (p &PlayStatusPacket) pid() u16 {
	return 2
}

pub fn (p &PlayStatusPacket) name() string {
	return 'PlayStatusPacket'
}

pub fn (p &PlayStatusPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &PlayStatusPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(i32(p.status))
}

pub fn (mut p PlayStatusPacket) decode_payload(mut r serializer.Reader) ! {
	p.status = unsafe { PlayStatus(r.be_i32()!) }
}
