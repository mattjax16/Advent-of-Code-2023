// day5-q2.go
// Author: Matt Bass

// Everyone will starve if you only plant such a small number of seeds. Re-reading the almanac, it looks like the seeds: line actually describes ranges of seed numbers.

// The values on the initial seeds: line come in pairs. Within each pair, the first value is the start of the range and the second value is the length of the range. So, in the first line of the example above:

// seeds: 79 14 55 13
// This line describes two ranges of seed numbers to be planted in the garden. The first range starts with seed number 79 and contains 14 values: 79, 80, ..., 91, 92. The second range starts with seed number 55 and contains 13 values: 55, 56, ..., 66, 67.

// Now, rather than considering four seed numbers, you need to consider a total of 27 seed numbers.

// In the above example, the lowest location number can be obtained from seed number 82, which corresponds to soil 84, fertilizer 84, water 84, light 77, temperature 45, humidity 46, and location 46. So, the lowest location number is 46.

// Consider all of the initial seed numbers listed in the ranges on the first line of the almanac. What is the lowest location number that corresponds to any of the initial seed numbers?

package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// zip takes two slices of integers and returns a new slice of slices of integers.
// Each inner slice has two integers, one from each of the input slices.
func zip(slice1, slice2 []int) [][]int {
	length := min(len(slice1), len(slice2))
	zipped := make([][]int, length)
	for i := 0; i < length; i++ {
		zipped[i] = []int{slice1[i], slice2[i]}
	}
	return zipped
}

// min returns the smaller of two integers.
func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

// Function to read the file and return its content
func readFile(fileName string) (string, error) {
	file, err := os.Open(fileName)
	if err != nil {
		return "", err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	content := ""
	for scanner.Scan() {
		content += scanner.Text() + "\n"
	}

	return content, scanner.Err()
}

// Function to parse the file data
func parseFileData(fileData string) [][]int {
	sections := strings.Split(strings.TrimSpace(fileData), "\n\n")
	var parsedSections [][]int

	for section_index, section := range sections {
		lines := strings.Split(section, "\n")
		var numbers []int
		for _, line := range lines[0:] {
			for _, num := range strings.Fields(line) {
				intNum, _ := strconv.Atoi(num)
				numbers = append(numbers, intNum)
			}
		}
		// if the first number is 0 then get rid of it
		if numbers[0] == 0 && section_index != 0 {
			numbers = numbers[2:]
		} else if numbers[0] == 0 && section_index == 0 {
			numbers = numbers[1:]
		}
		parsedSections = append(parsedSections, numbers)
	}

	return parsedSections
}

// Function to find seed to location map
func findSeedToLocationMap(sectionMaps [][]int) []int {
	seedToLocationMap := make([]int, len(sectionMaps[0]))
	for seedIndex, seed := range sectionMaps[0] {
		currentVal := seed
		for _, sectionMap := range sectionMaps[1:] {
			for i := 0; i < len(sectionMap); i += 3 {
				destinationStart, sourceStart, rangeLength := sectionMap[i], sectionMap[i+1], sectionMap[i+2]
				if currentVal >= sourceStart && currentVal < sourceStart+rangeLength {
					currentVal = destinationStart + (currentVal - sourceStart)
					break
				}
			}
		}
		seedToLocationMap[seedIndex] = currentVal
	}
	return seedToLocationMap
}

// Function to modify the seed values returns list of tuples of the seed start and range length
func modifySeedValues(seedValues []int) [][]int {

	var seed_start []int
	var seed_range []int

	// modify the seed values
	for seed_index, seed := range seedValues {
		if seed_index%2 == 0 {
			seed_start = append(seed_start, seed)
		} else {
			seed_range = append(seed_range, seed)
		}
	}

	// create a list of tuples of the seed start and range length
	var seed_vals = zip(seed_start, seed_range)
	return seed_vals
}

// Main method
func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: go run day5-q2.go [file name]")
		os.Exit(1)
	}

	fileName := os.Args[1]
	fileData, err := readFile(fileName)
	if err != nil {
		fmt.Println("Error reading file:", err)
		os.Exit(1)
	}

	sections := parseFileData(fileData)

	// modify the seed values
	var seed_values = modifySeedValues(sections[0])

	// min location number is the max int value
	var min_location_number = 9223372036854775807

	// loop through the seed values and find the min location number
	for i, seed_value := range seed_values {

		// get the seed start and range length
		seed_start := seed_value[0]
		range_length := seed_value[1]

		// loop through the range length and find the min location number
		for j := seed_start; j < seed_start+range_length; j++ {
			sections[0] = []int{j}
			seedToLocationMap := findSeedToLocationMap(sections)

			// see if the location number is less than the min location number
			if seedToLocationMap[0] <= min_location_number {
				min_location_number = seedToLocationMap[0]

				fmt.Println("Seed:", j, "Location:", seedToLocationMap[0])
			}
		}

		// update the seed value
		seed_values[i][0] = min_location_number
	}

	// print the min location number
	fmt.Println("The lowest location number that corresponds to any of the initial seed numbers is:", min_location_number)
}
