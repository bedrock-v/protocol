module main

import version
import version.v2
import version.v3
import version.v4
import version.v5
import version.v6
import version.v7
import version.v8
import version.v9
import version.v11
import version.v12
import version.v14
import version.v15
import version.v17
import version.v18
import version.v20
import version.v27
import version.v34
import version.v38
import version.v45
import version.v60
import version.v70
import version.v81
import version.v84
import version.v90
import version.v91
import version.v100
import version.v105
import version.v107
import version.v113
import version.v130
import version.v137
import version.v141
import version.v150
import version.v160
import version.v201
import version.v223
import version.v261
import version.v274
import version.v280
import version.v282
import version.v291
import version.v313
import version.v332
import version.v340
import version.v354
import version.v361
import version.v388
import version.v389
import version.v390
import version.v407
import version.v408
import version.v419
import version.v422
import version.v428
import version.v431
import version.v440
import version.v448
import version.v465
import version.v471
import version.v475
import version.v486
import version.v503
import version.v527
import version.v534
import version.v544
import version.v545
import version.v554
import version.v557
import version.v560
import version.v567
import version.v568
import version.v575
import version.v582
import version.v589
import version.v594
import version.v618
import version.v622
import version.v630
import version.v649
import version.v662
import version.v671
import version.v685
import version.v686
import version.v712
import version.v729
import version.v748
import version.v766
import version.v776
import version.v786
import version.v800
import version.v818
import version.v819
import version.v827
import version.v844
import version.v859
import version.v898
import version.v924
import version.v944
import version.v975
import version.v1001
import version.v2168

fn main() {
	mut pools := map[int]int{}
	pools[2] = v2.new_pool().factories.len
	pools[3] = v3.new_pool().factories.len
	pools[4] = v4.new_pool().factories.len
	pools[5] = v5.new_pool().factories.len
	pools[6] = v6.new_pool().factories.len
	pools[7] = v7.new_pool().factories.len
	pools[8] = v8.new_pool().factories.len
	pools[9] = v9.new_pool().factories.len
	pools[11] = v11.new_pool().factories.len
	pools[12] = v12.new_pool().factories.len
	pools[14] = v14.new_pool().factories.len
	pools[15] = v15.new_pool().factories.len
	pools[17] = v17.new_pool().factories.len
	pools[18] = v18.new_pool().factories.len
	pools[20] = v20.new_pool().factories.len
	pools[27] = v27.new_pool().factories.len
	pools[34] = v34.new_pool().factories.len
	pools[38] = v38.new_pool().factories.len
	pools[45] = v45.new_pool().factories.len
	pools[60] = v60.new_pool().factories.len
	pools[70] = v70.new_pool().factories.len
	pools[81] = v81.new_pool().factories.len
	pools[84] = v84.new_pool().factories.len
	pools[90] = v90.new_pool().factories.len
	pools[91] = v91.new_pool().factories.len
	pools[100] = v100.new_pool().factories.len
	pools[105] = v105.new_pool().factories.len
	pools[107] = v107.new_pool().factories.len
	pools[113] = v113.new_pool().factories.len
	pools[130] = v130.new_pool().factories.len
	pools[137] = v137.new_pool().factories.len
	pools[141] = v141.new_pool().factories.len
	pools[150] = v150.new_pool().factories.len
	pools[160] = v160.new_pool().factories.len
	pools[201] = v201.new_pool().factories.len
	pools[223] = v223.new_pool().factories.len
	pools[261] = v261.new_pool().factories.len
	pools[274] = v274.new_pool().factories.len
	pools[280] = v280.new_pool().factories.len
	pools[282] = v282.new_pool().factories.len
	pools[291] = v291.new_pool().factories.len
	pools[313] = v313.new_pool().factories.len
	pools[332] = v332.new_pool().factories.len
	pools[340] = v340.new_pool().factories.len
	pools[354] = v354.new_pool().factories.len
	pools[361] = v361.new_pool().factories.len
	pools[388] = v388.new_pool().factories.len
	pools[389] = v389.new_pool().factories.len
	pools[390] = v390.new_pool().factories.len
	pools[407] = v407.new_pool().factories.len
	pools[408] = v408.new_pool().factories.len
	pools[419] = v419.new_pool().factories.len
	pools[422] = v422.new_pool().factories.len
	pools[428] = v428.new_pool().factories.len
	pools[431] = v431.new_pool().factories.len
	pools[440] = v440.new_pool().factories.len
	pools[448] = v448.new_pool().factories.len
	pools[465] = v465.new_pool().factories.len
	pools[471] = v471.new_pool().factories.len
	pools[475] = v475.new_pool().factories.len
	pools[486] = v486.new_pool().factories.len
	pools[503] = v503.new_pool().factories.len
	pools[527] = v527.new_pool().factories.len
	pools[534] = v534.new_pool().factories.len
	pools[544] = v544.new_pool().factories.len
	pools[545] = v545.new_pool().factories.len
	pools[554] = v554.new_pool().factories.len
	pools[557] = v557.new_pool().factories.len
	pools[560] = v560.new_pool().factories.len
	pools[567] = v567.new_pool().factories.len
	pools[568] = v568.new_pool().factories.len
	pools[575] = v575.new_pool().factories.len
	pools[582] = v582.new_pool().factories.len
	pools[589] = v589.new_pool().factories.len
	pools[594] = v594.new_pool().factories.len
	pools[618] = v618.new_pool().factories.len
	pools[622] = v622.new_pool().factories.len
	pools[630] = v630.new_pool().factories.len
	pools[649] = v649.new_pool().factories.len
	pools[662] = v662.new_pool().factories.len
	pools[671] = v671.new_pool().factories.len
	pools[685] = v685.new_pool().factories.len
	pools[686] = v686.new_pool().factories.len
	pools[712] = v712.new_pool().factories.len
	pools[729] = v729.new_pool().factories.len
	pools[748] = v748.new_pool().factories.len
	pools[766] = v766.new_pool().factories.len
	pools[776] = v776.new_pool().factories.len
	pools[786] = v786.new_pool().factories.len
	pools[800] = v800.new_pool().factories.len
	pools[818] = v818.new_pool().factories.len
	pools[819] = v819.new_pool().factories.len
	pools[827] = v827.new_pool().factories.len
	pools[844] = v844.new_pool().factories.len
	pools[859] = v859.new_pool().factories.len
	pools[898] = v898.new_pool().factories.len
	pools[924] = v924.new_pool().factories.len
	pools[944] = v944.new_pool().factories.len
	pools[975] = v975.new_pool().factories.len
	pools[1001] = v1001.new_pool().factories.len
	pools[2168] = v2168.new_pool().factories.len
	mut total := 0
	for v in version.all() {
		id := v.protocol_id()
		n := pools[id] or { continue }
		total += n
		println('${v} proto=${id} mc=${v.minecraft_version()} rak=${v.raknet_version()} packets=${n}')
	}
	println('versions=${pools.len} total_packet_registrations=${total}')
}
