local function rotatePoint(x: number, y: number, angle: number)
	local rad = math.rad(angle)
	local cos = math.cos(rad)
	local sin = math.sin(rad)
	return x * cos - y * sin, x * sin + y * cos
end

return function(
	baseImage: EditableImage,
	targetImage: EditableImage,
	map: {
		[string]: {
			position: Vector2,
			size: Vector2,
			drawPosition: Vector2,
			rotation: number?,
		},
	},
	scale: number
)
	for _, v in map do
		local scaledSize = Vector2.new(math.round(v.size.X * scale), math.round(v.size.Y * scale))

		local buf: buffer = baseImage:ReadPixelsBuffer(v.position, v.size)

		if v.rotation and v.rotation % 90 == 0 then
			local ox, oy = v.size.X / 2, v.size.Y / 2
			local width, height = v.size.X, v.size.Y
			local newBuf = buffer.create(width * height * 4)

			for i = 0, (width * height * 4) - 1 do
				buffer.writeu8(newBuf, i, 0)
			end

			for y = 0, height - 1 do
				for x = 0, width - 1 do
					local srcX = x - ox
					local srcY = y - oy
					local rotX, rotY = rotatePoint(srcX, srcY, v.rotation)
					local dstX = math.round(rotX + ox)
					local dstY = math.round(rotY + oy)
					if not (dstX >= 0 and dstX < width and dstY >= 0 and dstY < height) then
						continue
					end

					local pixelOffset = (y * width + x) * 4
					local dstOffset = (dstY * width + dstX) * 4

					local r = buffer.readu8(buf, pixelOffset)
					local g = buffer.readu8(buf, pixelOffset + 1)
					local b = buffer.readu8(buf, pixelOffset + 2)
					local a = buffer.readu8(buf, pixelOffset + 3)

					buffer.writeu8(newBuf, dstOffset, r)
					buffer.writeu8(newBuf, dstOffset + 1, g)
					buffer.writeu8(newBuf, dstOffset + 2, b)
					buffer.writeu8(newBuf, dstOffset + 3, a)
				end
			end
			buf = newBuf
		end

		local scaledBuf = buffer.create(scaledSize.X * scaledSize.Y * 4)
		for i = 0, (scaledSize.X * scaledSize.Y * 4) - 1 do
			buffer.writeu8(scaledBuf, i, 0)
		end

		for y = 0, scaledSize.Y - 1 do
			for x = 0, scaledSize.X - 1 do
				local srcX = math.floor(x / scale)
				local srcY = math.floor(y / scale)

				if srcX >= 0 and srcX < v.size.X and srcY >= 0 and srcY < v.size.Y then
					local srcOffset = (srcY * v.size.X + srcX) * 4
					local dstOffset = (y * scaledSize.X + x) * 4

					local r = buffer.readu8(buf, srcOffset)
					local g = buffer.readu8(buf, srcOffset + 1)
					local b = buffer.readu8(buf, srcOffset + 2)
					local a = buffer.readu8(buf, srcOffset + 3)

					buffer.writeu8(scaledBuf, dstOffset, r)
					buffer.writeu8(scaledBuf, dstOffset + 1, g)
					buffer.writeu8(scaledBuf, dstOffset + 2, b)
					buffer.writeu8(scaledBuf, dstOffset + 3, a)
				end
			end
		end

		-- Calculate scaled position
		local scaledDrawPosition =
			Vector2.new(math.round(v.drawPosition.X * scale), math.round(v.drawPosition.Y * scale))

		targetImage:WritePixelsBuffer(scaledDrawPosition, scaledSize, scaledBuf)
	end
end
