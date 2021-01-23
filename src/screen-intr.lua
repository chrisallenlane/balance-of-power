function Screens.intr.update()
    if BtnX:once() then Screens.load("battle") end
end

function Screens.intr.draw()
    cls()
    rectfill(0, 0, 127, 127, 0)
    print(Map.current.intr.head, 49, 41, 7)
    print(Map.current.intr.body, 10, 55, 7)
    camera(0, 0)
end
