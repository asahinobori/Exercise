// compile: g++ -o deadLock -std=c++11 -pthread deadLock.cpp

#include <iostream>
#include <mutex>
#include <thread>

long num = 0;
std::mutex num_mutex1;
std::mutex num_mutex2;

const int loopTime 1000000

void numplus() {
    std::cout << "plus" << std::endl;
    std::lock_guard<std::mutex> lock1(num_mutex1);
    for (int i = 0; i < loopTime; i++) {
        // std::cout << "+";
        num++;
    }
    std::cout << "plus fin" << std::endl;
    std::lock_guard<std::mutex> lock2(num_mutex2);
}

void numsub() {
    std::cout << "sub" << std::endl;
    std::lock_guard<std::mutex> lock2(num_mutex2);
    for (int i = 0; i < loopTime; i++) {
        // std::cout << "-";
        num--;
    }
    std::cout << "sub fin" << std::endl;
    std::lock_guard<std::mutex> lock1(num_mutex1);
}

int main() {
    std::thread t1(numplus);
    std::thread t2(numsub);
    t1.join();
    t2.join();
    std::cout << num << std::endl;
    return 0;
}
