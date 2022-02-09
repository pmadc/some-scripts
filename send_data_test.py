import json
import boto3

from botocore.config import Config

my_config = Config(
    region_name = 'eu-central-1',
    signature_version = 'v4',
    retries = {
        'max_attempts': 10,
        'mode': 'standard'
        }
    )

kinesis = boto3.client('kinesis', config=my_config)

import sys

from random import seed
from random import randint
import time
import random

#kinesis = kinesis.connect_to_region("eu-central-1")
print(kinesis.list_streams())

seed(1)
i=0
while 1==1:
    new_dict={}
    new_dict["timestamp"]=int(time.time())
    new_dict["dataNum"]="data"+str(i)
    new_dict["device_name"]="dev"

    print("loading ",json.dumps(new_dict))
    #kinesis.put_record("input-stream", json.dumps(new_dict), "partitionkey")    
    kinesis.put_record(
        StreamName='input-stream',
        Data=json.dumps(new_dict),
        PartitionKey='device_name'
    )
    time.sleep(0.2)
    i+=1