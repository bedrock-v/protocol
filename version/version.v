module version

pub enum ProtoVersion {
	unknown
	v2
	v3
	v4
	v5
	v6
	v7
	v8
	v9
	v11
	v12
	v14
	v15
	v17
	v18
	v20
	v27
	v34
	v38
	v45
	v60
	v70
	v81
	v84
	v90
	v91
	v100
	v105
	v107
	v113
	v130
	v137
	v141
	v150
	v160
	v201
	v223
	v261
	v274
	v280
	v282
	v291
	v313
	v332
	v340
	v354
	v361
	v388
	v389
	v390
	v407
	v408
	v419
	v422
	v428
	v431
	v440
	v448
	v465
	v471
	v475
	v486
	v503
	v527
	v534
	v544
	v545
	v554
	v557
	v560
	v567
	v568
	v575
	v582
	v589
	v594
	v618
	v622
	v630
	v649
	v662
	v671
	v685
	v686
	v712
	v729
	v748
	v766
	v776
	v786
	v800
	v818
	v819
	v827
	v844
	v859
	v898
	v924
	v944
	v975
	v1001
	v2168
	v2192
}

pub fn (v ProtoVersion) protocol_id() int {
	return match v {
		.unknown { 0 }
		.v2 { 2 }
		.v3 { 3 }
		.v4 { 4 }
		.v5 { 5 }
		.v6 { 6 }
		.v7 { 7 }
		.v8 { 8 }
		.v9 { 9 }
		.v11 { 11 }
		.v12 { 12 }
		.v14 { 14 }
		.v15 { 15 }
		.v17 { 17 }
		.v18 { 18 }
		.v20 { 20 }
		.v27 { 27 }
		.v34 { 34 }
		.v38 { 38 }
		.v45 { 45 }
		.v60 { 60 }
		.v70 { 70 }
		.v81 { 81 }
		.v84 { 84 }
		.v90 { 90 }
		.v91 { 91 }
		.v100 { 100 }
		.v105 { 105 }
		.v107 { 107 }
		.v113 { 113 }
		.v130 { 130 }
		.v137 { 137 }
		.v141 { 141 }
		.v150 { 150 }
		.v160 { 160 }
		.v201 { 201 }
		.v223 { 223 }
		.v261 { 261 }
		.v274 { 274 }
		.v280 { 280 }
		.v282 { 282 }
		.v291 { 291 }
		.v313 { 313 }
		.v332 { 332 }
		.v340 { 340 }
		.v354 { 354 }
		.v361 { 361 }
		.v388 { 388 }
		.v389 { 389 }
		.v390 { 390 }
		.v407 { 407 }
		.v408 { 408 }
		.v419 { 419 }
		.v422 { 422 }
		.v428 { 428 }
		.v431 { 431 }
		.v440 { 440 }
		.v448 { 448 }
		.v465 { 465 }
		.v471 { 471 }
		.v475 { 475 }
		.v486 { 486 }
		.v503 { 503 }
		.v527 { 527 }
		.v534 { 534 }
		.v544 { 544 }
		.v545 { 545 }
		.v554 { 554 }
		.v557 { 557 }
		.v560 { 560 }
		.v567 { 567 }
		.v568 { 568 }
		.v575 { 575 }
		.v582 { 582 }
		.v589 { 589 }
		.v594 { 594 }
		.v618 { 618 }
		.v622 { 622 }
		.v630 { 630 }
		.v649 { 649 }
		.v662 { 662 }
		.v671 { 671 }
		.v685 { 685 }
		.v686 { 686 }
		.v712 { 712 }
		.v729 { 729 }
		.v748 { 748 }
		.v766 { 766 }
		.v776 { 776 }
		.v786 { 786 }
		.v800 { 800 }
		.v818 { 818 }
		.v819 { 819 }
		.v827 { 827 }
		.v844 { 844 }
		.v859 { 859 }
		.v898 { 898 }
		.v924 { 924 }
		.v944 { 944 }
		.v975 { 975 }
		.v1001 { 1001 }
		.v2168 { 2168 }
		.v2192 { 2192 }
	}
}

pub fn (v ProtoVersion) raknet_version() int {
	id := v.protocol_id()
	return match true {
		id == 0 { 10 }
		id <= 113 { 8 }
		id <= 274 { 9 }
		id <= 390 { 9 }
		id <= 649 { 10 }
		else { 11 }
	}
}

