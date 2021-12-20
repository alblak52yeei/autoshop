-- Продажа автомобиля

local pMarker = Marker( SELL_VEHICLE_POSITION, 'cylinder', 2, 15, 153, 220, 100 )

function onMarkerHit_handler( pSource )
	local pVehicle = pSource.vehicle

	if not pVehicle or pVehicle.controller ~= pSource then
		return false
	end

	if not pSource:IsOwner( pVehicle ) then
		return pSource:outputChat( 'Вы должны быть владельцем автомобиля!', 255, 0, 0 )
	end

	local self = GetTableFromModel( pVehicle.model )
	if not self then return end

	pSource:triggerEvent( 'OnClientShowSellVehicleUI', resourceRoot, true, { cost = math.floor( self.iPrice / 2 ) } )
end
addEventHandler( 'onMarkerHit', pMarker, onMarkerHit_handler )

function OnPlayerSellVehicle_handler( )
	local pVehicle = client.vehicle
	if not pVehicle or pVehicle.occupant ~= client then return end

	if not client:IsOwner( pVehicle ) then
		return client:outputChat( 'Вы должны быть владельцем автомобиля!', 255, 0, 0 )
	end

	local self = GetTableFromModel( pVehicle.model )
	if not self then return end

	local iPrice = math.floor( self.iPrice / 2 )

	client:giveMoney( iPrice )

	dbCarsell:exec( "DELETE FROM Vehicles WHERE ID = ?", pVehicle:getData( ELEMENT_DATA_NAMES.ID ) )

	pVehicle:destroy( )

	client:outputChat( 'Вы успешно продали свой автомобиль за ' .. iPrice .. ' руб.', 0, 255, 0 )
end
addEvent( 'OnPlayerSellVehicle', true )
addEventHandler( 'OnPlayerSellVehicle', resourceRoot, OnPlayerSellVehicle_handler )