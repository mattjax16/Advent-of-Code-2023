/**
 * day3-q2.js
 * Author: Matt Bass
 * 
 *--- Part Two ---

The engineer finds the missing part and installs it in the engine! As the engine springs to life, you jump in the closest gondola, finally ready to ascend to the water source.

You don't seem to be going very fast, though. Maybe something is still wrong? Fortunately, the gondola has a phone labeled "help", so you pick it up and the engineer answers.

Before you can explain the situation, she suggests that you look out the window. There stands the engineer, holding a phone in one hand and waving with the other. You're going so slowly that you haven't even left the station. You exit the gondola.

The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any * symbol that is adjacent to exactly two part numbers. Its gear ratio is the result of multiplying those two numbers together.

This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs to be replaced.

Consider the same engine schematic again:

467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
In this schematic, there are two gears. The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345. The second gear is in the lower right; its gear ratio is 451490. (The * adjacent to 617 is not a gear because it is only adjacent to one part number.) Adding up all of the gear ratios produces 467835.

What is the sum of all of the gear ratios in your engine schematic?
 * 
 */

const fs = require('fs');
const util = require('util');
const readFile = util.promisify(fs.readFile);

function isDigit(ch) {
    return !isNaN(parseInt(ch)) && ch !== '.';
}

async function readInFile(filename) {
    try {
        const data = await readFile(filename, 'utf8');
        return data.split('\n').map(line => line.split(''));
    } catch (err) {
        console.error(err);
        throw err;
    }
}

function findGearSymbPos(grid, row, col) {
    const gearSymb = '*';
    const gearPos = [];
    for (let i = 0; i < grid.length; i++) {
        const row = grid[i];
        for (let j = 0; j < row.length; j++) {
            const ch = row[j];
            if (ch === gearSymb) {
                gearPos.push([i, j]);
            }
        }
    }
    return gearPos;
}


function findNumbersInGrid(grid) {
    // find all the numbers in the grid
    // and returna list of tuples containing each number and its starting digit postion and ending digit position

    const numbers = [];
    for (let i = 0; i < grid.length; i++) {
        const row = grid[i];
        for (let j = 0; j < row.length; j++) {
            const ch = row[j];
            if (isDigit(ch)) {
                // find the end of the number
                let end = j + 1;
                while (end < row.length && isDigit(row[end])) {
                    end++;
                }
                numbers.push([parseInt(row.slice(j, end).join('')), [i, j], [i, end - 1]]);

                // skip over the number
                j = end - 1;
            }
        }
    }
    return numbers;
}


function findGearRatio(grid, gearPos) {
const gearRatio = [];

    // find all the numbers in the grid
    const numbers = findNumbersInGrid(grid);

    for (let i = 0; i < gearPos.length; i++) {
        const [row, col] = gearPos[i];


        // calc all the adjacent positions including diagonals
        const adjPos = [];
        for (let j = row - 1; j <= row + 1; j++) {
            for (let k = col - 1; k <= col + 1; k++) {
                if (j >= 0 && j < grid.length && k >= 0 && k < grid[j].length) {
                    adjPos.push([j, k]);
                }
            }
        }
        // find the numbers next to the gear symbol
        const gearNums = [];
        for (let j = 0; j < numbers.length; j++) {
            const [num, [numRow, numCol], [numRowEnd, numColEnd]] = numbers[j];

            // calculate the position of every digit in the number
            const numPos = [];
            for (let k = numRow; k <= numRowEnd; k++) {
                for (let l = numCol; l <= numColEnd; l++) {
                    numPos.push([k, l]);
                }
            }

            // check if the number is adjacent to the gear symbol
            let isAdj = false;
            for (let k = 0; k < adjPos.length; k++) {
                const [adjRow, adjCol] = adjPos[k];
                if (numPos.some(pos => pos[0] === adjRow && pos[1] === adjCol)) {
                    isAdj = true;
                    break;
                }
            }

            // if the number is adjacent to the gear symbol
            if (isAdj) {
                // push the number
                gearNums.push(num);
            }
        }

        // if there are exactly 2 digits next to the gear symbol
        if (gearNums.length === 2) {
            // push the gear ratio
            gearRatio.push(gearNums.reduce((a, b) => a * b));
        }
    }
    return gearRatio;
}
async function main() {
    const args = process.argv.slice(2);
    if (args.length < 1) {
        console.log('Usage: bun day3-q2.js <input file>');
        return;
    }

    try {
        const grid = await readInFile(args[0]);
        const gearPos = findGearSymbPos(grid);
        const gearRatio = findGearRatio(grid, gearPos);
        console.log(gearRatio.reduce((a, b) => a + b));


    } catch (err) {
        console.error('Error:', err);
    }
}

main();