pub fn (v ProtoVersion) minecraft_version() string {
	return match v {
		.unknown { '0.0.0' }
		.v2 { '0.2.0' }
		.v3 { '0.2.1' }
		.v4 { '0.3.0' }
		.v5 { '0.3.2' }
		.v6 { '0.3.3' }
		.v7 { '0.4.0' }
		.v8 { '0.5.0' }
		.v9 { '0.6.0' }
		.v11 { '0.7.0' }
		.v12 { '0.7.4' }
		.v14 { '0.8.0' }
		.v15 { '0.9.0' }
		.v17 { '0.9.0' }
		.v18 { '0.9.5' }
		.v20 { '0.10.0' }
		.v27 { '0.11.0' }
		.v34 { '0.12.1' }
		.v38 { '0.13.0' }
		.v45 { '0.14.0' }
		.v60 { '0.14.2' }
		.v70 { '0.14.3' }
		.v81 { '0.15.0' }
		.v84 { '0.15.10' }
		.v90 { '0.16.0' }
		.v91 { '0.16.0' }
		.v100 { '1.0.0' }
		.v105 { '1.0.5' }
		.v107 { '1.0.7' }
		.v113 { '1.1.0' }
		.v130 { '1.2.0' }
		.v137 { '1.2.0' }
		.v141 { '1.2.5' }
		.v150 { '1.2.6' }
		.v160 { '1.2.7' }
		.v201 { '1.2.10' }
		.v223 { '1.2.13' }
		.v261 { '1.4.0' }
		.v274 { '1.5.0' }
		.v280 { '1.6.0' }
		.v282 { '1.6.0' }
		.v291 { '1.7.0' }
		.v313 { '1.8.0' }
		.v332 { '1.9.0' }
		.v340 { '1.10.0' }
		.v354 { '1.11.0' }
		.v361 { '1.12.0' }
		.v388 { '1.13.0' }
		.v389 { '1.14.0' }
		.v390 { '1.14.60' }
		.v407 { '1.16.0' }
		.v408 { '1.16.20' }
		.v419 { '1.16.100' }
		.v422 { '1.16.200' }
		.v428 { '1.16.210' }
		.v431 { '1.16.220' }
		.v440 { '1.17.0' }
		.v448 { '1.17.10' }
		.v465 { '1.17.30' }
		.v471 { '1.17.40' }
		.v475 { '1.18.0' }
		.v486 { '1.18.10' }
		.v503 { '1.18.30' }
		.v527 { '1.19.0' }
		.v534 { '1.19.10' }
		.v544 { '1.19.20' }
		.v545 { '1.19.21' }
		.v554 { '1.19.30' }
		.v557 { '1.19.40' }
		.v560 { '1.19.50' }
		.v567 { '1.19.60' }
		.v568 { '1.19.63' }
		.v575 { '1.19.70' }
		.v582 { '1.19.80' }
		.v589 { '1.20.0' }
		.v594 { '1.20.10' }
		.v618 { '1.20.30' }
		.v622 { '1.20.40' }
		.v630 { '1.20.50' }
		.v649 { '1.20.60' }
		.v662 { '1.20.70' }
		.v671 { '1.20.80' }
		.v685 { '1.21.0' }
		.v686 { '1.21.2' }
		.v712 { '1.21.20' }
		.v729 { '1.21.30' }
		.v748 { '1.21.40' }
		.v766 { '1.21.50' }
		.v776 { '1.21.60' }
		.v786 { '1.21.70' }
		.v800 { '1.21.80' }
		.v818 { '1.21.90' }
		.v819 { '1.21.93' }
		.v827 { '1.21.100' }
		.v844 { '1.21.111' }
		.v859 { '1.21.120' }
		.v898 { '1.21.130' }
		.v924 { '1.26.0' }
		.v944 { '1.26.10' }
		.v975 { '1.26.20' }
		.v1001 { '1.26.30' }
		.v2168 { '1.26.40' }
		.v2192 { '1.26.50' }
	}
}

