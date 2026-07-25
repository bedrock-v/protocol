module enums

import serializer

pub enum GamePublishSetting as i32 {
	no_multi_play      = 0
	invite_only        = 1
	friends_only       = 2
	friends_of_friends = 3
	public             = 4
}

pub fn (e GamePublishSetting) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn GamePublishSetting.decode(mut r serializer.Reader) !GamePublishSetting {
	return unsafe { GamePublishSetting(r.read_varint32()!) }
}
