cmake_minimum_required(VERSION 3.16)
project(raspi-alarm LANGUAGES C CXX Swift)
add_subdirectory("./UIKit/" UIKit)

add_library(raspi-alarm SHARED 
    ./raspi-alarm/ViewController.swift
    ./raspi-alarm/androidMain.swift
    ./raspi-alarm/AppDelegate.swift
)

target_link_libraries(raspi-alarm PRIVATE UIKit JNI SDL)
