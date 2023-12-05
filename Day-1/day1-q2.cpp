/**
* Author: Matt Bass
 *
 * --- Part Two ---

Your calculation isn't quite right. It looks like some of the digits are actually spelled out with letters: one, two, three, four, five, six, seven, eight, and nine also count as valid "digits".

Equipped with this new information, you now need to find the real first and last digit on each line. For example:

two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76. Adding these together produces 281.
 *
*/
#include <iostream>
#include <fstream>
#include <printf.h>

typedef struct{
    int number_value;
    std::string string_value;
}number_map;


number_map digit_map[] = {
        {0, "zero"},
        {1, "one"},
        {2, "two"},
        {3, "three"},
        {4, "four"},
        {5, "five"},
        {6, "six"},
        {7, "seven"},
        {8, "eight"},
        {9, "nine"}
};


int main(int argc, char *argv[]) {
    // check that a file was passed in
    if (argc < 2) {
       printf("Please pass in a file name\n");
        return 1;
    }

    // open the file
    std::ifstream file(argv[1]);
    if (!file.is_open()) {
        printf("Could not open file %s\n", argv[1]);
        return 1;
    }


    std::string line;
    int sum = 0;

    while (getline(file, line)) {

        int left_most = -1;
        int right_most = -1;

        // Scan the line for the first and last numbers
        for (size_t i = 0; i < line.length(); i++) {
            // Check for digit
            if (isdigit(line[i])) {
                int digit = line[i] - '0';
                if (left_most == -1) left_most = digit;
                right_most = digit;
            } else {
                // Check for number string
                for (const auto &dm: digit_map) {
                    if (i <= line.length() - dm.string_value.length() &&
                        line.substr(i, dm.string_value.length()) == dm.string_value) {
                        if (left_most == -1) left_most = dm.number_value;
                        right_most = dm.number_value;
                        i += 1; // Skip over the number string
                        break;
                    }
                }
            }
        }
        sum += left_most * 10 + right_most;
    }
    printf("Sum: %d\n", sum);
}