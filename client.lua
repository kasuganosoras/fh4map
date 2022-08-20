posX = 0.01
posY = 0.0

width = 0.183
height = 0.32

Citizen.CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	SetMinimapClipType(1)
	SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX, posY, width, height)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.012, 0.022, 0.256, 0.337)
	SetBlipAlpha(GetNorthRadarBlip(), 0)

    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

local isPause = false
local uiHidden = false

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsBigmapActive() or IsRadarHidden() or IsPauseMenuActive() and not isPause then
			if not uiHidden then
			SendNUIMessage({
				action = "hideui"
			})
			uiHidden = true
			end
		elseif uiHidden or IsPauseMenuActive() and isPause then
			SendNUIMessage({
				action = "showui"
			})
			uiHidden = false
		end
	end
end)
