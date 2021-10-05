local zona1, zona2, zona3, zona4, puerta, plate
local oldCoords, heading
local inside = false
local actions = {
	{x = 1106.1505, y = -2993.4187, z = -38.5605, text = 'Press ~r~[E]~w~ to open crafting', type = 'crafting'},
	{x = 1104.1141, y = -3004.9197, z = -38.5263, text = 'Press ~r~[E]~w~ to open wardrobe', type = 'wardrobe'},
	{x = 1103.2407, y = -2991.3767, z = -38.5605, text = 'Press ~r~[E]~w~ to open stash', type = 'stash'},
	{x = 1104.6423, y = -3013.6111, z = -38.5605, text = 'Press ~r~[E]~w~ to exit', type = 'exit'},
}

RegisterCommand(Config.EnterCommand, function()
	local moc = closestVehicle(5)
	if moc then
		local model = GetEntityModel(moc)
		if model == GetHashKey(Config.MocModel) then
			local p = PlayerPedId()
			oldCoords = GetEntityCoords(p)
			heading = GetEntityHeading(p)
			plate = GetVehicleNumberPlateText(moc)
			Interior(oldCoords,heading)
			loop()
		end
	end
end)

RegisterCommand(Config.ColorCommand, function(source, args)
	local id = tonumber(args[1])
	if id ~= nil and inside then
		SetObjectTextureVariation(zona1,id)
		SetObjectTextureVariation(zona2,id)
		SetObjectTextureVariation(zona3,id)
		if id < 10 then
			SetObjectTextureVariation(puerta,id)
		end
	end
end)

function Interior()
	-- You have to make players invisible and mute them in your voice script, otherwise this will be a mess.
	local p = PlayerPedId()
	LoadModel('gr_prop_inttruck_vehicle_01')
	LoadModel('gr_prop_inttruck_living_01')
	LoadModel('gr_prop_inttruck_gunmod_01')
	LoadModel('gr_prop_inttruck_door_static')	
	DoScreenFadeOut(1000)
	Citizen.Wait(1500)
	SetEntityCoords(p, 1104.6523, -3013.4446, -38.5605)
	SetEntityHeading(p, 357.8066)
	zona1 = CreateObject(`gr_prop_inttruck_vehicle_01`, 1104.70, -3006.40, -39.60, false, true, false)
	SetEntityHeading(zona1,180.0)
	SetObjectTextureVariation(zona1,1)
	FreezeEntityPosition(zona1,true)	
	zona2 = CreateObject(`gr_prop_inttruck_living_01`, 1104.70, -2998.40, -39.69, false, true, false)
	SetEntityHeading(zona2,180.0)
	SetObjectTextureVariation(zona2,1)
	FreezeEntityPosition(zona2,true)	
	zona3 = CreateObject(`gr_prop_inttruck_gunmod_01`, 1104.70, -2990.40, -39.60, false, true, false)
	SetEntityHeading(zona3,180.0)
	SetObjectTextureVariation(zona3,1)
	FreezeEntityPosition(zona3,true)	
	puerta = CreateObject(`gr_prop_inttruck_door_static`,1105.10, -2990.40, -39.60, false, true, false)
	SetEntityHeading(puerta,0.0)
	SetObjectTextureVariation(puerta,1)
	FreezeEntityPosition(puerta,true)
	inside = true
	SetModelAsNoLongerNeeded('gr_prop_inttruck_vehicle_01')
	SetModelAsNoLongerNeeded('gr_prop_inttruck_living_01')
	SetModelAsNoLongerNeeded('gr_prop_inttruck_gunmod_01')
	SetModelAsNoLongerNeeded('gr_prop_inttruck_door_static')
	Citizen.Wait(500)
	DoScreenFadeIn(1500)
end

function loop()
	while inside do
		for i = 1, #actions do
			if #(GetEntityCoords(PlayerPedId()) - vector3(actions[i].x, actions[i].y, actions[i].z)) < 1.5 then
				DrawText3D(actions[i].x, actions[i].y, actions[i].z, actions[i].text)
				if IsControlJustPressed(0,38) then
					if actions[i].type == 'crafting' then
						-- TriggerEvent('your_crafting_event')
					elseif actions[i].type == 'wardrobe' then
						-- TriggerEvent('your_wardrobe_event')
					elseif actions[i].type == 'stash' then
						-- If your inventory supports it you can open a custom stash using the MOC plate number
						-- TriggerEvent('your_stash_event',plate)
					elseif actions[i].type == 'exit' then
						TriggerEvent('av_moc:exit')
					end
				end
			end
		end
		Citizen.Wait(3)
	end
