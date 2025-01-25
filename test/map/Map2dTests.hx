package map;

import dropecho.dungen.generators.VillageGenerator;
import utest.Assert;
import utest.Test;
import dropecho.dungen.Map2d;
import dropecho.dungen.bsp.BSPBuilder; // import dropecho.dungen.generators.ConvChain;
import dropecho.dungen.generators.RoomGenerator; // import dropecho.dungen.generators.MixedGenerator;
import dropecho.dungen.generators.CellularGenerator;

class Map2dTests extends Test {
	@Ignored
	public function test_splat_should_place_sub_map_within_map() {
		var bspGen = new BSPBuilder({
			width: 10,
			height: 10,
			minWidth: 3,
			minHeight: 3,
			depth: 2,
			ratio: .95,
		});

		var map = new Map2d(32, 32, 1);

		for (i in 0...3) {
			for (j in 0...2) {
				var seed = Std.int(Math.random() * 99999);
				bspGen.seed = Std.string(seed);
				var sample = RoomGenerator.buildRooms(bspGen.generate());
				sample.set(Std.int(Math.random() * 7) + 1, 9, 1);
				map.splat(sample, i * 11, j * 16);
			}
		}
		// trace(map);
	}

	public function test_bsp_map() {
		var bsp = new BSPBuilder({
			width: 32,
			height: 32,
			minWidth: 3,
			minHeight: 3,
			depth: 3,
			ratio: .95
		})
			.generate();

		//     var map = RoomGenerator.buildRooms(bsp);
		var params = new VillageParams();
		params.padding = 2;
		var map = VillageGenerator.buildVillages(bsp, params);
		//     trace(map.toPrettyString(['#', '.']));
		Assert.isTrue(true);
	}

	@Ignored
	public function test_cellular_map() {
		var params = new CELLULAR_PARAMS();
		params.start_fill_percent = 30;
		params.passes = 2;
		params.surviveCount = 4;
		params.bornCount = 3;

		var map = CellularGenerator.generate(params);
		//     trace(map.toPrettyString(['#', '.']));
		Assert.isTrue(true);
	}
}
