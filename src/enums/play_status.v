module enums

pub enum PlayStatus {
	login_success         = 0
	login_failed_client   = 1
	login_failed_server   = 2
	player_spawn          = 3
	login_failed_invalid_tenant = 4
	login_failed_vanilla_edu    = 5
	login_failed_edu_vanilla    = 6
	login_failed_server_full    = 7
	login_failed_editor_vanilla = 8
	login_failed_vanilla_editor = 9
}
