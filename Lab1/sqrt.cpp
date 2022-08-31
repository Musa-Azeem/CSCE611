#include <iostream>

float sqrt(int input);

int main(int argc, char** argv){
    std::cout << sqrt(10) << std::endl;
}

float sqrt(int input){

    float in = double(input);
    float step = 128;
    float guess = 256;

    while(step > 0){
        if(guess*guess == input){
            return guess;
        }
        else if(guess*guess > input){
            guess -= step;
            step /= 2;
        }
        else{
            guess += step;
            step /= 2;
        }
    }
    return -1;
}