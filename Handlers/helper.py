import hashlib
import re
from twilio.rest import TwilioRestClient 
 
#reserved for twilio message usage
def send_message(toNumber, fromNumber, name):
    ACCOUNT_SID = "xxx" 
    AUTH_TOKEN = "xxx" 
     
    client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN) 
     
    client.messages.create(
        to=toNumber, 
        from_=fromNumber,
        body="Incident: "+ name + " just happened arround your saved location, please take care", 
    )



#md5 hash
def md5(s):
    m = hashlib.md5()
    m.update(s.encode("utf-8"))
    return m.hexdigest()

