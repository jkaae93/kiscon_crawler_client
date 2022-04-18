import csv
import datetime
from pandas import notnull
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
import os
import time

# init selenium driver
def drive_init():
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_driver = os.path.join(os.getcwd() + '/.venv/chromedriver/', "chromedriver 2")

    return webdriver.Chrome(chrome_options=chrome_options, executable_path=chrome_driver)

# set category for search
def set_category(driver, id):
    driver.find_element_by_id(id).click()

# get colum count
def get_total_cnt(driver):
    total = driver.find_element_by_class_name("org01.dml")
    return int(total.text.replace(',',''))

# click to search button
def search(driver):
    search_btn = driver.find_element_by_class_name("flw.tcnt.mgtp30")
    search_btn.click()
    time.sleep(2)

# move to nextpage
def move_next(driver):
    next_btn = driver.find_elements_by_class_name("btn_prevNext")
    next = next_btn[1].find_element_by_tag_name("a")
    webdriver.ActionChains(driver).double_click(next).perform()

def load_data(total, driver, csv_writer):
    count = 0
    while total >= count:
        body = driver.find_element_by_class_name("basic_tbl.thickgr.w100.mgtp08.flft")
        lists = body.find_elements_by_tag_name("tr")
        index = 0

        for company in lists:
            # NOTE: range(0, 5), 0 is title
            if index != 0:
                shown = 0
                
                print("-----------------------------------------------------------------------")
                print("                  " + str(count)+" / "+str(total))
                print("-----------------------------------------------------------------------")

                simple = company.find_element_by_class_name("btn-in.btncol_yo")
                webdriver.ActionChains(driver).double_click(simple).perform()
                
                recover = 0
                # NOTE: wait modal
                while shown == 0:
                    company_name = driver.find_element_by_id("strSangho")
                    ceo = driver.find_element_by_id("strCeo")
                    category_list = driver.find_element_by_id("strItem")
                    tel = driver.find_element_by_id("strTel")
                    addr = driver.find_element_by_id("strAddr")
                    
                    print("company:" + company_name.text)
                    
                    if company_name.text != "":
                        # break while
                        shown = 1
                        recover = 0
                        
                        category_concat = category_list.text.replace("\n","/")
                        
                        csv_writer.writerow([company_name.text, ceo.text, tel.text, addr.text, category_concat])
                        modal = driver.find_element_by_class_name("modal.fade.bs-example-modal-lg.in")
                        close = modal.find_element_by_class_name("modal_close")
                        webdriver.ActionChains(driver).double_click(close).perform()
                        
                        # update count
                        count += 1
                        
                    else :
                        if recover > 5:
                            print("Try recover")
                            sub_info = company.find_elements_by_tag_name("td")
                            if(len(sub_info) > 0):
                                company_name = sub_info[1].text
                                ceo = sub_info[3].text
                                addr = sub_info[4].text
                                category_list = sub_info[6].text
                                tel = sub_info[7].text
                                category_concat = category_list.replace("\n","/")
                                csv_writer.writerow([company_name, ceo, tel, addr, category_concat])
                                print(company_name + "," + ceo + "," + addr + "," + category_list + "," + tel + "," )
                            else:
                                print("Empty")
                                csv_writer.writerow([str(count), "", "", "", ""])
                    
                            recover = 0
                            shown = 1
                        else:
                            time.sleep(1)
                            recover += 1
                            print("WAIT: " + str(count) + " / " + str(total))
            index += 1

        move_next(driver)

def finish(csv, driver):
    csv.close()
    driver.close()
    
    print("-----------------------------------------------------------------------")
    print("           ---    ----   ---         ----------------------------------")
    print(" -------------      --   ---   ----   ---------------------------------")
    print("           ---    -  -   ---   ----   ---------------------------------")
    print(" -------------    --     ---   ----   ---------------------------------")
    print("           ---    ---    ---         ----------------------------------")
    print("-----------------------------------------------------------------------")

def main():
    ts = datetime.datetime.now()
    start =  datetime.datetime.now().strftime("%y.%m.%d-%H:%M")

    print("-----------------------------------------------------------------------")
    print("                   start: " + start)
    print("-----------------------------------------------------------------------")

    drive = drive_init()
    drive.get("https://www.kiscon.net/gongsi/step_custom.asp")

    date =  datetime.datetime.now().strftime("%y%m%d")
    csv_filename = "./script/"+date+".csv"
    csv_open = open(csv_filename, "w+", encoding='utf-8')
    csv_writer = csv.writer(csv_open)
    csv_writer.writerow( ['Company name','CEO', 'TEL', 'Address', 'Category'] )
    
    #Please insert to id
    set_category(drive, "item3") 
    search(drive)

    total = get_total_cnt(drive)

    print("-----------------------------------------------------------------------")
    print("                   start: " + start)
    print("-----------------------------------------------------------------------")
    
    load_data(total, drive, csv_writer)
    
    end =  datetime.datetime.now().strftime("%y.%m.%d-%H:%M")

    print("-----------------------------------------------------------------------")
    print("                   start: " + start)
    print("                   end: " + end)
    print("-----------------------------------------------------------------------")
    
    finish(csv_open, drive)

main()