end

RegisterNetEvent('av_moc:exit')
AddEventHandler('av_moc:exit', function()
	local p = PlayerPedId()
	DoScreenFadeOut(1000)
	Citizen.Wait(1500)
	SetEntityCoords(p, oldCoords)
	SetEntityHeading(p, heading)
	Citizen.Wait(500)
	DoScreenFadeIn(1500)
	inside = false
end)

-- This is an old method where objects spawns under ped position but the exterior lights are a problem
-- I couldn't find a way to spawn the black shell gr_grdlc_int_01_shell
--[[
function Interior(coords,heading)
	LoadModel('gr_prop_inttruck_carmod_01')
	LoadModel('gr_prop_inttruck_living_01')
	LoadModel('gr_prop_inttruck_gunmod_01')
	LoadModel('gr_prop_inttruck_command_01')
	LoadModel('gr_prop_inttruck_door_static')
	CreateObject(`gr_grdlc_int_01_shell`,coords.x, coords.y,coords.z, false, true, false)
	zona1 = CreateObject(`gr_prop_inttruck_carmod_01`,coords.x, coords.y,coords.z - 100, false, true, false)
	SetEntityHeading(zona1,heading-180)
	SetObjectTextureVariation(zona1,7)
	FreezeEntityPosition(zona1,true)
	fwd, _, _, pos = GetEntityMatrix(zona1)
	newPos = (fwd * -0.0) + pos
	zona2 = CreateObject(`gr_prop_inttruck_living_01`,newPos.x, newPos.y,newPos.z - 0.20, false, true, false)
	SetEntityHeading(zona2,heading)
	SetObjectTextureVariation(zona2,7)
	FreezeEntityPosition(zona2,true)
	fwd, _, _, pos = GetEntityMatrix(zona2)
	newPos = (fwd * 8.0) + pos
	zona3 = CreateObject(`gr_prop_inttruck_gunmod_01`,newPos.x, newPos.y,newPos.z, false, true, false)
	SetEntityHeading(zona3,heading)
	SetObjectTextureVariation(zona3,7)
	FreezeEntityPosition(zona3,true)
	fwd, _, _, pos = GetEntityMatrix(zona3)
	newPos = (fwd * 8.0) + pos
	zona4 = CreateObject(`gr_prop_inttruck_command_01`,newPos.x, newPos.y,newPos.z, false, true, false)
	SetEntityHeading(zona4,heading)
	SetObjectTextureVariation(zona4,7)
	FreezeEntityPosition(zona4,true)
	fwd, _, _, pos = GetEntityMatrix(zona4)
	newPos = (fwd * 8.0) + pos
	puerta = CreateObject(`gr_prop_inttruck_door_static`,newPos.x, newPos.y+0.50,newPos.z, false, true, false)
	SetEntityHeading(puerta,heading)
	SetObjectTextureVariation(puerta,7)
	FreezeEntityPosition(puerta,true)
	inside = true
	SetModelAsNoLongerNeeded('gr_prop_inttruck_carmod_01')
	SetModelAsNoLongerNeeded('gr_prop_inttruck_living_01')
	SetModelAsNoLongerNeeded('gr_prop_inttruck_gunmod_01')
	SetModelAsNoLongerNeeded('gr_prop_inttruck_command_01')
	SetModelAsNoLongerNeeded('gr_prop_inttruck_door_static')
end
]]--

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())  
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function LoadModel(modelo)
	RequestModel(modelo)
	while not HasModelLoaded(modelo) do
		RequestModel(modelo)
		Citizen.Wait(0)
	end
end

function closestVehicle(dist)
	local p = PlayerPedId()
	local p_pos = GetEntityCoords(p)
	local p_fwd = GetEntityForwardVector(p)
	local up = vector3(0.0,0.0,1.0)
	local from = p_pos + (up*2)
	local to   = p_pos - (up*2)
	local ent_hit
	for i=0,(dist or 3),1 do
		local ray = StartShapeTestRay(from.x + (p_fwd.x*i),from.y + (p_fwd.y*i),from.z + (p_fwd.z*i),to.x + (p_fwd.x*i),to.y + (p_fwd.y*i),to.z + (p_fwd.z*i),2,ignore, 0);
		_,_,_,_,ent_hit = GetShapeTestResult(ray); 
		if ent_hit and ent_hit ~= 0 and ent_hit ~= -1 then
			local type = GetEntityType(ent_hit)
			if GetEntityType(ent_hit) == 2 then
				return ent_hit
			end
		end
	end
  return false
end