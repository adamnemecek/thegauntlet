//
//  LevelManager.swift
//  TheGauntlet
//
//  Created by Xavier De Koninck on 19/11/2015.
//  Copyright © 2015 Jeffrey Macko. All rights reserved.
//

import Foundation
import SpriteKit


class LevelManager {
  
  func levelFromLevelObject(levelObject: LevelModel) -> GameScene {
    
    let gameScene: GameScene = GameScene(size: UIScreen.mainScreen().bounds.size)
    
    // TEST
    gameScene.backgroundColor = UIColor.lightGrayColor()
    //
    
    gameScene.gridManager = GridManager(levelSize: levelObject.size, entityManager: gameScene.entityManager)
    
    gameScene.cameraManager = CameraManager(levelSize: levelObject.size)
    
    if GameConstant.Debug.Enable {
      self.addGridForSize(levelObject.size, gameScene: gameScene)
    }
    
    for anElement in levelObject.elements {
      let basetype = BaseType(rawValue: anElement.basetype)!
      switch basetype {
      case BaseType.User:
        let specifictype = SpecificTypeUser(rawValue: anElement.specifictype)!
        switch specifictype {
        case SpecificTypeUser.In:
          self.addPlayerForComponent(anElement, gameScene: gameScene)
          break
        case SpecificTypeUser.Out:
          self.addCaseEntityInGameScene(anElement, gameScene:gameScene)
          break
        }
      case BaseType.Case:
        let specifictype = SpecificTypeCase(rawValue: anElement.specifictype)!
        switch specifictype {
        case SpecificTypeCase.Muddy:
          self.addMuddyCaseEntityInGameScene(anElement, gameScene:gameScene)
        case SpecificTypeCase.Simple, SpecificTypeCase.Ephemeral, SpecificTypeCase.Actionable, SpecificTypeCase.Hole:
          self.addCaseEntityInGameScene(anElement, gameScene:gameScene)
          break
        }
      case BaseType.Block:
        let specifictype = SpecificTypeBlock(rawValue: anElement.specifictype)!
        switch specifictype {
        case SpecificTypeBlock.Boulder:
          self.addBoulderForComponent(anElement, gameScene: gameScene)
          break
        case SpecificTypeBlock.BoulderCracked:
          self.addBoulderCrackedForComponent(anElement, gameScene: gameScene)
          break
        case SpecificTypeBlock.Tree:
          self.addTreeForComponent(anElement, gameScene: gameScene)
          break
        case SpecificTypeBlock.BurningTree:
          self.addBurningTreeForComponent(anElement, gameScene: gameScene)
          break
        case SpecificTypeBlock.Wall:
          self.addWallForComponent(anElement, gameScene: gameScene)
          break
        }
      case BaseType.Item:
        let specifictype = SpecificTypeItem(rawValue: anElement.specifictype)!
        switch specifictype {
        case SpecificTypeItem.Rope:
          self.addRopeForComponent(anElement, gameScene: gameScene)
          break
        case SpecificTypeBlock.Hammer:
          self.addHammerForComponent(anElement, gameScene: gameScene)
          break
        case SpecificTypeBlock.Axe:
          self.addAxeForComponent(anElement, gameScene: gameScene)
          break
        case SpecificTypeBlock.WaterSeal:
          self.addWaterSealForComponent(anElement, gameScene: gameScene)
          break
        case SpecificTypeBlock.Glove:
          self.addGloveForComponent(anElement, gameScene: gameScene)
          break
        }
      }
    }
    
    return gameScene
  }
  
  
  func spriteNameForElement(anElement: ElementModel) -> String {
    let indexes : Array<String> = [
      "Boulder", // 0
      "Cracked",
      "Tree",
      "TreeFire",
      "Wall",
      "Action", // 5
      "Ephemeral",
      "Hole",
      "Muddy",
      "Simple",
      "lvl1", // 10
      "lvl2",
      "lvl3",
      "Axe",
      "Glove",
      "Hammer", // 15
      "Rope",
      "WaterSeal",
      "UserIn",
      "UserOut"
    ]
    
    let basetype = BaseType(rawValue: anElement.basetype)!
    switch basetype {
    case BaseType.User:
      let specifictype = SpecificTypeUser(rawValue: anElement.specifictype)!
      switch specifictype {
      case SpecificTypeUser.In:
        return indexes[18]
      case SpecificTypeUser.Out:
        return indexes[19]
      }
    case BaseType.Case:
      let specifictype = SpecificTypeCase(rawValue: anElement.specifictype)!
      switch specifictype {
      case SpecificTypeCase.Simple:
        return indexes[9]
      case SpecificTypeCase.Muddy:
        return indexes[8]
      case SpecificTypeCase.Ephemeral:
        return indexes[6]
      case SpecificTypeCase.Actionable:
        return indexes[5]
      case SpecificTypeCase.Hole:
        return indexes[7]
      }
    case BaseType.Block:
      let specifictype = SpecificTypeBlock(rawValue: anElement.specifictype)!
      switch specifictype {
      case SpecificTypeBlock.Boulder:
        return indexes[0]
      case SpecificTypeBlock.BoulderCracked:
        return indexes[1]
      case SpecificTypeBlock.Tree:
        return indexes[2]
      case SpecificTypeBlock.BurningTree:
        return indexes[3]
      case SpecificTypeBlock.Wall:
        return indexes[4]
      }
    case BaseType.Item:
      let specifictype = SpecificTypeItem(rawValue: anElement.specifictype)!
      switch specifictype {
      case SpecificTypeItem.Rope:
        return indexes[16]
      case SpecificTypeBlock.Hammer:
        return indexes[15]
      case SpecificTypeBlock.Axe:
        return indexes[13]
      case SpecificTypeBlock.WaterSeal:
        return indexes[17]
      case SpecificTypeBlock.Glove:
        return indexes[14]
      }
    }
  }
  
  
  
