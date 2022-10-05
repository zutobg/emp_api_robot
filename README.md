# README

## Robot framewok tests

follow steps to run the local API https://github.com/eMerchantPay/codemonsters_api_full#readme

there is a nice to have task to tear up and tear down the api from the robot test suite itself which is not implemented https://github.com/zutobg/emp_api_robot/issues/4



### PyCharrm IDE setup
This will be a sanity check app implemented in the main Ruby API project which will test the stability of the payment transaction gateway project.

Build with:

**javac 1.8.0_201**

**Python 3.6.9**

**pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)**

**Robot Framework 5.0.1 (Python 3.6.9 on linux)**

**PyCharm Intellibot plugin(patched)**




### What you need to install to be able to run the tests:

`pip3 check robotframework`

`pip3 install requests`

`pip3 install robotframework-requests`

`pip3 install -U robotframework-jsonlibrary`

`pip3 install jsonpath_rw`

`pip3 install jsonpath_rw_ext`


### How to execute from console

Go into the API project main folder

Clone this repo

run all tests:`robot emp_api_robot/robot-tests/sanity/api_tests.robot`

run Smoke:`robot -d results -i Smoke emp_api_robot/robot-tests/sanity/api_tests.robot`

run Sanity:`robot -d results -i Sanity emp_api_robot/robot-tests/sanity/api_tests.robot`

run Validation:`robot -d results -i Validation emp_api_robot/robot-tests/sanity/api_tests.robot`

runn all but Smoke:`robot -d results -e Smoke emp_api_robot/robot-tests/sanity/api_tests.robot`
