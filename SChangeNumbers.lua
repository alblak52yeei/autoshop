-- Смена номера у автомобиля

local pMarker = Marker( CHANGE_NUMBERS_POSITION, 'cylinder', 2, 15, 15, 220, 100 )

function onMarkerHit_handler( pSource )
	local pVehicle = pSource.vehicle

	if not pVehicle or pVehicle.controller ~= pSource then
		return false
	end

	if not pSource:IsOwner( pVehicle ) then
		return pSource:outputChat( 'Вы должны быть владельцем автомобиля!', 255, 0, 0 )
	end

	pSource:triggerEvent( 'OnClientShowChangeNumbersUI', resourceRoot, true )
end
addEventHandler( 'onMarkerHit', pMarker, onMarkerHit_handler )

function OnPlayerChangeNumbers_handler( sNewNumber )
	local pVehicle = client.vehicle
	if not pVehicle or pVehicle.occupant ~= client then return end

	if not client:HasMoney( PRICE_CHANGE_NUMBERS ) then
		return client:outputChat( 'Недостаточно средств (' .. PRICE_CHANGE_NUMBERS .. ' руб)', 255, 0, 0 )
	end

	if not IsValidNumber( sNewNumber ) then
		return client:outputChat( 'Неверный формат номера! (x000xx000)', 255, 0, 0 )
	end

	if IsNumberExists( sNewNumber ) then
		return client:outputChat( 'Данный номер занят!', 255, 0, 0 )
	end

	client:takeMoney( PRICE_CHANGE_NUMBERS )

	pVehicle:setData( ELEMENT_DATA_NAMES.Number, sNewNumber )

	client:outputChat( 'Вы успешно установили номер ' .. sNewNumber .. ' и заплатили ' .. PRICE_CHANGE_NUMBERS .. ' руб.' , 0, 255, 0 )
end
addEvent( 'OnPlayerChangeNumbers', true )
addEventHandler( 'OnPlayerChangeNumbers', resourceRoot, OnPlayerChangeNumbers_handler )