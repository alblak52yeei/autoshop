-- Сохранение автомобиля

Vehicle.Save = function ( self )

	local ID = self:getData( 'ID' )
	local sOwner = self:getData( 'owner' )

	local iHealth = self.health
	local x, y, z = getElementPosition( self )
	local _, _, rZ = getElementRotation( self )
	local c1,c2,c3,c4,c5,c6 = self:getColor( true )
	local c7,c8,c9 = self:getHeadLightColor( )
	local sColor = toJSON( { c1,c2,c3,c4,c5,c6,c7,c8,c9 } )
	local iPaintjob = self.paintjob
	local sHandling = toJSON( self.handling )
	local sNumber = self:getData( ELEMENT_DATA_NAMES.Number ) or ''

	local sUpgrade = ''
	for _, data in pairs( self.upgrades ) do
		if (sUpgrade == '') then
			sUpgrade = data
		else
			sUpgrade = sUpgrade..' ,'..data
		end
	end

	local pOccupant = self.occupant
	if pOccupant then
		if (pOccupant:IsOwner( self )) then
			bInVeh = true
		end
	end

	local aDoorsRatio = { }
	for i = 0, 5 do
		aDoorsRatio[ i ] = self:getDoorOpenRatio( i )
	end

	local aPanelState = { }
	for i = 0, 6 do
		aPanelState[ i ] = self:getPanelState( i )
	end

	local aDoorsState = { }
	for i = 0, 5 do
		aDoorsState[ i ] = self:getDoorState( i )
	end

	local aLightsState = { }
	for i = 0, 3 do
		aLightsState[ i ] = self:getLightState( i )
	end

	local w1, w2, w3, w4 = self:getWheelStates( )
	local sWheelState = toJSON( { w1, w2, w3, w4 } )

	dbCarsell:exec( 'UPDATE Vehicles SET Number = ?, Color = ?, Upgrades = ?, Paintjob = ?, Health = ?, Handling = ?, EngineState = ?, OverrideLights = ?, DoorsRatio = ?, WheelState = ?, PanelState = ?, DoorsState = ?, LightState = ?  WHERE ID = ?',
		sNumber, sColor, sUpgrade, iPaintjob, iHealth, sHandling, self.engineState and 'true' or 'false', self.overrideLights, toJSON( aDoorsRatio ), sWheelState, toJSON( aPanelState ), toJSON( aDoorsState ), toJSON( aLightsState ), ID )
end

-- Сохранение автомобилей у игрока

Player.SaveVehicles = function ( self )
	for _, pVehicle in pairs( getElementsByType( 'vehicle' ) ) do
		if (self:IsOwner( pVehicle )) then
			pVehicle:Destroy( )
		end
	end
end

-- Прогрузка автомобилей у игрока
Player.UpdateVehicles = function ( self )
	local aData = dbCarsell:query( 'SELECT * FROM Vehicles WHERE Serial = ?', self.serial ):poll(-1)
	if (aData and type( aData ) == 'table') then

		local this = { }

		local x, y, z = getElementPosition( self )

		for _, data in pairs( aData ) do
			table.insert( this, { ID = data.ID, VehicleName = data.VehicleName, Model = data.Model } )

			local pVehicle = Vehicle( data.Model, x, y + 3, z, 0, 0, 0 )
			pVehicle:setData( ELEMENT_DATA_NAMES.ID, data.ID )
			pVehicle:setData( ELEMENT_DATA_NAMES.Owner, data.Serial )
			pVehicle.health = data.Health
			setVehiclePaintjob( pVehicle, tonumber( data.Paintjob ) or 3 )
			local aHandlings = fromJSON( data.Handling )
			for k, v in pairs( aHandlings ) do
				setVehicleHandling( pVehicle, k, v )
			end
			local aColors = fromJSON( data.Color )
			pVehicle:setColor( aColors[ 1 ], aColors[ 2 ], aColors[ 3 ], aColors[ 4 ], aColors[ 5 ], aColors[ 6 ] )
			pVehicle:setHeadLightColor( aColors[ 7 ], aColors[ 8 ], aColors[ 9 ] )

			if data.Upgrages then
				local aUpgrades = split( data.Upgrages, ',' )
				for _, upgrade in ipairs( aUpgrades ) do
					pVehicle:addUpgrade( upgrade )
				end
			end

			if data.EngineState and data.EngineState == 'true' then
				pVehicle.engineState = true
			else
				pVehicle.engineState = false
			end

			pVehicle:setData( ELEMENT_DATA_NAMES.Number, data.Number or '' )

			if data.OverrideLights then
				pVehicle.overrideLights = tonumber( data.OverrideLights )
			end

			if data.DoorsRatio then
				local aDoorsRatio = fromJSON( data.DoorsRatio )
				for i, v in pairs( aDoorsRatio ) do
					pVehicle:setDoorOpenRatio( i, v )
				end
			end

			if data.WheelState then
				local aWheelState = fromJSON( data.WheelState )
				pVehicle:setWheelStates( aWheelState[ 1 ] or 0, aWheelState[ 2 ] or 0, aWheelState[ 3 ] or 0, aWheelState[ 4 ] or 0 )
			end

			if data.PanelState then
				local aPanelState = fromJSON( data.PanelState )
				for i, v in pairs( aPanelState ) do
					pVehicle:setPanelState( i, v or 0 )
				end
			end

			if data.DoorsState then
				local aDoorsState = fromJSON( data.DoorsState )
				for i, v in pairs( aDoorsState ) do
					pVehicle:setDoorState( i, v or 0 )
				end
			end

			if data.LightState then
				local aLightsState = fromJSON( data.LightState )
				for i, v in pairs( aLightsState ) do
					pVehicle:setLightState( i, v or 0 )
				end
			end

			pVehicle:setData( ELEMENT_DATA_NAMES.Parent, self )
		end
		self:setData( ELEMENT_DATA_NAMES.Vehicles, this )
	end
