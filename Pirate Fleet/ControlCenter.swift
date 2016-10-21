//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

// TODO: Add the computed property, cells.
    var cells: [GridLocation] {
        get {
            // Hint: These two constants will come in handy
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
           
//            // Hint: The cells getter should return an array of GridLocations.
              var occupiedCells = [GridLocation]()
            
            if(start.x==end.x){
                for y in start.y...end.y
                {
                    occupiedCells.append(GridLocation(x: start.x,y: y))
                }
            }else if(start.y==end.y){
                    for x in start.x...end.x
                    {
                        occupiedCells.append(GridLocation(x: x,y: start.y))
                    }
            }
            return occupiedCells

        }
    }
    
    var hitTracker: HitTracker
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    var sunk: Bool {
        get{
            var count = cells.count
            for item:GridLocation in cells {
                if(hitTracker.cellsHit[item])!{
                    count-=1
                }
            }
            if(count==0){
                return true
            }
            return false
        }
       
    }

// TODO: Add custom initializers
    init(length: Int) {
        self.length = length
        self.isVertical = false
        self.location = GridLocation(x:0,y:0)
        self.isWooden = false
        self.hitTracker = HitTracker()
    }
    //即使初始化方法没有明确某个属性的值，它仍必须初始化结构体的所有属性
    init(length: Int,location: GridLocation,isVertical: Bool,hitTracker: HitTracker) {
        self.length = length
        self.isVertical = isVertical
        self.location = location
        self.hitTracker = hitTracker
        self.isWooden = false
    }
    
    init(length: Int,location: GridLocation,isVertical: Bool,isWooden: Bool,hitTracker: HitTracker) {
        self.length = length
        self.isVertical = isVertical
        self.location = location
        self.isWooden = isWooden
        self.hitTracker = hitTracker
    }

}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    //guaranteesHit：Bool（表示对手是否应该保证击中）
    //penaltyText：String（对用户发出警报的文本）
    var guaranteesHit: Bool{set get}
    var penaltyText: String {set get}
    
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
     let location: GridLocation
     var guaranteesHit: Bool
     var penaltyText: String
     init(location:GridLocation,penaltyText:String){
        self.location=location
        self.penaltyText=penaltyText
        self.guaranteesHit=false
     }
    init(location:GridLocation,guaranteesHit:Bool,penaltyText: String){
        self.location=location
        self.penaltyText=penaltyText
        self.guaranteesHit=guaranteesHit
    }
    
}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
 
}

class ControlCenter {
    
    func placeItemsOnGrid(_ human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: true, hitTracker: HitTracker())
        print(smallShip.cells)
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0),guaranteesHit:true,penaltyText:"被鱼雷打中了")
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3),guaranteesHit:false,penaltyText:"被鱼雷打中了")
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6),guaranteesHit:false,penaltyText:"被海怪打中了")
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2),guaranteesHit:false,penaltyText:"海怪打中了")
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(_ gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}
