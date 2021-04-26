# tweets to scrape contents of
tweet_ids = [1298265396378656768, 1297273403175559173]

# selenium code: https://stackoverflow.com/a/53657649/2397327
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException

chrome_options = Options()
chrome_options.add_argument("--disable-extensions")
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--headless")
driver = webdriver.Chrome('./chromedriver', options=chrome_options)

import time

# scrape
selector = '[data-testid=tweet]~div>div'
for tweet_id in tweet_ids:
    driver.get(f'https://twitter.com/u/status/{tweet_id}')

    tweet = ''
    retries = 0
    while tweet == '' and retries < 10:
        try:
            tweet = driver.find_element_by_css_selector(selector).text
        except NoSuchElementException:
            # element not loaded yet
            pass
        time.sleep(0.1)
        retries += 1

    print(f'Got tweet: {tweet}')

driver.quit()