pub fn from_protocol_id(id int) ProtoVersion {
	return match id {
		2 { ProtoVersion.v2 }
		3 { ProtoVersion.v3 }
		4 { ProtoVersion.v4 }
		5 { ProtoVersion.v5 }
		6 { ProtoVersion.v6 }
		7 { ProtoVersion.v7 }
		8 { ProtoVersion.v8 }
		9 { ProtoVersion.v9 }
		11 { ProtoVersion.v11 }
		12 { ProtoVersion.v12 }
		14 { ProtoVersion.v14 }
		15 { ProtoVersion.v15 }
		17 { ProtoVersion.v17 }
		18 { ProtoVersion.v18 }
		20 { ProtoVersion.v20 }
		27 { ProtoVersion.v27 }
		34 { ProtoVersion.v34 }
		38 { ProtoVersion.v38 }
		45 { ProtoVersion.v45 }
		60 { ProtoVersion.v60 }
		70 { ProtoVersion.v70 }
		81 { ProtoVersion.v81 }
		84 { ProtoVersion.v84 }
		90 { ProtoVersion.v90 }
		91 { ProtoVersion.v91 }
		100 { ProtoVersion.v100 }
		105 { ProtoVersion.v105 }
		107 { ProtoVersion.v107 }
		113 { ProtoVersion.v113 }
		130 { ProtoVersion.v130 }
		137 { ProtoVersion.v137 }
		141 { ProtoVersion.v141 }
		150 { ProtoVersion.v150 }
		160 { ProtoVersion.v160 }
		201 { ProtoVersion.v201 }
		223 { ProtoVersion.v223 }
		261 { ProtoVersion.v261 }
		274 { ProtoVersion.v274 }
		280 { ProtoVersion.v280 }
		282 { ProtoVersion.v282 }
		291 { ProtoVersion.v291 }
		313 { ProtoVersion.v313 }
		332 { ProtoVersion.v332 }
		340 { ProtoVersion.v340 }
		354 { ProtoVersion.v354 }
		361 { ProtoVersion.v361 }
		388 { ProtoVersion.v388 }
		389 { ProtoVersion.v389 }
		390 { ProtoVersion.v390 }
		407 { ProtoVersion.v407 }
		408 { ProtoVersion.v408 }
		419 { ProtoVersion.v419 }
		422 { ProtoVersion.v422 }
		428 { ProtoVersion.v428 }
		431 { ProtoVersion.v431 }
		440 { ProtoVersion.v440 }
		448 { ProtoVersion.v448 }
		465 { ProtoVersion.v465 }
		471 { ProtoVersion.v471 }
		475 { ProtoVersion.v475 }
		486 { ProtoVersion.v486 }
		503 { ProtoVersion.v503 }
		527 { ProtoVersion.v527 }
		534 { ProtoVersion.v534 }
		544 { ProtoVersion.v544 }
		545 { ProtoVersion.v545 }
		554 { ProtoVersion.v554 }
		557 { ProtoVersion.v557 }
		560 { ProtoVersion.v560 }
		567 { ProtoVersion.v567 }
		568 { ProtoVersion.v568 }
		575 { ProtoVersion.v575 }
		582 { ProtoVersion.v582 }
		589 { ProtoVersion.v589 }
		594 { ProtoVersion.v594 }
		618 { ProtoVersion.v618 }
		622 { ProtoVersion.v622 }
		630 { ProtoVersion.v630 }
		649 { ProtoVersion.v649 }
		662 { ProtoVersion.v662 }
		671 { ProtoVersion.v671 }
		685 { ProtoVersion.v685 }
		686 { ProtoVersion.v686 }
		712 { ProtoVersion.v712 }
		729 { ProtoVersion.v729 }
		748 { ProtoVersion.v748 }
		766 { ProtoVersion.v766 }
		776 { ProtoVersion.v776 }
		786 { ProtoVersion.v786 }
		800 { ProtoVersion.v800 }
		818 { ProtoVersion.v818 }
		819 { ProtoVersion.v819 }
		827 { ProtoVersion.v827 }
		844 { ProtoVersion.v844 }
		859 { ProtoVersion.v859 }
		898 { ProtoVersion.v898 }
		924 { ProtoVersion.v924 }
		944 { ProtoVersion.v944 }
		975 { ProtoVersion.v975 }
		1001 { ProtoVersion.v1001 }
		2168 { ProtoVersion.v2168 }
		2192 { ProtoVersion.v2192 }
		else { ProtoVersion.unknown }
	}
}

pub fn all() []ProtoVersion {
	return [ProtoVersion.v2, .v3, .v4, .v5, .v6, .v7, .v8, .v9, .v11, .v12, .v14, .v15, .v17, .v18,
		.v20, .v27, .v34, .v38, .v45, .v60, .v70, .v81, .v84, .v90, .v91, .v100, .v105, .v107,
		.v113, .v130, .v137, .v141, .v150, .v160, .v201, .v223, .v261, .v274, .v280, .v282, .v291,
		.v313, .v332, .v340, .v354, .v361, .v388, .v389, .v390, .v407, .v408, .v419, .v422, .v428,
		.v431, .v440, .v448, .v465, .v471, .v475, .v486, .v503, .v527, .v534, .v544, .v545, .v554,
		.v557, .v560, .v567, .v568, .v575, .v582, .v589, .v594, .v618, .v622, .v630, .v649, .v662,
		.v671, .v685, .v686, .v712, .v729, .v748, .v766, .v776, .v786, .v800, .v818, .v819, .v827,
		.v844, .v859, .v898, .v924, .v944, .v975, .v1001, .v2168, .v2192]
}
