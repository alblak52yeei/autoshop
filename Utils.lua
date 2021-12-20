local aHandlingNamesTable = 
{
	"mass","turnMass","dragCoeff","centerOfMassX","centerOfMassY","centerOfMassZ","percentSubmerged","tractionMultiplier","tractionLoss", "tractionBias", "numberOfGears","maxVelocity","engineAcceleration","engineInertia",
	"driveType","engineType","brakeDeceleration","brakeBias","ABS","steeringLock","suspensionForceLevel","suspensionDamping","suspensionHighSpeedDamping","suspensionUpperLimit",
	"suspensionLowerLimit","suspensionFrontRearBias","suspensionAntiDiveMultiplier","seatOffsetDistance","collisionDamageMultiplier","monetary","modelFlags","handlingFlags"
}

Vehicle.SetHandling = function ( self, handlings )
	local strArray = { }
	for token in string.gmatch( handlings, "[^%s]+" ) do
  		table.insert( strArray, token )
	end
	local i = 2
	for k, v in pairs( aHandlingNamesTable ) do
		setVehicleHandling( self, v, strArray[ i ] )
		if (v == "modelFlags" or v == "handlingFlags") then
			setVehicleHandling( self, v, tonumber( "0x"..strArray[ i ] ) )
		elseif (v == "driveType") then
			if strArray[i] == "4" then
				setVehicleHandling( self, v, "awd" )
			elseif strArray[i] == "f" then
				setVehicleHandling( self, v, "fwd" )
			elseif strArray[i] == "r" then
				setVehicleHandling( self, v, "rwd" )
			end
		end
		i = i + 1
	end 
end

Vehicle.GetID = function ( self )
	return self:getData( ELEMENT_DATA_NAMES.ID )
end

Vehicle.GetOwner = function ( self )
	return self:getData( 'owner' ) or 'NO'
end

Player.IsOwner = function ( self, pVehicle )
	return ( pVehicle:GetOwner( ) == self.serial ) and true or false
end

Player.HasMoney = function ( self, iValue )
	return self.money - iValue > 0
end

-- Удаление авто с сохранением

Vehicle.Destroy = function ( self )
	self:Save( )
	self:destroy( )
end


function IsValidNumber( sFullNumber )

	local sNumber = utf8.sub( sFullNumber, 1, 6 )
	local sRegion = utf8.sub( sFullNumber, 7, utf8.len( sFullNumber ) )

	return utf8.find( sNumber, "%a%d%d%d%a%a" ) and utf8.len( sNumber ) == 6 and tonumber( sRegion ) and ( utf8.len( sRegion ) == 2 or utf8.len( sRegion ) == 3 )

end

function IsNumberExists ( sNumber )
	local result = dbCarsell:query( 'SELECT * FROM Vehicles WHERE Number = ?', sNumber ):poll( -1 )
	return #result > 0
end

function GetFreeID ( )
	local result = dbCarsell:query( 'SELECT * FROM Vehicles' ):poll(-1)
	local ID = false
	for i, v in pairs( result ) do
		if v[ 'ID' ] ~= i then
			ID = i
			break
		end
	end
	if ID then return ID else return #result + 1 end
end

function GetTableFromModel( iModel )
	for shop, self in pairs( AUTOSHOP_LIST ) do
		for _, v in pairs( self.aVehiclesList ) do
			if v.iModel == iModel then
				return v
			end
		end
	end
end