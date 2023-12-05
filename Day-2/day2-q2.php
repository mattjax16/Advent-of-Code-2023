<?php
    /*
    Author: Matt Bass 

    PHP oh the joys...

    The Elf says they've stopped producing snow because they aren't getting any water! He isn't sure why the water stopped; however, he can show you how to get to the water source to check it out for yourself. It's just up ahead!

    As you continue your walk, the Elf poses a second question: in each game you played, what is the fewest number of cubes of each color that could have been in the bag to make the game possible?

    Again consider the example games from earlier:

    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    In game 1, the game could have been played with as few as 4 red, 2 green, and 6 blue cubes. If any color had even one fewer cube, the game would have been impossible.
    Game 2 could have been played with a minimum of 1 red, 3 green, and 4 blue cubes.
    Game 3 must have been played with at least 20 red, 13 green, and 6 blue cubes.
    Game 4 required at least 14 red, 3 green, and 15 blue cubes.
    Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.
    The power of a set of cubes is equal to the numbers of red, green, and blue cubes multiplied together. The power of the minimum set of cubes in game 1 is 48. In games 2-5 it was 12, 1560, 630, and 36, respectively. Adding up these five powers produces the sum 2286.

    For each game, find the minimum set of cubes that must have been present. What is the sum of the power of these sets?
    */
    
    function getGames($fileContents) {
        // Define a list of possible colors
        $possibleColors = ['red', 'blue', 'green']; 
    
        // Ensure $fileContents is an array, split by newlines if it's a string
        if (is_string($fileContents)) {
            $fileContents = explode("\n", $fileContents);
        }
    
        $games = array();
        foreach ($fileContents as $line) {
            // Skip empty lines
            if (trim($line) === '') {
                continue;
            }
    
            // Get rid of ':' and everything before it
            $lineParts = explode(":", $line);
            if (count($lineParts) < 2) {
                // Handle invalid line format
                continue;
            }
            $line = trim($lineParts[1]);
    
            // Split the game by sets
            $sets = explode(";", $line);
            foreach ($sets as $index => $set) {
                $sets[$index] = trim($set);
            }
            $games[] = $sets;
        }
    
        // Process each game and its sets
        foreach ($games as $key => $game) {
            foreach ($game as $setKey => $set) {
                if ($set === '') {
                    continue;
                }
                $setParts = explode(",", $set);
                $gameData = array_fill_keys($possibleColors, 0); // Initialize all colors to 0
    
                foreach ($setParts as $cube) {
                    $cubeParts = explode(" ", trim($cube));
                    if (count($cubeParts) < 2) {
                        // Handle invalid cube format
                        continue;
                    }
                    $color = $cubeParts[1];
                    $number = $cubeParts[0];
                    if (array_key_exists($color, $gameData)) {
                        $gameData[$color] = $number;
                    }
                }
                $games[$key][$setKey] = $gameData;
            }
        }
        return $games;
    }

    function calculateMinCubesPerGame($games) {
        $minCubesPerGame = [];
    
        foreach ($games as $gameKey => $game) {
            $maxCubesForThisGame = [];
    
            foreach ($game as $set) {
                foreach ($set as $color => $number) {
                    if (!isset($maxCubesForThisGame[$color])) {
                        $maxCubesForThisGame[$color] = 0;
                    }
                    $maxCubesForThisGame[$color] = max($maxCubesForThisGame[$color], $number);
                }
            }
    
            $minCubesPerGame[$gameKey] = $maxCubesForThisGame;
        }
    
        return $minCubesPerGame;
    }
    

    
    
    
    function calculateProductOfMinCubes($minCubesPerGame) {
        $productsPerGame = [];
    
        foreach ($minCubesPerGame as $gameKey => $cubes) {
            $product = 1;
            foreach ($cubes as $color => $number) {
                $product *= $number;
            }
            $productsPerGame[$gameKey] = $product;
        }
    
        return $productsPerGame;
    }    
    



    // Main Function
    if ($argc > 0) { // Check if there are any arguments
        
        // check that the file exists
        if (file_exists($argv[1])) {
            $file = fopen($argv[1], "r") or exit("Unable to open file!");
            $fileContents = fread($file, filesize($argv[1]));
            fclose($file);
        } else {
            echo "File does not exist.\n";
            exit();
        }

    
        
        $games = getGames($fileContents);

        $minCubes = calculateMinCubesPerGame($games);

        $productOfMinCubes = calculateProductOfMinCubes($minCubes);

        $sum = array_sum($productOfMinCubes);

        echo "The sum of the product of the minimum cubes per game is: " . $sum . "\n";

        


    } else {
        echo "Usage: php day2-q2.php <input file>\n";
    }
?>