module packets

import serializer

pub struct AwardAchievementPacket {
pub mut:
	achievement_id i32
}

pub fn (p &AwardAchievementPacket) pid() u16 { return 309 }

pub fn (p &AwardAchievementPacket) name() string { return 'AwardAchievementPacket' }

pub fn (p &AwardAchievementPacket) can_be_sent_before_login() bool { return false }

pub fn (p &AwardAchievementPacket) encode_payload(mut w serializer.Writer) {
	w.le_i32(p.achievement_id)
}

pub fn (mut p AwardAchievementPacket) decode_payload(mut r serializer.Reader) ! {
	p.achievement_id = r.le_i32()!
}
