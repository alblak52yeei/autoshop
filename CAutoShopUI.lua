UI = { }

local iSelectedItem = 1
local sShopName

Fonts = {
	Title 		= DxFont( 'Resources/Fonts/Gilroy/gilroy-semibold.ttf', 18, false, 'antialiased' ),
	Money 		= DxFont( 'Resources/Fonts/Gilroy/gilroy-semibold.ttf', 19, false, 'antialiased' ),
	Price 		= DxFont( 'Resources/Fonts/Gilroy/gilroy-semibold.ttf', 30, false, 'antialiased' ),
	VehName		= DxFont( 'Resources/Fonts/Montserrat/montserrat-medium.ttf', 15, false, 'antialiased' ),
	VehType 	= DxFont( 'Resources/Fonts/Montserrat/montserrat-medium.ttf', 12, false, 'antialiased' ),
	VehStats	= DxFont( 'Resources/Fonts/Montserrat/montserrat-medium.ttf', 11, false, 'antialiased' ),
	Italic 		= DxFont( 'Resources/Fonts/Montserrat/montserrat-italic.ttf', 25, false, 'antialiased' ),
}

function ShowConfirm( self )
	if UI.ConfirmBG and isElement( UI.ConfirmBG ) then
		return false
	end

	local iPosX = 115
	local sNumber = 'a777aa777'

	UI.ConfirmBG = ibCreateImage( ( _SCREEN_X - 545 ) / 2, ( _SCREEN_Y - 500 ) / 2, 0, 0, "Resources/bg_confirm.png" ):ibSetRealSize( ):ibMoveTo( _, ( _SCREEN_Y - 220 ) / 2, 300, 'Linear' )
	UI.ConfirmTitle = ibCreateLabel( 270, 15, 0, 0, 'Вы действительно хотите купить\n'..self.sName..'?', UI.ConfirmBG, COLOR_WHITE, 1, 1, "center", "top", Fonts.VehName )
	UI.ConfirmInfo = ibCreateLabel( 270, 80, 0, 0, 'Цена: '..format_price( self.iPrice )..'₽.', UI.ConfirmBG, 0xFF00ffaf, 1, 1, "center", "top", Fonts.VehName )

	UI.NumberEdit = ibCreateEdit( 200, 120, 111, 30, sNumber, UI.ConfirmBG, 0xFFFFFFFF, 0xFF474242, 0xFFFFFFFF ):ibData( 'font', Fonts.VehName )
		:ibOnDataChange( function ( key, value )
			if key == 'text' then
				sNumber = value
			end
		end )

	UI.Confirm_Yes = ibCreateButton( 120, 171, 0, 0, UI.ConfirmBG, "Resources/confirm_yes.png", _, _, 0xFFFFFFFF, 0xFFebebeb, 0xFFd6d8d7 ):ibSetRealSize( )
		:ibOnClick( 
		   	function( button, state )
		       	if button ~= "left" or state ~= "up" then return end

		       	UI.ConfirmBG:destroy( )
		       	triggerServerEvent( 'OnPlayerBuyVehicle', resourceRoot, { shop_id = sShopName, index = iSelectedItem, number = sNumber } )
		   	end )
	UI.Confirm_No = ibCreateButton( 310, 171, 0, 0, UI.ConfirmBG, "Resources/confirm_no.png", _, _, 0xFFFFFFFF, 0xFFebebeb, 0xFFd6d8d7  ):ibSetRealSize( )
		:ibOnClick( 
		   	function( button, state )
		       	if button ~= "left" or state ~= "up" then return end

		       	UI.ConfirmBG:destroy( )
		   	end )
end 

