// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract BottleGame {
    uint256[5] private correctSequence;
    uint256 private attempts;
    bool private gameActive;
    address private player;

    event GameStarted(address player);
    event AttemptMade(uint256 correctPositions);
    event GameWon(address winner);
    event GameReset();

    constructor() {
        shuffleBottles();
    }

    function startNewGame() public {
        require(!gameActive || msg.sender != player, "Finish current game first");
        player = msg.sender;
        gameActive = true;
        attempts = 0;
        shuffleBottles();
        emit GameStarted(msg.sender);
    }

    function makeAttempt(uint256[5] memory attempt) public returns (uint256) {
        require(gameActive, "No active game");
        require(msg.sender == player, "Not your game");
        require(attempts < 5, "Max attempts reached");
        require(isValidAttempt(attempt), "Invalid attempt values");

        uint256 correctPositions = checkAttempt(attempt);
        attempts++;

        emit AttemptMade(correctPositions);

        if (correctPositions == 5) {
            gameActive = false;
            emit GameWon(msg.sender);
        } else if (attempts == 5) {
            gameActive = false;
            shuffleBottles();
        }

        return correctPositions;
    }

    function checkAttempt(uint256[5] memory attempt) private view returns (uint256) {
        uint256 correct = 0;
        for (uint256 i = 0; i < 5; i++) {
            if (attempt[i] == correctSequence[i]) {
                correct++;
            }
        }
        return correct;
    }

    function shuffleBottles() private {
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.prevrandao)));
        
        for (uint256 i = 0; i < 5; i++) {
            correctSequence[i] = i + 1;
        }

        
        for (uint256 i = 4; i > 0; i--) {
            uint256 j = seed % (i + 1);
            seed = uint256(keccak256(abi.encodePacked(seed)));
            
        
            uint256 temp = correctSequence[i];
            correctSequence[i] = correctSequence[j];
            correctSequence[j] = temp;
        }
    }

    function isValidAttempt(uint256[5] memory attempt) private pure returns (bool) {
        for (uint256 i = 0; i < 5; i++) {
            if (attempt[i] < 1 || attempt[i] > 5) {
                return false;
            }
        }
        return true;
    }

    function getRemainingAttempts() public view returns (uint256) {
        require(gameActive, "No active game");
        require(msg.sender == player, "Not your game");
        return 5 - attempts;
    }

    function isGameActive() public view returns (bool) {
        return gameActive;
    }
}