end

-- Покупка автоиобиля
addEvent( 'OnPlayerBuyVehicle', true )
addEventHandler( 'OnPlayerBuyVehicle', resourceRoot,
	function ( data )

		local aData = dbCarsell:query( 'SELECT * FROM Vehicles WHERE Serial = ?', client.serial ):poll( -1 )
		if (aData and type( aData ) == 'table' and #aData > 0) then
			return client:outputChat( 'Приобрести можно максимум 1 автомобиль!', 255, 0, 0 )
		end

		if data and type( data ) == 'table' and data.shop_id and data.index then
			-- Проверки на валидность и наличие номера

			if not IsValidNumber( data.number ) then
				return client:outputChat( 'Неверный формат номера! (x000xx000)', 255, 0, 0 )
			end

			if IsNumberExists( data.number ) then
				return client:outputChat( 'Данный номер занят!', 255, 0, 0 )
			end

			local this = AUTOSHOP_LIST[ data.shop_id ]
			local self = this.aVehiclesList[ data.index ]
			if (client:HasMoney( self.iPrice )) then
				client:takeMoney( self.iPrice )

				local ID = GetFreeID( ) or math.random( 9999, 99999 )

				client:outputChat( 'Вы купили автомобиль '..self.sName..' за '..self.iPrice..' руб.', 0, 255, 0 )

				local pVehicle = Vehicle( self.iModel, this.vSpawnPosition[1], this.vSpawnPosition[2], this.vSpawnPosition[3], 0, 0, this.vSpawnPosition[4] )
				local sHandling = toJSON( pVehicle.handling )
				client.vehicle = pVehicle
				pVehicle.engineState = true
				pVehicle.overrideLights = 2

				pVehicle:setData( ELEMENT_DATA_NAMES.Number, data.number )
				pVehicle:setData( ELEMENT_DATA_NAMES.ID, ID )
				pVehicle:setData( ELEMENT_DATA_NAMES.Owner, client.serial )
				pVehicle:setData( ELEMENT_DATA_NAMES.Parent, client )

				pVehicle:SetHandling( self.sHandling )

				local c1,c2,c3,c4,c5,c6 = pVehicle:getColor( true )
				local sColor = toJSON( { c1, c2, c3, c4, c5, c6, 255, 255, 255 } )
				local aVehicles = client:getData( ELEMENT_DATA_NAMES.Vehicles ) or { }

				table.insert( aVehicles, { ID = ID, VehicleName = self.sName, Model = self.iModel } )

				client:setData( ELEMENT_DATA_NAMES.Vehicles, aVehicles )

				dbCarsell:exec( "INSERT INTO Vehicles VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
					ID, client.serial, self.sName, self.iModel, data.number, sColor, "", "", 1000, sHandling, 'true', 2 )
			else
				client:outputChat( 'Недостаточно денег!', 255, 0, 0 )
			end
		end
		client:triggerEvent( 'ShowCarsellUI', resourceRoot, false )
	end )

-- Запуск ресурса, создание маркеров и прогрузка автомобилей, создание БД

addEventHandler( 'onResourceStart', resourceRoot,
	function ( )
		for i, v in pairs( AUTOSHOP_LIST ) do
			local pMarker = Marker( v.vPosition, 'cylinder', 2, 150, 153, 220, 100 )
			pMarker:setData( 'carsell_name', i )

			addEventHandler( 'onMarkerHit', pMarker,
				function ( pElement )
					if (pElement.type == 'player' and not pElement.vehicle) then
						pElement:triggerEvent( 'ShowCarsellUI', resourceRoot, true, { shop_id = i } )
					end
				end )
		end


		dbCarsell = Connection( 'sqlite', 'Autoshop.db' )
		dbCarsell:exec ( 'CREATE TABLE IF NOT EXISTS Vehicles (ID, Serial, VehicleName, Model, Number, Color, Upgrades, Paintjob, Health, Handling, EngineState, OverrideLights, DoorsRatio, WheelState, PanelState, DoorsState, LightState)' )
		setTimer(
			function ( )
				for _, player in pairs( getElementsByType( 'player' ) ) do
					player:UpdateVehicles( )
				end
			end,
		1000, 1 )
	end )

-- Античит от изменения элемент дат у автомобиля

addEventHandler( 'onElementDataChange', root,
	function ( theKey, oldValue, newValue )
		if client and newValue then
			for _, dataName in pairs( ELEMENT_DATA_NAMES ) do
				if (theKey == dataName) then
					source:setData( theKey, oldValue )
					client:kick( 'AC', 'Carsell data change ('..theKey..')')
				end
			end
		end
	end )

-- Сохранения 

addEventHandler( 'onPlayerJoin', root,
	function ( )
		source:UpdateVehicles( )
	end )

addEventHandler( 'onPlayerQuit', root,
	function ( )
		source:SaveVehicles( )
	end )

addEventHandler( 'onResourceStop', resourceRoot,
	function ( )
		for _, player in pairs( getElementsByType( 'player' ) ) do
			player:SaveVehicles( )
		end
	end )