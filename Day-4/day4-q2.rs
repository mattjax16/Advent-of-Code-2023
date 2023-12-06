/*
day4-q2.rs
Author: Matt Bass

--- Part Two ---

Just as you're about to report your findings to the Elf, one of you realizes that the rules have actually been printed on the back of every card this whole time.

There's no such thing as "points". Instead, scratchcards only cause you to win more scratchcards equal to the number of winning numbers you have.

Specifically, you win copies of the scratchcards below the winning card equal to the number of matches. So, if card 10 were to have 5 matching numbers, you would win one copy each of cards 11, 12, 13, 14, and 15.

Copies of scratchcards are scored like normal scratchcards and have the same card number as the card they copied. So, if you win a copy of card 10 and it has 5 matching numbers, it would then win a copy of the same cards that the original card 10 won: cards 11, 12, 13, 14, and 15. This process repeats until none of the copies cause you to win any more cards. (Cards will never make you copy a card past the end of the table.)

This time, the above example goes differently:

Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
Card 1 has four matching numbers, so you win one copy each of the next four cards: cards 2, 3, 4, and 5.
Your original card 2 has two matching numbers, so you win one copy each of cards 3 and 4.
Your copy of card 2 also wins one copy each of cards 3 and 4.
Your four instances of card 3 (one original and three copies) have two matching numbers, so you win four copies each of cards 4 and 5.
Your eight instances of card 4 (one original and seven copies) have one matching number, so you win eight copies of card 5.
Your fourteen instances of card 5 (one original and thirteen copies) have no matching numbers and win no more cards.
Your one instance of card 6 (one original) has no matching numbers and wins no more cards.
Once all of the originals and copies have been processed, you end up with 1 instance of card 1, 2 instances of card 2, 4 instances of card 3, 8 instances of card 4, 14 instances of card 5, and 1 instance of card 6. In total, this example pile of scratchcards causes you to ultimately have 30 scratchcards!

Process all of the original and copied scratchcards until no more scratchcards are won. Including the original set of scratchcards, how many total scratchcards do you end up with?
*/

use std::fs::File;
use std::io::{BufRead, BufReader};
use std::collections::HashMap;

// struct to hold the scratchcard data
#[derive(Debug)]
struct Scratchcard {
    card_number: u32,
    winning_numbers: Vec<u32>,
    scratchcard_numbers: Vec<u32>,
    win_count: u32,
    number_of_cards: u32
}

//Function to read in the file and return a vector of strings
fn read_file(filename: &str) -> Vec<String> {
    let file = File::open(filename).expect("Error file not found!");
    let reader = BufReader::new(file);
    let mut scratchcards: Vec<String> = Vec::new();
    for line in reader.lines() {
        scratchcards.push(line.unwrap());
    }
    scratchcards
}

// function to get the number of the scratchcard
fn get_scratchcard_number(scratchcard_str: &str) -> u32 {
    let scratchcard_number_str = scratchcard_str.split(":").nth(0).unwrap().split(" ").last().unwrap().trim();
    let scratchcard_number: u32 = scratchcard_number_str.parse().expect("Error parsing scratchcard number");
    return scratchcard_number;
}

// Function to parse the scratchcard data
fn parse_scratchcard(scratchcard_str: &str) -> Scratchcard {
    // Get the number of the scratchcard
    let scratchcard_number = get_scratchcard_number(scratchcard_str);
    let mut clean_scratchcard = scratchcard_str.split(":").nth(1).unwrap();
    let mut scratchcard_data = clean_scratchcard.split(" | ");
    let mut winning_numbers = scratchcard_data.next().unwrap().split(" ");
    let mut scratchcard_numbers = scratchcard_data.next().unwrap().split(" ");
    let mut scratchcard = Scratchcard {
        card_number: scratchcard_number,
        winning_numbers: Vec::new(),
        scratchcard_numbers: Vec::new(),
        win_count: 0,
        number_of_cards: 1
    };

    for number in scratchcard_numbers {
        // check if number is empty space and skip if it is
        if number == "" {
            continue;
        }else{
            scratchcard.scratchcard_numbers.push(number.parse::<u32>().expect("Error parsing scratchcard numbers"));
        }
    }
    for number in winning_numbers {
       // check if number is empty space and skip if it is
        if number == "" {
            continue;
        }else{
            scratchcard.winning_numbers.push(number.parse::<u32>().expect("Error parsing winning numbers"));
        }
    }
    scratchcard
}

// function to calculate the number of winning numbers
fn calculate_win_count(scratchcard: &mut Scratchcard) {
    let mut win_count = 0;
    for number in &scratchcard.winning_numbers {
        if scratchcard.scratchcard_numbers.contains(number) {
            win_count += 1;
        }
    }
    scratchcard.win_count = win_count;
}

// function to calculate the number of copies of each scratchcard won
fn calculate_number_of_copies(scratchcard_data: &mut Vec<Scratchcard>) {
    let len = scratchcard_data.len(); // Get the length of the vector

    for i in 0..len {
        let win_count = scratchcard_data[i].win_count as usize; // Convert to usize

        // for each copy of the scratchcard
        for k in 0..scratchcard_data[i].number_of_cards {
            // Check each win of the current scratchcard
            for j in 0..win_count {
                // Calculate the index of the next scratchcard
                let next_index = i + j + 1; // Now both `i` and `j` are of type `usize`

                // Make sure the index is within the bounds of the vector
                if next_index < len {
                    scratchcard_data[next_index].number_of_cards += 1;
                }
            }
        }
    }
}




// Main function
fn main() {

    // Check to make sure the user has entered a filename
    if std::env::args().len() < 2 {
        println!("Usage: day4-q2 <input filename>");
        std::process::exit(1);
    }

    // Read the file into a vector of strings
    let scratchcards = read_file(&std::env::args().nth(1).unwrap());

    // Parse the scratchcard data into a vector of scratchcard structs
    let mut scratchcard_data: Vec<Scratchcard> = Vec::new();
    for scratchcard in scratchcards {
        scratchcard_data.push(parse_scratchcard(&scratchcard));
    }

    // Calculate the number of winning numbers for each scratchcard
    for mut scratchcard in &mut scratchcard_data {
        calculate_win_count(&mut scratchcard);
    }

    // Calculate the number of copies of each scratchcard won
    calculate_number_of_copies(&mut scratchcard_data);

    // Calculate the total number of scratchcards won
    let mut total_scratchcards = 0;
    for scratchcard in &scratchcard_data {
        total_scratchcards += scratchcard.number_of_cards;
    }

    println!("Total number of scratchcards: {}", total_scratchcards);

    return;
}