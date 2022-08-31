#include <iostream>
#include <bitset>
#include <string>

using std::cout;
using std::endl;


int main(){
    unsigned long x = 10 << 14;
    x = 172032; //10.5
    unsigned long product = x*x;

    std::string product_b = std::bitset<64>(product).to_string();
    cout << (product_b) << endl;

    unsigned int hi = product >> 32;
    std::string hi_b = std::bitset<32>(hi).to_string();
    unsigned int lo = product;
    std::string lo_b = std::bitset<32>(lo).to_string();
    cout << hi_b << endl;
    cout << lo_b << endl;

    unsigned int hi_shifted = hi << 14;
    std::string hi_shifted_b = std::bitset<32>(hi_shifted).to_string();
    unsigned int lo_shifted = lo >> 18;
    std::string lo_shifted_b = std::bitset<32>(lo_shifted).to_string();
    cout << hi_shifted_b << endl;
    
    unsigned int product_final = hi_shifted | lo_shifted;
    std::string product_final_b = std::bitset<32>(product_final).to_string();
    cout << product_final_b << endl;

    // // get whole part
    // unsigned int x_whole = x & 0xFFFFC000;
    // std::string whole = std::bitset<32>(x_whole).to_string();
    // cout << whole << endl;

    // // get decimal part
    // unsigned int x_dec = x & 0x00003FFF;
    // std::string decimal = std::bitset<32>(x_dec).to_string();
    // cout << decimal << endl;

    // // back to og
    // // int ogx =(x_whole) | (x_dec);
    // // std::string ogxb = std::bitset<32>(ogx).to_string();
    // // cout << ogxb << endl;


    // unsigned int x_whole_shifted = x_whole >> 14;
    // unsigned int x_dec_shifted = x_dec << 18;

    // std::string z = std::bitset<14>(x_whole_shifted).to_string();
    // cout <<z << endl;

    // unsigned int whole_pr = x_whole_shifted * x_whole_shifted;
    // unsigned int dec_pr = x_dec_shifted * x_dec_shifted;


    // unsigned int whole_pr_shifted = whole_pr << 14;
    // unsigned int dec_pr_shifted = dec_pr << 18;
    // // std::string zz = std::bitset<32>(dec_pr_shifted).to_string();
    // // cout << zz << endl;

    // std::string whole_b = std::bitset<32>(whole_pr).to_string();
    // std::string dec_b = std::bitset<32>(dec_pr).to_string();
    // cout << whole_b << endl;
    // cout << dec_b << endl;
}