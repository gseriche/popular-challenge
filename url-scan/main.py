import requests
import json
import time
import logging
import boto3

logging.basicConfig(
    filename='urlscan.log', 
    filemode='w', 
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO)
logging.info("Start : %s" % time.ctime())
# TODO: llevar a variables de entorno el apikey
apikey = "b561ed5a-9558-46c0-89ff-29a088b2bf14"
headers = {
    'API-Key': '{}'.format(apikey),
    'Content-Type':'application/json'
    }
data = {"url": "https://popularenlinea.com", "visibility": "private"}

logging.info("Starting the url scanning")
response = requests.post('https://urlscan.io/api/v1/scan/',headers=headers, data=json.dumps(data))
response.raise_for_status()
get_response = response.json()

logging.info("Waiting 30 secs to get the report")
time.sleep(30)

logging.info("Getting the result of scanning")
urlscan_response = requests.get(get_response['api'])
urlscan_response.raise_for_status()

logging.info("Opening and filling the file url_response.json")
file = open("url_response.json", "w")
file.write(urlscan_response.text)
file.close()

logging.info("Closing file url_response.json")

logging.info("Uploading the file to the bucket")
s3 = boto3.resource('s3')
file_urlscan = open("url_response.json", "rb")
s3.Bucket('lapopular-url-scan').put_object(Key='url_response.json', Body=file_urlscan)

logging.info("End : %s" % time.ctime())