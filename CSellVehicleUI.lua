function ShowUI_SellVehicle( state, data )
	if state then
		UI.Background 	= ibCreateBackground( 0x780f0f0f, ShowUI_SellVehicle, _, true ):ibData( 'alpha', 0 ):ibAlphaTo( 255, 2000 )
		UI.Window 		= ibCreateImage( 0, 0, 500, 300, _, UI.Background, 0xFF0f0f0f ):center( )
		UI.Title 		= ibCreateLabel( 245, 18, 0, 0, 'Продажа автомобиля', UI.Window, COLOR_WHITE, 1, 1, "center", "top", Fonts.VehName )
		UI.Question 	= ibCreateLabel( 245, 75, 0, 0, 'Вы действительно хотите продать\nсвой автомобиль за ' .. data.cost .. ' ₽ ?', UI.Window, COLOR_WHITE, 1, 1, "center", "top", Fonts.VehType )

		UI.Yes			= ibCreateTextButton( 90, 140, 310, 40, UI.Window, _, _, _, 0xFF6bcf2d, 0xFF67d921, 0xFF62ff00, 'Да', COLOR_WHITE, Fonts.VehName )
			:ibOnClick( function ( button, state )
				if button ~= "left" or state ~= "up" then return end

				ShowUI_SellVehicle( false )

				triggerServerEvent( 'OnPlayerSellVehicle', resourceRoot )
			end )
		UI.No			= ibCreateTextButton( 90, 200, 310, 40, UI.Window, _, _, _, 0xFFde4545, 0xFFdb3030, 0xFFe81a1a, 'Нет', COLOR_WHITE, Fonts.VehName )
			:ibOnClick( function ( button, state )
				if button ~= "left" or state ~= "up" then return end

				ShowUI_SellVehicle( false )
			end )

	else
		DestroyTableElements( UI )
		UI = { }
	end

	showCursor( state )
end
addEvent( 'OnClientShowSellVehicleUI', true )
addEventHandler( 'OnClientShowSellVehicleUI', resourceRoot, ShowUI_SellVehicle )