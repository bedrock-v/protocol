module enums

import protocol.serializer

pub enum PlayStatus as i32 {
	login_success                                  = 0
	login_failed_client_old                        = 1
	login_failed_server_old                        = 2
	player_spawn                                   = 3
	login_failed_invalid_tenant                    = 4
	login_failed_edition_mismatch_edu_to_vanilla   = 5
	login_failed_edition_mismatch_vanilla_to_edu   = 6
	login_failed_server_full_sub_client            = 7
	login_failed_editor_mismatch_editor_to_vanilla = 8
	login_failed_editor_mismatch_vanilla_to_editor = 9
}

pub fn (e PlayStatus) encode(mut w serializer.Writer) {
	w.be_i32(i32(e))
}

pub fn PlayStatus.decode(mut r serializer.Reader) !PlayStatus {
	return unsafe { PlayStatus(r.be_i32()!) }
}
