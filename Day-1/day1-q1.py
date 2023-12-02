'''
Matt Bass
Advent of Code 2023 Day 1

The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover. On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.

For example:

1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.

Consider your entire calibration document. What is the sum of all of the calibration values?
'''
import re

# list of digit names
digit_names = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

# Import the file
file = open("day_1_q1_input.txt", "r")

# Read the file
file_contents = file.read()

# Split the file into a list of lines
file_lines = file_contents.splitlines()

# Initialize the sum
sum = 0

# Loop through each line
for line_num, line in enumerate(file_lines):
    # Get the first and last digits using regex pattern ^(\d).*\D(\d)$
    both_digits = re.findall(r'\d', line)

    # if there is a number greater than 9 in the both_digits list, then we need to
    # print a warning
    for digit in both_digits:
        if int(digit) > 9:
            print("WARNING: There is a digit greater than 9 on line " + str(line_num+1))


    if len(both_digits) < 2:

        # find a single digit in the string
        single_digit = re.search(r'\d', line)

        # turn it into an int
        single_digit = int(single_digit.group(0))

        # if the single digit is greater than 9, print a warning
        if(single_digit > 9):
            print("WARNING: There is a digit greater than 9 on line " + str(line_num+1))

        if(single_digit):
            # Add the single digit to the sum
            sum += int(single_digit)*11
    else:
        #combine the first and last digits into a single two-digit number
        two_digit_num = both_digits[0] + both_digits[-1]

        # Add the two-digit number to the sum
        sum += int(two_digit_num)









# Print the sum
print(sum)
