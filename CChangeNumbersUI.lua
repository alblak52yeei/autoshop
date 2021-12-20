function ShowUI_ChangeNumbers( state, data )
	if state then

		local sNumber = 'a777aa777'

		UI.Background 	= ibCreateBackground( 0x780f0f0f, ShowUI_SellVehicle, _, true ):ibData( 'alpha', 0 ):ibAlphaTo( 255, 2000 )
		UI.Window 		= ibCreateImage( 0, 0, 500, 300, _, UI.Background, 0xFF0f0f0f ):center( )
		UI.Title 		= ibCreateLabel( 245, 18, 0, 0, 'Продажа автомобиля', UI.Window, COLOR_WHITE, 1, 1, "center", "top", Fonts.VehName )
		UI.Question 	= ibCreateLabel( 245, 75, 0, 0, 'Введите в поле номер, который хотите установить', UI.Window, COLOR_WHITE, 1, 1, "center", "top", Fonts.VehType )

		UI.NumberEdit = ibCreateEdit( 200, 120, 111, 30, sNumber, UI.Window, 0xFF242424, 0xFFd4d4d4, 0xFF242424 ):ibData( 'font', Fonts.VehName )
			:ibOnDataChange( function ( key, value )
				if key == 'text' then
					sNumber = value
				end
			end )

		UI.Yes			= ibCreateTextButton( 90, 170, 310, 40, UI.Window, _, _, _, 0xFF6bcf2d, 0xFF67d921, 0xFF62ff00, 'Установить (' .. PRICE_CHANGE_NUMBERS .. ' ₽)', COLOR_WHITE, Fonts.VehName )
			:ibOnClick( function ( button, state )
				if button ~= "left" or state ~= "up" then return end

				ShowUI_ChangeNumbers( false )

				triggerServerEvent( 'OnPlayerChangeNumbers', resourceRoot, sNumber )
			end )
		UI.No			= ibCreateTextButton( 90, 230, 310, 40, UI.Window, _, _, _, 0xFFde4545, 0xFFdb3030, 0xFFe81a1a, 'Закрыть', COLOR_WHITE, Fonts.VehName )
			:ibOnClick( function ( button, state )
				if button ~= "left" or state ~= "up" then return end

				ShowUI_ChangeNumbers( false )
			end )

	else
		DestroyTableElements( UI )
		UI = { }
	end

	showCursor( state )
end
addEvent( 'OnClientShowChangeNumbersUI', true )
addEventHandler( 'OnClientShowChangeNumbersUI', resourceRoot, ShowUI_ChangeNumbers )