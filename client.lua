posX = 0.01
posY = 0.0-- 0.0152

width = 0.183
height = 0.32--0.354

ESX = nil

function GetMinimapPosition()
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))
	-- local minimapTopX, minimapTopY = GetScriptGfxPosition(0.031, -0.0302 + (0.19))
	local minimapTopX, minimapTopY = GetScriptGfxPosition(0.017, 0.19)
	ResetScriptGfxAlign()
	local w, h = GetActiveScreenResolution()
	print("RES", minimapTopX, minimapTopY, w, h)
	return {
		width = w * minimapTopX,
		height = (minimapTopY / 10) * h
	}
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	SetMinimapClipType(1)
	SetMinimapComponentPosition('minimap', 'L', 'B', 0.031, -0.0302, 0.143, 0.19)
	--SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0, 0.032, 0.101, 0.259)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX, posY, width, height)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.0115, 0.026, 0.256, 0.337)

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

local uiHidden = false

Citizen.CreateThread(function()
	while true do
		Wait(0)
		SetBigmapActive(false, false)
		if IsPauseMenuActive() or not IsMinimapRendering() then
			if not uiHidden then
				DisplayHud(false)
				SendNUIMessage({
					action = "hideUI"
				})
				uiHidden = true
			end
		elseif uiHidden then
			local position   = GetMinimapPosition()
			local resX, resY = GetActiveScreenResolution()
			local ratio      = (resX / 1920) - 1.0
			local ratioH     = (resY / 1080) - 1.0
			position.width   = position.width - (20 * ratio)
			position.height  = (position.height * 0.65) - (50 * ratioH)
			print(position.width, position.height, ratio, ratioH, resX, resY)
			-- print(ratio, resX, resY, position.width)
			DisplayHud(true)
			SendNUIMessage({
				action = "displayUI",
				position = position
			})
			ESX.UI.HUD.SetPosition(position.width + 270, position.height - 70)
			uiHidden = false
		end
	end
end)
