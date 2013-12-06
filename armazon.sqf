
private ["_spawnDrone"];

//TODO: Clear out contents of supply box, fill it with whatever player requested
//TODO: Make box detach from drone if drone dies or if drone is at pickup spot
//TODO: Maybe make assembly line sort of thing where drones pick up packages and then deliver
//TODO: Nice feature to have would be for players to be able to send packages, too

/**
 * Get Arma-compatible color RGB values for use in setObjectTexture.
 * Args: (String) hexRGBValue
 * Returns: (String) comma-separated RGB values
 * Return Value usage: _object setObjectTexture [0, format["#(rgb,8,8,3)color(%1,1)", _rgbReturnValue];
 */
getColorFromHex = {
    private ["_hex","_r","_g","_b","_nums","_return"];
    
    _nums = toArray "0123456789ABCDEF"; //for converting hex nibbles to base 10 equivalents
    _hex = toArray (_this select 0);
    _hex = _hex - [(_hex select 0)]; //remove the '#' at the beginning
    
    _r = (_nums find (_hex select 0)) * 16 + (_nums find (_hex select 1));
    _g = (_nums find (_hex select 2)) * 16 + (_nums find (_hex select 3));
    _b = (_nums find (_hex select 4)) * 16 + (_nums find (_hex select 5));
    
    //divide by 255 (0xFF) because game wants a num between 0 and 1
    _return = format ["%1,%2,%3",(_r/255),(_g/255),(_b/255)];
    _return
};

droneFollow = {
    private ["_drone","_guy"];
    
    _drone = _this select 0;
    _guy = _this select 1;
    
    while{alive _guy} do {
        sleep 0.1;
        if(_guy distance _drone >= 2) then {
            _drone move position _guy;
            _drone setSpeedMode "FULL";
        }
    }
    
};

_spawnDrone = {
    private ["_drone","_color","_package"];
    
    _drone = createVehicle ["B_UAV_01_F", position player, [], 0, "FLY"];
    removeAllActions _drone;
    createVehicleCrew _drone;
    _color = ["#EE7621"] call getColorFromHex;
    _drone flyInHeight 2;
    _drone setpos [getpos _drone select 0, getpos _drone select 1, 2];
    _package = createVehicle ["Box_NATO_Grenades_F",[getpos _drone select 0,getpos _drone select 1,(getpos _drone select 2)-0.4],[],0,"CAN_COLLIDE"];
    _package setObjectTexture [0, format["#(rgb,8,8,3)color(%1,1)", _color]];
    _package setObjectTexture [1, format["#(rgb,8,8,3)color(%1,1)", _color]];
    _package attachTo [_drone, [0,0,-0.4]];
    [_drone, player] call droneFollow; //For now, the drone just follows the player around.  This will be changed.
};

_this addAction ["SPAWN DRONE",_spawnDrone];
sleep 1;
