// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./ZombieHelper.sol";

contract ZombieAttack is ZombieHelper{
    using SafeMath for *;

    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint){
        randNonce = randNonce.add(1);
        
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId){
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
    
        uint rand = randMod(100);
        
        if(rand <= attackVictoryProbability){
            myZombie.winCount = uint16(myZombie.winCount.add(1));
            myZombie.level = uint32(myZombie.level.add(1));
            enemyZombie.lossCount = uint16(enemyZombie.lossCount.add(1));
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount = uint16(myZombie.lossCount.add(1));
            enemyZombie.winCount = uint16(enemyZombie.winCount.add(1));
            _triggerCooldown(myZombie);
        }
    }
}