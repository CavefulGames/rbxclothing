export type R15ClothingMaps = {
	rightLimbs: {
		[number]: { 
			position: Vector2,
			size: Vector2,
			drawPosition: Vector2,
			rotation: number?
		}
	},
	leftLimbs: {
		[number]: { 
			position: Vector2,
			size: Vector2,
			drawPosition: Vector2,
			rotation: number?
		}
	},
	torso: {
		[number]: { 
			position: Vector2,
			size: Vector2,
			drawPosition: Vector2,
		}
	},
}

return {
	rightLimbs = {
		{ --// U
			position = Vector2.new(217, 289),
			size = Vector2.one * 63,
			drawPosition = Vector2.one * 2,
			rotation = 270,
		},
		{ --// R
			position = Vector2.new(151, 355),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.new(2, 66),			
		},
		{ --// R2
			position = Vector2.new(151, 464),
			size = Vector2.new(63, 18),
			drawPosition = Vector2.new(2, 216),		
		},
		{ --// F
			position = Vector2.new(217, 355),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.one * 66,			
		},
		{ --// F2
			position = Vector2.new(217, 464),
			size = Vector2.new(63, 18),
			drawPosition = Vector2.new(66, 216),		
		},
		{ --// L
			position = Vector2.new(19, 355),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.new(130, 66),			
		},
		{ --// L2
			position = Vector2.new(19, 464),
			size = Vector2.new(63, 18),
			drawPosition = Vector2.new(130, 216),
		},
		{ --// B
			position = Vector2.new(85, 355),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.new(194, 66),			
		},
		{ --// B2
			position = Vector2.new(85, 464),
			size = Vector2.new(63, 18),
			drawPosition = Vector2.new(2, 236),
		},
		{ --// D
			position = Vector2.new(217, 485),
			size = Vector2.one * 63,
			drawPosition = Vector2.new(198, 218),			
		},
	},
	leftLimbs = {
		{ --// U
			position = Vector2.new(308, 289),
			size = Vector2.one * 63,
			drawPosition = Vector2.one * 2,
			rotation = 270,
		},
		{ --// R
			position = Vector2.new(506, 355),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.new(2, 66),			
		},
		{ --// R2
			position = Vector2.new(506, 464),
			size = Vector2.new(63, 18),
			drawPosition = Vector2.new(2, 216),		
		},
		{ --// F
			position = Vector2.new(308, 355),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.one * 66,			
		},
		{ --// F2
			position = Vector2.new(308, 464),
			size = Vector2.new(63, 18),
			drawPosition = Vector2.new(66, 216),		
		},
		{ --// L
			position = Vector2.new(374, 355),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.new(130, 66),			
		},
		{ --// L2
			position = Vector2.new(374, 464),
			size = Vector2.new(63, 18),
			drawPosition = Vector2.new(130, 216),
		},
		{ --// B
			position = Vector2.new(440, 355),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.new(194, 66),			
		},
		{ --// B2
			position = Vector2.new(440, 464),
			size = Vector2.new(63, 18),
			drawPosition = Vector2.new(2, 236),
		},
		{ --// D
			position = Vector2.new(308, 485),
			size = Vector2.one * 63,
			drawPosition = Vector2.new(198, 218),			
		},
	},
	torso = {
		U = {
			position = Vector2.new(231, 8),
			size = Vector2.new(127, 63),
			drawPosition = Vector2.new(2, 10),			
		},
		{ --// F
			position = Vector2.new(231, 74),
			size = Vector2.new(127, 127),
			drawPosition = Vector2.new(2, 74),			
		},
		{ --// D
			position = Vector2.new(231, 204),
			size = Vector2.new(127, 63),
			drawPosition = Vector2.new(2, 202),			
		},
		{ --// L
			position = Vector2.new(361, 74),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.new(130, 74),			
		},
		{ --// B
			position = Vector2.new(427, 74),
			size = Vector2.new(127, 127),
			drawPosition = Vector2.new(194, 74),			
		},
		{ --// R
			position = Vector2.new(165, 74),
			size = Vector2.new(63, 127),
			drawPosition = Vector2.new(322, 74),			
		},
	},
} :: R15ClothingMaps