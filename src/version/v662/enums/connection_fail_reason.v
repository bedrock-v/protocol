module enums

import serializer

pub enum ConnectionFailReason as i32 {
	unknown                                             = 0
	cant_connect_no_internet                            = 1
	no_permissions                                      = 2
	unrecoverable_error                                 = 3
	third_party_blocked                                 = 4
	third_party_no_internet                             = 5
	third_party_bad_ip                                  = 6
	third_party_no_server_or_server_locked              = 7
	version_mismatch                                    = 8
	skin_issue                                          = 9
	invite_session_not_found                            = 10
	edu_level_settings_missing                          = 11
	local_server_not_found                              = 12
	legacy_disconnect                                   = 13
	user_leave_game_attempted                           = 14
	platform_locked_skins_error                         = 15
	realms_world_unassigned                             = 16
	realms_server_cant_connect                          = 17
	realms_server_hidden                                = 18
	realms_server_disabled_beta                         = 19
	realms_server_disabled                              = 20
	cross_platform_disabled                             = 21
	cant_connect                                        = 22
	session_not_found                                   = 23
	client_settings_incompatible_with_server            = 24
	server_full                                         = 25
	invalid_platform_skin                               = 26
	edition_version_mismatch                            = 27
	edition_mismatch                                    = 28
	level_newer_than_exe_version                        = 29
	no_fail_occurred                                    = 30
	banned_skin                                         = 31
	timeout                                             = 32
	server_not_found                                    = 33
	outdated_server                                     = 34
	outdated_client                                     = 35
	no_premium_platform                                 = 36
	multiplayer_disabled                                = 37
	no_wi_fi                                            = 38
	world_corruption                                    = 39
	no_reason                                           = 40
	disconnected                                        = 41
	invalid_player                                      = 42
	logged_in_other_location                            = 43
	server_id_conflict                                  = 44
	not_allowed                                         = 45
	not_authenticated                                   = 46
	invalid_tenant                                      = 47
	unknown_packet                                      = 48
	unexpected_packet                                   = 49
	invalid_command_request_packet                      = 50
	host_suspended                                      = 51
	login_packet_no_request                             = 52
	login_packet_no_cert                                = 53
	missing_client                                      = 54
	kicked                                              = 55
	kicked_for_exploit                                  = 56
	kicked_for_idle                                     = 57
	resource_pack_problem                               = 58
	incompatible_pack                                   = 59
	out_of_storage                                      = 60
	invalid_level                                       = 61
	disconnect_packet                                   = 62
	block_mismatch                                      = 63
	invalid_heights                                     = 64
	invalid_widths                                      = 65
	connection_lost                                     = 66
	zombie_connection                                   = 67
	shutdown                                            = 68
	reason_not_set                                      = 69
	loading_state_timeout                               = 70
	resource_pack_loading_failed                        = 71
	searching_for_session_loading_screen_failed         = 72
	nether_net_protocol_version                         = 73
	subsystem_status_error                              = 74
	empty_auth_from_discovery                           = 75
	empty_url_from_discovery                            = 76
	expired_auth_from_discovery                         = 77
	unknown_signal_service_sign_in_failure              = 78
	xbl_join_lobby_failure                              = 79
	unspecified_client_instance_disconnection           = 80
	nether_net_session_not_found                        = 81
	nether_net_create_peer_connection                   = 82
	nether_net_ice                                      = 83
	nether_net_connect_request                          = 84
	nether_net_connect_response                         = 85
	nether_net_negotiation_timeout                      = 86
	nether_net_inactivity_timeout                       = 87
	stale_connection_being_replaced                     = 88
	realms_session_not_found                            = 89
	bad_packet                                          = 90
	nether_net_failed_to_create_offer                   = 91
	nether_net_failed_to_create_answer                  = 92
	nether_net_failed_to_set_local_description          = 93
	nether_net_failed_to_set_remote_description         = 94
	nether_net_negotiation_timeout_waiting_for_response = 95
	nether_net_negotiation_timeout_waiting_for_accept   = 96
	nether_net_incoming_connection_ignored              = 97
	nether_net_signaling_parsing_failure                = 98
	nether_net_signaling_unknown_error                  = 99
	nether_net_signaling_unicast_delivery_failed        = 100
	nether_net_signaling_broadcast_delivery_failed      = 101
	nether_net_signaling_generic_delivery_failed        = 102
	editor_mismatch_editor_world                        = 103
	editor_mismatch_vanilla_world                       = 104
	world_transfer_not_primary_client                   = 105
	request_server_shutdown                             = 106
	client_game_setup_cancelled                         = 107
	client_game_setup_failed                            = 108
}

pub fn (e ConnectionFailReason) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn ConnectionFailReason.decode(mut r serializer.Reader) !ConnectionFailReason {
	return unsafe { ConnectionFailReason(r.read_varint32()!) }
}
