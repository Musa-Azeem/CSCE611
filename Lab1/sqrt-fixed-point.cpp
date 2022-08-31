#include <iostream>

int sqrt(int input);

int main(int argc, char** argv){
    std::cout << sqrt(9) << std::endl;
}

int sqrt(int input){
    input = input << 14;
    std::cout << input << std::endl << std::endl;
    int step = 2097152;     // 128 * 2^14
    int guess = 4194304;    // 256 * 2^14

    while(step > 0){
        std::cout << guess << std::endl;
        std::cout << step << std::endl << std::endl;
        int guess_whole = (guess >> 14) * (guess >> 14);
        int guess_dec = (guess << 18) * (guess << 18);

        if(guess*guess == input){
            std::cout << "found" << std::endl;
            return guess;
        }
        else if(guess*guess > input){
            guess -= step;
            step = step >> 1;
        }
        else{
            guess += step;
            step /= 2;
        }
    }
    return -1;
}