*** Settings ***
# Import Resource & Libraries
## Main Library
Library             String
Library             python/Library.py
Library             RequestsLibrary
Library             Collections
Library             Process
Library             DateTime

## Variables config and base keyword
Resource            Base.robot
Resource            Config.robot

## Page Object
Resource            ../Services/PetstoreService.robot