function ShowCarsellUI( state, data )
	if state then
	    sShopName = data.shop_id
	    local self = AUTOSHOP_LIST[ sShopName ]
	    UI.black_bg = ibCreateBackground( 0x990f201a, ShowCarsellUI, _, true ):ibData( 'alpha', 0 ):ibAlphaTo( 255, 2000 )
	    UI.bg = ibCreateImage( 0, 0, _SCREEN_X, _SCREEN_Y, "Resources/bg.png", UI.black_bg )
	    UI.Title = ibCreateLabel( 100, 30, 0, 0, sShopName, UI.bg, COLOR_WHITE, 1, 1, "left", "top", Fonts.Title )
	    UI.Money = ibCreateLabel( _SCREEN_X - 400, 30, 0, 0, 'Ваш баланс: ' .. format_price( localPlayer:getMoney( ) ) .. ' ₽', UI.bg, COLOR_WHITE, 1, 1, "center", "top", Fonts.Money )
	    UI.Name = ibCreateLabel( 40, 150, 0, 0, "", UI.bg, COLOR_WHITE, 1, 1, "left", "top", Fonts.VehName )

		UI.Price = ibCreateLabel( _SCREEN_X - 420, 160, 0, 0, "", UI.bg, COLOR_WHITE, 1, 1, "left", "top", Fonts.Price )
		UI.Icon = ibCreateImage( 25, 15, 0, 0, ICONS_IMAGE_PATH .. self.sIconName..'.png', UI.bg ):ibSetRealSize( )
		UI.Number = ibCreateLabel( 110,  _SCREEN_Y - 316, 0, 0, "", UI.bg, COLOR_WHITE, 1, 1, "right", "top", Fonts.Italic )

		UI.fPrevious = function ( )
		     if (iSelectedItem - 1 > 0) then
		     	UI:UpdateInfo( iSelectedItem - 1 )
		     else
		     	UI:UpdateInfo( #self.aVehiclesList )
		     end
		end
		
		UI.Previous = ibCreateImage( 130, _SCREEN_Y - 310, 0, 0, 'Resources/previous.png', UI.bg ):ibSetRealSize( )
	    	:ibOnClick( 
		       	function( button, state )
		           	if button ~= "left" or state ~= "up" then return end

		           	UI.fPrevious( )
		       	end )

	    UI.fNext = function ( )
		    if (iSelectedItem + 1 <= #self.aVehiclesList) then
		    	UI:UpdateInfo( iSelectedItem + 1 )
		    else
		    	UI:UpdateInfo( 1 )
		    end
		end

		UI.Next = ibCreateImage( 170, _SCREEN_Y - 310, 0, 0, 'Resources/next.png', UI.bg ):ibSetRealSize( )
	    	:ibOnClick( 
		       	function( button, state )
		           	if button ~= "left" or state ~= "up" then return end

		           	UI.fNext( )
		       	end )

		UI.Quit = ibCreateImage( _SCREEN_X - 122, 0, 0, 0, "Resources/quit.png", UI.bg ):ibSetRealSize( )
	    	:ibOnClick( 
		       	function( button, state )
		           	if button ~= "left" or state ~= "up" then return end

		           	ShowCarsellUI( false )
		       	end )
		UI.Vehicle = ibCreateImage( 750, 380, 800, 400, "", UI.bg )

	    function UI:UpdateInfo( index )
	    	local self = AUTOSHOP_LIST[ sShopName ].aVehiclesList[ index ]

	    	UI.Name:ibData( 'text', self.sName )

	    	UI.Price:ibData( 'text', format_price( self.iPrice ) )
	    	UI.Vehicle:ibData( 'texture', VEHICLE_IMAGE_PATH .. self.iModel .. '.png' ):ibSetRealSize( )
	    	UI['bg_item_selected_'..iSelectedItem]:ibAlphaTo( 0 )
	    	UI['bg_item_selected_'..index]:ibAlphaTo( 255 )
	    	UI.Number:ibData( 'text', index..'/'..#AUTOSHOP_LIST[ sShopName ].aVehiclesList )

	    	iSelectedItem = index
	    	UI:UpdateSelectedVehicle( )
	    end

	    function BuyVehicle( )
	    	local self = self.aVehiclesList[ iSelectedItem ]
	    	ShowConfirm(
	    	{
	    		sName = self.sName,
	    		iPrice = self.iPrice
	    	} )
	    end 

	    bindKey( 'enter', 'down', BuyVehicle )
	    bindKey( 'arrow_l', 'down', UI.fPrevious )
	    bindKey( 'arrow_r', 'down', UI.fNext )
	    bindKey( 'backspace', 'down', 
	    	function ( )
	    		ShowCarsellUI( false )
	    	end )
	    local item_sx = 312
	    local item_sy = 189
	    local gap = 20
	    local pane_sx = gap
	    
	    UI.scrollpane, UI.scroll = ibCreateScrollpane( 0, _SCREEN_Y - 214 - 28, _SCREEN_X, 206, UI.bg, { horizontal = true } )
	    UI.scrollpane:ibData( "priority", -1 )
	    UI.scroll:ibBatchData( { handle_color = 0, bg_color = 0, absolute = true, sensivity = item_sx * 0.025 } )

	    for i, vehicle_data in pairs( self.aVehiclesList ) do
	    	UI['bg_item_'..i] = ibCreateImage( pane_sx, 3, item_sx, item_sy, 'Resources/bg_item.png', UI.scrollpane )
	    	UI['bg_item_selected_'..i] = ibCreateImage( -3, -3, item_sx + 6, item_sy + 6, 'Resources/bg_item_selected.png', UI['bg_item_'..i] ):ibData( "alpha", 0 )

			UI.img_vehicle = ibCreateImage( 25, 30, 300, 160, VEHICLE_IMAGE_PATH .. vehicle_data.iModel .. '.png', UI['bg_item_'..i] )
			:ibSetInBoundSize( 250 ):center( 1, 27 )

	        ibCreateArea( 0, 0, item_sx, item_sy, UI['bg_item_'..i] )
	            :ibOnHover( function( ) if i ~= iSelectedItem then UI['bg_item_selected_'..i]:ibAlphaTo( 128 ) end end )
	            :ibOnLeave( function( ) if i ~= iSelectedItem then UI['bg_item_selected_'..i]:ibAlphaTo( 0 ) end end )
	            :ibOnClick( 
	            	function( button, state )
	                	if button ~= "left" or state ~= "up" then return end
	                	if i == iSelectedItem then return end

	                	UI:UpdateInfo( i )
	            	end )
	    	pane_sx = pane_sx + item_sx + gap
	    end

	    UI.scrollpane:ibData( "sx", pane_sx )

	    function UI:UpdateSelectedVehicle( )
	        local position = UI.scroll:ibData( "position" )
	        local viewport_sx = UI.scrollpane:ibData( "viewport_sx" )
	        local item_full_sx = item_sx + gap
	        local first_fully_visible_index = math.ceil( ( ( pane_sx - viewport_sx ) * position + item_full_sx ) / item_full_sx )
	        local last_fully_visible_index = math.ceil( ( ( pane_sx - viewport_sx ) * position + viewport_sx - item_full_sx ) / item_full_sx )
	        if iSelectedItem < first_fully_visible_index then
	            UI.scroll:ibScrollTo( item_full_sx * ( iSelectedItem - 1 ) / ( pane_sx - viewport_sx ) )
	        elseif iSelectedItem > last_fully_visible_index then
	            UI.scroll:ibScrollTo( ( item_full_sx * iSelectedItem + gap - viewport_sx ) / ( pane_sx - viewport_sx ) )
	        end
	    end

	    UI:UpdateInfo( 1 )
	    Camera.setMatrix( self.vCamPosition, self.vCamToPosition )
	else
	    unbindKey( 'backspace', 'down', 
	    	function ( )
	    		ShowCarsellUI( false )
	    	end )
	    unbindKey( 'arrow_l', 'down', UI.fPrevious )
	    unbindKey( 'arrow_r', 'down', UI.fNext )
		unbindKey( 'enter', 'down', BuyVehicle )
		UI.black_bg:ibAlphaTo( 0, 500 )
    	UI.black_bg:ibTimer(
    		function ( )
				DestroyTableElements( UI )
				UI = { }
    		end,
    	500, 1 )
    	setCameraTarget( localPlayer )
	end
	showCursor( state )
	showChat( not state )
end
addEvent( 'ShowCarsellUI', true )
addEventHandler( 'ShowCarsellUI', resourceRoot, ShowCarsellUI )