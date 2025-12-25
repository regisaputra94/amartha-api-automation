*** Settings ***
# Import Resource & Libraries
## Main Library
Library             RequestsLibrary
Library             Collections
Library             String
Library             Process
Library             DateTime
Library             python/Library.py


## Variables config and base keyword
Resource            Base.robot
Resource            Config.robot

## Page Object
Resource            ../Services/PetstoreService.robot
