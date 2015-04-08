//
//  GameScene.swift
//  tutorialSpriteAtlas
//
//  Created by Gianluca on 23/03/15.
//  Copyright (c) 2015 KiokoKenda. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // qui inseriamo lo spritesheet che fa riferimento alla classe contenente le animazioni
    let sheet = NarutoClass()
    // sequence sara' la nostra action (il movimento avanti e indietro del personaggio)
    var sequence: SKAction?

    // definiamo il personaggio da spostare col joystick
    var player: SKSpriteNode!

    // queste due actions saranno usate all'interno dell'evento update()
    var goLeft: SKAction?
    var goRight: SKAction?
    // e qui definiamo una variabile che  ci terra' informati della direzione del personaggio
    var leftDir: Bool = false
    
    // infine dichiariamo globalmente anche il nostro joystick
    var joystick: Joystick!
    // e, visto che ci siamo, aggiungiamo anche un pulsante
    var button: SKSpriteNode!
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // iniziamo con il modo classico di caricare una immagine di sfondo come ripasso
        let backGround = SKSpriteNode(imageNamed: "nar-konoha-street1.jpg")
        // posizioniamo lo sfondo al centro della scena
        backGround.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        // la ridimensioniamo per adattarla alla dimensione dello schermo
        backGround.size.width = self.frame.width
        self.addChild(backGround)
        ///////////////////////////////////////////////////////////////////////////////////////
        
        // ora prepariamo le animazioni per i personaggi che popoleranno la scena
        // nella prima animazione il personaggio camminera' da sinistra a destra
        // all'interno della classe creata con TexturePacker (sheet.naruto) abbiamo appunto 
        // le 3 immagini del personaggio che cammina
        let walk = SKAction.animateWithTextures(sheet.naruto(), timePerFrame: 0.2)
        
        // per camminare da una parte all'altra dello schermo indichiamo circa 6 ripetizioni
        let walkAnim = SKAction.repeatAction(walk, count: 6)
        
        // definiamo le due azioni per andare vanti e indietro
        // SKAction.moveToX richiede la destinazione e durata del viaggio
        let moveRight = SKAction.moveToX(self.frame.width - 50, duration: walkAnim.duration)
        let moveLeft  = SKAction.moveToX(50, duration: walkAnim.duration)
        
        // un modo semplice per specchiare una sprite e' usare scaleXTo ed invertirla sull'asse x
        let mirrorDirection = SKAction.scaleXTo(-1, y:1, duration:0.0)
        let resetDirection  = SKAction.scaleXTo(1,  y:1, duration:0.0)
        
        // le azioni di un gruppo vengono eseguite insieme
        // per andare a destra: 
        // ripristino la direzione dx, uso animazione camminata
        let walkAndMoveRight = SKAction.group([resetDirection,  walkAnim, moveRight])
        // a sinistra, specchio la direzione
        let walkAndMoveLeft  = SKAction.group([mirrorDirection, walkAnim, moveLeft]);
        /////////////////////////////////////////////////////////////////////////////////////////
        
        // qui possiamo provare a definire azioni singole e multiple da assegnare al nostro personaggio
        // quello che gestiremo col joystick
        // repeatActionForever serve ad unire una serie di azioni da ripetere ad ignoranza
        sequence = SKAction.repeatActionForever(SKAction.sequence([walkAndMoveRight, walk, walkAndMoveLeft, walk]))
        goLeft = walkAndMoveLeft
        goRight = walkAndMoveRight
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        // poi inizializziamo il joystick
        joystick = Joystick()
        // come una qualsiasi sprite lo possiamo posizionare sullo schermo
        joystick.position = CGPointMake(100, 200)
        // e dargli una altezza sul piano (layer)
        joystick.zPosition = 10
        // e lo inseriamo nella scena
        self.addChild(joystick)
        //////////////////////////////////////////////////////////////////
        
        // abbiamo previsto anche di posizionare un pulsante
        // ricicliamo la 'pallina' del joystick come pulsante
        button = SKSpriteNode(imageNamed: "joystick.png")
        button.position = CGPoint(x: self.size.width - 100, y: 200)
        button.name = "buttonA"
        // e fissiamone le dimensioni
        button.size.height = 50
        button.size.width = 50
        // come col joystick, lo posizioniamo sul livello + alto della scena
        button.zPosition = 10
        addChild(button)
        ////////////////////////////////////////////////////////////////////
        
        // ora mettiamo un naruto da muovere col joystick (il nostro personaggio)
        // sheet e' la nostra raccolta di immagini e animazioni (istanza della classe NarutoClass)
        // assegnare una texture ad una node e' la stessa cosa che assegnargli una immagine, solo che
        // la scegliamo fra quelle dichiarate all'interno della classe
        player = SKSpriteNode(texture: sheet.naruto01())
        // ora raddoppiamo le dimensioni della sprite (sia altezza che larghezza)
        player.size.width = player.size.width*2
        player.size.height = player.size.height*2
        // e lo posizioniamo
        player.position = CGPointMake(100.0, 400.0)
        // visto che il personaggio e' girato verso destra mettiamo false alla direzione sinistra
        leftDir = false
        // e per finire assegniamo la sequenza [walkAndMoveRight, walk, walkAndMoveLeft, walk] 
        // al nostro personaggio per farlo muovere anche da solo
        player.runAction(sequence)
        // e finalmente lo mostriamo sullo schermo
        addChild(player)
        ////////////////////////////////////////////////////////////////////////////////////////////
        
    }
    
    // in molti giochi e apps i bottoni nn rispondono direttamente alla pressione, ma
    // piuttosto al suo effettivo rilascio, che ne conferma la volonta' da parte dell'utente
    // di toccare quell'oggetto, quindi, per mostrare questo, cambieremo le dimensioni
    // del pulsante quando premuto e lo ripristineremo a fine tocco verificandone la pressione
    // nel touchEnded():
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // rileviamo il tocco
        var touch: UITouch = touches.anyObject() as UITouch
        // la posizione del tocco
        var location = touch.locationInNode(self)
        // e l'eventuale bottone alla posizione del tocco
        var node = self.nodeAtPoint(location)
        
        // se e' stato premuto il pulsante gli cambiamo dimensione in modo da osservarne la pressione
        if (node.name == "buttonA") {
            button.size.width = 60
            button.size.height = 60
        }
        
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        // rileviamo il tocco
        var touch: UITouch = touches.anyObject() as UITouch
        // la posizione del tocco
        var location = touch.locationInNode(self)
        // e l'eventuale bottone alla posizione del tocco
        var node = self.nodeAtPoint(location)
        
        // se e' stato premuto il pulsante
        if (node.name == "buttonA") {
            // ogni volta che verra' premuto il pulsante, creeremo un nuovo omino sullo schermo
            let sprite = SKSpriteNode(texture: sheet.naruto01())
            // ora raddoppiamo le dimensioni della sprite (sia altezza che larghezza)
            sprite.size.width = sprite.size.width*2
            sprite.size.height = sprite.size.height*2
            // e lo posizioniamo  ad una altezza casuale
            sprite.position = CGPointMake(100.0, CGFloat(rand() % 100) + 200.0)
            
            // e gli diamo vita assegnandogli la sequenza animata
            sprite.runAction(sequence)
            // infine lo aggiungiamo alla scena
            addChild(sprite)
            
        }
        // se invece rilasciamo il tocco al di fuori del pulsante nn eseguiamo niente
        // ma ripristiniamo le dimensioni del bottone in ogni caso
        button.size.height = 50
        button.size.width = 50
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // il joystick in posizione normale ha velocity.x == 0, velocity.y == 0
        // quindi controlliamo che siano diversi da 0
        if joystick.velocity.x  != 0 || joystick.velocity.y != 0 {
            // se nn sta andando a sinistra e velocity x < 0 --> mandiamolo a sinistra
            if joystick.velocity.x  < 0  && !leftDir {
                leftDir = true
                player.xScale = fabs(player.xScale) * -1
                player.runAction(goLeft)
            }
            // altrimenti, se sta andando a sinistra e muoviamo il joystick verso destra
            else if joystick.velocity.x  > 0 && leftDir
            {
                leftDir = false
                player.xScale = fabs(player.xScale) * 1
                player.runAction(goRight)
            }
            // infine vediamo come spostare il nostro personaggio in base alle posizioni del joystick
            player.position = CGPointMake(player.position.x + 0.1 * joystick.velocity.x, player.position.y + 0.1 * joystick.velocity.y)
        }
    }
}
