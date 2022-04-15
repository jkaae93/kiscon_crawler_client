
import csv
import datetime
from pandas import notnull
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
import os
import time
import json

# functions

def build_json(categories) :
  jsons = {}
  for category in categories:
    id = category.find_element_by_class_name("checkln").get_attribute("id")
    if id != "":
      title = category.text
      print(id + " : " + title)
      jsons[id] = title
  return jsons
  

def export_json(path, file):
  with open(path, 'w', encoding='UTF-8-sig') as output:
    json.dump(file, output, ensure_ascii=False, indent=4)


def init():
  chrome_options = Options()
  chrome_options.add_argument("--headless")
  chrome_driver = os.path.join(os.getcwd() + '/.venv/chromedriver/', "chromedriver 2")
  return webdriver.Chrome(chrome_options=chrome_options, executable_path=chrome_driver)

def main():
  driver = init()
  driver.get("https://www.kiscon.net/gongsi/step_custom.asp")

  json_catogory = {}

  filename = "./assets/init.json"

  print("-----------------------------------------------------------------------")
  print("                   START INIT KISCON SCRAPPER")
  print("-----------------------------------------------------------------------")

  # scrap info
  search_btn = driver.find_element_by_class_name("flw.tcnt.mgtp30")
  search_btn.click()
  time.sleep(2)

  inputs = driver.find_element_by_class_name("basic_tbl.thick.w100.flft")
  common_category = inputs.find_element_by_class_name("disin.m_jh")
  prof_category = inputs.find_element_by_class_name("disin.m_jm")

  print("------------------------COMMON CATEGORY------------------------------")
  common = common_category.find_elements_by_tag_name("li")
  json_catogory["common"] = build_json(common)

  print("------------------------PROFESSION CATEGORY------------------------------")
  prof = prof_category.find_elements_by_tag_name("li")
  json_catogory["profession"] = build_json(prof)

  print(json_catogory)

  export_json(filename, json_catogory)

# main
main()