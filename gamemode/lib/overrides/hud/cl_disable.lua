hook.Add("HUDShouldDraw", "HideDefaultHealthHUD", function(name)
    if name == "CHudHealth" then
        return false
    end
end)