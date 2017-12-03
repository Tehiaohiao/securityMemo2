import tornado
import json
from tornado import gen
from .User import *
from .base_handler import *
import time
import re
from .config import *
import hashlib
from .helper import *
from boto.dynamodb2.table import Table

class MessageHandler(BaseHandler):

	@gen.coroutine
	def post(self):
		status = send_message(self.data['toNumber'], "+13146268102", self.data['message'], self.data['incident'])