import os
import sys
import time
from selenium import webdriver

_password = os.environ['PASSWORD']

driver = webdriver.Remote('http://127.0.0.1:9515')

driver.get('https://dev.carpe.io/login')


ctl_user_name = driver.find_element_by_id("username")
ctl_user_name.send_keys("efrain.olivares@rivdata.com")

ctl_password = driver.find_element_by_id("password")
ctl_password.send_keys(_password)
ctl_password.submit()

