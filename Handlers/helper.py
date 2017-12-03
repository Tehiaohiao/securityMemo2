import hashlib
import re
from twilio.rest import TwilioRestClient 
 
#reserved for twilio message usage
def send_message(toNumber, fromNumber, name, incident):
    ACCOUNT_SID = "xxxx" 
    AUTH_TOKEN = "xxxx" 
     
    client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN) 
     
    client.messages.create(
        to=toNumber, 
        from_=fromNumber,
        body="Hello from "+ name + ": "+incident+" happens arround your saved location, please be careful.", 
    )



#md5 hash
def md5(s):
    m = hashlib.md5()
    m.update(s.encode("utf-8"))
    return m.hexdigest()

