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

export type Maps = {
    R15Clothing: R15ClothingMaps,
}

return {}