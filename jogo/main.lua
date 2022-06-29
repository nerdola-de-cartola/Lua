FIM_JOGO = false
VITORIA = false
LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_METEOROS = 15
MAX_VEL = 20
MIN_VEL = 5
PONTOS = 0
OBJETIVO = 10

meteoros = {}

nave = {
    src = "imagens/nave.png",
    largura = 40,
    altura = 64,
    x = LARGURA_TELA / 2 - 20,
    y = ALTURA_TELA - 70,
    velocidade = 2,
    tiros = {},
    move = function ()
        if love.keyboard.isDown('w') and nave.y > 0 then
            nave.y = nave.y - nave.velocidade
        end
        if love.keyboard.isDown('a') and nave.x > 0 then
            nave.x = nave.x - nave.velocidade
        end
        if love.keyboard.isDown('s') and nave.y + nave.altura < ALTURA_TELA then
            nave.y = nave.y + nave.velocidade
        end
        if love.keyboard.isDown('d') and nave.x + nave.largura < LARGURA_TELA then
            nave.x = nave.x + nave.velocidade
        end
    end
}

function temColisao(obj1, obj2)
    return obj2.x < obj1.x + obj1.largura and
           obj1.x < obj2.x + obj2.largura and
           obj1.y < obj2.y + obj2.altura and
           obj2.y < obj1.y + obj1.altura

end

function naveColisoes()
    for i, meteoro in pairs(meteoros) do
        if temColisao(meteoro, nave) then
            musica_explosao:play()
            destroiAviao()
            gameOver()
        end
    end
end

function tiroColisoes()
    for i = #nave.tiros, 1, -1 do
        for j = #meteoros, 1, -1 do
            if temColisao(nave.tiros[i], meteoros[j]) then
                table.remove(nave.tiros, i)
                table.remove(meteoros, j)
                PONTOS = PONTOS + 1
                break
            end
        end
    end
end

function verificaColisoes()
    naveColisoes()
    tiroColisoes()
end

function destroiAviao()
    nave.src = "imagens/explosao.png"
    nave.image = love.graphics.newImage(nave.src)
    nave.largura = 58
    nave.altura = 45
end

function gameOver()
    musica_ambiente:stop()
    FIM_JOGO = true
end

function verificaVitoria()
    if PONTOS >= OBJETIVO then
        VITORIA = true
        gameOver()
    end
end

function newMeteoro()
    local m = {
        x = math.random(-24, LARGURA_TELA - 60),
        y = 0,
        largura = 46,
        altura = 72,
        direcao = math.random(-1, 1),
        velocidade = math.random(MIN_VEL, MAX_VEL) / 10
    }

    table.insert(meteoros, m)
end

function removeMeteoros()
    for i = #meteoros, 1, -1 do
        if meteoros[i].y > ALTURA_TELA then
            table.remove(meteoros, i)
        end
    end
end

function moveMeteoros()
    for i, meteoro in pairs(meteoros) do
        if meteoro.x == -25 and meteoro.direcao == -1 then
            meteoro.direcao = 1
        end
        if meteoro.x == LARGURA_TELA - 60 and meteoro.direcao == 1 then
            meteoro.direcao = -1
        end
        
        meteoro.x = meteoro.x + meteoro.direcao
        meteoro.y = meteoro.y + meteoro.velocidade
    end
    
end

function tiro()
    musica_tiro:play()
    local shoot = {
        x = nave.x + 11,
        y = nave.y,
        largura = 30,
        altura = 30,
    }

    table.insert(nave.tiros, shoot)
end

function moveTiros()
    for i, tiro in pairs(nave.tiros) do
        tiro.y = tiro.y - (nave.velocidade * 2)
    end
end

function removeTiros()
    for i = #nave.tiros, 1, -1 do
        if nave.tiros[i].y < 0 then
            table.remove(nave.tiros, i)
        end
    end
end

function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TELA)
    love.window.setTitle("14 Bis Vs Meteoros")
    math.randomseed(os.time())
    background = love.graphics.newImage("imagens/background.png")
    nave.image = love.graphics.newImage(nave.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
    tiro_img = love.graphics.newImage("imagens/tiro.png")
    game_over = love.graphics.newImage("imagens/game_over.png")
    win = love.graphics.newImage("imagens/vitoria.jpg")
    musica_ambiente = love.audio.newSource("audio/ambiente.mp3", "static")
    musica_ambiente:setLooping(true)
    musica_ambiente:play()
    musica_explosao = love.audio.newSource("audio/explosao.mp3", "static")
    musica_tiro = love.audio.newSource("audio/disparo.mp3", "static")
end

function love.update(dt)
    if FIM_JOGO then
        return
    end

    if love.keyboard.isDown('w', 'a', 's', 'd') then
        nave.move()
    end

    if #meteoros < MAX_METEOROS then
        newMeteoro()
    end

    moveMeteoros()
    moveTiros()
    verificaColisoes()
    removeMeteoros()
    removeTiros()
    verificaVitoria()
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(nave.image, nave.x, nave.y)
    love.graphics.print("Meteoros atingidos: " ..PONTOS, 0, 0, 0)
    for i, meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end
    for i, tiro in pairs(nave.tiros) do
        love.graphics.draw(tiro_img, tiro.x, tiro.y)
    end
    if FIM_JOGO then
        if VITORIA then
            love.graphics.draw(win, 85, 80)
        else
            love.graphics.draw(game_over, 85, 120)
        end
    end
end

function love.keypressed(tecla)
    if tecla == "escape" then
        love.event.quit()
    elseif tecla == "space" then
        tiro()
    end
end