  func addCaseEntityInGameScene(element: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(element, imageNamed:self.spriteNameForElement(element))
    let player = CaseEntity(component: element, spriteNode: spriteNode)
    gameScene.entityManager.add(player)
    gameScene.gridManager.addEntity(player, x: element.position.x, y: element.position.y)
  }
  
  func addMuddyCaseEntityInGameScene(element: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(element, imageNamed:self.spriteNameForElement(element))
    let muddy = Muddy(component: element, spriteNode: spriteNode, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(muddy)
    gameScene.gridManager.addEntity(muddy, x: element.position.x, y: element.position.y)
  }
  
  func addWallForComponent(component: ElementModel, gameScene: GameScene) {
    
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let wall = Wall(component: component, spriteNode: spriteNode, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(wall)
    gameScene.gridManager.addEntity(wall, x: component.position.x, y: component.position.y)
  }
  
  func addBoulderForComponent(component: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let basicBloc = Boulder(component: component, spriteNode: spriteNode, actionsManager: gameScene.actionsManager, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(basicBloc)
    gameScene.gridManager.addEntity(basicBloc, x: component.position.x, y: component.position.y)
  }
  
  func addBoulderCrackedForComponent(component: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let basicBloc = BoulderCracked(component: component, spriteNode: spriteNode, actionsManager: gameScene.actionsManager, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(basicBloc)
    gameScene.gridManager.addEntity(basicBloc, x: component.position.x, y: component.position.y)
  }
  
  func addTreeForComponent(component: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let basicBloc = Tree(component: component, spriteNode: spriteNode, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(basicBloc)
    gameScene.gridManager.addEntity(basicBloc, x: component.position.x, y: component.position.y)
  }
  
  func addBurningTreeForComponent(component: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let basicBloc = BurningTree(component: component, spriteNode: spriteNode, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(basicBloc)
    gameScene.gridManager.addEntity(basicBloc, x: component.position.x, y: component.position.y)
  }
  
  func addGloveForComponent(component: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let basicGauntlet = Glove(component: component, spriteNode: spriteNode, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(basicGauntlet)
    gameScene.gridManager.addEntity(basicGauntlet, x: component.position.x, y: component.position.y)
  }
  
  func addRopeForComponent(component: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let basicGauntlet = Rope(component: component, spriteNode: spriteNode, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(basicGauntlet)
    gameScene.gridManager.addEntity(basicGauntlet, x: component.position.x, y: component.position.y)
  }

  func addHammerForComponent(component: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let basicGauntlet = Hammer(component: component, spriteNode: spriteNode, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(basicGauntlet)
    gameScene.gridManager.addEntity(basicGauntlet, x: component.position.x, y: component.position.y)
  }

  
  func addAxeForComponent(component: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let basicGauntlet = Axe(component: component, spriteNode: spriteNode, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(basicGauntlet)
    gameScene.gridManager.addEntity(basicGauntlet, x: component.position.x, y: component.position.y)
  }

  func addWaterSealForComponent(component: ElementModel, gameScene: GameScene) {
    let spriteNode = self.spriteNodeFor(component, imageNamed: self.spriteNameForElement(component))
    let basicGauntlet = WaterSeal(component: component, spriteNode: spriteNode, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(basicGauntlet)
    gameScene.gridManager.addEntity(basicGauntlet, x: component.position.x, y: component.position.y)
  }

  func addPlayerForComponent(component: ElementModel, gameScene: GameScene) {
    
    let spriteNode = self.spriteNodeFor(component, imageNamed: GameConstant.Sprites.Player)
    let player = Player(component: component, spriteNode: spriteNode, actionsManager: gameScene.actionsManager, gridManager: gameScene.gridManager)
    gameScene.entityManager.add(player)
    gameScene.gridManager.addEntity(player, x: component.position.x, y: component.position.y)
  }
  
  func spriteNodeFor(component: ElementModel, imageNamed: String) -> SKSpriteNode {
    
    let spriteNode: SKSpriteNode = SKSpriteNode(imageNamed: imageNamed)
    spriteNode.size = CGSize(width: GameConstant.Entity.Size, height: GameConstant.Entity.Size)
    spriteNode.position.x = CGFloat(component.position.x + GameConstant.Level.Margin) * GameConstant.Entity.Size + GameConstant.Entity.Size / 2
    spriteNode.position.y = CGFloat(component.position.y + GameConstant.Level.Margin) * GameConstant.Entity.Size + GameConstant.Entity.Size / 2
    spriteNode.zPosition = CGFloat(component.position.z)
    spriteNode.zRotation = CGFloat(component.position.orientation.rawValue) / CGFloat(180) * CGFloat(M_PI)
    
    return spriteNode
  }
  
  //
  // DEBUG CONSUM A LOT OF NODE
  //
  func addGridForSize(size: LevelSizeModel, gameScene: GameScene) {
    
    for j in 0 ..< size.height {
      for i in 0 ..< size.width {
        let spriteNode: SKSpriteNode = SKSpriteNode(imageNamed: GameConstant.Sprites.Grid)
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteNode.size = CGSize(width: GameConstant.Entity.Size, height: GameConstant.Entity.Size)
        spriteNode.position.x = CGFloat(i + GameConstant.Level.Margin) * GameConstant.Entity.Size + GameConstant.Entity.Size / 2
        spriteNode.position.y = CGFloat(j + GameConstant.Level.Margin) * GameConstant.Entity.Size + GameConstant.Entity.Size / 2
        spriteNode.zPosition = CGFloat(2)
        gameScene.addChild(spriteNode)
      }
    }
  }
}