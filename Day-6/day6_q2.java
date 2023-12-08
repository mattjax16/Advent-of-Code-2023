/*
 * day6_q2.java
 * Author: Matt Bass
 * 
 * --- Part Two ---

As the race is about to start, you realize the piece of paper with race times and record distances 
you got earlier actually just has very bad kerning. There's really only one race - 
ignore the spaces between the numbers on each line.

So, the example from before:

Time:      7  15   30
Distance:  9  40  200
...now instead means this:

Time:      71530
Distance:  940200
Now, you have to figure out how many ways there are to win this single race. 
In this example, the race lasts for 71530 milliseconds and the record distance you
need to beat is 940200 millimeters. You could hold the button anywhere from 14 to 
71516 milliseconds and beat the record, a total of 71503 ways!

How many ways can you beat the record in this one much longer race?
 * 
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

class day6_q2 {
    static int numWays = 0;
    static int raceTime = 0;
    static long raceDistance = 0;

    public static void main(String[] args) {
        if (args.length > 0) {
            try {
                readFile(args[0]);
                findWays(raceTime, raceDistance);
                System.out.println(numWays);
            } catch (FileNotFoundException e) {
                System.out.println("An error occurred finding the file.");
                e.printStackTrace();
            }
        } else {
            System.out.println("Usage: java day6_q2 <file name>");
        }
    }

    public static void readFile(String fileName) throws FileNotFoundException {
        File file = new File(fileName);
        Scanner scanner = new Scanner(file);
        String[] lines = new String[1000];
        int i = 0;
        while (scanner.hasNextLine()) {
            lines[i] = scanner.nextLine();
            i++;
        }
        scanner.close();

        String time_string = lines[0].split(":")[1].replaceAll("\\s+", "");
        String distance_string = lines[1].split(":")[1].replaceAll("\\s+", "");
        raceTime = Integer.parseInt(time_string);
        raceDistance = Long.parseLong(distance_string);
    }

    public static void findWays(int time, long distance){
        // O(n) solution
        for (int i = 0; i <=time+1; i++) {
            int dx = i * (time - i);
            if (dx > distance) {
                numWays++;
            }
        }
    }

    // This works for test case but not for real input
    public static void findWaysBinary(int time, long distance){
        // going to be doing binary search here

        int left = 0;
        int right = time/2; // dividing by 2 dx is max at half time
        int mid = 0;
        while (left <= right) {
            mid = (left + right) / 2;
            int dx = mid * (time - mid);
            if (dx > distance) {
                numWays = time - mid + 1 - left;
                right = mid - 1;
            } else if (dx < distance) {
                left = mid + 1;
            }
        }
    }
}