import logging
import time
import pymongo
import re
from datetime import datetime
from datetime import timedelta

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.ui import WebDriverWait


class Motto:

    def __init__(self):
        self.browser = webdriver.Chrome(executable_path='/usr/local/bin/chromedriver')
        client = pymongo.MongoClient('mongodb://localhost:27017')
        self.db = client['motto']
        self.file = open('.motto', 'w')

    def open(self, url):
        self.browser.get(url)
        logging.debug('web title:%s', self.browser.title)

    def fetch_content(self):
        contents = self.browser.find_element_by_class_name('content').find_elements_by_tag_name('p')
        for item in contents:
            obj = re.search(r'[\u3001].*[\u3002]', item.text)
            if obj:
                self.file.write(item.text[obj.start() + 1:obj.end()] + '\n')

    def fetch_page(self):
        page_list = []
        for item in self.browser.find_element_by_id('container').find_elements_by_tag_name('ul'):
            for aa in item.find_elements_by_tag_name('a'):
                if ('爱情' or '男' or '女') not in aa.get_attribute('title'):
                    page_list.append(aa.get_attribute('href'))
        return list(set(page_list))

    def screenshot(self):
        self.browser.save_screenshot(datetime.now().strftime('screenshot_%Y%m%d%H%M%S.png'))

    def scroll_to(self, where='bottom'):
        if where is 'top':
            self.browser.execute_script('window.scrollTo({top:0, behavior:"smooth"});')
        else:
            self.browser.execute_script('window.scrollTo({top:document.body.scrollHeight, behavior:"smooth"});')

    def wait_page_over(self, locator):
        try:
            WebDriverWait(self.browser, 10).until(expected_conditions.presence_of_element_located(locator))
        except TimeoutError:
            logging.error('wait web loading time out')
            self.browser.quit()


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)

    motto = Motto()
    motto.open('https://www.geyanw.com')
    # time.sleep(1)
    # motto.scrollTo('bottom')
    # time.sleep(2)
    # motto.scrollTo('top')
    main_window = motto.browser.current_window_handle
    pages = motto.fetch_page()
    logging.info('[# total:%d #]', len(pages))
    for index, href in enumerate(pages):
        logging.info('====================================================================')
        logging.info('%d %s', index, href)

        motto.browser.execute_script('window.open("' + href + '");')
        motto.browser.switch_to.window(motto.browser.window_handles[len(motto.browser.window_handles) - 1])
        motto.fetch_content()
        motto.browser.close()
        motto.browser.switch_to.window(main_window)

        motto.browser.close()
