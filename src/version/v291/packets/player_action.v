module packets

import serializer
import version.v291.types

pub enum PlayerActionType as i32 {
	start_break                                        = 0
	abort_break                                        = 1
	stop_break                                         = 2
	get_updated_block                                  = 3
	drop_item                                          = 4
	start_sleep                                        = 5
	stop_sleep                                         = 6
	respawn                                            = 7
	jump                                               = 8
	start_sprint                                       = 9
	stop_sprint                                        = 10
	start_sneak                                        = 11
	stop_sneak                                         = 12
	dimension_change_request_or_creative_destroy_block = 13
	dimension_change_success                           = 14
	start_glide                                        = 15
	stop_glide                                         = 16
	build_denied                                       = 17
	continue_break                                     = 18
	change_skin                                        = 19
	set_enchantment_seed                               = 20
	start_swimming                                     = 21
	stop_swimming                                      = 22
	start_spin_attack                                  = 23
	stop_spin_attack                                   = 24
	block_interact                                     = 25
	block_predict_destroy                              = 26
	block_continue_destroy                             = 27
	start_item_use_on                                  = 28
	stop_item_use_on                                   = 29
	handled_teleport                                   = 30
	missed_swing                                       = 31
	start_crawling                                     = 32
	stop_crawling                                      = 33
	start_flying                                       = 34
	stop_flying                                        = 35
	received_server_data                               = 36
	start_using_item                                   = 37
}

pub struct PlayerActionPacket {
pub mut:
	runtime_entity_id u64
	action            PlayerActionType
	block_position    types.BlockPosition
	face              i32
}

pub fn (p &PlayerActionPacket) pid() u16 {
	return 36
}

pub fn (p &PlayerActionPacket) name() string {
	return 'PlayerActionPacket'
}

pub fn (p &PlayerActionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerActionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	w.write_varint32(i32(p.action))
	p.block_position.encode(mut w)
	w.write_varint32(p.face)
}

pub fn (mut p PlayerActionPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.action = unsafe { PlayerActionType(r.read_varint32()!) }
	p.block_position = types.BlockPosition.decode(mut r)!
	p.face = r.read_varint32()!
}
