JAM.VehicleShop = {}
local JVS = JAM.VehicleShop
JVS.ESX = JAM.ESX

JVS.DrawTextDist = 4.0
JVS.MenuUseDist = 3.0
JVS.SpawnVehDist = 5000.0
JVS.VehRetDist = 5.0

JVS.CarDealerJobLabel = "cardealer"
JVS.DealerMarkerPos = vector3(-33.79, -1101.7, 25.30)

-- Why vector4's, you ask?
-- X, Y, Z, Heading.

JVS.PurchasedCarPos = vector4(-31.06, -1090.79, 26.42, 340.0)
JVS.PurchasedUtilPos = vector4(449.6, -1018.84, 29.00, 90.35)

JVS.SmallSpawnVeh = 'asea'
JVS.SmallSpawnPos = vector4(-52.08, -1095.08, 25.98, 203.66)

JVS.LargeSpawnVeh = 'police7'
JVS.LargeSpawnPos = vector4(463.34, -1017.27, 28.09, 182.35)

JVS.DisplayPositions = {
	[1] = vector4(-49.05, -1100.63, 25.81, 40.00),
	[2] = vector4(-43.58, -1098.32, 25.98, 237.50),
	[3] = vector4(-46.05, -1093.03, 25.82, 82.80),
	[4] = vector4(-40.04, -1094.94, 25.95, 187.00),
	[5] = vector4(-44.65, -1103.22, 25.93, 346.12),
	[6] = vector4(-42.27, -1103.48, 25.93, 295.83),
}

JVS.Blips = {
	CityShop = {
		Zone = "Vehicle Shop",
		Sprite = 225,
		Scale = 1.0,
		Display = 4,
		Color = 4,
		Pos = { x = -54.02, y = -1110.43, z = 28.00 },
	},
}
