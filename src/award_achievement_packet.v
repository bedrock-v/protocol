module protocol

import serializer

pub struct AwardAchievementPacket {
pub mut:
	achievement_id int
}

pub fn (p &AwardAchievementPacket) pid() u16 {
	return award_achievement_packet
}

pub fn (p &AwardAchievementPacket) name() string {
	return 'AwardAchievementPacket'
}

pub fn (p &AwardAchievementPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AwardAchievementPacket) decode_payload(mut r serializer.Reader) ! {
	p.achievement_id = int(r.le_i32()!)
}

pub fn (p &AwardAchievementPacket) encode_payload(mut w serializer.Writer) {
	w.le_i32(i32(p.achievement_id))
}
